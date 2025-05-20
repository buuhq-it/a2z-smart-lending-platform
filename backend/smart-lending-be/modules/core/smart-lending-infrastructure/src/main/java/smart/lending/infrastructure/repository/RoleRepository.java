package smart.lending.infrastructure.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import smart.lending.common.enums.RoleName;
import smart.lending.infrastructure.entity.Role;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByName(RoleName name);
}
