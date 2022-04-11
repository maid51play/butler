defmodule Butler.TimeslotController do
  use Butler.Web, :controller

  alias Butler.Timeslot

  def index(conn, _params) do
    timeslots = Repo.all(Timeslot)
    render(conn, "index.html", timeslots: timeslots)
  end

  def new(conn, _params) do
    changeset = Timeslot.changeset(%Timeslot{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"timeslot" => timeslot_params}) do
    changeset = Timeslot.changeset(%Timeslot{}, timeslot_params)

    case Repo.insert(changeset) do
      {:ok, timeslot} ->
        conn
          |> put_flash(:info, "Timeslot created successfully.")
          |> redirect(to: timeslot_path(conn, :show, timeslot))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    timeslot = Repo.get!(Timeslot, id)
    render(conn, "show.html", timeslot: timeslot)
  end

  def edit(conn, %{"id" => id}) do
    timeslot = Repo.get!(Timeslot, id)
    changeset = Timeslot.changeset(timeslot)
    render(conn, "edit.html", timeslot: timeslot, changeset: changeset)
  end

  def update(conn, %{"id" => id, "timeslot" => timeslot_params}) do
    timeslot = Repo.get!(Timeslot, id)
    changeset = Timeslot.changeset(timeslot, timeslot_params)

    case Repo.update(changeset) do
      {:ok, timeslot} ->
        conn
          |> put_flash(:info, "Timeslot updated successfully.")
          |> redirect(to: timeslot_path(conn, :show, timeslot))
        {:error, changeset} ->
          render(conn, "edit.html", timeslot: timeslot, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    timeslot = Repo.get!(Timeslot, id)
    
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(timeslot)

    conn
    |> put_flash(:info, "Timeslot deleted successfully.")
    |> redirect(to: timeslot_path(conn, :index))
  end

  def reserve_timeslot(conn, %{}) do
    # TODO: get the first available timeslot for the time,
    # update the timeslot "booking_started_at"
    # return the timeslot id

    # timeslot is available if it has no reservation relation and
    # the booking_started_at date was more than 2 minutes ago
  end
end
