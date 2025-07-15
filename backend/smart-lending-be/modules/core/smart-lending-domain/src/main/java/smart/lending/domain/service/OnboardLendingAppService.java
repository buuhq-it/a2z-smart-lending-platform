package smart.lending.domain.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import smart.lending.domain.mapper.LendingAppMapper;
import smart.lending.domain.model.OnboardLendingAppReqBody;
import smart.lending.infrastructure.entity.OnboardLendingApp;
import smart.lending.infrastructure.repository.OnboardLendingAppRepository;

@Service
@RequiredArgsConstructor
public class OnboardLendingAppService {
    private final OnboardLendingAppRepository onboardLendingAppRepository;
    private final LendingAppMapper lendingAppMapper;

    public OnboardLendingApp addOnboardLendingApp(String processInstance,OnboardLendingAppReqBody model) {
        var entity = lendingAppMapper.toOnboardLendingApp(model);
        entity.setProcessInstance(processInstance);
        return onboardLendingAppRepository.save(entity);
    }
}
