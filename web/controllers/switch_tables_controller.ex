defmodule FanimaidButler.SwitchTablesController do
  use FanimaidButler.Web, :controller

  alias FanimaidButler.Party
  alias FanimaidButler.Reservation

  def index(conn, _params) do
    changeset = Reservation.changeset(%Reservation{})
    parties = Party |> Repo.all |> Repo.preload([[reservation: :maid], :table])
    render(conn, "index.html", changeset: changeset, parties: parties)
  end

  def switch(conn, params) do
    party_1 = Party |> Repo.get(params["party_1"]) |> Repo.preload([:reservation, :table])
    party_2 = Party |> Repo.get(params["party_2"]) |> Repo.preload([:reservation, :table])

    reservation_1 = party_1.reservation |> Repo.preload(:party)
    reservation_2 = party_2.reservation |> Repo.preload(:party)

    cond do
      !reservation_1 && !reservation_2 ->
        conn
          |> put_flash(:info, "Parties switched successfully.")
          |> redirect(to: switch_tables_path(conn, :index))
      reservation_1 && reservation_2 ->
        changeset_1 = Reservation.switch_parties_changeset(reservation_1, %{party_id: party_2.id, table_number: party_2.table.table_number})
        changeset_2 = Reservation.switch_parties_changeset(reservation_2, %{party_id: party_1.id, table_number: party_1.table.table_number})

        case Repo.transaction(fn ->
          Repo.update(changeset_1)
          Repo.update(changeset_2)
        end) do
          {:ok, _result} ->
            conn
              |> put_flash(:info, "Parties switched successfully.")
              |> redirect(to: switch_tables_path(conn, :index))
          {:error, _changeset} ->
            conn
              |> put_flash(:info, "Something went wrong ;0; go yell at midori")
              |> redirect(to: switch_tables_path(conn, :index))
        end
      true ->
        foo = if reservation_1, do: reservation_1, else: reservation_2
        bar = if reservation_1, do: party_2, else: party_1

        changeset = Reservation.switch_parties_changeset(foo, %{party_id: bar.id, table_number: bar.table.table_number})

        case Repo.update(changeset) do
          {:ok, _result} ->
            conn
              |> put_flash(:info, "Parties switched successfully.")
              |> redirect(to: switch_tables_path(conn, :index))
          {:error, _changeset} ->
            conn
              |> put_flash(:info, "Something went wrong ;0; go yell at midori")
              |> redirect(to: switch_tables_path(conn, :index))
        end
    end
  end
end
