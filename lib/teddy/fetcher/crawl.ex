defmodule Teddy.Fetcher.Crawl do
  defstruct start_page: "", visited: MapSet.new(), to_visit: MapSet.new()
  def new(attrs \\ []), do: __struct__(attrs)

  def queue(crawl, page) do
    cond do
      is_queued?(crawl, page) -> crawl
      is_visited?(crawl, page) -> crawl
      true -> %{crawl | to_visit: MapSet.put(crawl.to_visit, page)}
    end
  end

  def visit(crawl, page) do
    cond do
      is_visited?(crawl, page) ->
        crawl

      !is_queued?(crawl, page) ->
        crawl

      true ->
        %{
          crawl
          | to_visit: MapSet.delete(crawl.to_visit, page),
            visited: MapSet.put(crawl.visited, page)
        }
    end
  end

  def is_queued?(crawl, page), do: MapSet.member?(crawl.to_visit, page)
  def is_visited?(crawl, page), do: MapSet.member?(crawl.visited, page)
  def is_unseen?(crawl, page), do: !is_queued?(crawl, page) && !is_visited?(crawl, page)
  def done?(%__MODULE__{to_visit: to_visit}), do: MapSet.size(to_visit) == 0
end
