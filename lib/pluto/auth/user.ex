defmodule Pluto.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :email_token, :string
    field :name, :string
    field :password, :string
    many_to_many :chats, Pluto.Core.Chat, join_through: "chats_users"
    timestamps()
  end

  alias Comeonin.Bcrypt

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :email_token, :password])
    |> validate_required([:name, :email, :email_token, :password])
    |> validate_length(:password, min: 5)
    |> unique_constraint(:name)
    |> validate_format(:email, ~r/@/)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
