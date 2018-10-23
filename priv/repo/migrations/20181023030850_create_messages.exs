defmodule Pluto.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :text
      add :chat_id, references(:chats, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:chat_id])
    create index(:messages, [:user_id])
  end
end
