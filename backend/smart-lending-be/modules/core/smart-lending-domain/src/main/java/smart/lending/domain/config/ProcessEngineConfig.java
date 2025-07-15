package smart.lending.domain.config;

import org.flowable.engine.*;
import org.flowable.spring.ProcessEngineFactoryBean;
import org.flowable.spring.SpringProcessEngineConfiguration;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;


import javax.sql.DataSource;

@Configuration
public class ProcessEngineConfig {
    @Bean
    public SpringProcessEngineConfiguration processEngineConfiguration(
            @Qualifier("processDataSource") DataSource flowableDataSource,
            @Qualifier("processTransactionManager") PlatformTransactionManager flowableTransactionManager) {

        SpringProcessEngineConfiguration config = new SpringProcessEngineConfiguration();
        config.setDataSource(flowableDataSource);
        config.setTransactionManager(flowableTransactionManager);
//        config.setDatabaseSchemaUpdate(ProcessEngineConfiguration.DB_SCHEMA_UPDATE_TRUE);
        config.setDatabaseSchemaUpdate(ProcessEngineConfiguration.DB_SCHEMA_UPDATE_FALSE);
        config.setAsyncExecutorActivate(true);
//        config.setDeploymentResources(new ClassPathResource[] {
//                new ClassPathResource("processes/sample-process.bpmn20.xml")
//        });
        return config;
    }
    @Bean
    public ProcessEngineFactoryBean processEngineFactoryBean(
            SpringProcessEngineConfiguration configuration) {

        ProcessEngineFactoryBean factoryBean = new ProcessEngineFactoryBean();
        factoryBean.setProcessEngineConfiguration(configuration);
        return factoryBean;
    }

    @Bean
    public RepositoryService repositoryService(ProcessEngine engine) {
        return engine.getRepositoryService();
    }

    @Bean
    public RuntimeService runtimeService(ProcessEngine engine) {
        return engine.getRuntimeService();
    }

    @Bean
    public TaskService taskService(ProcessEngine engine) {
        return engine.getTaskService();
    }

    @Bean
    public HistoryService historyService(ProcessEngine engine) {
        return engine.getHistoryService();
    }

    @Bean
    public ManagementService managementService(ProcessEngine engine) {
        return engine.getManagementService();
    }
}
