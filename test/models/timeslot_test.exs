defmodule Butler.TimeslotTest do
  use Butler.DataCase

  import Butler.Factory
  
  alias Butler.Timeslot

  @valid_attrs %{start_time: "2010-04-17 14:00:00.000000Z", end_time: "2010-04-17 15:00:00.000000Z"}
  @invalid_attrs %{}
  
  test "today" do
    past_timeslot = insert(:timeslot, end_time: NaiveDateTime.utc_now |> NaiveDateTime.add(-82_800, :second), start_time: NaiveDateTime.utc_now |> NaiveDateTime.add(-86_400, :second))
    today_timeslot = insert(:timeslot, end_time: NaiveDateTime.utc_now |> NaiveDateTime.add(3600, :second) , start_time: NaiveDateTime.utc_now)
    future_timeslot = insert(:timeslot, end_time: NaiveDateTime.utc_now |> NaiveDateTime.add(90_000, :second), start_time: NaiveDateTime.utc_now |> NaiveDateTime.add(86_400, :second))

    timeslots = Timeslot |> Timeslot.today |> Repo.all

    assert Enum.count(timeslots) == 1
    assert Enum.at(timeslots, 0) == today_timeslot
  end

  test "changeset with valid attributes" do
    changeset = Timeslot.changeset(%Timeslot{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Timeslot.changeset(%Timeslot{}, @invalid_attrs)
    refute changeset.valid?
  end
end