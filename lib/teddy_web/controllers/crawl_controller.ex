defmodule TeddyWeb.CrawlController do
  use TeddyWeb, :controller

  alias Teddy.Fetcher
  alias Teddy.Accounts

  def index(conn, _params) do
    render(conn, "index.html", processes: Fetcher.list_crawls)
  end

  def run(conn, %{"id" => id}) do
    %{name: name, website: website} = Accounts.get_client!(id)
    Fetcher.start_crawl(name, website)

    conn
    |> put_flash(:info, "Started the crawl for #{name}")
    |> redirect(to: Routes.crawl_path(conn, :index))
  end
end
