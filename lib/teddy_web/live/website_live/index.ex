defmodule TeddyWeb.WebsiteLive.Index do
  use TeddyWeb, :live_view

  alias Teddy.Spiders
  alias Teddy.Spiders.Website

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:websites, list_websites())
      |> assign(:page, :websites)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Website")
    |> assign(:website, Spiders.get_website!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Website")
    |> assign(:website, %Website{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Websites")
    |> assign(:website, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    website = Spiders.get_website!(id)
    {:ok, _} = Spiders.delete_website(website)

    {:noreply, assign(socket, :websites, list_websites())}
  end

  defp list_websites do
    Spiders.list_websites()
  end
end
