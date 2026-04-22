package com.campusai.service.service;

import com.campusai.service.mapper.DashboardMapper;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {
   private final DashboardMapper dashboardMapper;
   private final MerchantService merchantService;
   private final MealPackageService mealPackageService;
   private final ImageCacheService imageCacheService;
   private final StaticPageService staticPageService;
   private final ZookeeperConfigService zookeeperConfigService;
   private final MerchantAdminScopeService merchantAdminScopeService;

   public DashboardService(DashboardMapper dashboardMapper, MerchantService merchantService, MealPackageService mealPackageService, ImageCacheService imageCacheService, StaticPageService staticPageService, ZookeeperConfigService zookeeperConfigService, MerchantAdminScopeService merchantAdminScopeService) {
      this.dashboardMapper = dashboardMapper;
      this.merchantService = merchantService;
      this.mealPackageService = mealPackageService;
      this.imageCacheService = imageCacheService;
      this.staticPageService = staticPageService;
      this.zookeeperConfigService = zookeeperConfigService;
      this.merchantAdminScopeService = merchantAdminScopeService;
   }

   public Map buildDashboard() {
      return this.buildDashboard((List<Long>)null);
   }

   public Map buildDashboard(Authentication authentication) {
      return this.buildDashboard((List<Long>)null);
   }

   public Map buildDashboard(List<Long> merchantIds) {
      boolean merchantScoped = merchantIds != null;
      Map<String, Object> dashboard = new LinkedHashMap();
      List<Map<String, Object>> orderRatio = merchantScoped ? this.queryOrderRatio(merchantIds) : this.dashboardMapper.queryOrderRatio();
      List<String> hotMerchants = orderRatio.stream().limit(5L).map((item) -> String.valueOf(item.getOrDefault("statName", "-"))).collect(Collectors.toList());
      List<String> hotPackages = new ArrayList<>();
      this.merchantService.listAllMerchants(merchantIds).stream().limit(8L).forEach((merchant) -> this.mealPackageService.listPackages(merchant.getId()).stream().filter((item) -> "ONLINE".equalsIgnoreCase(item.getStatus())).limit(3L).forEach((item) -> {
         if (hotPackages.size() < 6) {
            hotPackages.add(item.getName());
         }
      }));
      this.imageCacheService.cacheHomeHotData(hotMerchants, hotPackages);
      dashboard.put("summary", merchantScoped ? this.querySummary(merchantIds) : this.dashboardMapper.querySummary());
      dashboard.put("registerTrend", this.dashboardMapper.queryRegisterTrend());
      dashboard.put("orderRatio", orderRatio);
      dashboard.put("studyRoomUsage", this.dashboardMapper.queryStudyRoomUsage());
      dashboard.put("activityHotRank", this.dashboardMapper.queryActivityHotRank());
      dashboard.put("monthlyReportPreview", merchantScoped ? this.queryMonthlyOperationReport(merchantIds) : this.dashboardMapper.queryMonthlyOperationReport());
      Map<String, Object> system = new LinkedHashMap();
      system.put("cache", this.imageCacheService.snapshotCacheMetrics());
      system.put("staticPage", this.staticPageService.snapshot());
      system.put("zookeeper", this.zookeeperConfigService.loadConfig("/campusai/platform/config"));
      dashboard.put("system", system);
      Map<String, Object> scope = new LinkedHashMap();
      scope.put("merchantScoped", merchantScoped);
      scope.put("merchantIds", merchantScoped ? merchantIds : Collections.emptyList());
      dashboard.put("scope", scope);
      return dashboard;
   }

   private Map<String, Object> querySummary(List<Long> merchantIds) {
      if (merchantIds == null) {
         return this.dashboardMapper.querySummary();
      } else if (merchantIds.isEmpty()) {
         Map<String, Object> summary = new LinkedHashMap();
         summary.put("merchantCount", 0);
         summary.put("dishCount", 0);
         summary.put("packageCount", 0);
         summary.put("studyRoomCount", 0);
         summary.put("activityCount", 0);
         return summary;
      } else {
         return this.dashboardMapper.querySummaryByMerchantIds(merchantIds);
      }
   }

   private List<Map<String, Object>> queryOrderRatio(List<Long> merchantIds) {
      return merchantIds != null && !merchantIds.isEmpty() ? this.dashboardMapper.queryOrderRatioByMerchantIds(merchantIds) : List.of();
   }

   private List<Map<String, Object>> queryMonthlyOperationReport(List<Long> merchantIds) {
      return merchantIds != null && !merchantIds.isEmpty() ? this.dashboardMapper.queryMonthlyOperationReportByMerchantIds(merchantIds) : List.of();
   }
}
