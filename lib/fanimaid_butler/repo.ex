defmodule Butler.Repo do
  use Ecto.Repo,
    otp_app: :butler,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
