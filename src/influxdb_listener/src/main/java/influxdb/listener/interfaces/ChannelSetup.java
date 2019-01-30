package influxdb.listener.interfaces;

import com.rabbitmq.client.Channel;

/**
 * A functional interface that has a {@code setup()} method that receives
 * an instance of a {@link Channel} that allows declaring queues and
 * exchanges.
 */
public interface ChannelSetup {

    void setup(Channel channel);
}
