defmodule Frontend.MonitoredService do
  use Tesla
  require Logger

  plug Tesla.Middleware.BaseUrl, "http://monitored-service"
  plug Tesla.Middleware.JSON

  def get_host_info(host_id) do
    get!("/host", query: [id: host_id])
    |> Map.get(:body)
    |> Jason.decode!()
  end

  def get_services(host_id) do
    get!("/host/services", query: [id: host_id])
    |> Map.get(:body)
    |> Jason.decode!()
  end

  def search(search_string) do
    get!("/search", query: [search: search_string])
    |> Map.get(:body)
    |> Jason.decode!()
  end
end
