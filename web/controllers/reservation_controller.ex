defmodule Butler.ReservationController do
  use Butler.Web, :controller

  alias Butler.Maid
  alias Butler.Reservation
  alias Butler.Table

  @message_alone_table "This table already has a party seated who requested to be seated alone. Are you sure you want to seat this party with others anyway?"
  @message_alone_party "The party you are seating requested to be seated alone, but this table has parties already seated. Are you sure you want to seat this party with others anyway?"

  def index(conn, %{"page" => page}) do
    goshujinsama = Repo.aggregate(Reservation, :sum, :size)

    page =
      Reservation
        |> Reservation.seated
        |> order_by(asc: :id)
        |> preload([:maid, party: :table])
        |> Butler.Repo.paginate(page: page)

    render(conn, "index.html",
      url: "/reservations",
      reservations: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      goshujinsama: goshujinsama)
  end

  def index(conn, _params) do
    redirect(conn, to: reservation_path(conn, :index, page: 1))
  end

  def new(conn, %{"table_id" => table_id}) do
    maids = Maid |> Maid.present |> Repo.all
    table = Repo.get!(Table, table_id)
    existing_reservations = Repo.all(from reservation in Reservation, where: reservation.table_number == ^table.table_number, where: is_nil(reservation.time_out))
    warning = %{message: (if Enum.any?(existing_reservations, fn x -> x.seat_alone == true end), do: @message_alone_table, else: "")}
    changeset = Reservation.changeset(%Reservation{})
    render(conn, "new.html", maids: maids, table: table, changeset: changeset, warning: warning)
  end

  def create(conn, %{"reservation" => reservation_params}) do
    changeset = Reservation.booking_changeset(%Reservation{}, reservation_params)

    case Repo.insert(changeset) do
      {:ok, _reservation} ->
        conn
          |> put_flash(:info, "Reservation created successfully.")
          |> redirect(to: table_path(conn, :index))
      {:error, changeset} ->
        maids = Maid |> Maid.present |> Repo.all
        table = Repo.get_by!(Table, table_number: reservation_params["table_number"])
        warning = %{message: ""}
        render(conn, "new.html", maids: maids, table: table, changeset: changeset, warning: warning)
    end
  end

  def show(conn, %{"id" => id}) do
    reservation = Reservation |> Repo.get!(id) |> Repo.preload([:maid, party: :table])
    render(conn, "show.html", reservation: reservation)
  end

  def seat(conn, %{"id" => id, "table_id" => table_id}) do
    reservation = Reservation |> Repo.get!(id) |> Repo.preload([:maid, party: :table])
    table = Repo.get!(Table, table_id)
    maids = Maid |> Maid.present |> Repo.all
    changeset = Reservation.booking_waitlist_changeset(reservation)
    existing_reservations = Repo.all(from reservation in Reservation, where: reservation.table_number == ^table.table_number, where: is_nil(reservation.time_out))
    warning = %{message: (if (length(existing_reservations) > 0) && (reservation.seat_alone == true),
      do: @message_alone_party,
      else: "")}
    warning2 = %{message: (if Enum.any?(existing_reservations, fn x -> x.seat_alone == true end),
      do: @message_alone_table,
      else: "")}
    render(
      conn,
      "seat.html",
      reservation: reservation,
      maids: maids,
      table: table,
      warning: warning,
      warning2: warning2,
      changeset: changeset
    )
  end

  def edit(conn, %{"id" => id}) do
    reservation = Reservation |> Repo.get!(id) |> Repo.preload([:maid, party: :table])
    table = if reservation.party, do: reservation.party.table, else: nil
    available_maids = Maid |> Maid.present |> Repo.all
    maids = cond do
      reservation.time_out -> Maid |> Repo.all
      reservation.maid -> [[reservation.maid], available_maids] |> Enum.concat |> Enum.uniq
      true -> available_maids
    end
    changeset = Reservation.changeset(reservation)
    render(conn, "edit.html", reservation: reservation, maids: maids, table: table, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reservation" => reservation_params}) do
    reservation = Repo.get!(Reservation, id)
    time_in = reservation.time_in
    changeset = if reservation.time_in,
      do: Reservation.update_changeset(reservation, reservation_params),
      else: Reservation.booking_waitlist_changeset(reservation, reservation_params)

    case Repo.update(changeset) do
      {:ok, reservation} ->
        if !time_in, do: Butler.Endpoint.broadcast("room:lobby", "waitlist_updated", %{id: reservation.id})

        conn
          |> put_flash(:info, "Reservation updated successfully.")
          |> redirect(to: reservation_path(conn, :show, reservation))
      {:error, changeset} ->
        available_maids = Maid |> Maid.present |> Repo.all
        table_number = if reservation.table_number, do: reservation.table_number, else: changeset.changes.table_number
        table = Repo.get_by!(Table, table_number: table_number)
        existing_reservations = Repo.all(from reservation in Reservation, where: reservation.table_number == ^table.table_number, where: is_nil(reservation.time_out))
        warning = %{message: (if ((length(existing_reservations) > 0) && (reservation.seat_alone == true)),
          do: @message_alone_party,
          else: "")}
        route = if reservation.time_waitlisted, do: "seat.html", else: "edit.html"
        render(
          conn,
          route,
          reservation: reservation,
          table: table,
          maids: available_maids,
          warning: warning,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    reservation = Repo.get!(Reservation, id)

    if reservation.time_out do
      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise).
      Repo.delete!(reservation)

      conn
        |> put_flash(:info, "Reservation deleted successfully.")
        |> redirect(to: reservation_path(conn, :index))
    else
      conn
        |> put_flash(:error, "Please check out party before deleting the reservation.")
        |> redirect(to: reservation_path(conn, :index))
    end
  end

  def clear(conn, %{"reservation" => %{"party_id" => ""}}) do
    conn
      |> put_flash(:error, "Must scan a barcode.")
      |> redirect(to: reservation_path(conn, :clear))
  end

  def clear(conn, %{"reservation" => %{"party_id" => party_id}}) do
    reservation = Repo.get_by(Reservation, party_id: party_id)
    if reservation do
      changeset = Reservation.clearing_changeset(reservation)
      case Repo.update(changeset) do
        {:ok, reservation} ->
          Butler.Endpoint.broadcast("room:lobby", "table_cleared", %{id: party_id})
          conn
            |> put_flash(:info, "Reservation cleared successfully.")
            |> redirect(to: reservation_path(conn, :show, reservation))
        {:error, changeset} ->
          render(conn, "clear.html", reservation: reservation, changeset: changeset)
      end
    else
      conn
        |> put_flash(:error, "The party you scanned was already empty :(")
        |> redirect(to: reservation_path(conn, :clear))
    end
  end

  def clear(conn, _params) do
    changeset = Reservation.changeset(%Reservation{})
    render(conn, "clear.html", changeset: changeset)
  end
end
