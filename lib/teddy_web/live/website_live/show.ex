defmodule TeddyWeb.WebsiteLive.Show do
  use TeddyWeb, :live_view

  alias Teddy.Spiders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page, :websites)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:website, Spiders.get_website!(id))}
  end

  defp page_title(:show), do: "Show Website"
  defp page_title(:edit), do: "Edit Website"
end
