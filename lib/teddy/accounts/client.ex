defmodule Teddy.Accounts.Client do
  use Ecto.Schema
  import Ecto.Changeset

  @website_regex ~r[https?://]
  @invalid_website "Please add http(s)://"

  schema "clients" do
    field :name, :string
    field :website, :string

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :website])
    |> validate_required([:name, :website])
    |> validate_format(:website, @website_regex, message: @invalid_website)
  end
end
