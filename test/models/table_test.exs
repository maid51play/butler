defmodule FanimaidButler.TableTest do
  use FanimaidButler.DataCase

  alias FanimaidButler.Table

  @valid_attrs %{max_capacity: 42, table_number: "some table_number"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Table.changeset(%Table{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Table.changeset(%Table{}, @invalid_attrs)
    refute changeset.valid?
  end
end
