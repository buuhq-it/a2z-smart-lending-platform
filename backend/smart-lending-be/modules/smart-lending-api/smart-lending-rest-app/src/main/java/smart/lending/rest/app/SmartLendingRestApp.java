package smart.lending.rest.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = "smart.lending")
//@EnableConfigurationProperties(JwtProperties.class)
@EnableJpaRepositories(basePackages = "smart.lending.infrastructure.repository")
@EntityScan(basePackages = "smart.lending.infrastructure.entity")
public class SmartLendingRestApp {
    public static void main(String[] args) {
        SpringApplication.run(SmartLendingRestApp.class, args);
    }
}
