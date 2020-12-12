defmodule Teddy.Spiders.Website do
  use Ecto.Schema
  import Ecto.Changeset

  alias Teddy.Spiders.Element

  schema "websites" do
    field :base_url, :string
    field :description, :string
    field :name, :string
    field :filter, :string, default: ""

    has_many(:elements, Element, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(website, attrs) do
    website
    |> cast(attrs, [:name, :description, :base_url, :filter])
    |> validate_required([:name, :description, :base_url])
  end
end
