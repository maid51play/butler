defmodule Butler.Repo.Migrations.AddLastCheckedIn do
  use Ecto.Migration

  def change do
    alter table(:maids) do
      add :checked_in_at, :utc_datetime
    end
  end
end
