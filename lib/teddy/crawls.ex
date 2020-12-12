defmodule Teddy.Crawls do
  @crawl_dir System.tmp_dir!() <> "/crawls"
  @ignored_files MapSet.new([".keep"])

  def list_crawls() do
    File.mkdir(@crawl_dir)
    {:ok, listing} = File.ls(@crawl_dir)

    listing
    |> Enum.reject(&MapSet.member?(@ignored_files, &1))
    |> Enum.sort()
    |> Enum.reverse()
  end

  def get_path(file_name) do
    @crawl_dir <> "/" <> file_name
  end

  def preview_crawl(file_name) do
    stream = File.stream!(get_path(file_name))

    preview =
      stream
      |> Stream.take(3)
      |> Enum.to_list()

    count =
      stream
      |> Enum.to_list()
      |> Enum.count()

    %{preview: preview, count: count}
  end
end
