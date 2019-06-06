defmodule FanimaidButler.Party do
  @moduledoc """
  Placeholder moduledoc
  """

  use FanimaidButler.Web, :model

  @derive {Jason.Encoder, only: [:id, :size, :reservation]}
  schema "parties" do
    field :size, :integer

    timestamps()

    belongs_to :table, FanimaidButler.Table
    has_one :maid, FanimaidButler.Maid
    has_one :reservation, FanimaidButler.Reservation
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:size, :table_id])
    |> cast_assoc(:maid)
    |> cast_assoc(:reservation)
    |> validate_required([:size])
  end
end
