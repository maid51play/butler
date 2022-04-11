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

  def today(query) do
    from timeslot in query,
    group_by: timeslot.start_time,
    select: %{start_time: timeslot.start_time, count: count(timeslot.id)},
    where: fragment("? BETWEEN CURRENT_DATE AND CURRENT_DATE + interval '1 day' - interval '1 second'", timeslot.start_time)
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
    if NaiveDateTime.diff(start_time, end_time) >= 0 do
      add_error(changeset, :end_time, "End time must be after start time")
    else
      changeset
    end
  end
end
