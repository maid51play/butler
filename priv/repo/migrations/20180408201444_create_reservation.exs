defmodule FanimaidButler.Repo.Migrations.CreateReservation do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :size, :integer
      add :shinkansen, :boolean, default: false, null: false
      add :staff, :boolean, default: false, null: false
      add :time_in, :utc_datetime
      add :time_out, :utc_datetime
      add :notes, :string

      timestamps()
    end
  end
end
