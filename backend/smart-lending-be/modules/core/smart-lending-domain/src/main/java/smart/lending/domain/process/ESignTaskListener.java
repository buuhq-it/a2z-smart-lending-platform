package smart.lending.domain.process;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.flowable.task.service.delegate.DelegateTask;
import org.flowable.task.service.delegate.TaskListener;
import org.springframework.stereotype.Component;
import smart.lending.infrastructure.repository.OnboardLendingAppRepository;

@Component("eSignTaskListener")
@Slf4j
@RequiredArgsConstructor
@Transactional
public class ESignTaskListener implements TaskListener {
    private final OnboardLendingAppRepository lendingAppRepository;
    @Override
    public void notify(DelegateTask delegateTask) {
        String processInstanceId = delegateTask.getProcessInstanceId();
//        String taskId = delegateTask.getId();
//        String assignee = delegateTask.getAssignee(); // nếu có


        log.info("eSign task created in process: {}", processInstanceId);
        // Thực hiện xử lý tại đây (gửi mail, callback, v.v.)
        var entity = lendingAppRepository.findOnboardLendingAppByProcessInstance(processInstanceId);
        entity.setAppStage("eSign");
        entity.setAppStatus("Approved");
        lendingAppRepository.save(entity);
    }
}
