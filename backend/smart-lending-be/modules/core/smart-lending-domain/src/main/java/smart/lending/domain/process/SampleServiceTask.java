package smart.lending.domain.process;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

@Component("sampleServiceTask")
@Slf4j
public class SampleServiceTask {
    public void hello() {
        //${sampleServiceTask.hello()}
        log.info("🔥 Hello from Flowable Service Task expression call!");
    }
}
