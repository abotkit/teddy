defmodule TeddyWeb.Router do
  use TeddyWeb, :router

  import Phoenix.LiveDashboard.Router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TeddyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    if Mix.env() == :prod do
      plug :basic_auth, username: "abotkit", password: "abotkit"
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TeddyWeb do
    pipe_through :browser

    get "/download/:file_name", CrawlController, :download_file

    # live "/", PageLive, :index
    live "/", SpiderLive
    live "/crawls", CrawlsLive

    live "/websites", WebsiteLive.Index, :index
    live "/websites/new", WebsiteLive.Index, :new
    live "/websites/:id/edit", WebsiteLive.Index, :edit
    live "/websites/:id", WebsiteLive.Show, :show
    live "/websites/:id/show/edit", WebsiteLive.Show, :edit

    live "/websites/:website_id/elements", ElementLive.Index, :index
    live "/websites/:website_id/elements/new", ElementLive.Index, :new
    live "/websites/:website_id/elements/:id/edit", ElementLive.Index, :edit
    live "/websites/:website_id/elements/:id", ElementLive.Show, :show
    live "/websites/:website_id/elements/:id/show/edit", ElementLive.Show, :edit
  end

  scope "/" do
    pipe_through :browser
    live_dashboard "/dashboard", metrics: TeddyWeb.Telemetry
  end
end
