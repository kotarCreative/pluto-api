defmodule Pluto.Core.Chat do
  use Ecto.Schema
  import Ecto.Changeset


  schema "chats" do
    field :expires_at, :utc_datetime
    field :is_private, :boolean, default: false
    field :name, :string
    field :password, :string
    field :user_id, :id
    many_to_many :users, Pluto.Core.User, join_through: "chats_users"

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:name, :password, :is_private, :expires_at])
    |> validate_required([:name, :password, :is_private, :expires_at])
    |> foreign_key_constraint(:user_id)
  end
end
