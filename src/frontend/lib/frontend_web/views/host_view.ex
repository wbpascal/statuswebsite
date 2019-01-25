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

  def get_measurements(services) do
    start_time = Timex.now() |> Timex.shift(hours: -3) |> Timex.to_unix()
    end_time = Timex.now() |> Timex.to_unix()
    service_ids = services |> Enum.map(fn %{"id" => id} -> id end)

    Frontend.MeasurementsService.get_measurements(start_time, end_time, "10m", service_ids)
  end

  def get_measurements_json_data(measurements, service_id) do
    measurements
    |> Enum.filter(fn %{"serviceId" => id} -> id == service_id end)
    |> Jason.encode!()
  end

  def get_service_status_text(measurements, service_id) do
    case service_status(service_id, measurements) do
      :ok ->
        "<span class=\"badge badge-success\">Online</span>"
      :warning ->
        "<span class=\"badge badge-warning\">Warning</span>"
      :offline ->
        "<span class=\"badge badge-danger\">Offline</span>"
      _ -> # Unkown status
        "<span class=\"badge badge-muted\">Unkown</span>"
    end
  end

  def get_overall_status(services, measurements) do
    if services |> get_mayor_services() |> Enum.any?(fn %{"id" => id} -> service_status(id, measurements) != :ok end) do
      """
      <div class="col alert alert-warning" role="alert">
        <p class="host-alert-font font-big">Some services may not be reachable.</p>
      </div>
      """
    else
      """
      <div class="col alert alert-success" role="alert">
        <p class="host-alert-font font-big">All systems are operational. You should be able to reach the site.</p>
      </div>
      """
    end
  end

  defp service_status(service_id, measurements) do
    """
    Returns the status of the specified status. Status can be either :ok, :warning, :offline or :unkown.
    """

    last_measurement =
      measurements
      |> Enum.filter(fn %{"serviceId" => id} -> id == service_id end)
      |> Enum.max_by(fn %{"endTime" => end_time} -> end_time end, fn -> nil end)

    case last_measurement do
      %{"measurementsCount" => 0} -> :offline
      %{"measurementsCount" => count, "outages" => count} -> :offline
      %{"measurementsCount" => count, "outages" => outages} ->
        if outages/count > 0.5, do: :warning, else: :ok
      nil -> :unkown
    end
  end

end
