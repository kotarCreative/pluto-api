defmodule Pluto.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :email_token, :string

      timestamps()
    end

  end
end
