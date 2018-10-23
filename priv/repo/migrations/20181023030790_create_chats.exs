defmodule Pluto.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :name, :string
      add :password, :string
      add :is_private, :boolean, default: false, null: false
      add :expires_at, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:chats, [:user_id])
  end
end
