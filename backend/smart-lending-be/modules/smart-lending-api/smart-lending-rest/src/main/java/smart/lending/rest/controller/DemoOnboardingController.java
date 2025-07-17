package smart.lending.rest.controller;

import lombok.RequiredArgsConstructor;
import org.flowable.engine.RuntimeService;
import org.flowable.engine.TaskService;
import org.flowable.engine.runtime.ProcessInstance;
import org.flowable.task.api.Task;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import smart.lending.domain.model.OnboardAcquisitionRequest;
import smart.lending.domain.model.OnboardESignRequest;
import smart.lending.domain.service.OnboardLendingAppService;
import smart.lending.infrastructure.entity.OnboardLendingApp;
import smart.lending.rest.payload.RequestWrapper;
import smart.lending.rest.payload.ResponseBuilder;
import smart.lending.rest.payload.ResponseWrapper;

import java.util.List;
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
        var requestBody = request.getBody();
        // Step 1: start process
        ProcessInstance processInstance = runtimeService.startProcessInstanceByKey(processDefinitionKey);
        var processInstanceId = processInstance.getId();

        // Step 2: Complete acquisition-step
        Task task = taskService.createTaskQuery()
                .processInstanceId(processInstanceId)
                .taskDefinitionKey("acquisition-step")
                .singleResult();

        var entity = onboardLendingAppService.storeAcquisitionStep(processInstanceId, requestBody);
        //loanAppId
        taskService.complete(task.getId(), Map.of(
                "customerNationalId", requestBody.getCustomerNationalId(),
                "loanAppId",entity.getId()));

        return processInstanceId;
    }

    @PostMapping("/esign")
    public String esign(@RequestBody RequestWrapper<OnboardESignRequest> request) {
        var requestBody = request.getBody();
        var processInstanceId = requestBody.getProcessInstanceId();
        Task task = taskService.createTaskQuery()
                .processInstanceId(processInstanceId)
                .taskDefinitionKey("esign-step")
                .singleResult();
        taskService.complete(task.getId(), Map.of("esign-Note", "done"));

//        var entity = onboardLendingAppService.updateESignStep(processInstanceId);
        return "esign success";
    }

    @GetMapping("/getAllApps")
    public ResponseEntity<ResponseWrapper<List<OnboardLendingApp>>> getAllApps() {
        List<OnboardLendingApp> body =  onboardLendingAppService.getAllApps();
        return ResponseEntity.ok(ResponseBuilder.<List<OnboardLendingApp>>builder()
                .body(body)
//                .metadata("nextCursor", nextCursor)
                .build());
    }

}
