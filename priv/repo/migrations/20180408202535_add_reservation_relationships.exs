defmodule FanimaidButler.Repo.Migrations.AddReservationRelationships do
  use Ecto.Migration

  def change do
    alter table(:reservations) do
      add :party_id, references(:parties)
      add :maid_id, references(:maids)
    end
  end
end
