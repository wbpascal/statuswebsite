package Entities;

public class Service {
    private int id;
    private int hostID;
    private String serviceName;
    private String type;

    public Service() {
    }

    public Service(int id, String name, int hostID, String type) {
        this.id = id;
        this.serviceName = name;
        this.hostID = hostID;
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public int getHostID() {
        return hostID;
    }

    public void setHostID(int id) {
        this.hostID = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
