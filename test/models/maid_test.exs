defmodule Butler.MaidTest do
  use Butler.DataCase

  alias Butler.Maid
  alias Butler.Reservation

  describe "check_in_changeset" do
    setup do
      %{
        valid_attrs: %{logged_hours: 120.5, status: "some status", checked_in_at: "2010-04-17 14:00:00.000000Z"},
        invalid_attrs: %{status: 5}
      }
    end

    test "check_in_changeset with valid attributes", %{:valid_attrs => valid_attrs} do
      check_in_changeset = Maid.check_in_changeset(%Maid{}, valid_attrs)
      assert check_in_changeset.valid?
    end

    test "check_in_changeset with invalid attributes", %{:invalid_attrs => invalid_attrs} do
      check_in_changeset = Maid.check_in_changeset(%Maid{}, invalid_attrs)
      refute check_in_changeset.valid?
    end
  end

  describe "changeset" do
    setup do
      reservation = Repo.insert! %Reservation{}

      %{
        valid_attrs: %{name: "chihiro", goshujinsama: 1, tables: 0, logged_hours: 120.5, status: "some status", checked_in_at: "2010-04-17 14:00:00.000000Z", reservation_id: reservation.id},
        invalid_attrs: %{}
      }
    end

    test "changeset with valid attributes", %{:valid_attrs => valid_attrs} do
      changeset = Maid.changeset(%Maid{}, valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes", %{:invalid_attrs => invalid_attrs} do
      changeset = Maid.changeset(%Maid{}, invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "create_changeset" do
    setup do
      %{
        valid_attrs: %{name: "chihiro", goshujinsama: 1, tables: 0, logged_hours: 120.5, status: "some status", checked_in_at: "2010-04-17 14:00:00.000000Z"},
        invalid_attrs: %{}
      }
    end

    test "create_changeset with valid attributes", %{:valid_attrs => valid_attrs} do
      create_changeset = Maid.create_changeset(%Maid{}, valid_attrs)
      assert create_changeset.valid?
    end

    test "create_changeset with invalid attributes", %{:invalid_attrs => invalid_attrs} do
      create_changeset = Maid.create_changeset(%Maid{}, invalid_attrs)
      refute create_changeset.valid?
    end
  end
end
