defmodule Pluto.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :email, :string
    field :email_token, :string
    field :first_name, :string
    field :hash, :string
    field :is_active, :boolean, default: true
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :username, :string
    many_to_many :chats, Pluto.Core.Chat, join_through: "chats_users"
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation, :username])
    |> validate_required([:email, :password, :password_confirmation, :username])
    |> validate_length(:password, min: 5)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> unique_constraint(:hash)
    |> validate_confirmation(:password)
    |> validate_format(:email, ~r/@/)
    |> put_user_hash()
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    if (!changeset.errors) do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
      change(changeset, password_hash: hashpwsalt(password))
    else
      changeset
    end
  end

  defp put_user_hash(%Ecto.Changeset{changes: %{username: username, email: email}} = changeset) do
    time = DateTime.to_string(DateTime.utc_now())
    hash_string = username <> email <> time
    hash = :crypto.hash(:sha256, hash_string) |> Base.encode16()
    change(changeset, hash: hash)
  end
end
