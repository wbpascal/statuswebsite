package monitored_service.models.json;

import Entities.Host;

public class HostModel {
    private int id;
    private String name;
    private String icon;

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

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public static HostModel fromEntity(Host host) {
        HostModel model = new HostModel();
        model.id = host.getId();
        model.name = host.getHostName();
        model.icon = host.getIcon();
        return model;
    }
}
