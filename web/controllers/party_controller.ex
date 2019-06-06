defmodule FanimaidButler.PartyController do
  use FanimaidButler.Web, :controller

  alias FanimaidButler.Maid
  alias FanimaidButler.Party

  def index(conn, _params) do
    parties = Party |> Repo.all |> Repo.preload(:table)
    render(conn, "index.html", parties: parties)
  end

  def new(conn, _params) do
    changeset = Party.changeset(%Party{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"party" => party_params}) do
    changeset = Party.changeset(%Party{}, party_params)

    case Repo.insert(changeset) do
      {:ok, party} ->
        conn
        |> put_flash(:info, "Party created successfully.")
        |> redirect(to: party_path(conn, :show, party))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    party = Repo.get!(Party, id)
    render(conn, "show.html", party: party)
  end

  def edit(conn, %{"id" => id}) do
    party = Repo.get!(Party, id)
    changeset = Party.changeset(party)
    render(conn, "edit.html", party: party, changeset: changeset)
  end

  def clear(conn, %{"party" => %{"party_id" => party_id}}) do
    party = Party |> Repo.get(party_id) |> Repo.preload(:maid)
    case party.id > 0 do
      true ->
        # maid = Repo.get(Maid,party.maid.id)
        party_changeset = Party.changeset(party, %{size: 0})
        maid_changeset = Maid.changeset(party.maid, %{party_id: nil})
        res = Repo.transaction(
          Ecto.Multi.new
            |> Ecto.Multi.update(:party, party_changeset)
            |> Ecto.Multi.update(:maid, maid_changeset)
        )
        case res do
          {:ok, _party} ->
            conn
              |> put_flash(:info, "Party cleared successfully.")
              |> redirect(to: table_path(conn, :index))
          {:error, _changeset} ->
            render(conn, "clear.html")
        end
        conn
        |> put_flash(:info, "party ok")
        |> redirect(to: party_path(conn, :clear))
      false ->
        conn
        |> put_flash(:error, "Wrong party id")
        |> redirect(to: party_path(conn, :clear))
    end
  end

  def clear(conn, _params) do
    changeset = Party.changeset(%Party{})
    render(conn, "clear.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "party" => party_params}) do
    party = Repo.get!(Party, id)
    changeset = Party.changeset(party, party_params)

    case Repo.update(changeset) do
      {:ok, party} ->
        conn
        |> put_flash(:info, "Party updated successfully.")
        |> redirect(to: party_path(conn, :show, party))
      {:error, changeset} ->
        render(conn, "edit.html", party: party, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    party = Repo.get!(Party, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(party)

    conn
    |> put_flash(:info, "Party deleted successfully.")
    |> redirect(to: party_path(conn, :index))
  end
end
