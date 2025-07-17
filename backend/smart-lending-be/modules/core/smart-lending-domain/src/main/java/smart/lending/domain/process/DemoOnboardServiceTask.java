package smart.lending.domain.process;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import smart.lending.infrastructure.repository.OnboardLendingAppRepository;

@Service("demoOnboardServiceTask")
@Slf4j
@RequiredArgsConstructor
@Transactional
public class DemoOnboardServiceTask {
    private final OnboardLendingAppRepository lendingAppRepository;

    // ${demoOnboardServiceTask.checkDedupe()}
    public boolean checkDedupe(long loanAppId, String customerNationalId) {
        log.info("DemoOnboardServiceTask checkDedupe - customerNationalId: {}", customerNationalId);
//        boolean check =  lendingAppRepository.existsByCustomerNationalId(loanAppId, customerNationalId);
        return lendingAppRepository.existsByCustomerNationalId(loanAppId, customerNationalId);
    }

    // creditScore = ${demoOnboardServiceTask.getScore()}
    public double getScore(long loanAppId){
        log.info("=========DemoOnboardServiceTask getScore, loanAppId: {} ================", loanAppId);
        var optional = lendingAppRepository.findById(loanAppId);
        var entity = optional.get();
        return entity.getIncome() > 15000000 ? 567.89 : 456.78;
    }

    // isApprove = ${demoOnboardServiceTask.getApproval(creditScore)}
    public boolean getApproval(long loanAppId, double creditScore){
        log.info("DemoOnboardServiceTask getApproval - loanAppId:{},  creditScore {}", loanAppId, creditScore);
        // Dùng Decision Rule
        return creditScore > 500;
    }

    // ${demoOnboardServiceTask.disbursement()}
    public void disbursement(long loanAppId){
        log.info("DemoOnboardServiceTask disbursement loanAppId: {}", loanAppId);
    }

    //${demoOnboardServiceTask.endDedupeListener(loanAppId)}
    public void endDedupeListener(long loanAppId){
        var optional = lendingAppRepository.findById(loanAppId);
        var entity = optional.get();
        entity.setAppStatus("Rejected");
        entity.setAppStage("Completed");
        entity.setReason("App Dedupe");
        lendingAppRepository.save(entity);
    }

    public void endApprovalListener(long loanAppId){
        var optional = lendingAppRepository.findById(loanAppId);
        var entity = optional.get();
        entity.setAppStatus("Rejected");
        entity.setAppStage("Completed");
        entity.setReason("Reject cause Decision Rule");
        lendingAppRepository.save(entity);
    }

    //${demoOnboardServiceTask.endProcessListener(loanAppId)}
    public void endProcessListener(long loanAppId){
        var optional = lendingAppRepository.findById(loanAppId);
        var entity = optional.get();
        entity.setAppStage("Completed");
        lendingAppRepository.save(entity);
        log.info("DemoOnboardServiceTask endProcessListener loanAppId: {}", loanAppId);
    }
}
