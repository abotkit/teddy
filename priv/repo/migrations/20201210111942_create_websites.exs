defmodule Teddy.Repo.Migrations.CreateWebsites do
  use Ecto.Migration

  def change do
    create table(:websites) do
      add :name, :string
      add :description, :string
      add :base_url, :string

      timestamps()
    end
  end
end
