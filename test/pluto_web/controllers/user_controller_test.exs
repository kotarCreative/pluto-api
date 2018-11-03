defmodule PlutoWeb.UserControllerTest do
  use PlutoWeb.ConnCase

  alias Pluto.Auth.Guardian
  alias Pluto.Auth.User
  alias Pluto.Auth.UserManager

  @create_attrs %{
    email: "someemail@pluto.com",
    email_token: "some email_token",
    name: "some name",
    password: "some password",
    password_confirmation: "some password"
  }
  @update_attrs %{
    email: "someupdatedemail@pluto.com",
    email_token: "some updated email_token",
    name: "some updated name",
    password: "some updated password",
    password_confirmation: "some updated password"
  }
  @invalid_attrs %{
    email: nil,
    email_token: nil,
    name: nil,
    password: nil,
    password_confirmation: nil
  }

  def fixture(:user) do
    {:ok, user} = UserManager.create_user(@create_attrs)
    user
  end

  def authorize(conn, user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn |> put_req_header("authorization", "Bearer " <> token)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_user]

    test "lists all users", %{conn: conn, user: user} do
      conn = conn |> authorize(user) |> get(user_path(conn, :index))

      assert json_response(conn, 200)["data"] == [%{
        "id" => user.id,
        "is_active" => user.is_active,
        "email" => user.email,
        "email_token" => user.email_token,
        "name" => user.name}]
    end

    test "renders user", %{conn: conn, user: user} do
      conn = authorize(conn, user)
      conn = conn |> authorize(user) |> get(user_path(conn, :show, user.id))

      assert json_response(conn, 200)["data"] == %{
        "id" => user.id,
        "is_active" => user.is_active,
        "email" => user.email,
        "email_token" => user.email_token,
        "name" => user.name}
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"jwt" => token} = json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = conn |> authorize(user) |> put(user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = conn |> recycle |> authorize(user) |> get(user_path(conn, :show, id))
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_active" => true,
        "email" => "someupdatedemail@pluto.com",
        "email_token" => "some updated email_token",
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> authorize(user) |> put(user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = conn |> authorize(user) |> delete(user_path(conn, :delete, user))
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        conn |> recycle |> authorize(user) |> get(user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
