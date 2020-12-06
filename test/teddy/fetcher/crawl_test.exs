defmodule Teddy.Fetcher.CrawlTest do
  use ExUnit.Case, async: true
  import Teddy.Fetcher.Crawl

  test "queueing new pages works" do
    new()
    |> queue(:a)
    |> assert_queued(:a)
    |> queue(:b)
    |> assert_queued(:b)
  end

  test "visiting pages works" do
    new()
    |> queue(:a)
    |> assert_not_visited(:a)
    |> visit(:a)
    |> assert_not_queued(:a)
    |> assert_visited(:a)
  end

  test "checking if page is queued works" do
    assert !is_queued?(new(), :a)
    assert is_queued?(new() |> queue(:a), :a)
  end

  test "checking if page is visisted works" do
    assert !is_visited?(new(), :a)
    assert !is_visited?(new() |> queue(:a), :a)
    assert is_visited?(new() |> queue(:a) |> visit(:a), :a)
  end

  test "checking if done checks work" do
    new()
    |> queue(:a)
    |> assert_not_done()
    |> visit(:a)
    |> assert_done()
  end

  defp assert_queued(crawl, page) do
    assert MapSet.member?(crawl.to_visit, page)
    crawl
  end

  defp assert_not_queued(crawl, page) do
    assert !MapSet.member?(crawl.to_visit, page)
    crawl
  end

  defp assert_visited(crawl, page) do
    assert MapSet.member?(crawl.visited, page)
    crawl
  end

  defp assert_not_visited(crawl, page) do
    assert !MapSet.member?(crawl.visited, page)
    crawl
  end

  defp assert_done(crawl) do
    assert done?(crawl)
    crawl
  end

  defp assert_not_done(crawl) do
    assert !done?(crawl)
    crawl
  end
end
