defmodule TeddyWeb.CrawlController do
  use TeddyWeb, :controller

  alias Teddy.Crawls

  def download_file(conn, %{"file_name" => file_name}) do
    send_download(conn, {:file, Crawls.get_path(file_name)})
  end
end
