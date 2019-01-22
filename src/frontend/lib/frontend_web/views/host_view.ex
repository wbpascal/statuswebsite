defmodule FrontendWeb.HostView do
  use FrontendWeb, :view

  def get_services(host_id) do
    Frontend.MonitoredService.get_services(host_id)
  end

  def get_mayor_services(services) do
    services |> Enum.filter(fn %{"type" => type} -> type == "mayor" end)
  end

  def get_minor_services(services) do
    services |> Enum.filter(fn %{"type" => type} -> type == "minor" end)
  end

end
