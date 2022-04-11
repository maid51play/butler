defmodule Butler.Timeslot do
  @moduledoc """
  Placeholder moduledoc
  """

  use Butler.Web, :model

  @derive {Jason.Encoder, only: [:start_time, :end_time]}
  schema "timeslots" do
    field :end_time, :naive_datetime
    field :start_time, :naive_datetime

    timestamps()
  end

  def for_day(query, date) do
    today_start = Timex.beginning_of_day(date)
    today_end = Timex.end_of_day(date)
    
    from timeslot in query,
    group_by: timeslot.start_time,
    select: %{start_time: timeslot.start_time, count: count(timeslot.id)},
    where: timeslot.start_time >= ^today_start and
    timeslot.start_time <= ^today_end
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start_time, :end_time])
    |> validate_start_time_before_end_time()
    |> validate_required([:start_time, :end_time])
  end

  def validate_start_time_before_end_time(changeset \\ []) do
    start_time = get_change(changeset, :start_time)
    end_time = get_change(changeset, :end_time)
    if start_time && NaiveDateTime.diff(start_time, end_time) >= 0 do
      add_error(changeset, :end_time, "End time must be after start time")
    else
      changeset
    end
  end
end
