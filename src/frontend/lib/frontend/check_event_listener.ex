defmodule Frontend.CheckEventListener do
  use GenServer

  @recurring_time 30*1000 # Send every 30 seconds a dummy notification

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def init(_opts) do
    {:ok, %{}, @recurring_time}
  end

  def handle_info(:timeout, state) do
    measurement = Frontend.MeasurementsService.create_random_measurement(1, Timex.now() |> Timex.to_unix(), 0)

    event =
      %{
        "hostId" => 1,
        "serviceId" => measurement["serviceId"],
        "success" => measurement["responseTime"] != nil,
        "timeTaken" => measurement["responseTime"],
        "timestamp" => measurement["endTime"]
      }

    FrontendWeb.MeasurementsChannel.handle_new_check_event(event)

    {:noreply, state, @recurring_time}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end