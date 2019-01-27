package Entities;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Property;
import org.springframework.orm.hibernate5.HibernateTemplate;

import java.util.ArrayList;
import java.util.List;

public class HostDao {
    private HibernateTemplate template;

    public void setTemplate(HibernateTemplate template) {
        this.template = template;
    }

    //method to save host
    public void saveHost(Host h){
        template.save(h);
    }

    //method to update host
    public void updatehost(Host h){
        template.update(h);
    }

    //method to delete host
    public void deleteHost(Host h){
        template.delete(h);
    }

    //method to return one Host of given id
    public Host getById(int id){
        return template.get(Host.class,id);
    }

    //method to return all hosts
    public List<Host> getHosts(){
        return template.loadAll(Host.class);
    }

    public List<Service> getServices(int id) {
        Service service = new Service();
        service.setHostID(id);
        return template.findByExample(service);
    }

    public List<Host> getHostsByName(String name) {
        DetachedCriteria criteria = DetachedCriteria.forClass(Host.class).add(Property.forName("hostName").like(name+"%"));
        return (List<Host>) template.findByCriteria(criteria);
    }
}