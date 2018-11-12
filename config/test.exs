use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pluto, PlutoWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, :log_rounds, 4

# Configure your database
config :pluto, Pluto.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USER_TEST"),
  password: System.get_env("DB_PASSWORD_TEST"),
  database: System.get_env("DB_NAME_TEST"),
  hostname: System.get_env("DB_HOST_TEST"),
  pool: Ecto.Adapters.SQL.Sandbox
