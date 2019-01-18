package influxdb.listener.models;

public class CheckEvent {
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
}
