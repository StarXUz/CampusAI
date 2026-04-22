package com.campusai.web.controller;

import com.campusai.common.api.ApiResponse;
import com.campusai.service.dto.PageQuery;
import com.campusai.service.dto.SuperAuditLogQuery;
import com.campusai.service.dto.SuperUserSaveRequest;
import com.campusai.service.service.SuperAdminService;
import jakarta.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
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
@RequestMapping({"/api/super"})
public class SuperAdminController {
   private final SuperAdminService superAdminService;
   private final String uploadDir;

   public SuperAdminController(SuperAdminService superAdminService, @Value("${app.upload.dir:${user.dir}/runtime-uploads}") String uploadDir) {
      this.superAdminService = superAdminService;
      this.uploadDir = uploadDir;
   }

   @PostMapping({"/clients/page"})
   public ApiResponse pageClients(@RequestBody PageQuery query) {
      return ApiResponse.success(this.superAdminService.pageClientUsers(query));
   }

   @PostMapping({"/admins/page"})
   public ApiResponse pageAdmins(@RequestBody PageQuery query) {
      return ApiResponse.success(this.superAdminService.pageAdminUsers(query));
   }

   @GetMapping({"/users/{id}"})
   public ApiResponse findUser(@PathVariable("id") Long id) {
      return ApiResponse.success(this.superAdminService.findUser(id));
   }

   @PostMapping({"/users"})
   public ApiResponse saveUser(@RequestBody SuperUserSaveRequest request, Authentication authentication) {
      return ApiResponse.success("用户保存成功", this.superAdminService.saveUser(request, this.currentOperator(authentication)));
   }

   @PostMapping({"/users/{id}/delete"})
   public ApiResponse deleteUser(@PathVariable("id") Long id, Authentication authentication) {
      this.superAdminService.deleteUser(id, this.currentOperator(authentication));
      return ApiResponse.success("用户删除成功", (Object)null);
   }

   @GetMapping({"/users/template"})
   public void downloadUserTemplate(HttpServletResponse response) throws IOException {
      response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
      response.setHeader("Content-Disposition", "attachment; filename=super-users-template.xlsx");
      response.getOutputStream().write(this.superAdminService.generateUserTemplate());
   }

   @PostMapping(
      value = {"/users/import"},
      consumes = {MediaType.MULTIPART_FORM_DATA_VALUE}
   )
   public ApiResponse importUsers(@RequestPart("file") MultipartFile file, @RequestParam(value = "roleCode",required = false) String roleCode, Authentication authentication) throws IOException {
      Map<String, Object> payload = this.superAdminService.importUsers(file.getInputStream(), roleCode, this.currentOperator(authentication));
      Object errorRows = payload.get("errorRows");
      if (errorRows instanceof List rows && !rows.isEmpty()) {
         payload.put("errorReportUrl", this.writeImportErrorReport(rows));
      }

      return ApiResponse.success("账号导入完成", payload);
   }

   @GetMapping({"/audit-logs"})
   public ApiResponse listAuditLogs(@RequestParam(value = "operationType",required = false) String operationType, @RequestParam(value = "operatorName",required = false) String operatorName, @RequestParam(value = "actionResult",required = false) String actionResult, @RequestParam(value = "startTime",required = false) String startTime, @RequestParam(value = "endTime",required = false) String endTime, @RequestParam(value = "limit",defaultValue = "50") int limit) {
      return ApiResponse.success(this.superAdminService.listAuditLogs(operationType, operatorName, actionResult, startTime, endTime, limit));
   }

   @PostMapping({"/audit-logs"})
   public ApiResponse listAuditLogsCompat(@RequestBody(required = false) SuperAuditLogQuery query) {
      if (query == null) {
         query = new SuperAuditLogQuery();
      }

      int limit = query.getPageSize() > 0 ? query.getPageSize() : 50;
      return ApiResponse.success(this.superAdminService.listAuditLogs(query.getOperationType(), query.getOperatorName(), query.getActionResult(), query.getStartTime(), query.getEndTime(), limit));
   }

   @PostMapping({"/audit-logs/page"})
   public ApiResponse pageAuditLogs(@RequestBody SuperAuditLogQuery query) {
      return ApiResponse.success(this.superAdminService.pageAuditLogs(query));
   }

   @GetMapping({"/audit-logs/export"})
   public void exportAuditLogs(@RequestParam(value = "operationType",required = false) String operationType, @RequestParam(value = "operatorName",required = false) String operatorName, @RequestParam(value = "actionResult",required = false) String actionResult, @RequestParam(value = "startTime",required = false) String startTime, @RequestParam(value = "endTime",required = false) String endTime, @RequestParam(value = "limit",defaultValue = "500") int limit, HttpServletResponse response) throws IOException {
      response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
      response.setHeader("Content-Disposition", "attachment; filename=super-audit-logs.xlsx");
      response.getOutputStream().write(this.superAdminService.exportAuditLogs(operationType, operatorName, actionResult, startTime, endTime, limit));
   }

   @GetMapping({"/audit-trend"})
   public ApiResponse auditTrend(@RequestParam(value = "days",defaultValue = "7") int days) {
      return ApiResponse.success(this.superAdminService.queryAuditTrend(days));
   }

    @PostMapping({"/audit-trend"})
    public ApiResponse auditTrendCompat(@RequestBody(required = false) Map<String, Object> payload) {
       int days = 7;
       if (payload != null && payload.get("days") != null) {
          try {
             days = Integer.parseInt(String.valueOf(payload.get("days")));
          } catch (Exception var4) {
             days = 7;
          }
       }

       return ApiResponse.success(this.superAdminService.queryAuditTrend(days));
    }

   @GetMapping({"/overview"})
   public ApiResponse overview() {
      PageQuery clientQuery = new PageQuery();
      clientQuery.setPageNum(1);
      clientQuery.setPageSize(100);
      clientQuery.setKeyword("");
      PageQuery adminQuery = new PageQuery();
      adminQuery.setPageNum(1);
      adminQuery.setPageSize(100);
      adminQuery.setKeyword("");
      Map<String, Object> payload = new LinkedHashMap<>();
      payload.put("clientUsers", this.superAdminService.pageClientUsers(clientQuery).getTotal());
      payload.put("adminUsers", this.superAdminService.pageAdminUsers(adminQuery).getTotal());
      payload.put("sharedData", this.superAdminService.buildSharedSyncData());
      return ApiResponse.success(payload);
   }

   @PostMapping({"/overview"})
   public ApiResponse overviewCompat() {
      return this.overview();
   }

   @GetMapping({"/shared/snapshot"})
   public ApiResponse sharedSnapshot() {
      return ApiResponse.success(this.superAdminService.buildSharedSyncData());
   }

   private String currentOperator(Authentication authentication) {
      return authentication != null && authentication.getName() != null ? authentication.getName() : "super";
   }

   private String writeImportErrorReport(List<Map<String, Object>> errorRows) {
      try {
         Path reportDir = Path.of(this.uploadDir, "import-reports").toAbsolutePath().normalize();
         Files.createDirectories(reportDir);
         String fileName = "super-user-import-errors-" + UUID.randomUUID().toString().replace("-", "") + ".xlsx";
         Path target = reportDir.resolve(fileName);
         XSSFWorkbook workbook = new XSSFWorkbook();

         byte[] data;
         try {
            XSSFSheet sheet = workbook.createSheet("errors");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("row_num");
            header.createCell(1).setCellValue("username");
            header.createCell(2).setCellValue("phone");
            header.createCell(3).setCellValue("password");
            header.createCell(4).setCellValue("enabled");
            header.createCell(5).setCellValue("avatar_url");
            header.createCell(6).setCellValue("role_code");
            header.createCell(7).setCellValue("error");

            for(int i = 0; i < errorRows.size(); ++i) {
               Map<String, Object> rowData = errorRows.get(i);
               Row row = sheet.createRow(i + 1);
               row.createCell(0).setCellValue(String.valueOf(rowData.getOrDefault("rowNum", "")));
               row.createCell(1).setCellValue(String.valueOf(rowData.getOrDefault("username", "")));
               row.createCell(2).setCellValue(String.valueOf(rowData.getOrDefault("phone", "")));
               row.createCell(3).setCellValue(String.valueOf(rowData.getOrDefault("password", "")));
               row.createCell(4).setCellValue(String.valueOf(rowData.getOrDefault("enabled", "")));
               row.createCell(5).setCellValue(String.valueOf(rowData.getOrDefault("avatarUrl", "")));
               row.createCell(6).setCellValue(String.valueOf(rowData.getOrDefault("roleCode", "")));
               row.createCell(7).setCellValue(String.valueOf(rowData.getOrDefault("error", "")));
            }

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

            try {
               workbook.write(outputStream);
               data = outputStream.toByteArray();
            } catch (Throwable var13) {
               try {
                  outputStream.close();
               } catch (Throwable var12) {
                  var13.addSuppressed(var12);
               }

               throw var13;
            }

            outputStream.close();
         } catch (Throwable var14) {
            try {
               workbook.close();
            } catch (Throwable var11) {
               var14.addSuppressed(var11);
            }

            throw var14;
         }

         workbook.close();
         Files.write(target, data, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
         return "/uploads/import-reports/" + fileName;
      } catch (IOException exception) {
         throw new IllegalStateException("失败报告生成失败", exception);
      }
   }
}
