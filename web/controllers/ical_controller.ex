defmodule Butler.IcalController do
  use Butler.Web, :controller
  alias NimbleCSV.RFC4180, as: CSV

  def index(conn, %{"csv_url" => url, "subunits" => subunits, "filters" => filters, "overrides" => overrides}) do
    response = HTTPoison.request!(:get, url, "", [], [follow_redirect: true])
    
    events = response.body
      |> CSV.parse_string
      |> List.delete_at(0)
      |> List.delete_at(0)
      |> List.delete_at(0)
      |> Enum.filter(fn entry -> entry |> filter_entries(String.split(subunits, ","), String.split(filters, ","), String.split(overrides, ",")))
      |> Enum.map(fn (entry) -> entry |> list_to_ical_str end)

    calendar_str = Enum.join(events, "\n")

    render(conn, "index.txt", calendar_str: calendar_str)
  end
  
  def filter_entries(list, subunits, blocked, overrides) do
      subunit = Enum.at(list, 1)
      notes = Enum.at(list, 6)
      title = Enum.at(list, 0)
      
      is_override = String.contains?(notes,overrides) || String.contains?(title,overrides)
      is_blocked = String.contains?(notes,blocked) || String.contains?(title,blocked)
      is_subunit = Enum.member?(subunits, subunit)
      
      if is_override do
        return true
      end
      
      if is_blocked do
        return false
      end
      
      if is_subunit do
        return true
      end
      
      false
  end

  def list_to_ical_str(list) do
      starts_at_date = Enum.at(list, 2)
      starts_at_time = Enum.at(list, 3)
      ends_at_date = Enum.at(list, 2)
      ends_at_time = Enum.at(list, 4)
      
      parsed_date_data = if Blankable.blank?(starts_at_time), do: parse_date_all_day(starts_at_date, starts_at_time, ends_at_date, ends_at_time), else: parse_date(starts_at_date, starts_at_time, ends_at_date, ends_at_time)      

      subunit = Enum.at(list, 1)
      notes = Enum.at(list, 6)
      description = "Subunit: #{subunit}

#{notes}" |> String.replace(~r/\r|\n/, "\\n")

      if parsed_date_data != false do
      'BEGIN:VEVENT
SUMMARY:#{Enum.at(list, 0)}
#{parsed_date_data}
DESCRIPTION: #{description}
END:VEVENT'
      else
        ''
      end
  end

  def parse_date(starts_at_date, starts_at_time, ends_at_date, ends_at_time) do
    try do
    starts_at = Timex.parse!("#{starts_at_date} #{starts_at_time}", "%-m/%-d/%Y %-I:%M %P", :strftime)
    ends_at = Timex.parse!("#{ends_at_date} #{ends_at_time}", "%-m/%-d/%Y %-I:%M %P", :strftime)
    parsed_starts_at = Timex.format!(starts_at, "TZID=America/Los_Angeles:%Y%m%dT%H%M00", :strftime)
    parsed_ends_at = Timex.format!(ends_at, "TZID=America/Los_Angeles:%Y%m%dT%H%M00", :strftime)
    "DTSTART;#{parsed_starts_at}
DTEND;#{parsed_ends_at}"
    rescue
      e -> false
    end
    end

    def parse_date_all_day(starts_at_date, starts_at_time, ends_at_date, ends_at_time) do
      try do
        starts_at = Timex.parse!("#{starts_at_date}", "%-m/%-d/%Y", :strftime)
          |> Timex.to_datetime("America/Los_Angeles")
        ends_at = Timex.parse!("#{ends_at_date}", "%-m/%-d/%Y", :strftime)
          |> Timex.to_datetime("America/Los_Angeles")
          |> DateTime.add(86_400)
        parsed_starts_at = Timex.format!(starts_at, "VALUE=DATE:%Y%m%d", :strftime)
        parsed_ends_at = Timex.format!(ends_at, "VALUE=DATE:%Y%m%d", :strftime)
        "DTSTART;#{parsed_starts_at}
DTEND;#{parsed_ends_at}"
      rescue
        e -> false
      end
        end
end
