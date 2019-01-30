package monitored_service;

import Entities.Host;
import Entities.HostDao;
import Entities.Service;
import monitored_service.models.json.HostModel;
import monitored_service.models.json.ServiceModel;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.google.gson.*;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

@RestController
public class GetController {

    @Autowired
    private HostDao hostDao;

    @RequestMapping(value = "/host", params = "id", method = RequestMethod.GET)
    @ResponseBody
    public String getHost(@RequestParam("id") int id) {
        Host h = hostDao.getById(id);
        return new Gson().toJson(HostModel.fromEntity(h));
    }

    @RequestMapping(value = "/host/services", params = "id", method = RequestMethod.GET)
    @ResponseBody
    public String getServices(@RequestParam("id") int id) {
        Host host = hostDao.getById(id);
        Object[] serviceModelArray = host.getServices().stream()
                .map(ServiceModel::fromEntity)
                .peek(serviceModel -> serviceModel.setHostId(id)) // Does not set host on the service entity so we set the host id manually
                .toArray();
        return new Gson().toJson(serviceModelArray);
    }

    @RequestMapping(value = "/search", params = "name", method = RequestMethod.GET)
    @ResponseBody
    public String getHostsByName(@RequestParam("name") String name) {
        Object[] hostModelArray = hostDao.getHostsByName(name)
                .stream()
                .map(HostModel::fromEntity)
                .toArray();
        return new Gson().toJson(hostModelArray);
    }

    @ExceptionHandler
    void handleIllegalArgumentException(Exception e, HttpServletResponse response) throws Exception {
        response.sendError(400);
    }
}
