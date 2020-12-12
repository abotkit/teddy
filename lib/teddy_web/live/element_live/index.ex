defmodule TeddyWeb.ElementLive.Index do
  use TeddyWeb, :live_view

  alias Teddy.Spiders
  alias Teddy.Spiders.Element

  @impl true
  def mount(%{"website_id" => website_id}, _session, socket) do
    socket =
      socket
      |> assign(:website, Spiders.get_website!(website_id))
      |> assign(:elements, Spiders.list_elements(website_id))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Element")
    |> assign(:element, Spiders.get_element!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Element")
    |> assign(:element, %Element{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Elements")
    |> assign(:element, nil)
  end

  @impl true
  def handle_event("delete", %{"website_id" => website_id, "id" => id}, socket) do
    element = Spiders.get_element!(id)
    {:ok, _} = Spiders.delete_element(element)

    {:noreply, assign(socket, :elements, Spiders.list_elements(website_id))}
  end
end
