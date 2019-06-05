# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FanimaidButler.Repo.insert!(%FanimaidButler.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will halt execution if something goes wrong.

#Users
FanimaidButler.Auth.create_user(%{username: "admin", password: "password"})

# Tables
table_a1 = FanimaidButler.Repo.insert!(%FanimaidButler.Table{table_number: "A1", max_capacity: 4})
party_a1_1 = FanimaidButler.Repo.insert!(%FanimaidButler.Party{size: 0, table: table_a1})

table_a2 = FanimaidButler.Repo.insert!(%FanimaidButler.Table{table_number: "A2", max_capacity: 8})
party_a2_1 = FanimaidButler.Repo.insert!(%FanimaidButler.Party{size: 0, table: table_a2})
party_a2_2 = FanimaidButler.Repo.insert!(%FanimaidButler.Party{size: 0, table: table_a2})

# Maids
faris = FanimaidButler.Repo.insert!(%FanimaidButler.Maid{name: "Faris Nyannyan"})
mayushii = FanimaidButler.Repo.insert!(%FanimaidButler.Maid{name: "Mayushii"})
kotori = FanimaidButler.Repo.insert!(%FanimaidButler.Maid{name: "Kotori Minami"})
mahoro = FanimaidButler.Repo.insert!(%FanimaidButler.Maid{name: "Mahoro Andou"})