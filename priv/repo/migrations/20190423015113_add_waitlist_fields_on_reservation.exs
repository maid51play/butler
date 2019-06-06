defmodule Butler.Repo.Migrations.AddWaitlistFieldsOnReservation do
  use Ecto.Migration

  def change do
    alter table(:reservations) do
      add :name, :string
      add :time_waitlisted, :utc_datetime
      add :seat_alone, :boolean
    end
  end
end
