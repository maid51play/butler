defmodule Butler.TimeslotTest do
  use Butler.DataCase
  
  alias Butler.Timeslot

  @valid_attrs %{start_time: "2010-04-17 14:00:00.000000Z", end_time: "2010-04-17 14:00:00.000000Z"}
  @invalid_attrs %{}
  
  test "changeset with valid attributes" do
    changeset = Timeslot.changeset(%Timeslot{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Timeslot.changeset(%Timeslot{}, @invalid_attrs)
    refute changeset.valid?
  end
end