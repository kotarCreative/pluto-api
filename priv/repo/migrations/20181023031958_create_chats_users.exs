defmodule Pluto.Repo.Migrations.CreateChatsUsers do
  use Ecto.Migration

  def change do
    create table(:chats_users) do
      add :chat_id, references(:chats)
      add :user_id, references(:users)
      add :is_banned, :boolean, default: false, null: false
      add :banned_at, :utc_datetime
    end

    create unique_index(:chats_users, [:user_id, :chat_id])
  end
end
