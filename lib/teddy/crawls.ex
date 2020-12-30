defmodule Teddy.Crawls do
  @crawl_dir System.tmp_dir!() <> "/crawls"
  @ignored_files MapSet.new([".keep"])

  alias ExAws.S3

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

  def upload_crawl(file_name, bucket_id) do
    bucket = Teddy.Spiders.get_bucket!(bucket_id)

    file_name
    |> get_path()
    |> S3.Upload.stream_file()
    |> S3.upload(bucket.name, file_name)
    |> ExAws.request(
      access_key_id: bucket.access_key_id,
      secret_access_key: bucket.secret_access_key,
      region: bucket.region
    )

    # |> case do
    #   {:ok, _} ->
    #   {:error, e} ->
    # end
  end

  def delete_crawl(file_name) do
    file_name
    |> get_path()
    |> File.rm()
  end
end
