package smart.lending.rest.init;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import smart.lending.common.enums.RoleName;
import smart.lending.infrastructure.entity.Role;
import smart.lending.infrastructure.entity.User;
import smart.lending.infrastructure.repository.RoleRepository;
import smart.lending.infrastructure.repository.UserRepository;

import java.util.Set;

@Component
@RequiredArgsConstructor
public class MasterDataInitial {
    private final RoleRepository roleRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @PostConstruct
    public void init() {
        // 1. Create roles if not exist
        for (RoleName roleName : RoleName.values()) {
            roleRepository.findByName(roleName)
                    .orElseGet(() -> roleRepository.save(new Role(null, roleName)));
        }

        // 2. Create admin user
        if (userRepository.findByUsername("admin").isEmpty()) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setRoles(Set.of(roleRepository.findByName(RoleName.ROLE_ADMIN).orElseThrow()));
            userRepository.save(admin);
        }

        // 3. Create normal user
        if (userRepository.findByUsername("user").isEmpty()) {
            User user = new User();
            user.setUsername("user");
            user.setPassword(passwordEncoder.encode("user123"));
            user.setRoles(Set.of(roleRepository.findByName(RoleName.ROLE_USER).orElseThrow()));
            userRepository.save(user);
        }
    }
}
