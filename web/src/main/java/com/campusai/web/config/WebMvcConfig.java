package com.campusai.web.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

@Configuration
@EnableWebMvc
@ComponentScan({"com.campusai.web.controller"})
public class WebMvcConfig implements WebMvcConfigurer {
   private final ClientSessionInterceptor clientSessionInterceptor;
   private final String uploadDir;
   private final String staticOutputDir;

   public WebMvcConfig(ClientSessionInterceptor clientSessionInterceptor, @Value("${app.upload.dir:${user.dir}/runtime-uploads}") String uploadDir, @Value("${app.static.output-dir:generated-static/activities}") String staticOutputDir) {
      this.clientSessionInterceptor = clientSessionInterceptor;
      this.uploadDir = uploadDir;
      this.staticOutputDir = staticOutputDir;
   }

   public void addCorsMappings(CorsRegistry registry) {
      registry.addMapping("/api/**").allowedOrigins(new String[]{"*"}).allowedMethods(new String[]{"*"});
   }

   public void addInterceptors(InterceptorRegistry registry) {
      registry.addInterceptor(this.clientSessionInterceptor).addPathPatterns(new String[]{"/client", "/api/client/**"});
   }

   public void addResourceHandlers(ResourceHandlerRegistry registry) {
      registry.addResourceHandler(new String[]{"/static/**"}).addResourceLocations(new String[]{"classpath:/static/"});
      Path uploadPath = Path.of(this.uploadDir).toAbsolutePath().normalize();
      Path staticOutputPath = Path.of(this.staticOutputDir).toAbsolutePath().normalize();

      try {
         Files.createDirectories(uploadPath);
         Files.createDirectories(staticOutputPath);
      } catch (IOException exception) {
         throw new IllegalStateException("无法初始化资源目录", exception);
      }

      registry.addResourceHandler(new String[]{"/uploads/**"}).addResourceLocations(new String[]{uploadPath.toUri().toString()});
      registry.addResourceHandler(new String[]{"/generated-static/activities/**"}).addResourceLocations(new String[]{staticOutputPath.toUri().toString()});
   }

   public void configureViewResolvers(ViewResolverRegistry registry) {
      registry.freeMarker();
   }

   public void extendMessageConverters(List converters) {
      MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
      ObjectMapper objectMapper = new ObjectMapper();
      objectMapper.registerModule(new JavaTimeModule());
      converter.setObjectMapper(objectMapper);
      converters.add(0, converter);
   }

   @Bean
   public FreeMarkerConfigurer freeMarkerConfigurer() {
      FreeMarkerConfigurer configurer = new FreeMarkerConfigurer();
      configurer.setTemplateLoaderPath("classpath:/templates/");
      configurer.setDefaultEncoding("UTF-8");
      configurer.setPreferFileSystemAccess(false);
      return configurer;
   }
}
