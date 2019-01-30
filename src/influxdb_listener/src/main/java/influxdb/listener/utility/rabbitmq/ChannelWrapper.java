package influxdb.listener.utility.rabbitmq;

import com.rabbitmq.client.Channel;
import influxdb.listener.interfaces.ChannelSetup;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

/**
 * A wrapper for a RabbitMQ channel that restarts the channel if it crashes.
 */
public class ChannelWrapper {
    private final ConnectionWrapper connection;
    private final ChannelSetup setup;

    private Channel channel;

    public ChannelWrapper(ConnectionWrapper conn, ChannelSetup setup) {
        this.connection = conn;
        this.setup = setup;
    }

    public Channel getChannel() throws IOException, TimeoutException {
        if (channel == null || !channel.isOpen())
            this.channel = this.createChannel();

        return this.channel;
    }

    private Channel createChannel() throws IOException, TimeoutException {
        Channel channel = this.connection.getConnection().createChannel();
        this.setup.setup(channel);
        return channel;
    }
}
