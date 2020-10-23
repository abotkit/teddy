defmodule Teddy.Fetcher.Server do
  @moduledoc """
  Holds the state of a crawl. Can queue links, visit links and return if the
  queue is empty. If you queue or visit a page twice, it will indicate that with
  a `:noop` return code

  ## Example

      iex> {:ok, server} = Teddy.Fetcher.Server.new
      iex> Teddy.Fetcher.Server.queue(server, :page)
      :queued
      iex> Teddy.Fetcher.Server.queue(server, :page)
      :noop
      iex> Teddy.Fetcher.Server.done?(server)
      false
      iex> Teddy.Fetcher.Server.visit(server, :page)
      :visited
      iex> Teddy.Fetcher.Server.visit(server, :page)
      :noop
      iex> Teddy.Fetcher.Server.done?(server)
      true

  """
  use GenServer

  alias Teddy.Fetcher.Crawl

  def new, do: GenServer.start_link(__MODULE__, [])
  def queue(server, page), do: GenServer.call(server, {:queue, page})
  def visit(server, page), do: GenServer.call(server, {:visit, page})
  def done?(server), do: GenServer.call(server, :done?)

  @impl true
  def init(_) do
    {:ok, Crawl.new()}
  end

  @impl true
  def handle_call({:queue, page}, _from, crawl) do
    response = if Crawl.is_unseen?(crawl, page), do: :queued, else: :noop
    {:reply, response, Crawl.queue(crawl, page)}
  end

  @impl true
  def handle_call({:visit, page}, _from, crawl) do
    response = if Crawl.is_queued?(crawl, page), do: :visited, else: :noop
    {:reply, response, Crawl.visit(crawl, page)}
  end

  @impl true
  def handle_call(:done?, _from, crawl) do
    {:reply, Crawl.done?(crawl), crawl}
  end

  @impl true
  def handle_cast(:stats, state) do
    IO.inspect("Q: #{MapSet.size(state.to_visit)} V: #{MapSet.size(state.visited)}")
    {:noreply, state}
  end
end
