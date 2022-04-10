defmodule Butler.Repo.Migrations.CreateTimeslots do
  use Ecto.Migration

  def change do
    create table(:timeslots) do
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime

      timestamps()
    end

  end
end
