defmodule Butler.Repo.Migrations.RenamePartyTableToBarcode do
  use Ecto.Migration

  def change do
    rename table("parties"), to: table("barcodes")
  end
end
