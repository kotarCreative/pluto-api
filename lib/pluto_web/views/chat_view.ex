defmodule PlutoWeb.ChatView do
  use PlutoWeb, :view
  alias PlutoWeb.ChatView

  def render("index.json", %{chats: chats}) do
    %{data: render_many(chats, ChatView, "chat.json")}
  end

  def render("show.json", %{chat: chat}) do
    %{data: render_one(chat, ChatView, "chat.json")}
  end

  def render("chat.json", %{chat: chat}) do
    %{id: chat.id,
      name: chat.name,
      password: chat.password,
      is_private: chat.is_private,
      expires_at: chat.expires_at}
  end
end
