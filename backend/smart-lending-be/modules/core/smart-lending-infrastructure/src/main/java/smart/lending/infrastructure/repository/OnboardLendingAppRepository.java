package smart.lending.infrastructure.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import smart.lending.infrastructure.entity.OnboardLendingApp;

public interface OnboardLendingAppRepository extends JpaRepository<OnboardLendingApp, Long> {
}
