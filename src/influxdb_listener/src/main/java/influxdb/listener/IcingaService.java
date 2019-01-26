package influxdb.listener;

import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URI;

public class IcingaService {
	private static final String ICINGA_HOST = "icinga-api";
	
	public OutputStream getEventStream(String queueName, String[] types) throws MalformedURLException {
		URI url = new URI("http", null, ICINGA_HOST, 5665, "/v1/events", ); 
		return null;
	}
}
