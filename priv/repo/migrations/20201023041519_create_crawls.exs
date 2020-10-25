defmodule Teddy.Repo.Migrations.CreateCrawls do
  use Ecto.Migration

  def change do
    create table(:crawls) do
      add :client_id, :integer

      add :state, :string
      add :pages_found, :integer

      timestamps()
    end

  end
end
