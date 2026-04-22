package com.campusai.web.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
import org.springframework.data.redis.core.StringRedisTemplate;

@Configuration
public class RedisConfig {
   @Bean
   public LettuceConnectionFactory redisConnectionFactory(@Value("${redis.host}") String host, @Value("${redis.port}") int port, @Value("${redis.database}") int database) {
      RedisStandaloneConfiguration configuration = new RedisStandaloneConfiguration(host, port);
      configuration.setDatabase(database);
      return new LettuceConnectionFactory(configuration);
   }

   @Bean
   public StringRedisTemplate stringRedisTemplate(LettuceConnectionFactory connectionFactory) {
      return new StringRedisTemplate(connectionFactory);
   }
}
