defmodule Butler.Repo.Migrations.CreateTimeslots do
  use Ecto.Migration

  def change do
    create table(:timeslots) do
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      timestamps()
    end

  end
end
