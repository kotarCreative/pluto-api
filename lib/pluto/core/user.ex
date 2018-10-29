defmodule Pluto.Core.User do
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

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :email_token, :password])
    |> validate_required([:name, :email, :email_token, :password])
    |> validate_length(:password, min: 5)
    |> unique_constraint(:name)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
