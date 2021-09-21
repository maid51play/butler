# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Butler.Repo.insert!(%Butler.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will halt execution if something goes wrong.

#Users
Butler.Auth.create_user(%{username: "admin", password: "password"})

# Tables
table_a1 = Butler.Repo.insert!(%Butler.Table{table_number: "A1", max_capacity: 4})
barcode_a1_1 = Butler.Repo.insert!(%Butler.Barcode{size: 0, table: table_a1})

table_a2 = Butler.Repo.insert!(%Butler.Table{table_number: "A2", max_capacity: 8})
barcode_a2_1 = Butler.Repo.insert!(%Butler.Barcode{size: 0, table: table_a2})
barcode_a2_2 = Butler.Repo.insert!(%Butler.Barcode{size: 0, table: table_a2})

# Maids
faris = Butler.Repo.insert!(%Butler.Maid{name: "Faris Nyannyan"})
mayushii = Butler.Repo.insert!(%Butler.Maid{name: "Mayushii"})
kotori = Butler.Repo.insert!(%Butler.Maid{name: "Kotori Minami"})
mahoro = Butler.Repo.insert!(%Butler.Maid{name: "Mahoro Andou"})
