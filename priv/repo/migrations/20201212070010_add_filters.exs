defmodule Teddy.Repo.Migrations.AddFilters do
  use Ecto.Migration

  def change do
    alter table("websites") do
      add :filter, :string, default: ""
    end

    alter table("elements") do
      add :required, :boolean, default: false
    end
  end
end
