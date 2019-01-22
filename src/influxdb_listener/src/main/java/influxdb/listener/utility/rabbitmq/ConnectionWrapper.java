package influxdb.listener.utility.rabbitmq;

import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

public class ConnectionWrapper {
    private final ConnectionFactory factory;
    private Connection connection;

    public ConnectionWrapper(ConnectionFactory factory) {
        this.factory = factory;
    }

    public Connection getConnection() throws IOException, TimeoutException {
        if (connection == null || !connection.isOpen())
            this.connection = this.createConnection();

        return this.connection;
    }

    private Connection createConnection() throws IOException, TimeoutException {
        return this.factory.newConnection();
    }
}
