use Mix.Config

config :fanimaid_butler, env: Mix.env
# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fanimaid_butler, Butler.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :fanimaid_butler, Butler.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "fanimaid_butler_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
