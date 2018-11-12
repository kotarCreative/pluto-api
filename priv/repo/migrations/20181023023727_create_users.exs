defmodule Pluto.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :hash, :string
      add :name, :string
      add :email, :string
      add :email_token, :string
      add :password_hash, :string
      add :is_active, :boolean, default: true, null: false

      timestamps()
    end

    create(unique_index(:users, [:email, :hash, :name]))
  end
end
