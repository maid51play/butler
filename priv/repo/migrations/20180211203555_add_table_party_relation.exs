defmodule Butler.Repo.Migrations.AddTablePartyRelation do
  use Ecto.Migration

  def change do
    alter table(:parties) do
      add :table_id, references(:tables)
    end
  end
end
