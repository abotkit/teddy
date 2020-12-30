defmodule TeddyWeb.CrawlsLive do
  use TeddyWeb, :live_view

  def mount(_params, _args, socket) do
    socket =
      socket
      |> assign(:filter, "")
      |> assign(:expanded, nil)
      |> assign(:page, :crawls)
      |> assign(:selected, MapSet.new())
      |> assign(:buckets, Teddy.Spiders.list_buckets())
      |> load_files()

    {:ok, socket}
  end

  def handle_event("select_file", %{"file" => file} = params, socket) do
    selected = socket.assigns.selected
    value = Map.get(params, "value")

    selected =
      case value do
        "true" -> MapSet.put(selected, file)
        _ -> MapSet.delete(selected, file)
      end

    {:noreply, assign(socket, :selected, selected)}
  end

  def handle_event("delete_file", %{"file" => file}, socket) do
    case Teddy.Crawls.delete_crawl(file) do
      :ok ->
        socket =
          socket
          |> put_flash(:info, "Deleted #{file}")
          |> assign(:selected, MapSet.delete(socket.assigns.selected, file))
          |> load_files()

        {:noreply, socket}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, reason)}
    end
  end

  def handle_event("upload_selected", %{"upload" => %{"bucket" => bucket_id}}, socket) do
    Enum.each(socket.assigns.selected, fn file_name ->
      Task.async(fn -> Teddy.Crawls.upload_crawl(file_name, bucket_id) end)
    end)

    socket =
      socket
      |> put_flash(:info, "Uploading files in background")
      |> assign(:selected, MapSet.new())

    {:noreply, socket}
  end

  def handle_info({_pid, s3_result}, socket) do
    case s3_result do
      {:ok, _res} -> {:noreply, put_flash(socket, :info, "S3 task finished")}
      _ -> {:noreply, put_flash(socket, :error, "S3 task failed")}
    end
  end

  def handle_info({:DOWN, _, _, _, _}, socket) do
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
    filter = Map.get(socket.assigns, :filter, "")
    expanded = Map.get(socket.assigns, :expanded, nil)

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
