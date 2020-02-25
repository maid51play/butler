defmodule Butler.TableController do
  use Butler.Web, :controller

  alias Butler.Maid
  alias Butler.Barcode
  alias Butler.Reservation
  alias Butler.Table

  def index(conn, params) do
    selected_reservation_id = Map.get(params, "reservation")
    selected_reservation = if selected_reservation_id, do: Reservation |> Repo.get(selected_reservation_id) |> Repo.preload(:maid), else: %{}
    tables = Repo.all from t in Table, preload: [barcodes: [reservation: :maid]]
    waitlist = Reservation
      |> Reservation.waitlist
      |> order_by(asc: :id)
      |> preload([:maid])
      |> Butler.Repo.paginate(page: 1)

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
    table = Table
      |> Repo.get!(id)
      |> Repo.preload(:barcodes)
    maids = Repo.all(from maid in Maid, where: maid.status == "present", where: is_nil(maid.barcode_id))
    changeset = Table.changeset(table)
    render(conn, "edit.html", table: table, maids: maids, changeset: changeset)
  end

  def update(conn, %{"id" => id, "table" => %{"barcode_id" => ""}}) do
    # TODO: Add a changeset. This will probably require adding a context and an ecto thinggy.
    conn
      |> put_flash(:error, "Please scan a barcode")
      |> redirect(to: table_path(conn, :edit, id))
  end

  def update(conn, %{"id" => id, "table" => %{"barcode_size" => barcode_size, "barcode_id" => barcode_id, "maid_id" => maid_id}}) do
    table = Table
      |> Repo.get!(id)
      |> Repo.preload(:barcodes)
    maid = Maid
      |> Repo.get!(String.to_integer(maid_id))
      barcode = Barcode
      |> Repo.get(String.to_integer(barcode_id))

    valid_barcode_ids = Enum.map(table.barcodes, fn(x) -> x.id end)
    case Enum.member?(valid_barcode_ids, String.to_integer(barcode_id)) && barcode.size == 0 do
      true ->
        barcode_changeset = Barcode.changeset(barcode, %{size: String.to_integer(barcode_size)})
        maid_changeset = Maid.changeset(maid, %{barcode_id: String.to_integer(barcode_id)})
        res = Repo.transaction(
          Ecto.Multi.new
            |> Ecto.Multi.update(:barcode, barcode_changeset)
            |> Ecto.Multi.update(:maid, maid_changeset)
        )
        case res do
          {:ok, _barcode} ->
            conn
            |> put_flash(:info, "Table updated successfully.")
            |> redirect(to: table_path(conn, :index))
          {:error, changeset} ->
            render(conn, "edit.html", table: table, changeset: changeset)
        end
      false ->
        conn
        |> put_flash(:error, "Invalid barcode id #{Enum.member?(valid_barcode_ids, String.to_integer(barcode_id))}")
        |> redirect(to: table_path(conn, :edit, table))
    end
  end

  def update(conn, %{"id" => id, "table" => table_params}) do
    table = Table
      |> Repo.get!(id)
      |> Repo.preload(:barcodes)
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
