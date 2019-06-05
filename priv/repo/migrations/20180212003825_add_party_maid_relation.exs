defmodule FanimaidButler.Repo.Migrations.AddPartyMaidRelation do
  use Ecto.Migration

  def change do
    alter table(:maids) do
      add :party_id, references(:parties)
    end
  end
end