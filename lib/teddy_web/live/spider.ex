defmodule TeddyWeb.SpiderLive do
  use TeddyWeb, :live_view

  def mount(_params, _args, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 1000)

    socket =
      socket
      |> assign(:spiders, Teddy.Spiders.list_spiders())
      |> assign(:page, :spiders)

    {:ok, socket}
  end

  def handle_event("start", %{"spider" => name}, socket) do
    Teddy.Spiders.start_spider(name)
    {:noreply, put_flash(socket, :info, "Started crawler")}
  end

  def handle_event("stop", %{"spider" => name}, socket) do
    Teddy.Spiders.stop_spider(name)
    {:noreply, put_flash(socket, :info, "Stopped crawler")}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 1000)

    {:noreply, assign(socket, :spiders, Teddy.Spiders.list_spiders())}
  end
end
