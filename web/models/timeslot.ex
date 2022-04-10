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

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start_time, :end_time])
    |> validate_required([:start_time, :end_time])
  end
end
