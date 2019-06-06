require Protocol
Protocol.derive(Jason.Encoder, Scrivener.Page)

defmodule FanimaidButler.Reservation do
  use FanimaidButler.Web, :model

  alias FanimaidButler.Repo
  alias FanimaidButler.Party
  alias FanimaidButler.Table
  alias FanimaidButler.Reservation

  @derive {Jason.Encoder, only: [:id, :name, :size, :time_waitlisted, :time_in, :seat_alone, :notes, :seat_alone, :maid]}
  @derive {Poison.Encoder, only: [:id, :name, :size, :time_waitlisted, :time_in, :seat_alone, :notes, :seat_alone, :maid]}
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

    belongs_to :party, FanimaidButler.Party
    belongs_to :maid, FanimaidButler.Maid
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
    |> cast(params, [:name, :size, :shinkansen, :staff, :time_in, :notes, :table_number, :party_id, :maid_id, :seat_alone])
    |> cast_assoc(:maid)
    |> cast_assoc(:party)
    |> validate_matching_party()
    |> validate_party_available()
    |> validate_party_size()
    |> validate_required([:size, :shinkansen, :staff, :maid_id, :table_number, :party_id])
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
    |> put_change(:party_id, nil)
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:size, :shinkansen, :staff, :time_in, :time_out, :notes, :maid_id])
    |> cast_assoc(:maid)
    |> validate_party_size()
    |> validate_required([:size, :shinkansen, :staff, :maid_id])
  end

  def switch_parties_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:party_id, :table_number])
    |> cast_assoc(:party)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:size, :shinkansen, :staff, :time_in, :time_out, :notes, :table_number, :party_id, :maid_id])
    |> cast_assoc(:maid)
    |> cast_assoc(:party)
    |> validate_matching_party()
    |> validate_party_available()
    |> validate_party_size()
    |> validate_required([:size, :shinkansen, :staff, :maid_id, :table_number, :party_id])
  end

  def validate_matching_party(changeset \\ []) do 
    if get_change(changeset, :party_id) && Repo.get!(Party, get_change(changeset, :party_id)).table_id != Repo.get_by!(Table, table_number: get_change(changeset, :table_number)).id do
      add_error(changeset, :party_id, "Scanned party does not match table!")
    else
      changeset
    end
  end

  def validate_party_size(changeset \\ []) do
    if get_change(changeset, :size) do
      table = Table
        |> Repo.get_by!(table_number: get_change(changeset, :table_number, changeset.data.table_number))
        |> Repo.preload [parties: :reservation]
      party_id = get_change(changeset, :party_id, changeset.data.party_id)

      table_parties = Enum.filter(table.parties, fn x -> if changeset.data.time_out, do: x.id == party_id, else: x.id != party_id end)
      full_seats = Enum.reduce(table_parties, 0, fn(x, acc) -> if x.reservation do x.reservation.size + acc else acc end end)
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

  def validate_party_available(changeset \\ []) do
    if get_change(changeset, :party_id) do
      party = Party
        |> Repo.get!(get_change(changeset, :party_id))
        |> Repo.preload [reservation: :maid]
      if party.reservation do
        add_error(changeset, :party_id, "Barcode already assigned to #{party.reservation.maid.name}")
      else
        changeset
      end
    else
      changeset
    end
  end
end
