defmodule TeddyWeb.SpiderLive do
  use TeddyWeb, :live_view

  def render(assigns) do
    ~L"""
    <h1>Spiders</h1>
    <button phx-click="refresh">Recompile spiders</button>

    <table>
      <tr>
        <th>Name</th>
        <th>Status</th>
        <th>Progress</th>
        <th>Process</th>
        <th></th>
      </tr>

    <%= for spider <- @spiders do %>
    <tr>
      <td><%= spider.name %></td>
      <td><%= spider.status %></td>
      <td>
        <%= if spider.status == "started" do %>
          Done: <%= elem(spider.stats.data_storage, 1) %><br>
          Queue: <%= elem(spider.stats.requests_storage, 1) %>
        <% else %>
          -
        <% end %>
      </td>
      <td>
        <%= if spider.status == "started" do %>
          Status: <%= spider.proc_info[:status] %><br>
          Heap: <%= spider.proc_info[:heap_size] %><br>
          Queue: <%= spider.proc_info[:message_queue_len] %>
        <% else %>
          -
        <% end %>
      </td>
      <td>
        <button phx-click="start" phx-value-spider=<%= spider.name %>>Start</button>
        <button phx-click="stop" phx-value-spider=<%= spider.name %>>Stop</button>
      </td>
    </tr>
    <% end %>

    </table>
    """
  end

  def mount(_params, _args, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 100)

    spiders = Teddy.Spiders.list_spiders()
    {:ok, assign(socket, :spiders, spiders)}
  end

  def handle_event("refresh", _params, socket) do
    Crawly.Engine.refresh_spider_list()
    {:noreply, socket}
  end

  def handle_event("start", %{"spider" => name}, socket) do
    Teddy.Spiders.start_spider(name)
    {:noreply, socket}
  end

  def handle_event("stop", %{"spider" => name}, socket) do
    Teddy.Spiders.stop_spider(name)
    {:noreply, socket}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 100)

    {:noreply, assign(socket, :spiders, Teddy.Spiders.list_spiders())}
  end
end
