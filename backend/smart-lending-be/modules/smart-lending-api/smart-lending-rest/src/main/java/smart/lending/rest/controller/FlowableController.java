package smart.lending.rest.controller;

import org.flowable.engine.RuntimeService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/public/flow")
public class FlowableController {
    private final RuntimeService runtimeService;

    public FlowableController(RuntimeService runtimeService) {
        this.runtimeService = runtimeService;
    }

    @GetMapping("/simple")
    public String start() {
        runtimeService.startProcessInstanceByKey("first-simple-process");
        return "Process started!";
    }
    //demo-onboarding-process
}
