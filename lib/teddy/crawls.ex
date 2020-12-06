defmodule Teddy.Crawls do
  @crawl_dir "./crawls/"
  @ignored_files MapSet.new([".keep"])

  def list_crawls() do
    {:ok, listing} = File.ls(@crawl_dir)

    listing
    |> Enum.reject(&MapSet.member?(@ignored_files, &1))
    |> Enum.sort()
    |> Enum.reverse()
  end

  def preview_crawl(file_name) do
    File.stream!(@crawl_dir <> file_name)
    |> Stream.take(3)
  end
end
