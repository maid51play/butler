defmodule FanimaidButler.Repo do
  use Ecto.Repo, otp_app: :fanimaid_butler
  use Scrivener, page_size: 10
end
