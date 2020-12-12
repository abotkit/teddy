defmodule Teddy.Repo.Migrations.CreateElements do
  use Ecto.Migration

  def change do
    create table(:elements) do
      add :website_id, references(:websites)

      add :name, :string
      add :css_selector, :string
      add :multi, :boolean, default: false, null: false
      add :processing, {:array, :string}

      timestamps()
    end
  end
end
