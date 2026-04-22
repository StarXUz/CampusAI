package com.campusai.service.service;

import com.campusai.common.util.AssertUtils;
import java.time.Duration;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class SubmissionGuardService {
   private static final String PREFIX = "campus:submit:guard:";
   private final StringRedisTemplate redisTemplate;

   public SubmissionGuardService(StringRedisTemplate redisTemplate) {
      this.redisTemplate = redisTemplate;
   }

   public void guard(String scope, String uniqueKey, Duration ttl, String message) {
      AssertUtils.notBlank(scope, "重复提交防护范围不能为空");
      AssertUtils.notBlank(uniqueKey, "重复提交防护键不能为空");
      Duration finalTtl = ttl == null ? Duration.ofSeconds(3L) : ttl;
      String redisKey = PREFIX + scope + ":" + uniqueKey;
      Boolean ok = this.redisTemplate.opsForValue().setIfAbsent(redisKey, "1", finalTtl);
      AssertUtils.isTrue(Boolean.TRUE.equals(ok), message == null || message.isBlank() ? "操作过于频繁，请稍后重试" : message);
   }
}
