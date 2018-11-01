defmodule Pluto.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :email, :string
    field :email_token, :string
    field :is_active, :boolean, default: true
    field :name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    many_to_many :chats, Pluto.Core.Chat, join_through: "chats_users"
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :email_token, :password, :password_confirmation])
    |> validate_required([:name, :email, :email_token, :password, :password_confirmation])
    |> validate_length(:password, min: 5)
    |> unique_constraint(:name)
    |> unique_constraint(:email)
    |> validate_confirmation(:password)
    |> validate_format(:email, ~r/@/)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: hashpwsalt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
