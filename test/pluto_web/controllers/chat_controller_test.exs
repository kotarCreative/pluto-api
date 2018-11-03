defmodule PlutoWeb.ChatControllerTest do
  use PlutoWeb.ConnCase

  alias Pluto.Auth.Guardian
  alias Pluto.Auth.UserManager
  alias Pluto.Core
  alias Pluto.Core.Chat

  @create_attrs %{expires_at: "2010-04-17 14:00:00.000000Z", is_private: true, name: "some name", password: "some password"}
  @update_attrs %{expires_at: "2011-05-18T15:01:01.000000Z", is_private: false, name: "some updated name", password: "some updated password"}
  @invalid_attrs %{expires_at: nil, is_private: nil, name: nil, password: nil}

  @user_attrs %{
    email: "someemail@pluto.com",
    email_token: "some email_token",
    name: "some name",
    password: "some password",
    password_confirmation: "some password"
  }

  defp create_chat(_) do
    {:ok, chat} = Core.create_chat(@create_attrs)
    {:ok, chat: chat}
  end

  setup %{conn: conn} do
    {:ok, user} = UserManager.create_user(@user_attrs)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all chats", %{conn: conn} do
      conn = get conn, chat_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create chat" do
    test "renders chat when data is valid", %{conn: conn} do
      conn_1 = post conn, chat_path(conn, :create), chat: @create_attrs
      assert %{"id" => id} = json_response(conn_1, 201)["data"]

      conn_2 = get(conn, chat_path(conn, :show, id))
      assert json_response(conn_2, 200)["data"] == %{
        "id" => id,
        "expires_at" => "2010-04-17T14:00:00.000000Z",
        "is_private" => true,
        "name" => "some name",
        "password" => "some password"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, chat_path(conn, :create), chat: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update chat" do
    setup [:create_chat]

    test "renders chat when data is valid", %{conn: conn, chat: %Chat{id: id} = chat} do
      conn_1 = put conn, chat_path(conn, :update, chat), chat: @update_attrs
      assert %{"id" => ^id} = json_response(conn_1, 200)["data"]

      conn_2 = conn |> get(chat_path(conn, :show, id))
      assert json_response(conn_2, 200)["data"] == %{
        "id" => id,
        "expires_at" => "2011-05-18T15:01:01.000000Z",
        "is_private" => false,
        "name" => "some updated name",
        "password" => "some updated password"}
    end

    test "renders errors when data is invalid", %{conn: conn, chat: chat} do
      conn = put conn, chat_path(conn, :update, chat), chat: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete chat" do
    setup [:create_chat]

    test "deletes chosen chat", %{conn: conn, chat: chat} do
      conn_1 = delete conn, chat_path(conn, :delete, chat)
      assert response(conn_1, 204)
      assert_error_sent 404, fn ->
        conn |> get(chat_path(conn, :show, chat))
      end
    end
  end
end
