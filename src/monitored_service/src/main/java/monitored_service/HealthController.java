package monitored_service;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {
    @RequestMapping(value = "/healthz", method = RequestMethod.GET)
    @ResponseBody
    public String health() {
        // Always return a 200 status so that we can see if the server is reachable
        return "";
    }
}
