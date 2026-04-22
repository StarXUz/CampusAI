package com.campusai.web.config;

import org.apache.catalina.connector.Connector;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MultiPortTomcatConfig {
   @Bean
   public WebServerFactoryCustomizer<TomcatServletWebServerFactory> multiPortCustomizer(@Value("${app.server.multi-port.enabled:true}") boolean enabled, @Value("${server.port:8091}") int mainPort, @Value("${app.server.client-port:8092}") int clientPort, @Value("${app.server.super-port:8093}") int superPort) {
      return (factory) -> {
         if (enabled) {
            Connector clientConnector = this.createConnectorIfValid(clientPort, mainPort);
            Connector superConnector = this.createConnectorIfValid(superPort, mainPort);
            if (clientConnector != null && superConnector != null && clientPort == superPort) {
               factory.addAdditionalTomcatConnectors(new Connector[]{clientConnector});
            } else {
               if (clientConnector != null) {
                  factory.addAdditionalTomcatConnectors(new Connector[]{clientConnector});
               }

               if (superConnector != null) {
                  factory.addAdditionalTomcatConnectors(new Connector[]{superConnector});
               }
            }
         }
      };
   }

   private Connector createConnectorIfValid(int candidatePort, int mainPort) {
      if (candidatePort <= 0 || candidatePort == mainPort) {
         return null;
      } else {
         Connector connector = new Connector(TomcatServletWebServerFactory.DEFAULT_PROTOCOL);
         connector.setPort(candidatePort);
         connector.setScheme("http");
         connector.setSecure(false);
         return connector;
      }
   }
}
