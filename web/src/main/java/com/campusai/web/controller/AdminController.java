package com.campusai.web.controller;

import com.campusai.common.api.ApiResponse;
import com.campusai.common.util.AssertUtils;
import com.campusai.service.dto.AdminAuditLogQuery;
import com.campusai.service.dto.DishQuery;
import com.campusai.service.dto.PageQuery;
import com.campusai.service.entity.Activity;
import com.campusai.service.entity.Dish;
import com.campusai.service.entity.DishCategory;
import com.campusai.service.entity.MealPackage;
import com.campusai.service.entity.Merchant;
import com.campusai.service.entity.PackageDish;
import com.campusai.service.entity.ReservationRule;
import com.campusai.service.entity.StudyRoom;
import com.campusai.service.service.ActivityService;
import com.campusai.service.service.AdminAuditLogService;
import com.campusai.service.service.DashboardService;
import com.campusai.service.service.DishService;
import com.campusai.service.service.MealPackageService;
import com.campusai.service.service.MerchantAdminScopeService;
import com.campusai.service.service.MerchantService;
import com.campusai.service.service.ReportExportService;
import com.campusai.service.service.StaticPageService;
import com.campusai.service.service.StudyRoomService;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping({"/api/admin"})
public class AdminController {
   private final MerchantService merchantService;
   private final DishService dishService;
   private final MealPackageService mealPackageService;
   private final StudyRoomService studyRoomService;
   private final ActivityService activityService;
   private final DashboardService dashboardService;
   private final ReportExportService reportExportService;
   private final StaticPageService staticPageService;
   private final AdminAuditLogService adminAuditLogService;
   private final MerchantAdminScopeService merchantAdminScopeService;
   private final Path uploadRoot;

   public AdminController(MerchantService merchantService, DishService dishService, MealPackageService mealPackageService, StudyRoomService studyRoomService, ActivityService activityService, DashboardService dashboardService, ReportExportService reportExportService, StaticPageService staticPageService, AdminAuditLogService adminAuditLogService, MerchantAdminScopeService merchantAdminScopeService, @Value("${app.upload.dir:${user.dir}/runtime-uploads}") String uploadDir) {
      this.merchantService = merchantService;
      this.dishService = dishService;
      this.mealPackageService = mealPackageService;
      this.studyRoomService = studyRoomService;
      this.activityService = activityService;
      this.dashboardService = dashboardService;
      this.reportExportService = reportExportService;
      this.staticPageService = staticPageService;
      this.adminAuditLogService = adminAuditLogService;
      this.merchantAdminScopeService = merchantAdminScopeService;
      this.uploadRoot = Path.of(uploadDir).toAbsolutePath().normalize();
   }

   @GetMapping({"/context"})
   public ApiResponse adminContext(Authentication authentication) {
      return ApiResponse.success(this.merchantAdminScopeService.buildAdminContext(authentication));
   }

   @PostMapping({"/merchants/page"})
   public ApiResponse pageMerchants(@RequestBody PageQuery query, Authentication authentication) {
      return ApiResponse.success(this.merchantService.pageMerchants(query, this.currentMerchantScope(authentication)));
   }

   @PostMapping({"/merchants"})
   public ApiResponse saveMerchant(@RequestBody Merchant merchant, Authentication authentication) {
      Merchant saved = this.merchantService.saveMerchant(merchant);
      this.writeAudit("MERCHANT", saved.getId(), saved.getName(), "SAVE", "商家保存成功", authentication);
      return ApiResponse.success("商家保存成功", saved);
   }

   @GetMapping({"/merchants/{id}"})
   public ApiResponse findMerchant(@PathVariable("id") Long id, Authentication authentication) {
      this.assertMerchantAccessible(authentication, id);
      return ApiResponse.success(this.merchantService.findMerchant(id));
   }

   @PostMapping({"/merchants/{id}/audit"})
   public ApiResponse auditMerchant(@PathVariable("id") Long id, @RequestParam("status") String status, Authentication authentication) {
      this.merchantService.auditMerchant(id, status);
      this.writeAudit("MERCHANT", id, null, "AUDIT", "商家审核状态更新为 " + status, authentication);
      return ApiResponse.success("审核状态已更新", (Object)null);
   }

   @GetMapping({"/merchants/{merchantId}/categories"})
   public ApiResponse listCategories(@PathVariable("merchantId") Long merchantId, Authentication authentication) {
      this.assertMerchantAccessible(authentication, merchantId);
      return ApiResponse.success(this.dishService.listCategories(merchantId));
   }

   @PostMapping({"/categories"})
   public ApiResponse saveCategory(@RequestBody DishCategory category, Authentication authentication) {
      this.assertMerchantAccessible(authentication, category.getMerchantId());
      DishCategory saved = this.dishService.saveCategory(category);
      this.writeAudit("DISH", saved.getId(), saved.getName(), "SAVE_CATEGORY", "菜品分类保存成功", authentication);
      return ApiResponse.success("分类保存成功", saved);
   }

   @PostMapping({"/merchants/{merchantId}/dishes/page"})
   public ApiResponse pageDishes(@PathVariable("merchantId") Long merchantId, @RequestBody DishQuery query, Authentication authentication) {
      this.assertMerchantAccessible(authentication, merchantId);
      return ApiResponse.success(this.dishService.pageMerchantDishes(merchantId, query, false));
   }

   @PostMapping({"/dishes"})
   public ApiResponse saveDish(@RequestBody Dish dish, Authentication authentication) {
      if (dish.getId() != null) {
         Dish existing = this.dishService.findDish(dish.getId());
         this.assertMerchantAccessible(authentication, existing.getMerchantId());
      }

      this.assertMerchantAccessible(authentication, dish.getMerchantId());
      this.assertCategoryBelongsToMerchant(dish.getMerchantId(), dish.getCategoryId());
      Dish saved = this.dishService.saveDish(dish);
      this.writeAudit("DISH", saved.getId(), saved.getName(), "SAVE_DISH", "菜品保存成功", authentication);
      return ApiResponse.success("菜品保存成功", saved);
   }

   @GetMapping({"/dishes/{id}"})
   public ApiResponse findDish(@PathVariable("id") Long id, Authentication authentication) {
      Dish dish = this.dishService.findDish(id);
      this.assertMerchantAccessible(authentication, dish.getMerchantId());
      return ApiResponse.success(dish);
   }

   @PostMapping({"/dishes/{id}/delete"})
   public ApiResponse deleteDish(@PathVariable("id") Long id, Authentication authentication) {
      Dish dish = this.dishService.findDish(id);
      this.assertMerchantAccessible(authentication, dish.getMerchantId());
      this.dishService.deleteDish(id);
      this.writeAudit("DISH", id, null, "DELETE_DISH", "菜品删除成功", authentication);
      return ApiResponse.success("菜品删除成功", (Object)null);
   }

   @GetMapping({"/packages"})
   public ApiResponse listPackages(@RequestParam("merchantId") Long merchantId, Authentication authentication) {
      this.assertMerchantAccessible(authentication, merchantId);
      return ApiResponse.success(this.mealPackageService.listPackages(merchantId));
   }

   @GetMapping({"/packages/{id}"})
   public ApiResponse findPackage(@PathVariable("id") Long id, Authentication authentication) {
      MealPackage mealPackage = this.mealPackageService.findPackage(id);
      this.assertMerchantAccessible(authentication, mealPackage.getMerchantId());
      Map<String, Object> payload = new LinkedHashMap<>();
      payload.put("mealPackage", mealPackage);
      payload.put("relations", this.mealPackageService.findPackageRelations(id));
      return ApiResponse.success(payload);
   }

   @PostMapping({"/packages"})
   public ApiResponse savePackage(@RequestBody PackageSaveCommand command, Authentication authentication) {
      MealPackage mealPackage = command.getMealPackage();
      if (mealPackage.getId() != null) {
         MealPackage existing = this.mealPackageService.findPackage(mealPackage.getId());
         this.assertMerchantAccessible(authentication, existing.getMerchantId());
      }

      this.assertMerchantAccessible(authentication, mealPackage.getMerchantId());
      this.assertPackageRelationsBelongToMerchant(mealPackage.getMerchantId(), command.getRelations());
      MealPackage saved = this.mealPackageService.savePackage(command.getMealPackage(), command.getRelations());
      this.writeAudit("PACKAGE", saved.getId(), saved.getName(), "SAVE_PACKAGE", "套餐保存成功", authentication);
      return ApiResponse.success("套餐保存成功", saved);
   }

   @PostMapping({"/packages/{id}/delete"})
   public ApiResponse deletePackage(@PathVariable("id") Long id, Authentication authentication) {
      MealPackage mealPackage = this.mealPackageService.findPackage(id);
      this.assertMerchantAccessible(authentication, mealPackage.getMerchantId());
      this.mealPackageService.deletePackage(id);
      this.writeAudit("PACKAGE", id, null, "DELETE_PACKAGE", "套餐删除成功", authentication);
      return ApiResponse.success("套餐删除成功", (Object)null);
   }

   @GetMapping({"/study-rooms"})
   public ApiResponse listRooms(Authentication authentication) {
      return ApiResponse.success(this.studyRoomService.listRooms());
   }

   @GetMapping({"/study-rooms/{id}"})
   public ApiResponse findRoom(@PathVariable("id") Long id, Authentication authentication) {
      return ApiResponse.success(this.studyRoomService.findRoom(id));
   }

   @PostMapping({"/study-rooms"})
   public ApiResponse saveRoom(@RequestBody StudyRoom room, Authentication authentication) {
      StudyRoom saved = this.studyRoomService.saveRoom(room);
      this.writeAudit("STUDY_ROOM", saved.getId(), saved.getName(), "SAVE_ROOM", "自习室保存成功", authentication);
      return ApiResponse.success("自习室保存成功", saved);
   }

   @GetMapping({"/study-rooms/{id}/rule"})
   public ApiResponse findRule(@PathVariable("id") Long id, Authentication authentication) {
      return ApiResponse.success(this.studyRoomService.findRule(id));
   }

   @GetMapping({"/study-rooms/{id}/reservations"})
   public ApiResponse listReservations(@PathVariable("id") Long id, @RequestParam(value = "startDate", required = false) LocalDate startDate, @RequestParam(value = "endDate", required = false) LocalDate endDate, Authentication authentication) {
      return ApiResponse.success(this.studyRoomService.listReservationsByRoom(id, startDate, endDate));
   }

   @PostMapping({"/study-rooms/{id}/delete"})
   public ApiResponse deleteRoom(@PathVariable("id") Long id, Authentication authentication) {
      this.studyRoomService.deleteRoom(id);
      this.writeAudit("STUDY_ROOM", id, null, "DELETE_ROOM", "自习室删除成功", authentication);
      return ApiResponse.success("自习室删除成功", (Object)null);
   }

   @PostMapping({"/study-rooms/rules"})
   public ApiResponse saveRule(@RequestBody ReservationRule rule, Authentication authentication) {
      ReservationRule saved = this.studyRoomService.saveRule(rule);
      this.writeAudit("STUDY_ROOM", saved.getId(), null, "SAVE_RULE", "预约规则保存成功", authentication);
      return ApiResponse.success("预约规则保存成功", saved);
   }

   @GetMapping({"/study-rooms/template"})
   public void downloadSeatTemplate(HttpServletResponse response, Authentication authentication) throws IOException {
      response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
      response.setHeader("Content-Disposition", "attachment; filename=study-room-seats.xlsx");
      response.getOutputStream().write(this.studyRoomService.generateSeatTemplate());
   }

   @PostMapping(
      value = {"/study-rooms/import"},
      consumes = {"multipart/form-data"}
   )
   public ApiResponse importSeats(@RequestPart("file") MultipartFile file, Authentication authentication) throws IOException {
      int total = this.studyRoomService.importSeats(file.getInputStream());
      this.writeAudit("STUDY_ROOM", null, null, "IMPORT_SEATS", "导入座位 " + total + " 条", authentication);
      return ApiResponse.success("座位导入成功", total);
   }

   @GetMapping({"/activities"})
   public ApiResponse listActivities(Authentication authentication) {
      return ApiResponse.success(this.activityService.listActivities());
   }

   @PostMapping({"/activities"})
   public ApiResponse saveActivity(@RequestBody Activity activity, Authentication authentication) {
      Activity saved = this.activityService.saveActivity(activity);
      this.writeAudit("ACTIVITY", saved.getId(), saved.getTitle(), "SAVE_ACTIVITY", "活动保存成功", authentication);
      return ApiResponse.success("活动保存成功", saved);
   }

   @PostMapping(
      value = {"/uploads/images"},
      consumes = {MediaType.MULTIPART_FORM_DATA_VALUE}
   )
   public ApiResponse uploadImage(@RequestPart("file") MultipartFile file, @RequestParam(value = "type", defaultValue = "common") String type) throws IOException {
      if (file.isEmpty()) {
         throw new IllegalArgumentException("请选择要上传的图片文件");
      }

      String contentType = file.getContentType();
      if (contentType == null || !contentType.startsWith("image/")) {
         throw new IllegalArgumentException("仅支持上传图片文件");
      }

      String extension = this.resolveExtension(file.getOriginalFilename(), contentType);
      String normalizedType = type == null || type.isBlank() ? "common" : type.replaceAll("[^a-zA-Z0-9_-]", "").toLowerCase();
      Path targetDir = this.uploadRoot.resolve(normalizedType);
      Files.createDirectories(targetDir);
      String filename = normalizedType + "-" + UUID.randomUUID().toString().replace("-", "") + extension;
      Path targetFile = targetDir.resolve(filename);
      Files.copy(file.getInputStream(), targetFile, StandardCopyOption.REPLACE_EXISTING);
      Map<String, Object> payload = new LinkedHashMap<>();
      payload.put("url", "/uploads/" + normalizedType + "/" + filename);
      payload.put("name", filename);
      return ApiResponse.success("图片上传成功", payload);
   }

   @GetMapping({"/activities/{id}"})
   public ApiResponse findActivity(@PathVariable("id") Long id, Authentication authentication) {
      return ApiResponse.success(this.activityService.findActivity(id));
   }

   @PostMapping({"/activities/{id}/delete"})
   public ApiResponse deleteActivity(@PathVariable("id") Long id, Authentication authentication) {
      this.activityService.deleteActivity(id);
      this.writeAudit("ACTIVITY", id, null, "DELETE_ACTIVITY", "活动删除成功", authentication);
      return ApiResponse.success("活动删除成功", (Object)null);
   }

   @GetMapping({"/dashboard"})
   public ApiResponse dashboard(Authentication authentication) {
      return ApiResponse.success(this.dashboardService.buildDashboard(authentication));
   }

   @GetMapping({"/reports/activity/{activityId}/pdf"})
   public void exportActivityReport(@PathVariable("activityId") Long activityId, HttpServletResponse response, Authentication authentication) throws IOException {
      Activity activity = this.activityService.findActivity(activityId);
      String filename = "activity-" + activityId + "-" + this.normalizeFilename(activity.getTitle()) + "-report.pdf";
      response.setContentType("application/pdf");
      response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + URLEncoder.encode(filename, "UTF-8"));
      response.getOutputStream().write(this.activityService.exportSignupReport(activityId));
   }

   @GetMapping({"/reports/monthly.xlsx"})
   public void exportMonthlyReport(HttpServletResponse response, Authentication authentication) throws IOException {
      response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
      response.setHeader("Content-Disposition", "attachment; filename=monthly-operation-report.xlsx");
      response.getOutputStream().write(this.reportExportService.exportMonthlyOperationReport(this.currentMerchantScope(authentication)));
   }

   @GetMapping({"/reports/monthly.pdf"})
   public void exportMonthlyReportPdf(HttpServletResponse response, Authentication authentication) throws IOException {
      response.setContentType("application/pdf");
      response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + URLEncoder.encode("monthly-operation-report.pdf", "UTF-8"));
      response.getOutputStream().write(this.reportExportService.exportMonthlyOperationPdf(this.currentMerchantScope(authentication)));
   }

   @PostMapping({"/activities/{activityId}/staticize"})
   public ApiResponse staticizeActivity(@PathVariable("activityId") Long activityId, Authentication authentication) {
      Activity activity = this.activityService.findActivity(activityId);
      Path outputFile = this.activityService.regenerateStaticPage(activityId);
      Map<String, String> payload = new LinkedHashMap<>();
      payload.put("outputPath", outputFile.toString());
      payload.put("accessUrl", "/generated-static/activities/" + outputFile.getFileName());
      this.writeAudit("ACTIVITY", activityId, activity.getTitle(), "STATICIZE_ACTIVITY", "活动静态页生成成功", authentication);
      return ApiResponse.success("活动静态页生成成功", payload);
   }

   @PostMapping({"/audit-logs/page"})
   public ApiResponse pageAuditLogs(@RequestBody(required = false) AdminAuditLogQuery query, Authentication authentication) {
      return ApiResponse.success(this.adminAuditLogService.page(query));
   }

   public static class PackageSaveCommand {
      private MealPackage mealPackage;
      private List<PackageDish> relations;

      public MealPackage getMealPackage() {
         return this.mealPackage;
      }

      public void setMealPackage(MealPackage mealPackage) {
         this.mealPackage = mealPackage;
      }

      public List<PackageDish> getRelations() {
         return this.relations;
      }

      public void setRelations(List<PackageDish> relations) {
         this.relations = relations;
      }
   }

   private String resolveExtension(String originalFilename, String contentType) {
      if (originalFilename != null) {
         int dotIndex = originalFilename.lastIndexOf(46);
         if (dotIndex >= 0 && dotIndex < originalFilename.length() - 1) {
            return originalFilename.substring(dotIndex).toLowerCase();
         }
      }

      if ("image/png".equalsIgnoreCase(contentType)) {
         return ".png";
      } else if ("image/webp".equalsIgnoreCase(contentType)) {
         return ".webp";
      } else if ("image/gif".equalsIgnoreCase(contentType)) {
         return ".gif";
      } else {
         return ".jpg";
      }
   }

   private void writeAudit(String module, Long targetId, String targetName, String action, String detail, Authentication authentication) {
      this.adminAuditLogService.logSuccess(module, action, targetId, targetName, detail, this.currentOperator(authentication));
   }

   private List<Long> currentMerchantScope(Authentication authentication) {
      return null;
   }

   private void assertMerchantAccessible(Authentication authentication, Long merchantId) {
      this.merchantAdminScopeService.assertMerchantAccessible(authentication, merchantId);
   }

   private void assertCategoryBelongsToMerchant(Long merchantId, Long categoryId) {
      AssertUtils.notNull(categoryId, "菜品分类不能为空");
      boolean matched = this.dishService.listCategories(merchantId).stream().anyMatch((item) -> categoryId.equals(item.getId()));
      AssertUtils.isTrue(matched, "菜品分类不属于当前商家");
   }

   private void assertPackageRelationsBelongToMerchant(Long merchantId, List<PackageDish> relations) {
      if (relations != null) {
         for(PackageDish relation : relations) {
            Dish dish = this.dishService.findDish(relation.getDishId());
            AssertUtils.isTrue(merchantId.equals(dish.getMerchantId()), "套餐关联菜品必须属于当前商家");
         }
      }
   }

   private String currentOperator(Authentication authentication) {
      return authentication != null && authentication.getName() != null ? authentication.getName() : "admin";
   }

   private String normalizeFilename(String value) {
      if (value == null || value.isBlank()) {
         return "activity";
      }

      return value.replaceAll("[\\\\/:*?\"<>|\\s]+", "-").replaceAll("-{2,}", "-").replaceAll("^-|-$", "").toLowerCase();
   }
}
