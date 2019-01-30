defmodule FrontendWeb.HostController do
  use FrontendWeb, :controller
  require Logger

  def index(conn, %{"id" => id}) do
    host_info = Frontend.MonitoredService.get_host_info(id)
    services =
      Frontend.MonitoredService.get_services(host_info["id"])
      |> Enum.sort_by(fn service -> service["name"] |> String.downcase() end)
    render(conn, "index.html", host: host_info, services: services)
  end
end
