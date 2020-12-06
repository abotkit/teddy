defmodule Teddy.Spiders do
  @spider_module_prefix "Elixir.Teddy.Spiders."

  def list_spiders() do
    Crawly.Engine.list_known_spiders()
    |> Enum.map(&format_spider/1)
  end

  defp format_spider(%{name: module, pid: {pid, _uuid}, status: :started = status}) do
    %{
      name:
        module
        |> to_string()
        |> String.replace_prefix(@spider_module_prefix, ""),
      status: to_string(status),
      stats: spider_stats(module),
      proc_info: Process.info(pid)
    }
  end

  defp format_spider(%{name: module, status: :stopped = status}) do
    %{
      name:
        module
        |> to_string()
        |> String.replace_prefix(@spider_module_prefix, ""),
      status: to_string(status),
      stats: spider_stats(module)
    }
  end

  def start_spider(name) do
    (@spider_module_prefix <> name)
    |> String.to_existing_atom()
    |> Crawly.Engine.start_spider()
  end

  def stop_spider(name) do
    (@spider_module_prefix <> name)
    |> String.to_existing_atom()
    |> Crawly.Engine.stop_spider()
  end

  @doc """
  Returns `data_storage` and `requests_storage` statistics about the running
  crawl or an error if the spider is stopped.

  ## For running spiders

      iex> spider_stats(running_spider)
      %{data_storage: {:stored_items, 0}, requests_storage: {:stored_requests, 23}}

  ## For stopped spiders

      iex> spider_stats(stopped_spider)
      %{
          data_storage: {:error, :data_storage_worker_not_running},
          requests_storage: {:error, :storage_worker_not_running}
      }

  """
  def spider_stats(module) do
    %{
      data_storage: Crawly.DataStorage.stats(module),
      requests_storage: Crawly.RequestsStorage.stats(module)
    }
  end
end
