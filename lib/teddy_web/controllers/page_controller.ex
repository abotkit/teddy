defmodule TeddyWeb.PageController do
  use TeddyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
