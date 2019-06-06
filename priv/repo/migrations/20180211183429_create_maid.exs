defmodule Butler.Repo.Migrations.CreateMaid do
  use Ecto.Migration

  def change do
    create table(:maids) do
      add :name, :string
      add :status, :string
      add :goshujinsama, :integer
      add :tables, :integer
      add :logged_hours, :float

      timestamps()
    end
  end
end
