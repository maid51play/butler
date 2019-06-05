defmodule FanimaidButler.Table do
  use FanimaidButler.Web, :model

  @derive {Jason.Encoder, only: [:id, :table_number, :max_capacity, :parties]}
  schema "tables" do
    field :table_number, :string
    field :max_capacity, :integer

    timestamps()

    has_many :parties, FanimaidButler.Party
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:table_number, :max_capacity])
    |> cast_assoc(:parties)
    |> validate_required([:table_number, :max_capacity])
  end
end
