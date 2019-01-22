package web;

import Entities.Host;
import Entities.HostDao;
import Entities.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.google.gson.*;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

@RestController
public class GetController {

    @Autowired
    private HostDao hostDao;

    @RequestMapping(value = "/host", params = "id", method = RequestMethod.GET)
    @ResponseBody
    public String getHost(@RequestParam("id") int id) {
        Host h = hostDao.getById(id);
        Gson gson = new Gson();
        return gson.toJson(h);
    }

    @RequestMapping(value = "/host/services", params = "id", method = RequestMethod.GET)
    @ResponseBody
    public String getServices(@RequestParam("id") int id) {
        List<Service> list;
        list = hostDao.getServices(id);
        Gson gson = new Gson();
        return gson.toJson(list);
    }

    @ExceptionHandler
    void handleIllegalArgumentException(Exception e, HttpServletResponse response) throws Exception {
        response.sendError(400);
    }
}
