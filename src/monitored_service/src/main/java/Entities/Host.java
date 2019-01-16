package Entities;

import java.util.ArrayList;

public class Host {
    private String hostName;
    private ArrayList<Service> services;
    private String description;
    private String icon;
    private int id;

    public Host(int id, String hostName, ArrayList<Service> serviceList, String description, String icon) {
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

    public String getDescription() {
        return description;
    }

    public String getIcon() {
        return icon;
    }

}
