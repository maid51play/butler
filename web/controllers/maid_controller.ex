defmodule FanimaidButler.MaidController do
  use FanimaidButler.Web, :controller

  alias FanimaidButler.Maid

  def index(conn, %{"search" => search, "page" => page} = params) do
    page =
      Maid
      |> where([m], ilike(m.name, ^search))
      |> order_by(desc: :status)
      |> order_by(:name)
      |> FanimaidButler.Repo.paginate(page: page)

    render(conn, "index.html", 
      search: search,
      url: "/maids",
      maids: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries)
  end

  def index(conn, %{"search" => search} = params) do
    redirect(conn, to: maid_path(conn, :index, search: search, page: 1))
  end

  def index(conn, %{"page" => page} = params) do    
    page =
      Maid
      |> order_by(desc: :status)
      |> order_by(:name)
      |> FanimaidButler.Repo.paginate(page: page)

    render(conn, "index.html", 
      search: "",
      url: "/maids",
      maids: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries)
  end

  def index(conn, _params) do
    redirect(conn, to: maid_path(conn, :index, page: 1))
  end

  def new(conn, _params) do
    changeset = Maid.create_changeset(%Maid{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"maid" => maid_params}) do
    changeset = Maid.create_changeset(%Maid{}, maid_params)

    case Repo.insert(changeset) do
      {:ok, maid} ->
        conn
        |> put_flash(:info, "Maid #{maid.name} created successfully.")
        |> redirect(to: maid_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    maid = Repo.get!(Maid, id)
    render(conn, "show.html", maid: maid)
  end

  def edit(conn, %{"id" => id}) do
    maid = Repo.get!(Maid, id)
    changeset = Maid.changeset(maid)
    render(conn, "edit.html", maid: maid, changeset: changeset)
  end

  def update(conn, %{"id" => id, "maid" => maid_params}) do
    maid = Repo.get!(Maid, id)
    changeset = Maid.changeset(maid, maid_params)

    case Repo.update(changeset) do
      {:ok, maid} ->
        conn
        |> put_flash(:info, "Maid updated successfully.")
        |> redirect(to: maid_path(conn, :show, maid))
      {:error, changeset} ->
        render(conn, "edit.html", maid: maid, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    maid = Repo.get!(Maid, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(maid)

    conn
    |> put_flash(:info, "Maid deleted successfully.")
    |> redirect(to: maid_path(conn, :index))
  end

  def check_in(conn, %{"id" => id}) do
    maid= Repo.get!(Maid, id)
    changeset = Maid.check_in_changeset(maid, %{status: "present", checked_in_at: DateTime.utc_now()})

    case Repo.update(changeset) do
      {:ok, maid} ->
        conn
        |> put_flash(:info, "#{maid.name} checked in successfully at #{DateTime.utc_now()}")
        |> redirect(to: maid_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", maid: maid, changeset: changeset)
    end
  end

  def check_out(conn, %{"id" => id}) do
    maid= Repo.get!(Maid, id)
    new_hours = DateTime.diff(DateTime.utc_now(), maid.checked_in_at)
    hours = maid.logged_hours + new_hours
    changeset = Maid.check_in_changeset(maid, %{status: "not-present", checked_in_at: nil, logged_hours: hours})

    case Repo.update(changeset) do
      {:ok, maid} ->
        conn
        |> put_flash(:info, "#{maid.name} checked out successfully.")
        |> redirect(to: maid_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", maid: maid, changeset: changeset)
    end
  end
end
