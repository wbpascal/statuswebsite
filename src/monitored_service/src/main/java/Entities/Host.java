package Entities;

import java.util.ArrayList;
import java.util.Set;

public class Host {
    private String hostName;
    private Set<Service> services;
    private String description;
    private String icon;
    private int id;

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

    public String getHostName() {
        return hostName;
    }

    public Set<Service> getServices() {
        return services;
    }

    public String getDescription() {
        return description;
    }

    public String getIcon() {
        return icon;
    }

}
