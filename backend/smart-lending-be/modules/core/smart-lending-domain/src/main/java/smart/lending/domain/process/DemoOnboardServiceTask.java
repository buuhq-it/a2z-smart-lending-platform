package smart.lending.domain.process;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service("demoOnboardServiceTask")
@Slf4j
public class DemoOnboardServiceTask {
    // ${demoOnboardServiceTask.checkDedupe()}
    public boolean checkDedupe(){
        log.info("DemoOnboardServiceTask checkDedupe");
        return false;
    }

    // creditScore = ${demoOnboardServiceTask.getScore()}
    public double getScore(){
        log.info("=========DemoOnboardServiceTask getScore================");
        return 567.89;
    }

    // isApprove = ${demoOnboardServiceTask.getApproval(creditScore)}
    public boolean getApproval(double creditScore){
        log.info("DemoOnboardServiceTask getApproval - creditScore {}", creditScore);
        return creditScore > 500;
    }

    // ${demoOnboardServiceTask.disbursement()}
    public void disbursement(){
        log.info("DemoOnboardServiceTask disbursement");
    }

}
