package com.campusai.web.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;

@Configuration
@ComponentScan(
   basePackages = {"com.campusai.service"}
)
@PropertySource({"classpath:application.properties"})
@Import({PersistenceConfig.class, RedisConfig.class})
public class RootConfig {
   @Bean
   public static PropertySourcesPlaceholderConfigurer propertyConfigurer() {
      return new PropertySourcesPlaceholderConfigurer();
   }
}
