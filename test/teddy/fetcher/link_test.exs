defmodule Teddy.Fetcher.LinkTest do
  use ExUnit.Case, async: true
  import Teddy.Fetcher.Link

  doctest Teddy.Fetcher.Link

  describe "get_links/1" do
    test "with no links should return an empty list" do
      assert get_links(URI.parse("")) == []
    end

    test "with one link should return the link" do
      raw = "<html><a href=\"/the/link\">hi</a></html>"
      assert get_links(raw) == [URI.parse("/the/link")]
    end

    test "with many links should return all" do
      raw = """
      <a href="a">a</a>
      <div><a href="b">b</a></div>
      <a href="c">c</a>
      """

      assert get_links(raw) == Enum.map(["a", "b", "c"], &URI.parse/1)
    end
  end

  describe "local?/1" do
    test "for a local path should return the path" do
      assert local?(URI.parse("/a/b/c?test=42&lang=en"))
    end

    test "for a foreign path should not return" do
      assert !local?(URI.parse("https://url.com/42"))
    end

    test "for a file should return the file" do
      assert local?(URI.parse("/css/main.css?id=123"))
    end
  end
end
