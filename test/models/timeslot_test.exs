defmodule Butler.TimeslotTest do
  use Butler.DataCase

  import Butler.Factory
  
  alias Butler.Timeslot

  @valid_attrs %{start_time: "2010-04-17 14:00:00.000000Z", end_time: "2010-04-17 15:00:00.000000Z"}
  @invalid_attrs %{}
  
  test "for_day" do
    past_timeslot = insert(:timeslot, end_time: ~N[2010-04-16 15:00:00], start_time:  ~N[2010-04-16 16:00:00])
    today_timeslot = insert(:timeslot, end_time: ~N[2010-04-17 15:00:00], start_time:  ~N[2010-04-17 16:00:00])
    future_timeslot = insert(:timeslot, end_time: ~N[2010-04-18 15:00:00], start_time: ~N[2010-04-18 16:00:00])

    timeslots = Timeslot |> Timeslot.for_day(~N[2010-04-17 15:00:00]) |> Repo.all

    assert Enum.count(timeslots) == 1
    assert Enum.at(timeslots, 0).start_time == today_timeslot.start_time
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