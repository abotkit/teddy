defmodule Teddy.Fetcher.Worker do
  require Logger
  use GenServer

  alias Teddy.Fetcher.{Server, Website, Link}

  # Client API
  def start_link(name, link) do
    GenServer.start_link(__MODULE__, link, name: via_tuple(name))
  end

  defp via_tuple(name) do
    {:via, Registry, {__MODULE__, name}}
  end

  def crawl(name), do: GenServer.cast(via_tuple(name), :crawl)
  def state(name), do: GenServer.call(via_tuple(name), :state)

  # GenServer
  def init(link) do
    with uri <- URI.parse(link),
         {:ok, server} <- Server.new() do
      {:ok, %{base_uri: uri, current_uri: uri, server: server}}
    end
  end

  def handle_call(:state, _from, state), do: {:reply, state, state}

  # TODO: @max refactor this mess
  # This should have base/current uri as arguments
  # so we can use GenServer to call itself
  def handle_cast(:crawl, state) do
    %{base_uri: base_uri, current_uri: current_uri, server: server} = state

    IO.puts("Visiting: #{current_uri}")
    GenServer.cast(server, :stats)

    case Website.fetch(current_uri) do
      {:ok, payload} ->
        Logger.info("Uploading to S3")

        spawn(fn ->
          s3_key = "#{current_uri.host}#{current_uri.path}"
          ExAws.S3.put_object(
            "devcrawl",
            "#{s3_key}.txt.gzip",
            :zlib.gzip(payload)
          ) |> ExAws.request!()
          Logger.info("S3 upload done")
        end)

        Server.visit(server, current_uri)

        Link.extract(base_uri, payload)
        |> Enum.filter(&(Server.queue(server, &1) == :queued))
        |> Enum.each(&handle_cast(:crawl, %{state | current_uri: &1}))

      {code, _} ->
        Logger.info("Error: #{code} for #{current_uri}")
    end

    {:stop, :normal, state}
  end
end
