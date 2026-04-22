package com.campusai.web.config;

import com.campusai.service.service.ActivityService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class ActivityStaticPageScheduler {
   private final ActivityService activityService;

   public ActivityStaticPageScheduler(ActivityService activityService) {
      this.activityService = activityService;
   }

   @Scheduled(fixedDelayString = "${app.activity.static-refresh-ms:300000}", initialDelay = 20000L)
   public void refreshExpiredActivities() {
      this.activityService.refreshExpiredActivities();
   }
}
