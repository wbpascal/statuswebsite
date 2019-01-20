package influxdb.listener.utility;

import com.google.gson.Gson;
import com.rabbitmq.client.ConnectionFactory;
import influxdb.listener.models.rabbitmq.CheckResultMessage;
import influxdb.listener.utility.rabbitmq.ChannelWrapper;
import influxdb.listener.utility.rabbitmq.ConnectionWrapper;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeoutException;

public class RabbitMqService {
    private static final ConnectionWrapper DEFAULT_CONNECTION;
    private static final ChannelWrapper DEFAULT_CHANNEL;
    private static final String DEFAULT_EXCHANGE = "icinga_checks";

    static {
        DEFAULT_CONNECTION = createDefaultConnection();
        DEFAULT_CHANNEL = createDefaultChannelWrapper();
    }

    public static void publishIcingaCheckEvent(CheckResultMessage message) {
        String json = new Gson().toJson(message);
        try {
            DEFAULT_CHANNEL.getChannel().basicPublish(DEFAULT_EXCHANGE, "", null, json.getBytes(StandardCharsets.UTF_8));
        } catch (IOException | TimeoutException e) {
            System.out.println("Could not publish message to RabbitMQ. Stack trace follows...");
            e.printStackTrace();
        }
    }

    private static ConnectionWrapper createDefaultConnection() {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setUsername(System.getenv("RABBITMQ_USER"));
        factory.setPassword(System.getenv("RABBITMQ_PASS"));
        factory.setHost("rabbitmq");
        factory.setPort(5672);

        return new ConnectionWrapper(factory);
    }

    private static ChannelWrapper createDefaultChannelWrapper() {
        return new ChannelWrapper(DEFAULT_CONNECTION, channel -> {
            try {
                channel.exchangeDeclare(DEFAULT_EXCHANGE, "fanout", true);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }
}
