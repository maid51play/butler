defmodule Butler.MaidControllerTest do
  use Butler.ConnCase

  alias Butler.Maid

  @valid_attrs %{name: "some name", status: "some status"}
  @invalid_attrs %{}

  test "lists all entries on index for a given page", %{conn: conn} do
    conn = conn
      |> authorize
      |> get(maid_path(conn, :index, page: 1))

    assert html_response(conn, 200) =~ "MaidComponent"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
      |> authorize
      |> get(maid_path(conn, :new))
    assert html_response(conn, 200) =~ "MaidNewComponent"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
      |> authorize
      |> post(maid_path(conn, :create), maid: @valid_attrs)

    assert redirected_to(conn) == maid_path(conn, :index)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
      |> authorize
      |> post(maid_path(conn, :create), maid: @invalid_attrs)

    assert html_response(conn, 200) =~ "MaidNewComponent"
  end

  test "shows chosen resource", %{conn: conn} do
    maid = Repo.insert! %Maid{}
    conn = conn
      |> authorize
      |> get(maid_path(conn, :show, maid))

    assert html_response(conn, 200) =~ "Show maid"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      conn
        |> authorize
        |> get(maid_path(conn, :show, -1))
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    maid = Repo.insert! %Maid{}
    conn = conn
      |> authorize
      |> get(maid_path(conn, :edit, maid))

    assert html_response(conn, 200) =~ "MaidEditComponent"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    maid = Repo.insert! %Maid{}
    conn = conn
      |> authorize
      |> put(maid_path(conn, :update, maid), maid: @valid_attrs)

    assert redirected_to(conn) == maid_path(conn, :show, maid)
    assert Repo.get_by(Maid, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    maid = Repo.insert! %Maid{}
    conn = conn
      |> authorize
      |> put(maid_path(conn, :update, maid), maid: @invalid_attrs)

    assert html_response(conn, 200) =~ "MaidEditComponent"
  end

  test "deletes chosen resource", %{conn: conn} do
    maid = Repo.insert! %Maid{}
    conn = conn
      |> authorize
      |> delete(maid_path(conn, :delete, maid))

    assert redirected_to(conn) == maid_path(conn, :index)
    refute Repo.get(Maid, maid.id)
  end
end
