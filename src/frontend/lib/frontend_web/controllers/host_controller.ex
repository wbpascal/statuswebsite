defmodule FrontendWeb.HostController do
  use FrontendWeb, :controller
  require Logger

  def index(conn, %{"id" => id}) do
    render(conn, "index.html", id: id)
  end

end
