defmodule Teddy.Fetcher.ServerTest do
  use ExUnit.Case, async: true
  import Teddy.Fetcher.Server

  doctest Teddy.Fetcher.Server

  test "is done by default" do
    {:ok, server} = new()
    assert done?(server)
  end

  test "is not done when pages are queued" do
    {:ok, server} = new()
    queue(server, :some_page)
    assert !done?(server)
  end

  test "indicates already queued pages" do
    {:ok, server} = new()
    assert :queued == queue(server, :page)
    assert :noop == queue(server, :page)
  end

  test "indicates already visited pages" do
    {:ok, server} = new()
    assert :noop == visit(server, :page)

    queue(server, :page)
    assert :visited == visit(server, :page)
    assert :noop == visit(server, :page)
  end
end
