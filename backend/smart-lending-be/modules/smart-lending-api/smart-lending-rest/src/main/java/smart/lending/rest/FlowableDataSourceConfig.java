package smart.lending.rest;


import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;

/*
@Configuration
public class FlowableDataSourceConfig {
    @Bean(name = "flowableDataSource")
    @ConfigurationProperties(prefix = "spring.flowable-datasource")
    public DataSource flowableDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "flowableTransactionManager")
    public PlatformTransactionManager flowableTransactionManager(
            @Qualifier("flowableDataSource") DataSource flowableDataSource) {
        return new DataSourceTransactionManager(flowableDataSource);
    }
}
*/