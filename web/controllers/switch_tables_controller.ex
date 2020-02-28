defmodule Butler.SwitchTablesController do
  use Butler.Web, :controller

  alias Butler.Barcode
  alias Butler.Reservation

  def index(conn, _params) do
    changeset = Reservation.changeset(%Reservation{})
    barcodes = Barcode |> Repo.all |> Repo.preload([[reservation: :maid], :table])
    render(conn, "index.html", changeset: changeset, barcodes: barcodes)
  end

  def switch(conn, params) do
    barcode_1 = Barcode |> Repo.get(params["barcode_1"]) |> Repo.preload([:reservation, :table])
    barcode_2 = Barcode |> Repo.get(params["barcode_2"]) |> Repo.preload([:reservation, :table])

    reservation_1 = barcode_1.reservation |> Repo.preload(:barcode)
    reservation_2 = barcode_2.reservation |> Repo.preload(:barcode)

    cond do
      !reservation_1 && !reservation_2 ->
        conn
          |> put_flash(:info, "Tables switched successfully.")
          |> redirect(to: switch_tables_path(conn, :index))
      reservation_1 && reservation_2 ->
        changeset_1 = Reservation.switch_barcodes_changeset(reservation_1, %{barcode_id: barcode_2.id, table_number: barcode_2.table.table_number})
        changeset_2 = Reservation.switch_barcodes_changeset(reservation_2, %{barcode_id: barcode_1.id, table_number: barcode_1.table.table_number})

        case Repo.transaction(fn ->
          Repo.update(changeset_1)
          Repo.update(changeset_2)
        end) do
          {:ok, _result} ->
            conn
              |> put_flash(:info, "Tables switched successfully.")
              |> redirect(to: switch_tables_path(conn, :index))
          {:error, _changeset} ->
            conn
              |> put_flash(:info, "Something went wrong ;0; go yell at midori")
              |> redirect(to: switch_tables_path(conn, :index))
        end
      true ->
        foo = if reservation_1, do: reservation_1, else: reservation_2
        bar = if reservation_1, do: barcode_2, else: barcode_1

        changeset = Reservation.switch_barcodes_changeset(foo, %{barcode_id: bar.id, table_number: bar.table.table_number})

        case Repo.update(changeset) do
          {:ok, _result} ->
            conn
              |> put_flash(:info, "Tables switched successfully.")
              |> redirect(to: switch_tables_path(conn, :index))
          {:error, _changeset} ->
            conn
              |> put_flash(:info, "Something went wrong ;0; go yell at midori")
              |> redirect(to: switch_tables_path(conn, :index))
        end
    end
  end
end
