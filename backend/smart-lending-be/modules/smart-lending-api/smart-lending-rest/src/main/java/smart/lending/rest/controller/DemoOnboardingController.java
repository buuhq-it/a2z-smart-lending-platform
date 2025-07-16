package smart.lending.rest.controller;

import lombok.RequiredArgsConstructor;
import org.flowable.engine.RuntimeService;
import org.flowable.engine.TaskService;
import org.flowable.engine.runtime.ProcessInstance;
import org.flowable.task.api.Task;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import smart.lending.domain.model.OnboardAcquisitionRequest;
import smart.lending.domain.model.OnboardESignRequest;
import smart.lending.domain.service.OnboardLendingAppService;
import smart.lending.rest.payload.RequestWrapper;

import java.util.Map;

@RestController
@RequestMapping("/process/demo-onboarding")
@RequiredArgsConstructor
public class DemoOnboardingController {
    private final RuntimeService runtimeService;
    private final TaskService taskService;
    private final OnboardLendingAppService onboardLendingAppService;

    private String processDefinitionKey = "demo-onboarding-process";

    @PostMapping("/acquisition")
    public String acquisition(@RequestBody RequestWrapper<OnboardAcquisitionRequest> request) {
        // Step 1: start process
        ProcessInstance processInstance = runtimeService.startProcessInstanceByKey(processDefinitionKey);
        var processInstanceId = processInstance.getId();

        // Step 2: Complete acquisition-step
        Task task = taskService.createTaskQuery()
                .processInstanceId(processInstanceId)
                .taskDefinitionKey("acquisition-step")
                .singleResult();
        taskService.complete(task.getId(), Map.of("acquisitionNote", "done"));
        // Step 3: StoreDb
        var entity = onboardLendingAppService.storeAcquisitionStep(processInstanceId, request.getBody());
        return processInstanceId;
    }

    @PostMapping("/esign")
    public String esign(@RequestBody RequestWrapper<OnboardESignRequest> request) {
        var processInstanceId = request.getBody().getProcessInstanceId();
        Task task = taskService.createTaskQuery()
                .processInstanceId(processInstanceId)
                .taskDefinitionKey("esign-step")
                .singleResult();
        taskService.complete(task.getId(), Map.of("esignNote", "done"));

        var entity = onboardLendingAppService.updateESignStep(processInstanceId);
        return "esign success";
    }

}
