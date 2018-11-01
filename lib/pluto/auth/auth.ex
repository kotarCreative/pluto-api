defmodule Pluto.Auth do
  import Ecto.Query, warn: false
  alias Pluto.Repo
  alias Pluto.Auth.User
  alias Pluto.Auth.Guardian
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def token_sign_in(username, password) do
    case authenticate_user(username, password) do
      {:ok, user} ->
        Guardian.encode_and_sign(user)
      _ ->
        {:error, :unauthorized}
    end
  end

  defp authenticate_user(username, password) when is_binary(username) and is_binary(password) do
    with {:ok, user} <- get_by_username(username),
    do: verify_password(password, user)
  end

  defp get_by_username(name) when is_binary(name) do
    case Repo.get_by(User, name: name) do
      nil ->
        dummy_checkpw()
        {:error, "Login error."}
      user ->
        {:ok, user}
    end
  end

  defp verify_password(password, %User{} = user) when is_binary(password) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end
end
