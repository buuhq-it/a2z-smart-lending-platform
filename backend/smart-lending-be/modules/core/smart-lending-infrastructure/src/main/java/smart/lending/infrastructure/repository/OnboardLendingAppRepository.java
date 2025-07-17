package smart.lending.infrastructure.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import smart.lending.infrastructure.entity.OnboardLendingApp;

public interface OnboardLendingAppRepository extends JpaRepository<OnboardLendingApp, Long> {
    OnboardLendingApp findOnboardLendingAppByProcessInstance(String processInstance);

    @Query("SELECT COUNT(e) > 0 FROM OnboardLendingApp e WHERE e.id != :appId and e.customerNationalId = :value")
    boolean existsByCustomerNationalId(@Param("appId") long appId, @Param("value") String value);
}
