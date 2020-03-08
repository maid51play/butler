defmodule Butler.Maid do
  @moduledoc """
  Placeholder moduledoc
  """

  use Butler.Web, :model

  @derive {Jason.Encoder, only: [:id, :name]}
  schema "maids" do
    field :name, :string
    field :status, :string, default: "not-present"
    field :goshujinsama, :integer, default: 0
    field :tables, :integer, default: 0
    field :logged_hours, :float, default: 0.0
    field :checked_in_at, :utc_datetime, default: nil

    timestamps()

    belongs_to :barcode, Butler.Barcode
    has_many :reservations, Butler.Reservation
  end

  def present(query) do
    from maid in query,
    where: maid.status == "present",
    except: ^unavailable(query)
  end

  def unavailable(query) do
    from maid in query,
    left_join: r in assoc(maid, :reservations),
    where: is_nil(r.time_out) and not is_nil(r)
  end

  def fuzzy_search(query_string, threshold) do
    query_string = query_string |> String.downcase
    from maid in Butler.Maid,
      where:
        fragment(
          "levenshtein(LOWER(?), LOWER(?))",
          maid.name,
          ^query_string
        ) <= ^threshold,
      order_by:
        fragment(
          "levenshtein(LOWER(?), LOWER(?))",
          maid.name,
          ^query_string
        )
  end

  def check_in_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :logged_hours, :checked_in_at])
    |> validate_required([:status])
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :status, :goshujinsama, :tables, :logged_hours, :checked_in_at, :barcode_id])
    |> cast_assoc(:reservations)
    |> validate_required([:name, :status, :goshujinsama, :tables, :logged_hours])
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :status, :goshujinsama, :tables, :logged_hours, :checked_in_at, :barcode_id])
    |> validate_required([:name])
  end
end
