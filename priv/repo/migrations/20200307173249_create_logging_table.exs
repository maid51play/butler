defmodule Butler.Repo.Migrations.CreateLoggingTable do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :maid_id, references(:maids)
      add :message, :string
      add :data, :string

      timestamps()
    end
  end
end
