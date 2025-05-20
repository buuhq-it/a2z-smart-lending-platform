package smart.lending.infrastructure.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import smart.lending.infrastructure.entity.User;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    boolean existsByUsername(String username);
    @Query("""
    SELECT u FROM User u 
    WHERE (:cursor IS NULL OR u.id < :cursor)
    ORDER BY u.id DESC
""")
    List<User> findNextUsers(@Param("cursor") Long cursor, Pageable pageable);
}
