defmodule Frontend.CheckEventListener do
  use GenServer
  use AMQP

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  @exchange "icinga_checks"

  def init(_opts) do
    rabbitmq_connect()
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    spawn fn -> consume(chan, tag, redelivered, payload) end
    {:noreply, chan}
  end

  def handle_info({:DOWN, _, :process, _pid, _reason}, _) do
    {:ok, chan} = rabbitmq_connect()
    {:noreply, chan}
  end

  defp setup_queue(channel) do
    {:ok, %{queue: queue_name}} = AMQP.Queue.declare(channel, "", exclusive: true)
    AMQP.Exchange.fanout(channel, @exchange, durable: true)
    AMQP.Queue.bind(channel, queue_name, @exchange)

    queue_name
  end

  defp consume(channel, tag, _redelivered, payload) do
    payload
    |> Jason.decode!()
    |> FrontendWeb.MeasurementsChannel.handle_new_check_event()

    Basic.ack(channel, tag)
  end

  defp rabbitmq_connect() do
    case Connection.open("amqp://#{System.get_env("RABBITMQ_USER")}:#{System.get_env("RABBITMQ_PASS")}@rabbitmq") do
      {:ok, conn} ->
        # Get notifications when the connection goes down
        Process.monitor(conn.pid)

        {:ok, chan} = Channel.open(conn)
        queue_name = setup_queue(chan)
        {:ok, _consumer_tag} = Basic.consume(chan, queue_name)
        {:ok, chan}

      {:error, _} ->
        # Reconnection loop
        :timer.sleep(10000)
        rabbitmq_connect()
    end
  end
end