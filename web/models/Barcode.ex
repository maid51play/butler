defmodule Butler.Barcode do
  @moduledoc """
  Placeholder moduledoc
  """

  use Butler.Web, :model

  @derive {Jason.Encoder, only: [:id, :size, :reservation]}
  schema "barcodes" do
    field :size, :integer

    timestamps()

    belongs_to :table, Butler.Table
    has_one :maid, Butler.Maid
    has_one :reservation, Butler.Reservation
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
