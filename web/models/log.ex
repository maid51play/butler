defmodule Butler.Log do
    @moduledoc """
    Placeholder moduledoc
    """
  
    use Butler.Web, :model
  
    @derive {Jason.Encoder, only: [:id, :name]}
    schema "logs" do
      field :message, :string
      field :data, :string
  
      timestamps()

      belongs_to :maid, Butler.Maid
    end

    @doc """
    Builds a changeset based on the `struct` and `params`.
    """
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:message, :data])
    end
  end
  