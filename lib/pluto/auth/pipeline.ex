defmodule Pluto.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :pluto,
    error_handler: Pluto.Auth.ErrorHandler,
    module: Pluto.Auth.Guardian

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
end
