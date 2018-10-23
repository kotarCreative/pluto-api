defmodule Pluto.Core.Report do
  use Ecto.Schema
  import Ecto.Changeset


  schema "reports" do
    field :message, :string
    field :chat_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
    |> cast(attrs, [:message])
    |> validate_required([:message])
    |> foreign_key_constraint(:chat_id)
    |> foreign_key_constraint(:user_id)
  end
end
