defmodule TeddyWeb.Router do
  use TeddyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TeddyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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

  # Other scopes may use custom stacks.
  # scope "/api", TeddyWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TeddyWeb.Telemetry
    end
  end
end
