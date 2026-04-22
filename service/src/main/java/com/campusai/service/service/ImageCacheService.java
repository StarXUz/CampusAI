package com.campusai.service.service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class ImageCacheService {
   private static final String IMAGE_CACHE_PREFIX = "campus:image:";
   private static final String UNUSED_IMAGE_SET = "campus:image:unused";
   private static final String HOT_MERCHANTS_KEY = "campus:home:hot:merchants";
   private static final String HOT_PACKAGES_KEY = "campus:home:hot:packages";
   private final StringRedisTemplate redisTemplate;

   public ImageCacheService(StringRedisTemplate redisTemplate) {
      this.redisTemplate = redisTemplate;
   }

   public void cacheImage(String imageKey, String imageUrl) {
      this.redisTemplate.opsForValue().set("campus:image:" + imageKey, imageUrl, Duration.ofHours(6L));
      this.redisTemplate.opsForSet().add("campus:image:unused", new String[]{imageKey});
   }

   public void markReferenced(String imageKey) {
      this.redisTemplate.opsForSet().remove("campus:image:unused", new Object[]{imageKey});
   }

   public Set loadUnusedImages() {
      return this.redisTemplate.opsForSet().members("campus:image:unused");
   }

   public void cacheHomeHotData(List<String> merchants, List<String> packages) {
      this.redisTemplate.delete(HOT_MERCHANTS_KEY);
      this.redisTemplate.delete(HOT_PACKAGES_KEY);
      if (merchants != null && !merchants.isEmpty()) {
         this.redisTemplate.opsForList().rightPushAll(HOT_MERCHANTS_KEY, merchants);
         this.redisTemplate.expire(HOT_MERCHANTS_KEY, Duration.ofMinutes(30L));
      }

      if (packages != null && !packages.isEmpty()) {
         this.redisTemplate.opsForList().rightPushAll(HOT_PACKAGES_KEY, packages);
         this.redisTemplate.expire(HOT_PACKAGES_KEY, Duration.ofMinutes(30L));
      }
   }

   public Map<String, Object> snapshotCacheMetrics() {
      Map<String, Object> payload = new LinkedHashMap();
      payload.put("imageCacheCount", this.countKeys(IMAGE_CACHE_PREFIX + "*"));
      payload.put("unusedImageCount", this.sizeOfSet(UNUSED_IMAGE_SET));
      payload.put("hotMerchantCount", this.sizeOfList(HOT_MERCHANTS_KEY));
      payload.put("hotPackageCount", this.sizeOfList(HOT_PACKAGES_KEY));
      payload.put("codeCacheCount", this.countKeys("campus:login:code:*"));
      payload.put("sampleHotMerchants", this.sampleList(HOT_MERCHANTS_KEY));
      payload.put("sampleHotPackages", this.sampleList(HOT_PACKAGES_KEY));
      return payload;
   }

   private long countKeys(String pattern) {
      Set<String> keys = this.redisTemplate.keys(pattern);
      return keys == null ? 0L : (long)keys.size();
   }

   private long sizeOfSet(String key) {
      Long value = this.redisTemplate.opsForSet().size(key);
      return value == null ? 0L : value;
   }

   private long sizeOfList(String key) {
      Long value = this.redisTemplate.opsForList().size(key);
      return value == null ? 0L : value;
   }

   private List<String> sampleList(String key) {
      List<String> list = this.redisTemplate.opsForList().range(key, 0L, 4L);
      return list == null ? new ArrayList<>() : list;
   }
}
