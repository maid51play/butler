require Protocol
Protocol.derive(Jason.Encoder, Scrivener.Page)

defmodule Butler.Reservation do
  @moduledoc """
  Placeholder moduledoc
  """

  use Butler.Web, :model

  alias Butler.Barcode
  alias Butler.Repo
  alias Butler.Table

  @derive {
    Jason.Encoder,
    only: [:id, :name, :size, :time_waitlisted, :time_in, :seat_alone, :notes, :seat_alone, :maid]
  }
  @derive {
    Poison.Encoder,
    only: [:id, :name, :size, :time_waitlisted, :time_in, :seat_alone, :notes, :seat_alone, :maid]
  }
  schema "reservations" do
    field :name, :string
    field :size, :integer
    field :shinkansen, :boolean, default: false
    field :staff, :boolean, default: false
    field :time_waitlisted, :utc_datetime
    field :time_in, :utc_datetime
    field :time_out, :utc_datetime
    field :seat_alone, :boolean
    field :notes, :string
    field :table_number, :string

    timestamps()

    belongs_to :barcode, Butler.Barcode
    belongs_to :maid, Butler.Maid
  end

  def waitlist(query) do
    from reservation in query,
    where: is_nil reservation.time_in
  end

  def seated(query) do
    from reservation in query,
    where: not is_nil reservation.time_in
  end

  def waitlist_changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:name, :size, :time_waitlisted, :notes, :seat_alone])
      |> put_change(:time_waitlisted, DateTime.truncate(DateTime.utc_now, :second))
      |> validate_required([:name, :size, :time_waitlisted, :seat_alone])
  end

  def update_waitlist_changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:name, :size, :time_waitlisted, :notes, :seat_alone])
      |> validate_required([:name, :size, :time_waitlisted, :seat_alone])
  end

  def booking_waitlist_changeset(struct, params \\ %{}) do
    struct
      |> cast(
        params,
        [:name, :size, :shinkansen, :staff, :time_in, :notes, :table_number, :barcode_id, :maid_id, :seat_alone]
      )
      |> cast_assoc(:maid)
      |> cast_assoc(:barcode)
      |> validate_matching_barcode()
      |> validate_barcode_available()
      |> validate_barcode_size()
      |> validate_required([:size, :shinkansen, :staff, :maid_id, :table_number, :barcode_id])
      |> put_change(:time_in, DateTime.truncate(DateTime.utc_now, :second))
  end

  def booking_changeset(struct, params \\ %{}) do
    struct
      |> changeset(params)
      |> put_change(:time_in, DateTime.truncate(DateTime.utc_now, :second))
  end

  def clearing_changeset(struct, params \\ %{}) do
    struct
      |> changeset(params)
      |> put_change(:time_out, DateTime.truncate(DateTime.utc_now, :second))
      |> put_change(:barcode_id, nil)
  end

  def update_changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:size, :shinkansen, :staff, :time_in, :time_out, :notes, :maid_id])
      |> cast_assoc(:maid)
      |> validate_barcode_size()
      |> validate_required([:size, :shinkansen, :staff, :maid_id])
  end

  def switch_barcodes_changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:barcode_id, :table_number])
      |> cast_assoc(:barcode)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:size, :shinkansen, :staff, :time_in, :time_out, :notes, :table_number, :barcode_id, :maid_id])
      |> cast_assoc(:maid)
      |> cast_assoc(:barcode)
      |> validate_matching_barcode()
      |> validate_barcode_available()
      |> validate_barcode_size()
      |> validate_required([:size, :shinkansen, :staff, :maid_id, :table_number, :barcode_id])
  end

  def validate_matching_barcode(changeset \\ []) do
    if get_change(changeset, :barcode_id) && Repo.get!(Barcode, get_change(changeset, :barcode_id)).table_id != Repo.get_by!(Table, table_number: get_change(changeset, :table_number)).id do
      add_error(changeset, :barcode_id, "Scanned barcode does not match table!")
    else
      changeset
    end
  end

  def validate_barcode_size(changeset \\ []) do
    if get_change(changeset, :size) do
      table = Table
        |> Repo.get_by!(table_number: get_change(changeset, :table_number, changeset.data.table_number))
        |> Repo.preload([barcodes: :reservation])
      barcode_id = get_change(changeset, :barcode_id, changeset.data.barcode_id)

      table_barcodes = Enum.filter(table.barcodes, fn x -> if changeset.data.time_out, do: x.id == barcode_id, else: x.id != barcode_id end)
      full_seats = Enum.reduce(table_barcodes, 0, fn(x, acc) -> if x.reservation do x.reservation.size + acc else acc end end)
      max_seats = table.max_capacity

      if get_change(changeset, :size) > (max_seats - full_seats) do
        add_error(changeset, :size, "Specified party size is too large for this table!")
      else
        changeset
      end
    else
      changeset
    end
  end

  def validate_barcode_available(changeset \\ []) do
    if get_change(changeset, :barcode_id) do
      barcode = Barcode
        |> Repo.get!(get_change(changeset, :barcode_id))
        |> Repo.preload([reservation: :maid])
      if barcode.reservation do
        add_error(changeset, :barcode_id, "Barcode already assigned to #{barcode.reservation.maid.name}")
      else
        changeset
      end
    else
      changeset
    end
  end
end
