# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :fanimaid_butler,
  ecto_repos: [FanimaidButler.Repo]

# Configures the endpoint
config :fanimaid_butler, FanimaidButler.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: FanimaidButler.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FanimaidButler.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures auth
config :fanimaid_butler, FanimaidButler.Auth.Guardian,
  issuer: "fanimaid_butler",
  secret_key: System.get_env("AUTH_SECRET")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
