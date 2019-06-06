defmodule Butler.Repo do
  use Ecto.Repo,
    otp_app: :fanimaid_butler,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
