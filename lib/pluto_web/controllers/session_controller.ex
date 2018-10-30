defmodule PlutoWeb.SessionController do
  use PlutoWeb, :controller

  alias PlutoWeb.{UserManager, UserManager.User, UserManager.Guardian}

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    UserManager.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/secret")
  end
end
