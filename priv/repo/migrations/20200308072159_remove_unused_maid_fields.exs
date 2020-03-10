defmodule Butler.Repo.Migrations.RemoveUnusedMaidFields do
  use Ecto.Migration

  def change do
    alter table(:maids) do
      remove :goshujinsama, :integer
      remove :tables, :integer
      remove :logged_hours, :float
    end
  end
end
