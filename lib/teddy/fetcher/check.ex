defmodule Teddy.Fetcher.Check do
  def check(%HTTPoison.Response{status_code: 301, headers: headers}) do
    case List.keyfind(headers, "Location", 0) do
      nil -> {:error, "No redirect given"}
      {"Location", location} -> {:redirect, location}
    end
  end

  def check(%HTTPoison.Response{status_code: status, body: body}) when status < 400 do
    {:ok, body}
  end

  def check(%HTTPoison.Response{body: body}) do
    {:error, body}
  end

  def check(%HTTPoison.Error{reason: reason}) do
    {:error, reason}
  end
end
