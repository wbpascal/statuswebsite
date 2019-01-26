defmodule FrontendWeb.MeasurementsChannel do
  use Phoenix.Channel
  require Logger

  def join("measurements:" <> service_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_in(_event, _payload, socket) do
    {:noreply, socket}
  end

  def handle_new_check_event(event = %{"serviceId" => id}) do
    Logger.debug("Sending following event to topic \"measurements:#{id}\": #{inspect(event)}")
    FrontendWeb.Endpoint.broadcast!("measurements:#{id}", "measurement", event)
  end

end
