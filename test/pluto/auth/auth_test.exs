defmodule Pluto.AuthTest do
  use Pluto.DataCase

  alias Pluto.Auth.UserManager

  describe "users" do
    alias Pluto.Auth.User

    @valid_attrs %{email: "someemail@pluto.com", email_token: "some email_token", name: "some name", password: "some password", password_confirmation: "some password"}
    @update_attrs %{email: "someupdatedemail@pluto.com", email_token: "some updated email_token", name: "some updated name", password: "some updated password", password_confirmation: "some updated password"}
    @invalid_attrs %{email: nil, email_token: nil, name: nil, password: nil, password_confirmation: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserManager.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserManager.list_users() == [%User{user | password: nil, password_confirmation: nil}]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserManager.get_user!(user.id) == %User{user | password: nil, password_confirmation: nil}
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserManager.create_user(@valid_attrs)
      assert user.email == "someemail@pluto.com"
      assert user.email_token == "some email_token"
      assert user.name == "some name"
      assert Bcrypt.verify_pass("some password", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserManager.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = UserManager.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "someupdatedemail@pluto.com"
      assert user.email_token == "some updated email_token"
      assert user.name == "some updated name"
      assert Bcrypt.verify_pass("some updated password", user.password_hash)

    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserManager.update_user(user, @invalid_attrs)
      assert %User{user | password: nil, password_confirmation: nil} == UserManager.get_user!(user.id)
      assert Bcrypt.verify_pass("some password", user.password_hash)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserManager.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserManager.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserManager.change_user(user)
    end
  end
end
