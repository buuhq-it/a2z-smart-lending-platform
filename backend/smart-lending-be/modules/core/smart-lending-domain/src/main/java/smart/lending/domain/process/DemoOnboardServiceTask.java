package smart.lending.domain.process;

import org.springframework.stereotype.Service;

@Service("demoOnboardServiceTask")
public class DemoOnboardServiceTask {
    // ${demoOnboardServiceTask.checkDedupe()}
    public boolean checkDedupe(){
        return false;
    }

    // creditScore = ${demoOnboardServiceTask.checkDedupe()}
    public double getScore(){
        return 567.89;
    }

    // isApprove = ${demoOnboardServiceTask.getApproval(creditScore)}
    public boolean getApproval(double score){
        return true;
    }

}
