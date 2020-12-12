defmodule TeddyWeb.ElementLive.Show do
  use TeddyWeb, :live_view

  alias Teddy.Spiders

  @impl true
  def mount(%{"website_id" => website_id}, _session, socket) do
    socket =
      socket
      |> assign(:website, Spiders.get_website!(website_id))

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "website_id" => website_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:element, Spiders.get_element!(id))
     |> assign(:website, Spiders.get_website!(website_id))}
  end

  defp page_title(:show), do: "Show Element"
  defp page_title(:edit), do: "Edit Element"
end
