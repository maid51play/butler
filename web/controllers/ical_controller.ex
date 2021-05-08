defmodule Butler.IcalController do
  use Butler.Web, :controller

  def index(conn, _params) do
    IO.puts('>>>>>>>>>>>>><<<<<<<<<<<<<<')
    url = "https://docs.google.com/spreadsheets/d/e/2PACX-1vSjB8rcgK4_HJx7b6Cl11yhoNSMHvV3WKWtV3Ugbp1OVKeEm4xX1CxYzSEQelJzBG4nhw9Z7eltjeRz/pub?gid=0&single=true&output=csv"

    response = HTTPoison.request!(:get, url, "", [], [follow_redirect: true]) 
    req = response.body

    IO.puts(req)
    IO.puts('>>>>>>>>>>>>><<<<<<<<<<<<<<')

    Enum.map(String.split(req, ~r/\R/), fn (foo) -> IO.puts(foo) end)
    IO.puts('>>>>>>>>>>>>><<<<<<<<<<<<<<')

    events = Enum.map(String.split(req, ~r/\R/) |> List.delete("Subject,Start Date,Start Time,End Date,End Time,All Day Event,Description,Location,Private"), fn (event) ->
        string_to_ical(event)
    end)

    IO.puts(events)

    calendar_str = Enum.join(events, "\n")


    render(conn, "index.txt", calendar_str: calendar_str)
  end

  def string_to_ical(str) do
      list = String.split(str, ~r/,/)

      starts_at_date = Enum.at(list, 1)
      starts_at_time = Enum.at(list,2)
      ends_at_date = Enum.at(list, 3)
      ends_at_time = Enum.at(list, 4)

      parsed_date_data = if Enum.at(list, 5) == "TRUE", do: parse_date_all_day(starts_at_date, starts_at_time, ends_at_date, ends_at_time), else: parse_date(starts_at_date, starts_at_time, ends_at_date, ends_at_time)      

      'BEGIN:VEVENT
SUMMARY:#{Enum.at(list, 0)}
#{parsed_date_data}
DESCRIPTION: #{Enum.at(list, 6)}
END:VEVENT'
  end

  def parse_date(starts_at_date, starts_at_time, ends_at_date, ends_at_time) do
    starts_at = Timex.parse!("#{starts_at_date} #{starts_at_time}", "%-m/%-d/%Y %-I:%M %P", :strftime)
    ends_at = Timex.parse!("#{ends_at_date} #{ends_at_time}", "%-m/%-d/%Y %-I:%M %P", :strftime)
    parsed_starts_at = Timex.format!(starts_at, "TZID=America/Los_Angeles:%Y%m%dT%H%M00", :strftime)
    parsed_ends_at = Timex.format!(ends_at, "TZID=America/Los_Angeles:%Y%m%dT%H%M00", :strftime)
    "DTSTART;#{parsed_starts_at}
DTEND;#{parsed_ends_at}"
    end

    def parse_date_all_day(starts_at_date, starts_at_time, ends_at_date, ends_at_time) do
        starts_at = Timex.parse!("#{starts_at_date}", "%-m/%-d/%Y", :strftime)
        ends_at = Timex.parse!("#{ends_at_date}", "%-m/%-d/%Y", :strftime)
        parsed_starts_at = Timex.format!(starts_at, "VALUE=DATE:%Y%m%d", :strftime)
        parsed_ends_at = Timex.format!(ends_at, "VALUE=DATE:%Y%m%d", :strftime)
        "DTSTART;#{parsed_starts_at}
DTEND;#{parsed_ends_at}"
        end
end
