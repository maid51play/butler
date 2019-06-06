defmodule Butler.ReservationTest do
  use Butler.DataCase

  alias Butler.Maid
  alias Butler.Party
  alias Butler.Reservation
  alias Butler.Table

  setup do
    table = Repo.insert! %Table{table_number: "A1", max_capacity: 4}
    maid = Repo.insert! %Maid{}
    party = Repo.insert! %Party{table_id: table.id}

    %{
      valid_attrs: %{notes: "some notes", shinkansen: true, size: 2, staff: true, time_in: "2010-04-17 14:00:00.000000Z", time_out: "2010-04-17 14:00:00.000000Z", table_number: table.table_number, maid_id: maid.id, party_id: party.id},
      invalid_attrs: %{size: "500", table_number: table.table_number}
    }
  end

  test "changeset with valid attributes", %{:valid_attrs => valid_attrs} do
    changeset = Reservation.changeset(%Reservation{}, valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes", %{:invalid_attrs => invalid_attrs} do
    changeset = Reservation.changeset(%Reservation{}, invalid_attrs)
    refute changeset.valid?
  end
end
