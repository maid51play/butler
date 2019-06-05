defmodule FanimaidButler.Repo.Migrations.CreateTable do
  use Ecto.Migration

  def change do
    create table(:tables) do
      add :table_number, :string
      add :max_capacity, :integer

      timestamps()
    end
  end
end
