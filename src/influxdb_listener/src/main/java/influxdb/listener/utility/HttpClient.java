package influxdb.listener.utility;

import javax.net.ssl.*;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.X509Certificate;
import java.util.Collection;

public class HttpClient {

    public static HttpsURLConnection startPostRequestSsl(String baseUrl, Collection<Pair<String, String>> queryParams,
                                                      Collection<Pair<String, String>> postArgs,
                                                      Collection<Pair<String, String>> headers) {
        if (queryParams != null && queryParams.size() != 0)
            baseUrl += "?" + paramsToString(queryParams);

        // Create URL for connection
        URL url;
        try {
            url = new URL(baseUrl);
        } catch (MalformedURLException e) {
            System.out.println("Malformed url");
            return null;
        }

        // Create connection
        byte[] postData = paramsToString(postArgs).getBytes(StandardCharsets.UTF_8);
        HttpsURLConnection connection;
        try {
            connection = (HttpsURLConnection) url.openConnection();
        } catch (IOException e) {
            System.out.println("Could not open connection");
            return null;
        }

        // Add default connection settings
        connection.setDoOutput(true);
        connection.setDoInput(true);
        try {
            connection.setRequestMethod("POST");
        } catch (ProtocolException e) {
            System.out.println("Protocol Exception");
            return null;
        }
        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        connection.setRequestProperty("charset", "utf-8");
        connection.setRequestProperty("Content-Length", Integer.toString(postData.length));
        connection.setUseCaches(false);

        // Add custom headers
        for (Pair<String, String> header : headers) {
            connection.setRequestProperty(header.getKey(), header.getValue());
        }

        // Write POST data to output stream
        try(DataOutputStream wr = new DataOutputStream(connection.getOutputStream())) {
            wr.write(postData);
        } catch (IOException e) {
            System.out.println("Error while writing to output stream");
            e.printStackTrace();
        }

        return connection;
    }

    public static void trustAllCertificates() {
        // Create a trust manager that does not validate certificate chains
        TrustManager[] trustAllCerts = new TrustManager[] {new X509TrustManager() {
            public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                return null;
            }
            public void checkClientTrusted(X509Certificate[] certs, String authType) {
            }
            public void checkServerTrusted(X509Certificate[] certs, String authType) {
            }
        }
        };

        // Install the all-trusting trust manager
        SSLContext sc = null;
        try {
            sc = SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
        } catch (NoSuchAlgorithmException | KeyManagementException e) {
            e.printStackTrace();
            return;
        }

        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

        // Create all-trusting host name verifier
        HostnameVerifier allHostsValid = (hostname, session) -> true;

        // Install the all-trusting host verifier
        HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
    }

    private static String paramsToString(Collection<Pair<String, String>> params) {
        if (params == null)
            return "";

        StringBuilder queryBuilder = new StringBuilder();
        for (Pair<String, String> queryParam : params) {
            queryBuilder.append("&")
                    .append(queryParam.getKey())
                    .append("=")
                    .append(queryParam.getValue());
        }
        if (queryBuilder.length() > 0)
            queryBuilder.deleteCharAt(0); // Delete '&' at the start

        return queryBuilder.toString();
    }
}
