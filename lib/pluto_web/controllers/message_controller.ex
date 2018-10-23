defmodule PlutoWeb.MessageController do
  use PlutoWeb, :controller

  alias Pluto.Core
  alias Pluto.Core.Message

  action_fallback PlutoWeb.FallbackController

  def index(conn, _params) do
    messages = Core.list_messages()
    render(conn, "index.json", messages: messages)
  end

  def create(conn, %{"message" => message_params}) do
    with {:ok, %Message{} = message} <- Core.create_message(message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", message_path(conn, :show, message))
      |> render("show.json", message: message)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Core.get_message!(id)
    render(conn, "show.json", message: message)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Core.get_message!(id)

    with {:ok, %Message{} = message} <- Core.update_message(message, message_params) do
      render(conn, "show.json", message: message)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Core.get_message!(id)
    with {:ok, %Message{}} <- Core.delete_message(message) do
      send_resp(conn, :no_content, "")
    end
  end
end
