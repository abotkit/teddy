defmodule Teddy.Fetcher.CheckTest do
  use ExUnit.Case, async: true
  doctest Teddy.Fetcher.Check

  import Teddy.Fetcher.Check

  test "should follow redirects" do
    headers = [{"c", "d"}, {"Location", "redirect"}, {"a", "b"}]
    response = %HTTPoison.Response{status_code: 301, headers: headers}
    assert {:redirect, "redirect"} = check(response)
  end

  test "should fail for broken redirects" do
    headers = [{"c", "d"}, {"a", "b"}]
    response = %HTTPoison.Response{status_code: 301, headers: headers}
    assert {:error, "No redirect given"} = check(response)
  end

  test "should handle valid responses" do
    response = %HTTPoison.Response{status_code: 200, body: "HTML"}
    assert {:ok, "HTML"} = check(response)
  end

  test "should handle 400/500 responses" do
    response = %HTTPoison.Response{status_code: 404, body: "denied"}
    assert {:error, "denied"} = check(response)
  end

  test "should handle failed requests" do
    response = %HTTPoison.Error{reason: "reason"}
    assert {:error, "reason"} = check(response)
  end
end
