defmodule Butler.Repo.Migrations.RenamePartyIdInVariousTables do
  use Ecto.Migration

  def change do
    rename table("maids"), :party_id, to: :barcode_id
    rename table("reservations"), :party_id, to: :barcode_id

    alter table(:maids) do
      modify :barcode_id, references(:barcodes)
    end

    alter table(:reservations) do
      modify :barcode_id, references(:barcodes)
    end
  end
end
