package influxdb.listener.utility;

import com.google.gson.Gson;
import influxdb.listener.models.icinga.CheckEvent;
import io.reactivex.Observable;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collection;

public class IcingaService {
    private static final String ICINGA_BASE_URL = "https://icinga-api:5665";

    public static Observable<CheckEvent> getEventStream(String[] types, String queue) {
        Gson gson = new Gson();
        return Observable.<String>create(emitter -> {
            while (true) {
                try {
                    InputStream inputStream = getEventStreamInputStream(types, queue);
                    if (inputStream == null) continue;
                    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));

                    while (true) {
                        String line = bufferedReader.readLine();
                        // System.out.println(line);
                        emitter.onNext(line);
                    }
                } catch (Exception ignored) {
                    System.out.println("Exception reading the InputStream. Restarting request...");
                    // Ignore the exception and restart the request
                }
            }
        }).map(s -> gson.fromJson(s, CheckEvent.class));
    }

    private static InputStream getEventStreamInputStream(String[] types, String queue) {
        ArrayList<Pair<String, String>> postParams = new ArrayList<>();
        postParams.add(new Pair<>("queue", queue));
        for (String type : types) {
            postParams.add(new Pair<>("types", type));
        }

        HttpsURLConnection httpURLConnection = HttpClient.startPostRequestSsl(ICINGA_BASE_URL + "/v1/events",
                postParams, null, createDefaultIcingaHeader());
        if (httpURLConnection == null)
            return null;

        try {
            return httpURLConnection.getInputStream();
        } catch (IOException e) {
            System.out.println("Could not get input stream");
            System.out.println(e.toString());
            return null;
        }
    }

    private static Collection<Pair<String, String>> createDefaultIcingaHeader() {
        ArrayList<Pair<String, String>> headers = new ArrayList<>();
        headers.add(new Pair<>("Accept", "application/json"));
        String user = System.getenv("ICINGA_API_USER");
        String password = System.getenv("ICINGA_API_PASS");
        String encoded = Base64.getEncoder().encodeToString((user + ":" + password).getBytes(StandardCharsets.UTF_8));
        headers.add(new Pair<>("Authorization", "Basic " + encoded));
        return headers;
    }
}
