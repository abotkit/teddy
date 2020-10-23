defmodule Teddy.Fetcher.Link do
  @moduledoc """
  Extracts links from raw html
  """

  @doc """
  Returns all links from raw html

  ## Examples

      iex> Teddy.Fetcher.Link.get_links("<a href='href'>link</a>")
      [URI.parse("href")]

  """
  def get_links(raw_body) do
    {:ok, body} = Floki.parse_document(raw_body)

    body
    |> Floki.find("a")
    |> Enum.flat_map(&Floki.attribute(&1, "href"))
    |> Enum.map(&URI.parse/1)
  end

  @doc """
  Returns a tuple `{:ok, path}` if the uri is a local path or `:error` otherwise

  ## Examples

      iex> Teddy.Fetcher.Link.local?(URI.parse("/local/path?id=42&a=b"))
      true

      iex> Teddy.Fetcher.Link.local?(URI.parse("https://localhost:4000/hi"))
      false

  """
  def local?(uri) do
    uri |> local_path()
  end

  defp local_path(%URI{host: nil, path: path}) when path != nil, do: true
  defp local_path(_), do: false

  @doc """
  Returns `true` if `uri` points to a file, `false` otherwise

  ## Examples

      iex> Teddy.Fetcher.Link.file?(URI.parse("/css/main.css&id=123"))
      true

      iex> Teddy.Fetcher.Link.file?(URI.parse("/a/b/c"))
      false

  """
  def file?(uri) do
    uri
    |> Map.get(:path)
    |> String.split("/")
    |> List.last()
    |> String.contains?("\.")
  end

  def javascript?(uri) do
    uri |> javascript_path()
  end

  defp javascript_path(%URI{scheme: "javascript"}), do: true
  defp javascript_path(_uri), do: false

  def extract(uri, payload) do
    get_links(payload)
    |> Enum.filter(&local?/1)
    |> Enum.reject(&file?/1)
    |> Enum.reject(&javascript?/1)
    |> Enum.map(&URI.merge(uri, &1))
  end
end
