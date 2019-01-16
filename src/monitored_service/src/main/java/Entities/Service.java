package Entities;

public class Service {
    private int id;
    private int hostID;
    private String serviceName;
    private String type;

    public Service(int id, String name, int hostID, String type) {
        this.id = id;
        this.serviceName = name;
        this.hostID = hostID;
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public String getServiceName() {
        return serviceName;
    }

    public int getHostID() {
        return hostID;
    }

    public String getType() {
        return type;
    }
}
