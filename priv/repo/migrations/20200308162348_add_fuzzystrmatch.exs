defmodule Butler.Repo.Migrations.AddFuzzystrmatch do
  use Ecto.Migration

  def up do
    execute "CREATE extension if not exists fuzzystrmatch;"
  end

  def down do
    execute "DROP extension if exists fuzzystrmatch;"
  end
end
