defmodule Frontend.MeasurementsService do
  use Tesla
  require Logger

  plug Tesla.Middleware.BaseUrl, "http://measurements-service"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.FollowRedirects
  plug Tesla.Middleware.Logger

  def get_measurements(start_time, end_time, interval, service_id) do
    get!("/measurements/", query: [serviceId: service_id, startTime: start_time, endTime: end_time, groupBy: interval])
    |> Map.get(:body)
    |> Jason.decode!()
  end

end
