defmodule FanimaidButler.PartyControllerTest do
  use FanimaidButler.ConnCase

  alias FanimaidButler.Party
  @valid_attrs %{size: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = conn
      |> authorize
      |> get(party_path(conn, :index))

    assert html_response(conn, 200) =~ "Listing parties"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
      |> authorize
      |> get(party_path(conn, :new))

    assert html_response(conn, 200) =~ "New party"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
      |> authorize
      |> post(party_path(conn, :create), party: @valid_attrs)

    party = Repo.get_by!(Party, @valid_attrs)
    assert redirected_to(conn) == party_path(conn, :show, party.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
      |> authorize
      |> post(party_path(conn, :create), party: @invalid_attrs)

    assert html_response(conn, 200) =~ "New party"
  end

  test "shows chosen resource", %{conn: conn} do
    party = Repo.insert! %Party{}
    conn = conn
      |> authorize
      |> get(party_path(conn, :show, party))

    assert html_response(conn, 200) =~ "Show party"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      conn
        |> authorize
        |> get(party_path(conn, :show, -1))
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    party = Repo.insert! %Party{}
    conn = conn
      |> authorize
      |> get(party_path(conn, :edit, party))

    assert html_response(conn, 200) =~ "Edit party"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    party = Repo.insert! %Party{}
    conn = conn
      |> authorize
      |> put(party_path(conn, :update, party), party: @valid_attrs)

    assert redirected_to(conn) == party_path(conn, :show, party)
    assert Repo.get_by(Party, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    party = Repo.insert! %Party{}
    conn = conn
      |> authorize
      |> put(party_path(conn, :update, party), party: @invalid_attrs)

    assert html_response(conn, 200) =~ "Edit party"
  end

  test "deletes chosen resource", %{conn: conn} do
    party = Repo.insert! %Party{}
    conn = conn
      |> authorize
      |> delete(party_path(conn, :delete, party))

    assert redirected_to(conn) == party_path(conn, :index)
    refute Repo.get(Party, party.id)
  end
end
