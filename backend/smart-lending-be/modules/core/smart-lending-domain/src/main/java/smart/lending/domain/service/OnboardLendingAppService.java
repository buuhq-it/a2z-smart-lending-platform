package smart.lending.domain.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import smart.lending.domain.mapper.LendingAppMapper;
import smart.lending.domain.model.OnboardAcquisitionRequest;
import smart.lending.infrastructure.entity.OnboardLendingApp;
import smart.lending.infrastructure.repository.OnboardLendingAppRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OnboardLendingAppService {
    private final OnboardLendingAppRepository onboardLendingAppRepository;
//    private final LendingAppMapper lendingAppMapper;

    public OnboardLendingApp storeAcquisitionStep(String processInstanceId, OnboardAcquisitionRequest model) {
        LendingAppMapper lendingAppMapper = LendingAppMapper.INSTANCE;

        var entity = lendingAppMapper.toOnboardLendingApp(model);
        entity.setProcessInstance(processInstanceId);
        entity.setAppStage("Acquisition");
        entity.setAppStatus("Pending");
        return onboardLendingAppRepository.save(entity);
    }

    /*
    public OnboardLendingApp updateESignStep(String processInstanceId) {
        var entity = onboardLendingAppRepository.findOnboardLendingAppByProcessInstance(processInstanceId);
        entity.setAppStage("ESign");
        return onboardLendingAppRepository.save(entity);
    }
     */
    public List<OnboardLendingApp> getAllApps(){
        return onboardLendingAppRepository.findAll();
    }
}
