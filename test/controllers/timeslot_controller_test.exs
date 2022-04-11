defmodule Butler.TimeslotControllerTest do
  use Butler.ConnCase

  import Butler.Factory

  alias Butler.Timeslot

  @create_attrs %{end_time: ~N[2010-04-17 15:00:00], start_time: ~N[2010-04-17 14:00:00]}
  @update_attrs %{end_time: ~N[2011-05-18 16:01:01], start_time: ~N[2011-05-18 15:01:01]}
  @invalid_attrs %{end_time: nil, start_time: nil}

  test "lists all timeslots on index", %{conn: conn} do
    conn = conn
      |> authorize
      |> get(timeslot_path(conn, :index))
    assert html_response(conn, 200) =~ "Listing Timeslots"
  end

  test "renders new timeslot form", %{conn: conn} do
    conn = conn
      |> authorize
      |> get(timeslot_path(conn, :new))
    assert html_response(conn, 200) =~ "New Timeslot"
  end

  describe "create timeslot" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = conn
        |> authorize
        |> post(timeslot_path(conn, :create), timeslot: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == timeslot_path(conn, :show, id)

      conn = conn
        |> get(timeslot_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Timeslot"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = conn
        |> authorize
        |> post(timeslot_path(conn, :create), timeslot: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Timeslot"
    end
  end

  describe "edit timeslot" do    
    test "renders form for editing chosen timeslot", %{conn: conn} do
      timeslot = insert(:timeslot, end_time: ~N[2022-04-10 06:26:05], start_time: ~N[2022-04-10 06:26:05])

      conn = conn
        |> authorize
        |> get(timeslot_path(conn, :edit, timeslot))
      assert html_response(conn, 200) =~ "Edit Timeslot"
    end
  end

  describe "update timeslot" do
    test "redirects when data is valid", %{conn: conn} do
      timeslot = insert(:timeslot, end_time: ~N[2022-04-10 06:26:05], start_time: ~N[2022-04-10 06:26:05])

      conn = conn
        |> authorize
        |> put(timeslot_path(conn, :update, timeslot), timeslot: @update_attrs)
      assert redirected_to(conn) == timeslot_path(conn, :show, timeslot)

      conn = get(conn, timeslot_path(conn, :show, timeslot))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      timeslot = insert(:timeslot, end_time: ~N[2022-04-10 06:26:05], start_time: ~N[2022-04-10 06:26:05])

      conn = conn
        |> authorize
        |> put(timeslot_path(conn, :update, timeslot), timeslot: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Timeslot"
    end
  end

  describe "delete timeslot" do
    test "deletes chosen timeslot", %{conn: conn} do
      timeslot = insert(:timeslot, end_time: ~N[2022-04-10 06:26:05], start_time: ~N[2022-04-10 06:26:05])

      conn = conn
        |> authorize
        |> delete(timeslot_path(conn, :delete, timeslot))
      assert redirected_to(conn) == timeslot_path(conn, :index)
      refute Repo.get(Timeslot, timeslot.id)
    end
  end
end
