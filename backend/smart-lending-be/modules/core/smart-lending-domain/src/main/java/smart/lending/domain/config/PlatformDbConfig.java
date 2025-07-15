package smart.lending.domain.config;


import jakarta.persistence.EntityManagerFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.boot.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(
        basePackages = "smart.lending.infrastructure.repository",
        entityManagerFactoryRef = "platformEntityManagerFactory",
        transactionManagerRef = "platformTransactionManager"
)
public class PlatformDbConfig {
    private final Environment environment;

    public PlatformDbConfig(Environment environment) {
        this.environment = environment;
    }

    @Primary
    @Bean(name = "platformDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.platform")
    public DataSource platformDataSource() {
        var ds = DataSourceBuilder.create().build();
        log.info("=========== Platform DataSource: {} ==========", ds.toString());
        return ds;
    }

    @Primary
    @Bean(name = "platformEntityManagerFactory")
    public LocalContainerEntityManagerFactoryBean platformEntityManagerFactory(
            EntityManagerFactoryBuilder builder,
            @Qualifier("platformDataSource") DataSource dataSource
    ) {
        Map<String, Object> jpaProperties = new HashMap<>();

        jpaProperties.put("hibernate.hbm2ddl.auto", environment.getProperty("spring.jpa-platform.properties.hibernate.hbm2ddl.auto"));
        jpaProperties.put("hibernate.format_sql", environment.getProperty("spring.jpa-platform.properties.hibernate.format_sql"));
        jpaProperties.put("hibernate.use_sql_comments", environment.getProperty("spring.jpa-platform.properties.hibernate.use_sql_comments"));

        return builder
                .dataSource(dataSource)
//                .packages("vuxe.domain.ordering.entity", "vuxe.domain.common.entity")
                .packages("smart.lending.infrastructure.entity")
                .persistenceUnit("platform")
                .properties(jpaProperties)
                .build();
    }
    @Primary
    @Bean(name = "platformTransactionManager")
    public PlatformTransactionManager platformTransactionManager(
            @Qualifier("platformEntityManagerFactory") EntityManagerFactory emf
    ) {
        return new JpaTransactionManager(emf);
    }
}
