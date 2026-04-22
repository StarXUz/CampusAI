package com.campusai.service.job;

import com.campusai.service.service.ImageCacheService;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.stereotype.Component;

@Component
public class ClearUnusedImageJob implements Job {
   private final ImageCacheService imageCacheService;

   public ClearUnusedImageJob(ImageCacheService imageCacheService) {
      this.imageCacheService = imageCacheService;
   }

   public void execute(JobExecutionContext context) throws JobExecutionException {
      this.imageCacheService.loadUnusedImages();
   }
}
