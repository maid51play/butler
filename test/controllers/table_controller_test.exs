defmodule FanimaidButler.TableControllerTest do
  use FanimaidButler.ConnCase

  alias FanimaidButler.Table
  alias FanimaidButler.Maid

  @valid_attrs %{max_capacity: 42, table_number: "some table_number"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = conn
    |> authorize
    |> get table_path(conn, :index)
    
    assert html_response(conn, 200) =~ "Cafe Data"
  end

  test "shows chosen resource", %{conn: conn} do
    table = Repo.insert! %Table{}
    conn = conn
    |> authorize
    |> get table_path(conn, :show, table)
    
    assert html_response(conn, 200) =~ "Show table"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      conn
      |> authorize
      |> get table_path(conn, :show, -1)
    end
  end
end
