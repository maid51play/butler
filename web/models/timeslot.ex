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
    |> validate_required([:start_time, :end_time])
  end
end
