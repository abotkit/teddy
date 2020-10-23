defmodule Teddy.Fetcher.Task do
  @moduledoc """
  Fetches a website and returns the payload. Will follow redirects

  ## Example usage

  ```elixir
    Teddy.Fetcher.Task.fetch(URI.parse("news.ycombinator.com"))
  ```
  """
  alias Teddy.Fetcher.Check

  @max_redirects 3

  def fetch(uri, redirect_count \\ 0) do
    {:ok, response} = uri
    |> URI.to_string()
    |> HTTPoison.get([], redirect: true)

    case Check.check(response) do
      {:redirect, link} when redirect_count < @max_redirects ->
        fetch(URI.parse(link), redirect_count + 1)

      res ->
        res
    end

    # Return an empty string if the request fails
  rescue
    RuntimeError -> ""
  end
end
