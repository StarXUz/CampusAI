package com.campusai.web;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication(
   scanBasePackages = {"com.campusai"}
)
@ConfigurationPropertiesScan(
   basePackages = {"com.campusai.service.ai"}
)
@EnableScheduling
public class CampusServiceManagerAiApplication extends SpringBootServletInitializer {
   public static void main(String[] args) {
      SpringApplication.run(CampusServiceManagerAiApplication.class, args);
   }

   protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
      return builder.sources(new Class[]{CampusServiceManagerAiApplication.class});
   }
}
