defmodule Butler.BarcodeControllerTest do
  use Butler.ConnCase

  alias Butler.Barcode
  @valid_attrs %{size: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = conn
      |> authorize
      |> get(barcode_path(conn, :index))

    assert html_response(conn, 200) =~ "Listing barcodes"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
      |> authorize
      |> get(barcode_path(conn, :new))

    assert html_response(conn, 200) =~ "New barcode"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
      |> authorize
      |> post(barcode_path(conn, :create), barcode: @valid_attrs)

    barcode = Repo.get_by!(Barcode, @valid_attrs)
    assert redirected_to(conn) == barcode_path(conn, :show, barcode.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
      |> authorize
      |> post(barcode_path(conn, :create), barcode: @invalid_attrs)

    assert html_response(conn, 200) =~ "New barcode"
  end

  test "shows chosen resource", %{conn: conn} do
    barcode = Repo.insert! %Barcode{}
    conn = conn
      |> authorize
      |> get(barcode_path(conn, :show, barcode))

    assert html_response(conn, 200) =~ "Show barcode"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      conn
        |> authorize
        |> get(barcode_path(conn, :show, -1))
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    barcode = Repo.insert! %Barcode{}
    conn = conn
      |> authorize
      |> get(barcode_path(conn, :edit, barcode))

    assert html_response(conn, 200) =~ "Edit barcode"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    barcode = Repo.insert! %Barcode{}
    conn = conn
      |> authorize
      |> put(barcode_path(conn, :update, barcode), barcode: @valid_attrs)

    assert redirected_to(conn) == barcode_path(conn, :show, barcode)
    assert Repo.get_by(Barcode, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    barcode = Repo.insert! %Barcode{}
    conn = conn
      |> authorize
      |> put(barcode_path(conn, :update, barcode), barcode: @invalid_attrs)

    assert html_response(conn, 200) =~ "Edit barcode"
  end

  test "deletes chosen resource", %{conn: conn} do
    barcode = Repo.insert! %Barcode{}
    conn = conn
      |> authorize
      |> delete(barcode_path(conn, :delete, barcode))

    assert redirected_to(conn) == barcode_path(conn, :index)
    refute Repo.get(Barcode, barcode.id)
  end
end
