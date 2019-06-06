defmodule Butler.WaitlistController do
  use Butler.Web, :controller

  alias Butler.Reservation

  def index(conn, %{"page" => page}) do
    waitlist = Reservation
      |> Reservation.waitlist
      |> order_by(asc: :id)
      |> preload([:maid])
      |> Butler.Repo.paginate(page: page)
    token = get_csrf_token()
    render(conn, "index.html", waitlist: waitlist, token: token)
  end

  def index(conn, _params) do
    redirect(conn, to: waitlist_path(conn, :index, page: 1))
  end

  def new(conn, _params) do
    # maids = Maid |> Maid.present |> Repo.all
    # table = Repo.get!(Table, table_id)
    token = get_csrf_token()
    changeset = Reservation.waitlist_changeset(%Reservation{})
    render(conn, "new.html", changeset: changeset, token: token)
  end

  def create(conn, %{"reservation" => reservation_params}) do
    changeset = Reservation.waitlist_changeset(%Reservation{}, reservation_params)

    case Repo.insert(changeset) do
      {:ok, reservation} ->
        waitlist = Reservation
          |> Reservation.waitlist
          |> order_by(asc: :id)
          |> preload([:maid])
          |> Butler.Repo.paginate(page: 1)
        Butler.Endpoint.broadcast("room:lobby", "waitlist_updated", %{waitlist: waitlist, id: reservation.id})

        conn
          |> put_flash(:info, "Reservation created successfully.")
          |> redirect(to: waitlist_path(conn, :index))
      {:error, _changeset} ->
        conn
          |> put_flash(:error, "Reservation not created.")
          |> redirect(to: waitlist_path(conn, :new))
    end
  end

  def edit(conn, %{"id" => id}) do
    token = get_csrf_token()
    reservation = Reservation
      |> Repo.get!(id)
      |> Repo.preload([:maid, party: :table])
    changeset = Reservation.waitlist_changeset(reservation)
    render(conn, "edit.html", reservation: reservation, changeset: changeset, token: token)
  end

  def update(conn, %{"id" => id, "reservation" => reservation_params}) do
    reservation = Repo.get!(Reservation, id)
    changeset = Reservation.update_waitlist_changeset(reservation, reservation_params)

    case Repo.update(changeset) do
      {:ok, reservation} ->
        waitlist = Reservation
          |> Reservation.waitlist
          |> order_by(asc: :id)
          |> preload([:maid])
          |> Butler.Repo.paginate(page: 1)
        Butler.Endpoint.broadcast("room:lobby", "waitlist_updated", %{waitlist: waitlist, id: reservation.id})

        conn
          |> put_flash(:info, "Reservation updated successfully.")
          |> redirect(to: waitlist_path(conn, :index))
      {:error, _changeset} ->
        conn
          |> put_flash(:error, "Error updating reservation.")
          |> redirect(to: waitlist_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    reservation = Repo.get!(Reservation, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(reservation)

    waitlist = Reservation
      |> Reservation.waitlist
      |> order_by(asc: :id)
      |> preload([:maid])
      |> Butler.Repo.paginate(page: 1)
    Butler.Endpoint.broadcast("room:lobby", "waitlist_updated", %{waitlist: waitlist, id: id})

    conn
      |> put_flash(:info, "Reservation deleted successfully.")
      |> redirect(to: waitlist_path(conn, :index))
  end

  def new_waitlist_entries(page) do
    Reservation
      |> Reservation.waitlist
      |> order_by(asc: :id)
      |> preload([:maid])
      |> Butler.Repo.paginate(page: page)
  end
end
