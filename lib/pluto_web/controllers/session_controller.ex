defmodule PlutoWeb.SessionController do
  use PlutoWeb, :controller

  alias PlutoWeb.UserView
  alias Pluto.{Auth}

  def login(conn, %{"username" => username, "password" => password}) do
    case Auth.token_sign_in(username, password) do
      {:ok, token, _claims} ->
        conn |> render(UserView, "jwt.json", jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
  end
end
