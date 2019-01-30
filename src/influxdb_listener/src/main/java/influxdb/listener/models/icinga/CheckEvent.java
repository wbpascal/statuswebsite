package influxdb.listener.models.icinga;

import com.google.gson.annotations.SerializedName;

/**
 * A model for the check event returned by the icinga event stream
 */
public class CheckEvent {
    @SerializedName("check_result")
    private CheckResult checkResult;
    private String host;
    private String service;
    private float timestamp;
    private String type;

    public CheckResult getCheckResult() {
        return checkResult;
    }

    public String getHost() {
        return host;
    }

    public String getService() {
        return service;
    }

    public float getTimestamp() {
        return timestamp;
    }

    public String getType() {
        return type;
    }

    @Override
    public String toString() {
        return "CheckEvent{" +
                "checkResult=" + checkResult +
                ", host='" + host + '\'' +
                ", service='" + service + '\'' +
                ", timestamp=" + timestamp +
                ", type='" + type + '\'' +
                '}';
    }
}
