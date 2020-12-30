defmodule Teddy.Repo.Migrations.CreateBuckets do
  use Ecto.Migration

  def change do
    create table(:buckets) do
      add :name, :string
      add :region, :string
      add :access_key_id, :string
      add :secret_access_key, :string

      timestamps()
    end
  end
end
