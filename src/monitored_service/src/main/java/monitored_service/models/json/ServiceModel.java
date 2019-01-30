package monitored_service.models.json;

import Entities.Service;

public class ServiceModel {
    private int id;
    private String name;
    private int hostId;
    private String type;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getHostId() {
        return hostId;
    }

    public void setHostId(int hostId) {
        this.hostId = hostId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public static ServiceModel fromEntity(Service service) {
        ServiceModel model = new ServiceModel();
        model.setId(service.getId());
        model.setName(service.getServiceName());
        model.setHostId(service.getHost().getId());
        model.setType(service.getType());
        return model;
    }
}
