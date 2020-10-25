defmodule Teddy.Fetcher do
  alias Teddy.Fetcher.Worker

  def start_crawl(name, link) do
    Worker.start_link(name, link)
    Worker.crawl(name)
  end

  def list_crawls do
    Registry.select(Worker, [{{:"$1", :_, :_}, [], [:"$1"]}])
    |> Enum.map(&process_info/1)
  end

  defp process_info(name) do
    pid = Registry.lookup(Worker, name) |> List.first |> elem(0)
    %{name: name, info: Process.info(pid)}
  end
end
