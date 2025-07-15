package smart.lending.domain.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;
import smart.lending.domain.model.OnboardLendingAppReqBody;
import smart.lending.infrastructure.entity.OnboardLendingApp;

@Mapper(componentModel = "spring")
public interface LendingAppMapper {
    LendingAppMapper INSTANCE = Mappers.getMapper(LendingAppMapper.class);

    OnboardLendingApp toOnboardLendingApp(OnboardLendingAppReqBody model);
}
