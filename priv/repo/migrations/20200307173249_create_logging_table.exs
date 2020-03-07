defmodule Butler.Repo.Migrations.CreateLoggingTable do
  use Ecto.Migration

  def change do
    create table(:logging) do
      add :maid_id, references(:maids)
      add :operation, :string
      add :data, :string

      timestamps()
    end
  end
end
