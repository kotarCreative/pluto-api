defmodule PlutoWeb.MessageControllerTest do
  use PlutoWeb.ConnCase

  alias Pluto.Auth.UserManager
  alias Pluto.Auth.Guardian
  alias Pluto.Core
  alias Pluto.Core.Message

  @create_attrs %{message: "some message"}
  @update_attrs %{message: "some updated message"}
  @invalid_attrs %{message: nil}

  @user_attrs %{
    email: "someemail@pluto.com",
    email_token: "some email_token",
    name: "some name",
    password: "some password",
    password_confirmation: "some password"
  }

  def fixture(:message) do
    {:ok, message} = Core.create_message(@create_attrs)
    message
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
    test "lists all messages", %{conn: conn} do
      conn = get conn, message_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create message" do
    test "renders message when data is valid", %{conn: conn} do
      conn_1 = post conn, message_path(conn, :create), message: @create_attrs
      assert %{"id" => id} = json_response(conn_1, 201)["data"]

      conn_2 = get conn, message_path(conn, :show, id)
      assert json_response(conn_2, 200)["data"] == %{
        "id" => id,
        "message" => "some message"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, message_path(conn, :create), message: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update message" do
    setup [:create_message]

    test "renders message when data is valid", %{conn: conn, message: %Message{id: id} = message} do
      conn_1 = put conn, message_path(conn, :update, message), message: @update_attrs
      assert %{"id" => ^id} = json_response(conn_1, 200)["data"]

      conn_2 = get conn, message_path(conn, :show, id)
      assert json_response(conn_2, 200)["data"] == %{
        "id" => id,
        "message" => "some updated message"}
    end

    test "renders errors when data is invalid", %{conn: conn, message: message} do
      conn = put conn, message_path(conn, :update, message), message: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete message" do
    setup [:create_message]

    test "deletes chosen message", %{conn: conn, message: message} do
      conn_1 = delete conn, message_path(conn, :delete, message)
      assert response(conn_1, 204)
      assert_error_sent 404, fn ->
        get conn, message_path(conn, :show, message)
      end
    end
  end

  defp create_message(_) do
    message = fixture(:message)
    {:ok, message: message}
  end
end
