defmodule Pluto.Auth do
  import Ecto.Query, warn: false
  alias Pluto.Repo
  alias Comeonin.Bcrypt
  alias Pluto.Auth.User

  @doc """
  Returns a check if the user can be authenticated or not.
  """
  def authenticate_user(username, plain_text_password) do
    query = from u in User, where: u.name == ^username
    case Repo.one(query) do
      nil ->
        Bcrypt.dummy_checkpw()
        {:error, :invalid_credentials}
      user ->
        if Bcrypt.checkpw(plain_text_password, user.password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
