package monitored_service;

import java.util.ArrayList;

public class Host {
    private String hostName;
    private ArrayList<Service> services=new ArrayList<Service>();
    private String address;

    public Host(String name, String url) {
        this.hostName = name;
        this.address = url;
    }

    public Host(String name, String url, ArrayList<Service> servicelist) {
        this.hostName = name;
        this.address = url;
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

    public String getAddress() {
        return address;
    }

}
