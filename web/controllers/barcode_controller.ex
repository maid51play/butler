defmodule Butler.BarcodeController do
  use Butler.Web, :controller

  alias Butler.Maid
  alias Butler.Barcode

  def index(conn, _params) do
    barcodes = Barcode |> Repo.all |> Repo.preload(:table)
    render(conn, "index.html", barcodes: barcodes)
  end

  def new(conn, _params) do
    changeset = Barcode.changeset(%Barcode{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"barcode" => barcode_params}) do
    changeset = Barcode.changeset(%Barcode{}, barcode_params)

    case Repo.insert(changeset) do
      {:ok, barcode} ->
        conn
        |> put_flash(:info, "Barcode created successfully.")
        |> redirect(to: barcode_path(conn, :show, barcode))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    barcode = Repo.get!(Barcode, id)
    render(conn, "show.html", barcode: barcode)
  end

  def edit(conn, %{"id" => id}) do
    barcode = Repo.get!(Barcode, id)
    changeset = Barcode.changeset(barcode)
    render(conn, "edit.html", barcode: barcode, changeset: changeset)
  end

  def clear(conn, %{"barcode" => %{"barcode_id" => barcode_id}}) do
    barcode = Barcode |> Repo.get(barcode_id) |> Repo.preload(:maid)
    case barcode.id > 0 do
      true ->
        barcode_changeset = Barcode.changeset(barcode, %{size: 0})
        maid_changeset = Maid.changeset(barcode.maid, %{barcode_id: nil})
        res = Repo.transaction(
          Ecto.Multi.new
            |> Ecto.Multi.update(:barcode, barcode_changeset)
            |> Ecto.Multi.update(:maid, maid_changeset)
        )
        case res do
          {:ok, _barcode} ->
            conn
              |> put_flash(:info, "Party cleared successfully.")
              |> redirect(to: table_path(conn, :index))
          {:error, _changeset} ->
            render(conn, "clear.html")
        end
        conn
        |> put_flash(:info, "barcode ok")
        |> redirect(to: barcode_path(conn, :clear))
      false ->
        conn
        |> put_flash(:error, "Wrong barcode id")
        |> redirect(to: barcode_path(conn, :clear))
    end
  end

  def clear(conn, _params) do
    changeset = Barcode.changeset(%Barcode{})
    render(conn, "clear.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "barcode" => barcode_params}) do
    barcode = Repo.get!(Barcode, id)
    changeset = Barcode.changeset(barcode, barcode_params)

    case Repo.update(changeset) do
      {:ok, barcode} ->
        conn
        |> put_flash(:info, "Barcode updated successfully.")
        |> redirect(to: barcode_path(conn, :show, barcode))
      {:error, changeset} ->
        render(conn, "edit.html", barcode: barcode, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    barcode = Repo.get!(Barcode, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(barcode)

    conn
    |> put_flash(:info, "barcode deleted successfully.")
    |> redirect(to: barcode_path(conn, :index))
  end
end
