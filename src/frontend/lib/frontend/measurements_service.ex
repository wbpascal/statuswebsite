defmodule Frontend.MeasurementsService do

  def get_measurements(start_time, end_time, "10m", services) do
    create_measurements(start_time + 10*60, 10*60, end_time, services)
  end

  defp create_measurements(cur_time, interval, end_time, services) do
    if cur_time > end_time do
      []
    else
      measurements =
        services
        |> Enum.map(
             fn id ->
               count = 10
               outages = :rand.uniform(10)
               resp_time =
                 if count == outages do
                   nil
                 else
                   Enum.random(50..500)
                 end

               %{
                 "serviceId" => id,
                 "responseTime" => resp_time,
                 "startTime" => cur_time - interval,
                 "endTime" => cur_time,
                 "measurementsCount" => count,
                 "outages" => outages,
                 "tries" => 1
               }
             end
           )

      measurements ++ create_measurements(cur_time + interval, interval, end_time, services)
    end
  end

end
