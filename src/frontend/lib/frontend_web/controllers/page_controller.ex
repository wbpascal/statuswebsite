defmodule FrontendWeb.PageController do
  use FrontendWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
