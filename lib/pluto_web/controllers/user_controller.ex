defmodule PlutoWeb.UserController do
  use PlutoWeb, :controller

  alias Pluto.Auth.User
  alias Pluto.Auth.UserManager
  alias Pluto.Auth.Guardian

  action_fallback PlutoWeb.FallbackController

  def index(conn, _params) do
    users = UserManager.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserManager.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
        |> put_status(:created)
        |> render("jwt.json", jwt: token)
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserManager.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserManager.get_user!(id)

    with {:ok, %User{} = user} <- UserManager.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserManager.get_user!(id)
    with {:ok, %User{}} <- UserManager.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
