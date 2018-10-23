defmodule Pluto.Core.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :email_token, :string
    field :name, :string
    many_to_many :chats, Pluto.Core.Chat, join_through: "chats_users"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :email_token])
    |> validate_required([:name, :email, :email_token])
  end
end
