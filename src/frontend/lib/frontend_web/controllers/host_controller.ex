defmodule FrontendWeb.HostController do
  use FrontendWeb, :controller
  require Logger

  def index(conn, %{"id" => id}) do
    host_info = Frontend.MonitoredService.get_host_info(id)
    render(conn, "index.html", host: host_info)
  end
end
