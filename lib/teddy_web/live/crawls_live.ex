defmodule TeddyWeb.CrawlsLive do
  use TeddyWeb, :live_view

  def mount(_params, _args, socket) do
    socket =
      socket
      |> assign(:filter, "")
      |> assign(:expanded, nil)
      |> load_files()

    {:ok, socket}
  end

  def handle_event("expand", %{"file" => file_name}, socket) do
    socket =
      socket
      |> assign(:expanded, file_name)
      |> load_files()

    {:noreply, socket}
  end

  def handle_event("hide", _params, socket) do
    socket =
      socket
      |> assign(:expanded, nil)
      |> load_files()

    {:noreply, socket}
  end

  def handle_event("filter", %{"file_name" => %{"filter" => filter}}, socket) do
    socket =
      socket
      |> assign(:filter, filter)
      |> load_files()

    {:noreply, socket}
  end

  def handle_event("clear", _params, socket) do
    socket =
      socket
      |> assign(:filter, "")
      |> load_files()

    {:noreply, socket}
  end

  defp load_files(socket) do
    filter =
      Map.get(socket.assigns, :filter, "")
      |> IO.inspect(label: :filter)

    expanded =
      Map.get(socket.assigns, :expanded, nil)
      |> IO.inspect(label: :expanded)

    crawls =
      Teddy.Crawls.list_crawls()
      |> Enum.filter(&String.contains?(&1, filter))
      |> Enum.map(fn file_name ->
        %{
          name: file_name,
          expanded:
            if file_name == expanded do
              Teddy.Crawls.preview_crawl(file_name)
            end
        }
      end)

    socket
    |> assign(:crawls, crawls)
  end
end
