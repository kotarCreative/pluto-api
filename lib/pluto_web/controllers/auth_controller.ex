defmodule PlutoWeb.AuthController do
  use PlutoWeb, :controller

  plug Ueberauth

  alias Pluto.Repo
  alias Pluto.Auth.{Guardian, User, UserManager}

  alias Pluto.Router.Helpers

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    signin_or_register(conn, auth)
  end

  def register(conn, params) do

    case UserManager.create_user(params) do
      {:ok, %User{} = user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, json(conn, %{jwt: token}))
      {:error, result} ->
        render conn, "registration.html", user_data: params, callback_url: auth_path(conn, :register), errors: result.errors
     end
  end

  defp signin_or_register(conn, auth) do
    email = auth.info.email
    [ first_name, last_name ] = String.split(auth.info.name, " ")

    case Repo.get_by(User, email: email) do
      nil ->
        user_data = %{
            "email" => email,
            "first_name" => first_name,
            "last_name" => last_name,
            "username" => auth.info.name
        }
        render conn, "registration.html", user_data: user_data, callback_url: auth_path(conn, :register)
      user ->
        {:ok, token, _ignore} = Guardian.encode_and_sign(user)
        conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, json(conn, %{jwt: token}))
    end
  end
end
