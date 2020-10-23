defmodule Teddy.Fetcher.Worker do
  alias Teddy.Fetcher.{Server, Task, Link}

  def start_crawl(link) do
    {:ok, server} = Server.new()

    uri = URI.parse(link)
    Server.queue(server, uri)
    crawl(uri, uri, server)
  end

  defp crawl(base_uri, current_uri, server) do
    IO.puts("Visiting: #{current_uri}")
    GenServer.cast(server, :stats)

    case Task.fetch(current_uri) do
      {:ok, payload} ->
        Server.visit(server, current_uri)

        Link.extract(base_uri, payload)
        |> Enum.filter(&(Server.queue(server, &1) == :queued))
        |> Enum.each(&crawl(base_uri, &1, server))

      {code, _} ->
        IO.puts("Error: #{code} for #{current_uri}")
    end
  end
end
