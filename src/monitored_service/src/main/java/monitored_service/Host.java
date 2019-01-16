package monitored_service;

import java.util.ArrayList;

public class Host {
    private String hostName;
    private ArrayList<Service> services=new ArrayList<>();
    private int id;
    private String description;
    private String icon; //change String to any picture file format

    public Host(String hostName, int id, String description, String icon) {
        this.hostName = hostName;
        this.id = id;
        this.description = description;
        this.icon = icon;
    }

    public Host(String hostName, int id, ArrayList<Service> servicelist) {
        this.hostName = hostName;
        this.id = id;
        this.services = servicelist;
    }

    public void addService() {
    }

    public void deleteService() {
    }

    public ArrayList<Service> getServices() {
        return services;
    }

    public String getHostName() {
        return hostName;
    }

    public int geId() {
        return id;
    }

    public String getIcon() {
        return icon;
    }

}
