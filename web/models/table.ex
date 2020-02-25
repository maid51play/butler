defmodule Butler.Table do
  @moduledoc """
  Placeholder moduledoc
  """

  use Butler.Web, :model

  @derive {Jason.Encoder, only: [:id, :table_number, :max_capacity, :barcodes]}
  schema "tables" do
    field :table_number, :string
    field :max_capacity, :integer

    timestamps()

    has_many :barcodes, Butler.Barcode
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:table_number, :max_capacity])
    |> cast_assoc(:barcodes)
    |> validate_required([:table_number, :max_capacity])
  end
end
