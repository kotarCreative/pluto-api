# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pluto,
  ecto_repos: [Pluto.Repo]

# Configures the endpoint
config :pluto, PlutoWeb.Endpoint,
  url: [host: System.get_env("APP_HOST")],
  secret_key_base: System.get_env("APP_KEY"),
  render_errors: [view: PlutoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pluto.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configures UeberAuth
config :ueberauth, Ueberauth,
  providers: [
    facebook: { Ueberauth.Strategy.Facebook, [] },
  ]

# Configures Facebook UeberAuth
config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_CLIENT_ID"),
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

# Configures Guardian
config :pluto, Pluto.Auth.Guardian,
       issuer: "pluto",
       secret_key: System.get_env("GUARDIAN_SECRET_KEY")
