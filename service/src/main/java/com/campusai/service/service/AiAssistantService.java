package com.campusai.service.service;

import com.campusai.service.ai.AiChatClient;
import com.campusai.service.dto.DishQuery;
import com.campusai.service.entity.Activity;
import com.campusai.service.entity.Dish;
import com.campusai.service.entity.MealPackage;
import com.campusai.service.entity.Order;
import com.campusai.service.entity.ReservationRecord;
import com.campusai.service.entity.StudyRoom;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;

@Service
public class AiAssistantService {
   private final AiChatClient aiChatClient;
   private final MerchantService merchantService;
   private final DishService dishService;
   private final MealPackageService mealPackageService;
   private final StudyRoomService studyRoomService;
   private final ActivityService activityService;
   private final OrderService orderService;

   public AiAssistantService(AiChatClient aiChatClient, MerchantService merchantService, DishService dishService, MealPackageService mealPackageService, StudyRoomService studyRoomService, ActivityService activityService, OrderService orderService) {
      this.aiChatClient = aiChatClient;
      this.merchantService = merchantService;
      this.dishService = dishService;
      this.mealPackageService = mealPackageService;
      this.studyRoomService = studyRoomService;
      this.activityService = activityService;
      this.orderService = orderService;
   }

   public String ask(String scene, String question) {
      return this.ask(scene, question, (Long)null);
   }

   public String ask(String scene, String question, Long userId) {
      String context = this.buildRealtimeContext(userId, question);
      String prompt = """
              请严格基于以下“实时业务数据上下文”回答，若上下文不存在对应信息，请明确说“当前数据中未找到”，不要编造。
              回答时优先参考“关键词命中数据”，其次再参考全量概览数据。

              实时业务数据上下文：
              %s

              用户问题：
              %s
      """.formatted(context, question == null ? "" : question.trim());
      return this.aiChatClient.ask(scene, prompt);
   }

   private String buildRealtimeContext(Long userId, String question) {
      Set<String> keywords = this.extractKeywords(question);
      StringBuilder builder = new StringBuilder(1024);
      List<com.campusai.service.entity.Merchant> merchants = this.merchantService.listAllMerchants();
      List<com.campusai.service.entity.Merchant> approvedMerchants = merchants.stream().filter((merchant) -> "APPROVED".equalsIgnoreCase(merchant.getAuditStatus())).collect(Collectors.toList());
      List<StudyRoom> rooms = this.studyRoomService.listRooms();
      List<Activity> activities = this.activityService.listActivities();
      List<DishDigest> allDishes = new ArrayList<>();
      List<PackageDigest> allPackages = new ArrayList<>();
      builder.append("【上下文生成时间】\n");
      builder.append("- ").append(LocalDateTime.now()).append("\n");
      if (!keywords.isEmpty()) {
         builder.append("- 问题关键词：").append(String.join("、", keywords)).append("\n");
      }

      List<String> keywordHits = new ArrayList<>();
      for(com.campusai.service.entity.Merchant merchant : merchants) {
         if (this.matchesAnyKeyword(keywords, merchant.getName(), merchant.getCanteenName())) {
            keywordHits.add("商家命中：" + safe(merchant.getName()) + "（" + safe(merchant.getCanteenName()) + "，审核：" + this.formatAuditStatus(merchant.getAuditStatus()) + "）");
         }

         List<Dish> merchantDishes = new ArrayList<>();
         for(Object item : this.dishService.pageMerchantDishes(merchant.getId(), pageQueryTopWithSoldOut(120), false).getRecords()) {
            if (item instanceof Dish dish) {
               merchantDishes.add(dish);
               allDishes.add(new DishDigest(merchant, dish));
            }
         }

         for(Dish dish : merchantDishes) {
            if (this.matchesAnyKeyword(keywords, dish.getName(), dish.getDescription())) {
               keywordHits.add("菜品命中：" + safe(dish.getName()) + "（商家：" + safe(merchant.getName()) + "，价格￥" + safe(dish.getPrice()) + "）");
            }
         }

         for(MealPackage mealPackage : this.mealPackageService.listPackages(merchant.getId())) {
            allPackages.add(new PackageDigest(merchant, mealPackage));
            if (this.matchesAnyKeyword(keywords, mealPackage.getName(), mealPackage.getTheme(), mealPackage.getDescription())) {
               keywordHits.add("套餐命中：" + safe(mealPackage.getName()) + "（商家：" + safe(merchant.getName()) + "，价格￥" + safe(mealPackage.getPrice()) + "）");
            }
         }
      }

      for(StudyRoom room : rooms) {
         if (this.matchesAnyKeyword(keywords, room.getName(), room.getLocation())) {
            keywordHits.add("自习室命中：" + safe(room.getName()) + "（" + safe(room.getLocation()) + "）");
         }
      }

      for(Activity activity : activities) {
         if (this.matchesAnyKeyword(keywords, activity.getTitle(), activity.getLocation(), activity.getSummary(), activity.getStatus())) {
            keywordHits.add("活动命中：" + safe(activity.getTitle()) + "（地点：" + safe(activity.getLocation()) + "，状态：" + safe(activity.getStatus()) + "）");
         }
      }

      builder.append("\n【关键词命中数据】\n");
      if (keywordHits.isEmpty()) {
         builder.append("- 无关键词命中记录（将使用全量概览回答）\n");
      } else {
         keywordHits.stream().limit(18L).forEach((line) -> builder.append("- ").append(line).append("\n"));
      }

      long pendingMerchantCount = merchants.stream().filter((merchant) -> !"APPROVED".equalsIgnoreCase(merchant.getAuditStatus())).count();
      long recommendedMerchantCount = merchants.stream().filter((merchant) -> Boolean.TRUE.equals(merchant.getRecommended())).count();
      long onSaleDishCount = allDishes.stream().filter((digest) -> Boolean.TRUE.equals(digest.dish().getOnSale())).count();
      long onlinePackageCount = allPackages.stream().filter((digest) -> "ONLINE".equalsIgnoreCase(digest.mealPackage().getStatus())).count();
      builder.append("\n【全量实时概览】\n");
      builder.append("- 商家总数：").append(merchants.size()).append("（已审核 ").append(approvedMerchants.size()).append("，待处理 ").append(pendingMerchantCount).append("，推荐 ").append(recommendedMerchantCount).append("）\n");
      builder.append("- 菜品总数：").append(allDishes.size()).append("（当前上架 ").append(onSaleDishCount).append("）\n");
      builder.append("- 套餐总数：").append(allPackages.size()).append("（在线 ").append(onlinePackageCount).append("）\n");
      builder.append("- 自习室：").append(rooms.size()).append("，活动：").append(activities.size()).append("\n");

      builder.append("\n【最新新增与最近变更】\n");
      merchants.stream().sorted(Comparator.comparing(com.campusai.service.entity.Merchant::getId, Comparator.nullsLast(Long::compareTo)).reversed()).limit(6L).forEach((merchant) -> builder.append("- 最新商家：").append(safe(merchant.getName())).append("（").append(safe(merchant.getCanteenName())).append("，审核：").append(this.formatAuditStatus(merchant.getAuditStatus())).append("）\n"));
      allDishes.stream().sorted(Comparator.comparing((DishDigest digest) -> digest.dish().getId(), Comparator.nullsLast(Long::compareTo)).reversed()).limit(10L).forEach((digest) -> builder.append("- 最新菜品：").append(safe(digest.dish().getName())).append("（商家：").append(safe(digest.merchant().getName())).append("，价格￥").append(safe(digest.dish().getPrice())).append("，").append(Boolean.TRUE.equals(digest.dish().getOnSale()) ? "上架中" : "已售罄").append("）\n"));
      allPackages.stream().sorted(Comparator.comparing((PackageDigest digest) -> digest.mealPackage().getId(), Comparator.nullsLast(Long::compareTo)).reversed()).limit(8L).forEach((digest) -> builder.append("- 最新套餐：").append(safe(digest.mealPackage().getName())).append("（商家：").append(safe(digest.merchant().getName())).append("，状态：").append(safe(digest.mealPackage().getStatus())).append("）\n"));
      activities.stream().sorted(Comparator.comparing(Activity::getId, Comparator.nullsLast(Long::compareTo)).reversed()).limit(6L).forEach((activity) -> builder.append("- 最新活动：").append(safe(activity.getTitle())).append("（地点：").append(safe(activity.getLocation())).append("，状态：").append(safe(activity.getStatus())).append("）\n"));

      builder.append("\n【商家与餐饮】\n");
      approvedMerchants.stream().sorted(Comparator.comparing(com.campusai.service.entity.Merchant::getId, Comparator.nullsLast(Long::compareTo)).reversed()).limit(12L).forEach((merchant) -> {
         builder.append("- 商家：").append(safe(merchant.getName())).append("（").append(safe(merchant.getCanteenName())).append("）");
         List<String> dishes = new ArrayList<>();
         for(DishDigest digest : allDishes) {
            Dish dish = digest.dish();
            if (merchant.getId().equals(digest.merchant().getId()) && (keywords.isEmpty() || this.matchesAnyKeyword(keywords, dish.getName(), dish.getDescription()))) {
               dishes.add(safe(dish.getName()) + "￥" + safe(dish.getPrice()) + (Boolean.TRUE.equals(dish.getOnSale()) ? "" : "(售罄)"));
            }

            if (dishes.size() >= 6) {
               break;
            }
         }

         List<String> mealPackages = new ArrayList<>();
         for(PackageDigest digest : allPackages) {
            MealPackage mealPackage = digest.mealPackage();
            if (merchant.getId().equals(digest.merchant().getId()) && "ONLINE".equalsIgnoreCase(mealPackage.getStatus()) && (keywords.isEmpty() || this.matchesAnyKeyword(keywords, mealPackage.getName(), mealPackage.getTheme(), mealPackage.getDescription()))) {
               mealPackages.add(safe(mealPackage.getName()) + "￥" + safe(mealPackage.getPrice()));
               if (mealPackages.size() >= 4) {
                  break;
               }
            }
         }

         if (!dishes.isEmpty()) {
            builder.append("；在售菜品：").append(String.join("、", dishes));
         }

         if (!mealPackages.isEmpty()) {
            builder.append("；在线套餐：").append(String.join("、", mealPackages));
         }

         builder.append("\n");
      });
      builder.append("\n【自习室与预约规则】\n");
      rooms.stream().limit(10L).forEach((room) -> builder.append("- ").append(safe(room.getName())).append("，位置：").append(safe(room.getLocation())).append("，开放：").append(safe(room.getOpenTime())).append("-").append(safe(room.getCloseTime())).append("，单次最多").append(safe(room.getMaxHours())).append("小时，每日").append(safe(room.getDailyLimit())).append("次\n"));
      builder.append("\n【活动】\n");
      activities.stream().limit(12L).forEach((activity) -> builder.append("- ").append(safe(activity.getTitle())).append("，地点：").append(safe(activity.getLocation())).append("，时间：").append(safe(activity.getStartTime())).append("，状态：").append(safe(activity.getStatus())).append("\n"));
      if (userId != null) {
         builder.append("\n【当前用户近期记录】\n");
         List<Order> orders = this.orderService.listMyOrders(userId);
         if (orders.isEmpty()) {
            builder.append("- 最近订单：无\n");
         } else {
            orders.stream().limit(5L).forEach((order) -> builder.append("- 订单：").append(safe(order.getItemName())).append("，金额￥").append(safe(order.getTotalAmount())).append("，状态：").append(safe(order.getStatus())).append("，创建时间：").append(safe(order.getCreatedAt())).append("\n"));
         }

         List<ReservationRecord> reservations = this.studyRoomService.listMyReservations(userId);
         if (reservations.isEmpty()) {
            builder.append("- 最近预约：无\n");
         } else {
            reservations.stream().limit(5L).forEach((record) -> builder.append("- 预约：").append(safe(record.getStudyRoomName())).append(" 座位").append(safe(record.getSeatCode())).append("，").append(safe(record.getReservationDate())).append(" ").append(safe(record.getStartTime())).append("-").append(safe(record.getEndTime())).append("，状态：").append(safe(record.getStatus())).append("\n"));
         }

         List<String> mineSignups = this.activityService.listMyRegistrations(userId).stream().limit(5L).map((registration) -> {
            String title = activities.stream().filter((a) -> a.getId().equals(registration.getActivityId())).map(Activity::getTitle).findFirst().orElse("活动#" + registration.getActivityId());
            return title + "（" + safe(registration.getStatus()) + "）";
         }).collect(Collectors.toList());
         builder.append("- 我的报名：").append(mineSignups.isEmpty() ? "无" : String.join("、", mineSignups)).append("\n");
      }

      return builder.toString();
   }

   private String formatAuditStatus(String auditStatus) {
      if ("APPROVED".equalsIgnoreCase(auditStatus)) {
         return "已审核";
      } else if ("PENDING".equalsIgnoreCase(auditStatus)) {
         return "待审核";
      } else {
         return safe(auditStatus);
      }
   }

   private static String safe(Object value) {
      return value == null ? "-" : String.valueOf(value);
   }

   private Set<String> extractKeywords(String question) {
      Set<String> tokens = new LinkedHashSet<>();
      String source = question == null ? "" : question.toLowerCase(Locale.ROOT);
      String[] var4 = source.split("[^0-9a-zA-Z\\u4e00-\\u9fa5]+");
      int var5 = var4.length;

      for(int var6 = 0; var6 < var5; ++var6) {
         String token = var4[var6];
         if (token.length() >= 2 && !"当前".equals(token) && !"数据".equals(token) && !"信息".equals(token) && !"请问".equals(token)) {
            tokens.add(token);
         }
      }

      return tokens;
   }

   private boolean matchesAnyKeyword(Set<String> keywords, String... fields) {
      if (keywords.isEmpty()) {
         return false;
      } else {
         for(String field : fields) {
            String text = field == null ? "" : field.toLowerCase(Locale.ROOT);

            for(String keyword : keywords) {
               if (text.contains(keyword)) {
                  return true;
               }
            }
         }

         return false;
      }
   }

   private static DishQuery pageQueryTopWithSoldOut(int pageSize) {
      DishQuery query = new DishQuery();
      query.setPageNum(1);
      query.setPageSize(pageSize);
      query.setKeyword("");
      query.setIncludeSoldOut(Boolean.TRUE);
      return query;
   }

   private static record DishDigest(com.campusai.service.entity.Merchant merchant, Dish dish) {
   }

   private static record PackageDigest(com.campusai.service.entity.Merchant merchant, MealPackage mealPackage) {
   }
}
