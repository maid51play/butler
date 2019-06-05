defmodule FanimaidButler.Repo.Migrations.AddTableNameToReservation do
  use Ecto.Migration

  def change do
    alter table(:reservations) do
      add :table_number, :string
    end
  end
end
