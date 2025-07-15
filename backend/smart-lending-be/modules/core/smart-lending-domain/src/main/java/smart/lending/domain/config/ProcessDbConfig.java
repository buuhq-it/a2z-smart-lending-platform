package smart.lending.domain.config;



import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;

@Configuration
@Slf4j
public class ProcessDbConfig {
    private final Environment environment;

    public ProcessDbConfig(Environment environment) {
        this.environment = environment;
    }

    @Bean(name = "processDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.process")
    public DataSource processDataSource() {
        var ds = DataSourceBuilder.create().build();
        log.info("=========== Process DataSource: {} ==========", ds.toString());
        return ds;
    }

    @Bean(name = "processTransactionManager")
    public PlatformTransactionManager processTransactionManager(
            @Qualifier("processDataSource") DataSource flowableDataSource) {
        return new DataSourceTransactionManager(flowableDataSource);
    }

}
