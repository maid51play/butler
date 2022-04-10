defmodule Butler.ReserveTimeslotController do
    use Butler.Web, :controller
  
    alias Butler.Timeslot

    def index(conn, _params) do
        timeslots = Timeslot |> Timeslot.today |> Repo.all

        render(conn, "index.html", timeslots: timeslots, layout: {Butler.LayoutView, "patrons.html"})
    end
  end
  