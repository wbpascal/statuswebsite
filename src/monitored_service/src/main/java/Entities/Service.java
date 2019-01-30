package Entities;

import javax.persistence.JoinColumn;

public class Service {
    private int id;
    @JoinColumn(name = "hostID", referencedColumnName = "hostID", insertable = false, updatable = false)
    private Host host;
    private String serviceName;
    private String type;

    public Service() {
    }

    public Service(int id, String name, Host host, String type) {
        this.id = id;
        this.serviceName = name;
        this.host = host;
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

    public Host getHost() {
        return host;
    }

    public void setHost(Host id) {
        this.host = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
