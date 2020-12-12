defmodule Teddy.Spiders.Element do
  use Ecto.Schema
  import Ecto.Changeset

  alias Teddy.Spiders.Website

  schema "elements" do
    field :css_selector, :string
    field :multi, :boolean, default: false
    field :required, :boolean, default: false
    field :name, :string
    field :processing, {:array, :string}, default: []

    belongs_to(:website, Website)

    timestamps()
  end

  @doc false
  def changeset(element, attrs) do
    element
    |> cast(attrs, [:name, :website_id, :css_selector, :multi, :processing, :required])
    |> validate_required([:name, :website_id, :css_selector, :multi])
  end
end
