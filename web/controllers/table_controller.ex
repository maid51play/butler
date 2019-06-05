defmodule FanimaidButler.TableController do
  use FanimaidButler.Web, :controller

  alias FanimaidButler.Table
  alias FanimaidButler.Party
  alias FanimaidButler.Maid
  alias FanimaidButler.Reservation

  def index(conn, params) do
    selected_reservation_id = Map.get(params, "reservation")
    selected_reservation = if selected_reservation_id, do: Repo.get(Reservation, selected_reservation_id) |> Repo.preload :maid, else: %{}
    tables = Repo.all from t in Table, preload: [parties: [reservation: :maid]]
    waitlist = Reservation 
    |> Reservation.waitlist 
    |> order_by(asc: :id)
    |> preload([:maid])
    |> FanimaidButler.Repo.paginate(page: 1)
    
    render(conn, "index.html", tables: tables, waitlist: waitlist, selected_reservation: selected_reservation)
  end

  def new(conn, _params) do
    changeset = Table.changeset(%Table{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"table" => table_params}) do
    changeset = Table.changeset(%Table{}, table_params)

    case Repo.insert(changeset) do
      {:ok, table} ->
        conn
        |> put_flash(:info, "Table created successfully.")
        |> redirect(to: table_path(conn, :show, table))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    table = Repo.get!(Table, id)
    render(conn, "show.html", table: table)
  end

  def edit(conn, %{"id" => id}) do
    table = Repo.get!(Table, id) |> Repo.preload :parties
    maids = Repo.all(from maid in Maid, where: maid.status == "present", where: is_nil(maid.party_id))
    changeset = Table.changeset(table)
    render(conn, "edit.html", table: table, maids: maids, changeset: changeset)
  end

  def update(conn, %{"id" => id, "table" => %{"party_size" => party_size, "party_id" => "", "maid_id" => maid_id}}) do
    # TODO: Add a changeset. This will probably require adding a context and an ecto thinggy.
    conn
    |> put_flash(:error, "Please scan a barcode")
    |> redirect(to: table_path(conn, :edit, id))
  end

  def update(conn, %{"id" => id, "table" => %{"party_size" => party_size, "party_id" => party_id, "maid_id" => maid_id}}) do
    table = Repo.get!(Table, id) |> Repo.preload :parties
    maid = Repo.get!(Maid, String.to_integer(maid_id))
    party = Repo.get(Party, String.to_integer(party_id))

    valid_party_ids = Enum.map(table.parties, fn(x) -> x.id end)
    case Enum.member?(valid_party_ids, String.to_integer(party_id)) && party.size == 0 do
      true ->
        party_changeset = Party.changeset(party, %{size: String.to_integer(party_size)})
        maid_changeset = Maid.changeset(maid, %{party_id: String.to_integer(party_id)})
        res = Repo.transaction(
          Ecto.Multi.new
            |> Ecto.Multi.update(:party, party_changeset)
            |> Ecto.Multi.update(:maid, maid_changeset)
        )
        case res do
          {:ok, party} ->
            conn
            |> put_flash(:info, "Table updated successfully.")
            |> redirect(to: table_path(conn, :index))
          {:error, changeset} ->
            render(conn, "edit.html", table: table, changeset: changeset)
        end
      false ->
        conn
        |> put_flash(:error, "Invalid party id #{Enum.member?(valid_party_ids, String.to_integer(party_id))}")
        |> redirect(to: table_path(conn, :edit, table))
    end
  end

  def update(conn, %{"id" => id, "table" => table_params}) do
    table = Repo.get!(Table, id) |> Repo.preload :parties
    changeset = Table.changeset(table, table_params)

    case Repo.update(changeset) do
      {:ok, table} ->
        conn
        |> put_flash(:info, "Table updated successfully.")
        |> redirect(to: table_path(conn, :show, table))
      {:error, changeset} ->
        render(conn, "edit.html", table: table, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    table = Repo.get!(Table, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(table)

    conn
    |> put_flash(:info, "Table deleted successfully.")
    |> redirect(to: table_path(conn, :index))
  end
end
