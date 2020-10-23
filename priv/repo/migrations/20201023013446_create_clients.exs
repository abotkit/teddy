defmodule Teddy.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :name, :string
      add :website, :string

      timestamps()
    end

  end
end
