defmodule Teddy.Spiders.Bucket do
  use Ecto.Schema
  import Ecto.Changeset

  schema "buckets" do
    field :access_key_id, :string
    field :name, :string
    field :region, :string
    field :secret_access_key, :string

    timestamps()
  end

  @doc false
  def changeset(bucket, attrs) do
    bucket
    |> cast(attrs, [:name, :region, :access_key_id, :secret_access_key])
    |> validate_required([:name, :region, :access_key_id, :secret_access_key])
  end
end
