package smart.lending.rest.controller;

import lombok.RequiredArgsConstructor;
import org.flowable.engine.RuntimeService;
import org.flowable.engine.runtime.ProcessInstance;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import smart.lending.domain.model.OnboardLendingAppReqBody;
import smart.lending.domain.service.OnboardLendingAppService;
import smart.lending.rest.payload.RequestWrapper;

@RestController
@RequestMapping("/smart-lending/process/demo-onboarding")
@RequiredArgsConstructor
public class DemoOnboardingController {
    private final RuntimeService runtimeService;
    private final OnboardLendingAppService onboardLendingAppService;

    private String processDefinitionKey = "demo-onboarding-process";

    @PostMapping("/start")
    public String start(@RequestBody RequestWrapper<OnboardLendingAppReqBody> request) {
        // start process
        ProcessInstance processInstance = runtimeService.startProcessInstanceByKey(processDefinitionKey);
        onboardLendingAppService.addOnboardLendingApp(processInstance.getBusinessKey(), request.getBody());
        return processInstance.getId();
    }


}
