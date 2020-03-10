defmodule Butler.MaidController do
  use Butler.Web, :controller

  alias Butler.Maid

  alias Butler.Plug.Logger

  def index(conn, %{"search" => search, "page" => page}) do
    page =
      Maid
        |> where([m], ilike(m.name, ^search))
        |> order_by(desc: :status)
        |> order_by(:name)
        |> Butler.Repo.paginate(page: page)

    render(conn, "index.html",
      search: search,
      url: "/maids",
      maids: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries)
  end

  def index(conn, %{"search" => search}) do
    redirect(conn, to: maid_path(conn, :index, search: search, page: 1))
  end

  def index(conn, %{"page" => page}) do
    page =
      Maid
        |> order_by(desc: :status)
        |> order_by(:name)
        |> Butler.Repo.paginate(page: page)

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
    log_query = from log in Butler.Log,
      where: log.message == "check_in",
      or_where: log.message == "check_out",
      or_where: log.message == "start_break",
      or_where: log.message == "end_break",
      order_by: [desc: :inserted_at]
    maid = Repo.get!(Maid, id) |> Repo.preload([logs: log_query])
    hours = maid.logs 
      |> Enum.filter(fn log -> log.message == "start_break" || log.message == "end_break" end)
      |> Enum.map(fn log -> log.inserted_at end) 
      |> Enum.chunk_every(2)
      |> Enum.map(fn pair -> NaiveDateTime.diff(Enum.at(pair, 1, NaiveDateTime.utc_now()), Enum.at(pair, 0)) end)
      |> Enum.reduce(0, fn x, acc -> x + acc end)
    render(conn, "show.html", maid: maid, hours: hours)
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
    maid = Repo.get!(Maid, id)
    changeset = Maid.check_in_changeset(maid, %{status: "present", checked_in_at: DateTime.utc_now()})

    case Repo.update(changeset) do
      {:ok, maid} ->
        Logger.log(maid, "check_in")
        conn
          |> put_flash(:info, "#{maid.name} checked in successfully at #{DateTime.utc_now()}")
          |> redirect(to: maid_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", maid: maid, changeset: changeset)
    end
  end

  def check_out(conn, %{"id" => id}) do
    maid = Repo.get!(Maid, id)
    new_hours = DateTime.diff(DateTime.utc_now(), maid.checked_in_at)
    changeset = Maid.check_in_changeset(maid, %{status: "not-present", checked_in_at: nil})

    case Repo.update(changeset) do
      {:ok, maid} ->
        Logger.log(maid, "check_out")
        conn
          |> put_flash(:info, "#{maid.name} checked out successfully.")
          |> redirect(to: maid_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", maid: maid, changeset: changeset)
    end
  end

  def start_break(conn, %{"id" => id}) do
    maid = Repo.get!(Maid, id)
    changeset = Maid.check_in_changeset(maid, %{status: "on-break"})

    case Repo.update(changeset) do
      {:ok, maid} ->
        Logger.log(maid, "start_break")
        conn
          |> put_flash(:info, "#{maid.name} is on break now!")
          |> redirect(to: maid_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", maid: maid, changeset: changeset)
    end
  end

  def end_break(conn, %{"id" => id}) do
    maid = Repo.get!(Maid, id)
    changeset = Maid.check_in_changeset(maid, %{status: "present"})

    case Repo.update(changeset) do
      {:ok, maid} ->
        Logger.log(maid, "end_break")
        conn
          |> put_flash(:info, "おかえり、#{maid.name}！")
          |> redirect(to: maid_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", maid: maid, changeset: changeset)
    end
  end
end
