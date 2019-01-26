package influxdb.listener.models.rabbitmq;

import influxdb.listener.models.icinga.CheckEvent;

public class CheckResultMessage {
    private int hostId;
    private int serviceId;
    private boolean success;
    private float timeTaken;
    private float timestamp;

    public int getHostId() {
        return hostId;
    }

    public void setHostId(int hostId) {
        this.hostId = hostId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public float getTimeTaken() {
        return timeTaken;
    }

    public void setTimeTaken(float timeTaken) {
        this.timeTaken = timeTaken;
    }

    public float getTimestamp() {
        return this.timestamp;
    }

    public void setTimestamp(float timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "CheckResultMessage{" +
                "hostId=" + hostId +
                ", serviceId=" + serviceId +
                ", success=" + success +
                ", timeTaken=" + timeTaken +
                ", timestamp=" + timestamp +
                '}';
    }

    public static CheckResultMessage fromCheckEvent(CheckEvent event) {
        CheckResultMessage instance = new CheckResultMessage();
        try {
            instance.setHostId(Integer.parseInt(event.getHost(), 10));
            instance.setServiceId(Integer.parseInt(event.getService(), 10));
        } catch (NumberFormatException ex) {
            System.out.println("Could not parse host or service id from event. Stack trace follows.");
            ex.printStackTrace();
            return null;
        }
        int serviceState = event.getCheckResult().getState();
        // Mark as success if the state is OK (0) or WARNING (1) as WARNING only applies if the service is reachable
        // but took longer then a specified amount of time to respond.
        // Though it is planned to differentiate between those at a later date.
        instance.setSuccess(serviceState == 0 || serviceState == 1);

        instance.setTimestamp(event.getCheckResult().getExecutionEnd());

        try {
            // At the moment only HTTP and PING checks are supported, all other checks are ignored
            if (!instance.getSuccess()) { // Not a successful check, ignore output
                instance.setTimeTaken(null);
            } else if (event.getCheckResult().getOutput().startsWith("HTTP")) {
                String performanceData = (String) event.getCheckResult().getPerformanceData()[0];
                String timeData = performanceData.split("s;")[0].substring("time=".length());
                instance.setTimeTaken(Float.parseFloat(timeData) * 1000); // timeData is in seconds so we need to convert it to ms
            } else if (event.getCheckResult().getOutput().startsWith("PING ")) {
                String performanceData = (String) event.getCheckResult().getPerformanceData()[0];
                String timeData = performanceData.split("ms;")[0].substring("rta=".length());
                instance.setTimeTaken(Float.parseFloat(timeData));
            } else { // Not a supported check, ignore the whole check
                return null;
            }
        } catch (Exception ex) {
            System.out.println("Could not get time taken from performance data. Stack trace follows.");
            ex.printStackTrace();
            return null;
        }

        return instance;
    }
}
