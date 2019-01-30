package Entities;

import java.util.Set;

public class Host {
    private String hostName;
    private Set<Service> services;
    private String description;
    private String icon;
    private int id;

    public Host() {
    }

    public Host(int id, String hostName, Set<Service> serviceList, String description, String icon) {
        this.id = id;
        this.hostName = hostName;
        this.services = serviceList;
        this.description = description;
        this.icon = icon;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    public Set<Service> getServices() {
        return services;
    }

    public void setServices(Set<Service> services) {
        this.services = services;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }
}
