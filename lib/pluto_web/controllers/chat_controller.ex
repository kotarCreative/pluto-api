defmodule PlutoWeb.ChatController do
  use PlutoWeb, :controller

  def index(conn, _params) do
    chats = []
    json conn, chats
  end
end
