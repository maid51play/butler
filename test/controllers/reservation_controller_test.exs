defmodule FanimaidButler.ReservationControllerTest do
  use FanimaidButler.ConnCase

  import FanimaidButler.Factory

  alias FanimaidButler.Reservation

  # DO NOT TOUCH THIS METHOD
  # we don't know why but deleting this breaks everything
  describe "you" do
    test "are fucking cute" do
      assert true
    end
  end
  
  describe "#index" do
    test "lists all entries on index for a given page", %{conn: conn} do
      conn = conn
        |> authorize
        |> get(reservation_path(conn, :index, page: 1))
      
      assert html_response(conn, 200) =~ "Total Reservations"
    end
  end

  describe "#new" do
    test "renders form for new reservation", %{conn: conn} do
      table = insert(:table)
      conn = conn
        |> authorize
        |> get(reservation_path(conn, :new, table.id))
      
      assert html_response(conn, 200) =~ "New reservation"
    end
  end

  describe "#create" do
    setup do
      table = insert(:table)
      party = insert(:party, table: table)
      maid = insert(:maid)
      %{
        valid_attrs: %{notes: "some notes", shinkansen: true, size: 2, staff: true, table_number: table.table_number, party_id: party.id, maid_id: maid.id},
        invalid_attrs: %{table_number: party.table.table_number},
        table: table,
      }
    end

    test "creates resource and redirects when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
      conn = conn
        |> authorize
        |> post(reservation_path(conn, :create), reservation: valid_attrs)

      assert redirected_to(conn) == table_path(conn, :index)
    end
    
    test "allows multiple parties at one table when data is valid and table is not overbooked", %{conn: conn, valid_attrs: valid_attrs, table: table} do
      existing_party = insert(:party, table: table)
      insert(:reservation, party: existing_party, table_number: valid_attrs.table_number, size: 2)

      conn = conn
        |> authorize
        |> post(reservation_path(conn, :create), reservation: valid_attrs)
      
      assert redirected_to(conn) == table_path(conn, :index)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, invalid_attrs: invalid_attrs} do
      conn = conn
        |> authorize
        |> post(reservation_path(conn, :create), reservation: invalid_attrs)
      
      assert html_response(conn, 200) =~ "New reservation"
    end

    test "does not create resource and renders errors when party size is too large", %{conn: conn, valid_attrs: valid_attrs} do
      invalid_attrs = %{valid_attrs | size: 5}

      conn = conn
        |> authorize
        |> post(reservation_path(conn, :create), reservation: invalid_attrs)
      
      assert html_response(conn, 200) =~ "New reservation"
    end

    test "does not create resource and renders errors when party size would overbook table", %{conn: conn, valid_attrs: valid_attrs, table: table} do
      existing_party = insert(:party, table: table)
      insert(:reservation, party: existing_party, table_number: valid_attrs.table_number, size: 2)

      invalid_attrs = %{valid_attrs | size: 3}

      conn = conn
        |> authorize
        |> post(reservation_path(conn, :create), reservation: invalid_attrs)
      
      assert html_response(conn, 200) =~ "New reservation"
    end
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn} do
      maid = insert(:maid, name: "Faris Nyannyan")
      reservation = insert(:reservation, maid: maid)

      conn = conn
        |> authorize
        |> get(reservation_path(conn, :show, reservation))
      
      assert html_response(conn, 200) =~ "Reservation Details"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        conn
          |> authorize
          |> get(reservation_path(conn, :show, -1))
      end
    end
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn} do
      reservation = insert(:reservation)

      conn = conn
        |> authorize
        |> get(reservation_path(conn, :edit, reservation))
      assert html_response(conn, 200) =~ "Edit reservation"
    end
  end

  describe "#update" do
    setup do
      table = insert(:table, table_number: "B1")
      party = insert(:party, table: table)
      new_maid = insert(:maid)
      reservation = insert(:reservation, party: party, table_number: table.table_number)
      %{
        valid_attrs: %{notes: "some new notes", shinkansen: false, size: 3, staff: false, table_number: table.table_number, party_id: party.id, maid_id: new_maid.id},
        invalid_attrs: %{table_number: table.table_number, size: 100},
        reservation: reservation,
        party: party,
      }
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, valid_attrs: valid_attrs, reservation: reservation} do
      conn = conn
        |> authorize
        |> put(reservation_path(conn, :update, reservation), reservation: valid_attrs)
      assert redirected_to(conn) == reservation_path(conn, :show, reservation)
      assert Repo.get_by(Reservation, valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, invalid_attrs: invalid_attrs, reservation: reservation} do
      conn = conn
        |> authorize
        |> put(reservation_path(conn, :update, reservation), reservation: invalid_attrs)
      assert html_response(conn, 200) =~ "Edit reservation"
    end

    # TODO: test with multiple parties
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn} do
      reservation = insert(:reservation, time_out: "2010-04-17 14:40:00.000000Z")
      conn = conn
        |> authorize
        |> delete(reservation_path(conn, :delete, reservation))
      assert redirected_to(conn) == reservation_path(conn, :index)
      refute Repo.get(Reservation, reservation.id)
    end
  end
end
