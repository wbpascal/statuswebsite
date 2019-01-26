defmodule Frontend.MeasurementsService do

  def get_measurements(start_time, end_time, "10m", services) do
    create_measurements(start_time + 10*60, 10*60, end_time, services) # Create dummy measurements
  end

  defp create_measurements(cur_time, interval, end_time, services) do
    if cur_time > end_time do
      []
    else
      measurements = services |> Enum.map(fn id -> create_random_measurement(id, cur_time, interval) end)
      measurements ++ create_measurements(cur_time + interval, interval, end_time, services)
    end
  end

  def create_random_measurement(service_id, cur_time, interval) do
    count = 10
    outages = :rand.uniform(count)
    resp_time =
      if count == outages do
        nil
      else
        :math.pow(6, :rand.uniform() * 1.5 + 2)
      end

    %{
      "serviceId" => service_id,
      "responseTime" => resp_time,
      "startTime" => cur_time - interval,
      "endTime" => cur_time,
      "measurementsCount" => count,
      "outages" => outages,
      "tries" => 1
    }
  end

end
