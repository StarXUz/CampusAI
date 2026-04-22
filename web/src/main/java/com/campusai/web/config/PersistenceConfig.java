package com.campusai.web.config;

import com.zaxxer.hikari.HikariDataSource;
import javax.sql.DataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement
@MapperScan({"com.campusai.service.mapper"})
public class PersistenceConfig {
   @Bean
   public DataSource dataSource(@Value("${db.url}") String url, @Value("${db.username}") String username, @Value("${db.password}") String password, @Value("${db.driver-class-name}") String driverClassName) {
      HikariDataSource dataSource = new HikariDataSource();
      dataSource.setJdbcUrl(url);
      dataSource.setUsername(username);
      dataSource.setPassword(password);
      dataSource.setDriverClassName(driverClassName);
      dataSource.setMaximumPoolSize(10);
      dataSource.setMinimumIdle(2);
      return dataSource;
   }

   @Bean
   public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
      SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
      factoryBean.setDataSource(dataSource);
      factoryBean.setMapperLocations((new PathMatchingResourcePatternResolver()).getResources("classpath*:mybatis/*.xml"));
      org.apache.ibatis.session.Configuration configuration = new org.apache.ibatis.session.Configuration();
      configuration.setMapUnderscoreToCamelCase(true);
      factoryBean.setConfiguration(configuration);
      return factoryBean.getObject();
   }

   @Bean
   public DataSourceTransactionManager transactionManager(DataSource dataSource) {
      return new DataSourceTransactionManager(dataSource);
   }
}
