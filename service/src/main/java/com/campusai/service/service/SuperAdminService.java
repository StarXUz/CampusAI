package com.campusai.service.service;

import com.campusai.common.api.PageResult;
import com.campusai.common.util.AssertUtils;
import com.campusai.service.dto.PageQuery;
import com.campusai.service.dto.SuperAuditLogQuery;
import com.campusai.service.dto.SuperUserSaveRequest;
import com.campusai.service.entity.Role;
import com.campusai.service.entity.SuperAuditLog;
import com.campusai.service.entity.User;
import com.campusai.service.mapper.SuperAuditLogMapper;
import com.campusai.service.mapper.SuperSyncMapper;
import com.campusai.service.mapper.UserMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SuperAdminService {
   private static final Set<String> ADMIN_ROLE_CODES = Set.of("ROLE_SUPER_ADMIN", "ROLE_MERCHANT_ADMIN");
   private static final String CLIENT_ROLE_CODE = "ROLE_USER";
   private static final Pattern MOBILE_PATTERN = Pattern.compile("^1\\d{10}$");
   private final UserMapper userMapper;
   private final SuperSyncMapper superSyncMapper;
   private final SuperAuditLogMapper superAuditLogMapper;
   private final PasswordEncoder passwordEncoder;

   public SuperAdminService(UserMapper userMapper, SuperSyncMapper superSyncMapper, SuperAuditLogMapper superAuditLogMapper, PasswordEncoder passwordEncoder) {
      this.userMapper = userMapper;
      this.superSyncMapper = superSyncMapper;
      this.superAuditLogMapper = superAuditLogMapper;
      this.passwordEncoder = passwordEncoder;
      this.superAuditLogMapper.ensureTable();
   }

   public PageResult pageClientUsers(PageQuery query) {
      PageHelper.startPage(query.getPageNum(), query.getPageSize());
      List<User> users = this.userMapper.findUsersByRoleCode(CLIENT_ROLE_CODE, query.getKeyword());
      this.attachRoles(users);
      return new PageResult(PageInfo.of(users).getTotal(), users);
   }

   public PageResult pageAdminUsers(PageQuery query) {
      PageHelper.startPage(query.getPageNum(), query.getPageSize());
      List<User> users = this.userMapper.findUsersByRoleCodes(List.copyOf(ADMIN_ROLE_CODES), query.getKeyword());
      this.attachRoles(users);
      return new PageResult(PageInfo.of(users).getTotal(), users);
   }

   public User findUser(Long userId) {
      AssertUtils.notNull(userId, "用户ID不能为空");
      User user = this.userMapper.findById(userId);
      AssertUtils.notNull(user, "用户不存在");
      user.setRoles(this.userMapper.findRolesByUserId(userId));
      return user;
   }

   @Transactional
   public User saveUser(SuperUserSaveRequest request, String operatorName) {
      String operationType = request != null && request.getId() != null ? "UPDATE_USER" : "CREATE_USER";
      return this.saveUserInternal(request, operatorName, operationType);
   }

   @Transactional
   public Map<String, Object> importUsers(InputStream inputStream, String defaultRoleCode, String operatorName) {
      AssertUtils.notNull(inputStream, "导入文件不能为空");
      String importRoleCode = this.normalizeRoleCode(defaultRoleCode);
      AssertUtils.notNull(this.userMapper.findRoleByCode(importRoleCode), "默认角色不存在");
      int total = 0;
      int success = 0;
      int created = 0;
      int updated = 0;
      List<String> errors = new ArrayList<>();
      List<Map<String, Object>> errorRows = new ArrayList<>();
      DataFormatter formatter = new DataFormatter();

      try {
         XSSFWorkbook workbook = new XSSFWorkbook(inputStream);

         try {
            XSSFSheet sheet = workbook.getSheetAt(0);

            for(int rowNum = 1; rowNum <= sheet.getLastRowNum(); ++rowNum) {
               Row row = sheet.getRow(rowNum);
               if (row != null) {
                  String username = this.readCell(formatter, row, 0);
                  String phone = this.readCell(formatter, row, 1);
                  if (!username.isBlank() || !phone.isBlank()) {
                     ++total;
                     String password = this.readCell(formatter, row, 2);
                     String enabledText = this.readCell(formatter, row, 3);
                     String avatarUrl = this.readCell(formatter, row, 4);
                     String roleCodeCell = this.readCell(formatter, row, 5);
                     String roleCode = this.normalizeRoleCode(roleCodeCell.isBlank() ? importRoleCode : roleCodeCell);
                     User matchedByPhone = null;

                     try {
                        matchedByPhone = this.userMapper.findByPhone(phone);
                        SuperUserSaveRequest request = new SuperUserSaveRequest();
                        if (matchedByPhone != null) {
                           request.setId(matchedByPhone.getId());
                        }

                        request.setUsername(username);
                        request.setPhone(phone);
                        request.setPassword(password);
                        request.setEnabled(this.parseEnabled(enabledText));
                        request.setAvatarUrl(avatarUrl);
                        request.setRoleCode(roleCode);
                        this.saveUserInternal(request, operatorName, "IMPORT_USER");
                        ++success;
                        if (matchedByPhone == null) {
                           ++created;
                        } else {
                           ++updated;
                        }
                     } catch (Exception exception) {
                        this.writeAuditLog("IMPORT_USER", matchedByPhone == null ? null : matchedByPhone.getId(), username, roleCode, "FAIL", "第" + (rowNum + 1) + "行导入失败：" + exception.getMessage(), operatorName);
                        String rowError = "第" + (rowNum + 1) + "行：" + exception.getMessage();
                        errors.add(rowError);
                        Map<String, Object> errorRow = new LinkedHashMap<>();
                        errorRow.put("rowNum", rowNum + 1);
                        errorRow.put("username", username);
                        errorRow.put("phone", phone);
                        errorRow.put("password", password);
                        errorRow.put("enabled", enabledText);
                        errorRow.put("avatarUrl", avatarUrl);
                        errorRow.put("roleCode", roleCode);
                        errorRow.put("error", exception.getMessage());
                        errorRows.add(errorRow);
                     }
                  }
               }
            }
         } catch (Throwable var25) {
            try {
               workbook.close();
            } catch (Throwable var24) {
               var25.addSuppressed(var24);
            }

            throw var25;
         }

         workbook.close();
      } catch (IOException exception) {
         throw new IllegalStateException("账号导入失败", exception);
      }

      Map<String, Object> payload = new LinkedHashMap<>();
      payload.put("total", total);
      payload.put("success", success);
      payload.put("failed", total - success);
      payload.put("created", created);
      payload.put("updated", updated);
      payload.put("errors", errors.size() > 20 ? errors.subList(0, 20) : errors);
      payload.put("errorRows", errorRows.size() > 200 ? errorRows.subList(0, 200) : errorRows);
      return payload;
   }

   public byte[] generateUserTemplate() {
      try {
         XSSFWorkbook workbook = new XSSFWorkbook();

         byte[] var5;
         try {
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

            try {
               XSSFSheet sheet = workbook.createSheet("users");
               Row header = sheet.createRow(0);
               header.createCell(0).setCellValue("username");
               header.createCell(1).setCellValue("phone");
               header.createCell(2).setCellValue("password");
               header.createCell(3).setCellValue("enabled(true/false)");
               header.createCell(4).setCellValue("avatar_url");
               header.createCell(5).setCellValue("role_code");
               Row demo = sheet.createRow(1);
               demo.createCell(0).setCellValue("student_demo_01");
               demo.createCell(1).setCellValue("18810000099");
               demo.createCell(2).setCellValue("123456");
               demo.createCell(3).setCellValue("true");
               demo.createCell(4).setCellValue("/static/img/user.svg");
               demo.createCell(5).setCellValue(CLIENT_ROLE_CODE);
               workbook.write(outputStream);
               var5 = outputStream.toByteArray();
            } catch (Throwable var8) {
               try {
                  outputStream.close();
               } catch (Throwable var7) {
                  var8.addSuppressed(var7);
               }

               throw var8;
            }

            outputStream.close();
         } catch (Throwable var9) {
            try {
               workbook.close();
            } catch (Throwable var6) {
               var9.addSuppressed(var6);
            }

            throw var9;
         }

         workbook.close();
         return var5;
      } catch (IOException exception) {
         throw new IllegalStateException("模板生成失败", exception);
      }
   }

   @Transactional
   public void deleteUser(Long userId, String operatorName) {
      User user = this.findUser(userId);
      boolean isSuperAdmin = user.getRoles().stream().anyMatch((role) -> "ROLE_SUPER_ADMIN".equals(role.getCode()));
      AssertUtils.isTrue(!isSuperAdmin, "超级管理员账号不能删除");
      Map<String, Object> usage = this.superSyncMapper.queryUserBizUsage(userId);
      int orderCount = this.asInt(usage.get("orderCount"));
      int reservationCount = this.asInt(usage.get("reservationCount"));
      int activitySignupCount = this.asInt(usage.get("activitySignupCount"));
      AssertUtils.isTrue(orderCount + reservationCount + activitySignupCount == 0, "该用户有关联订单/预约/报名数据，请改为停用账号");
      this.userMapper.deleteUserRoles(userId);
      this.userMapper.deleteUser(userId);
      String roleCode = user.getRoles().isEmpty() ? "-" : user.getRoles().get(0).getCode();
      this.writeAuditLog("DELETE_USER", user.getId(), user.getUsername(), roleCode, "SUCCESS", "删除账号成功", operatorName);
   }

   public List<SuperAuditLog> listAuditLogs(int limit) {
      int finalLimit = limit <= 0 ? 20 : Math.min(limit, 200);
      return this.superAuditLogMapper.listLatest(finalLimit);
   }

   public List<SuperAuditLog> listAuditLogs(String operationType, String operatorName, String actionResult, String startTime, String endTime, int limit) {
      int finalLimit = limit <= 0 ? 50 : Math.min(limit, 500);
      return this.superAuditLogMapper.listByFilter(operationType, operatorName, actionResult, startTime, endTime, finalLimit);
   }

   public PageResult pageAuditLogs(SuperAuditLogQuery query) {
      AssertUtils.notNull(query, "查询参数不能为空");
      int pageNum = query.getPageNum() <= 0 ? 1 : query.getPageNum();
      int pageSize = query.getPageSize() <= 0 ? 20 : Math.min(query.getPageSize(), 100);
      int offset = (pageNum - 1) * pageSize;
      long total = this.superAuditLogMapper.countByFilter(query.getOperationType(), query.getOperatorName(), query.getActionResult(), query.getStartTime(), query.getEndTime());
      List<SuperAuditLog> rows = this.superAuditLogMapper.pageByFilter(query.getOperationType(), query.getOperatorName(), query.getActionResult(), query.getStartTime(), query.getEndTime(), offset, pageSize);
      return new PageResult(total, rows);
   }

   public List<Map<String, Object>> queryAuditTrend(int days) {
      int finalDays = days <= 0 ? 7 : Math.min(days, 30);
      LocalDate startDate = LocalDate.now().minusDays((long)(finalDays - 1));
      List<Map<String, Object>> rows = this.superAuditLogMapper.queryDailyStats(startDate.toString());
      Map<String, Map<String, Object>> rowMap = new LinkedHashMap<>();

      for(Map<String, Object> row : rows) {
         Object dayObj = row.get("day");
         if (dayObj != null) {
            rowMap.put(String.valueOf(dayObj), row);
         }
      }

      List<Map<String, Object>> result = new ArrayList<>();

      for(int i = 0; i < finalDays; ++i) {
         LocalDate day = startDate.plusDays((long)i);
         String key = day.toString();
         Map<String, Object> row = rowMap.get(key);
         Map<String, Object> item = new LinkedHashMap<>();
         item.put("day", key);
         item.put("createCount", row == null ? 0 : this.asInt(row.get("createCount")));
         item.put("updateCount", row == null ? 0 : this.asInt(row.get("updateCount")));
         item.put("deleteCount", row == null ? 0 : this.asInt(row.get("deleteCount")));
         item.put("importCount", row == null ? 0 : this.asInt(row.get("importCount")));
         item.put("totalCount", row == null ? 0 : this.asInt(row.get("totalCount")));
         result.add(item);
      }

      return result;
   }

   public byte[] exportAuditLogs(String operationType, String operatorName, String actionResult, String startTime, String endTime, int limit) {
      List<SuperAuditLog> rows = this.listAuditLogs(operationType, operatorName, actionResult, startTime, endTime, limit);

      try {
         XSSFWorkbook workbook = new XSSFWorkbook();

         byte[] var12;
         try {
            XSSFSheet sheet = workbook.createSheet("audit_logs");
            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("id");
            header.createCell(1).setCellValue("operation_type");
            header.createCell(2).setCellValue("target_user_id");
            header.createCell(3).setCellValue("target_username");
            header.createCell(4).setCellValue("role_code");
            header.createCell(5).setCellValue("action_result");
            header.createCell(6).setCellValue("operator_name");
            header.createCell(7).setCellValue("detail");
            header.createCell(8).setCellValue("created_at");

            for(int i = 0; i < rows.size(); ++i) {
               SuperAuditLog log = rows.get(i);
               Row row = sheet.createRow(i + 1);
               row.createCell(0).setCellValue(String.valueOf(log.getId()));
               row.createCell(1).setCellValue(log.getOperationType() == null ? "" : log.getOperationType());
               row.createCell(2).setCellValue(log.getTargetUserId() == null ? "" : String.valueOf(log.getTargetUserId()));
               row.createCell(3).setCellValue(log.getTargetUsername() == null ? "" : log.getTargetUsername());
               row.createCell(4).setCellValue(log.getRoleCode() == null ? "" : log.getRoleCode());
               row.createCell(5).setCellValue(log.getActionResult() == null ? "" : log.getActionResult());
               row.createCell(6).setCellValue(log.getOperatorName() == null ? "" : log.getOperatorName());
               row.createCell(7).setCellValue(log.getDetail() == null ? "" : log.getDetail());
               row.createCell(8).setCellValue(log.getCreatedAt() == null ? "" : String.valueOf(log.getCreatedAt()));
            }

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

            try {
               workbook.write(outputStream);
               var12 = outputStream.toByteArray();
            } catch (Throwable var9) {
               try {
                  outputStream.close();
               } catch (Throwable var8) {
                  var9.addSuppressed(var8);
               }

               throw var9;
            }

            outputStream.close();
         } catch (Throwable var10) {
            try {
               workbook.close();
            } catch (Throwable var7) {
               var10.addSuppressed(var7);
            }

            throw var10;
         }

         workbook.close();
         return var12;
      } catch (IOException exception) {
         throw new IllegalStateException("审计日志导出失败", exception);
      }
   }

   private User saveUserInternal(SuperUserSaveRequest request, String operatorName, String operationType) {
      AssertUtils.notNull(request, "用户参数不能为空");
      AssertUtils.notBlank(request.getUsername(), "用户名不能为空");
      AssertUtils.notBlank(request.getPhone(), "手机号不能为空");
      AssertUtils.notBlank(request.getRoleCode(), "角色不能为空");
      AssertUtils.isTrue(MOBILE_PATTERN.matcher(request.getPhone()).matches(), "手机号格式不正确");
      Role role = this.userMapper.findRoleByCode(request.getRoleCode());
      AssertUtils.notNull(role, "角色不存在");
      User user;
      if (request.getId() == null) {
         this.assertUniqueUserFields(null, request.getUsername(), request.getPhone());
         AssertUtils.notBlank(request.getPassword(), "新增用户时密码不能为空");
         user = new User();
         user.setUsername(request.getUsername());
         user.setPhone(request.getPhone());
         user.setPassword(this.passwordEncoder.encode(request.getPassword()));
         user.setEnabled(request.getEnabled() == null ? Boolean.TRUE : request.getEnabled());
         user.setAvatarUrl(request.getAvatarUrl() == null || request.getAvatarUrl().isBlank() ? "/static/img/user.svg" : request.getAvatarUrl());
         this.userMapper.insertUser(user);
      } else {
         user = this.findUser(request.getId());
         this.assertUniqueUserFields(user.getId(), request.getUsername(), request.getPhone());
         user.setUsername(request.getUsername());
         user.setPhone(request.getPhone());
         user.setEnabled(request.getEnabled() == null ? Boolean.TRUE : request.getEnabled());
         user.setAvatarUrl(request.getAvatarUrl() == null || request.getAvatarUrl().isBlank() ? "/static/img/user.svg" : request.getAvatarUrl());
         if (request.getPassword() != null && !request.getPassword().isBlank()) {
            user.setPassword(this.passwordEncoder.encode(request.getPassword()));
         }

         this.userMapper.updateUser(user);
         this.userMapper.deleteUserRoles(user.getId());
      }

      this.userMapper.insertUserRole(user.getId(), role.getId());
      User saved = this.findUser(user.getId());
      this.writeAuditLog(operationType, saved.getId(), saved.getUsername(), role.getCode(), "SUCCESS", "账号保存成功", operatorName);
      return saved;
   }

   public Map<String, Object> buildSharedSyncData() {
      Map<String, Object> payload = new LinkedHashMap<>();
      payload.put("summary", this.superSyncMapper.querySharedSummary());
      payload.put("latestMerchants", this.superSyncMapper.queryLatestMerchants());
      payload.put("latestActivities", this.superSyncMapper.queryLatestActivities());
      payload.put("latestOrders", this.superSyncMapper.queryLatestOrders());
      payload.put("latestReservations", this.superSyncMapper.queryLatestReservations());
      payload.put("latestAuditLogs", this.listAuditLogs(20));
      payload.put("auditTrend", this.queryAuditTrend(7));
      return payload;
   }

   private void attachRoles(List<User> users) {
      for (User user : users) {
         user.setRoles(this.userMapper.findRolesByUserId(user.getId()));
      }
   }

   private void assertUniqueUserFields(Long currentUserId, String username, String phone) {
      User sameUsername = this.userMapper.findByUsername(username);
      AssertUtils.isTrue(sameUsername == null || sameUsername.getId().equals(currentUserId), "用户名已存在");
      User samePhone = this.userMapper.findByPhone(phone);
      AssertUtils.isTrue(samePhone == null || samePhone.getId().equals(currentUserId), "手机号已存在");
   }

   private int asInt(Object value) {
      if (value == null) {
         return 0;
      } else if (value instanceof Number number) {
         return number.intValue();
      } else {
         return Integer.parseInt(String.valueOf(value));
      }
   }

   private Boolean parseEnabled(String enabledText) {
      if (enabledText == null || enabledText.isBlank()) {
         return Boolean.TRUE;
      } else {
         String text = enabledText.trim().toLowerCase();
         if (!"true".equals(text) && !"false".equals(text) && !"1".equals(text) && !"0".equals(text)) {
            throw new IllegalStateException("enabled 字段只能是 true/false 或 1/0");
         } else {
            return "true".equals(text) || "1".equals(text);
         }
      }
   }

   private String readCell(DataFormatter formatter, Row row, int cellIndex) {
      if (row.getCell(cellIndex) == null) {
         return "";
      } else {
         return formatter.formatCellValue(row.getCell(cellIndex)).trim();
      }
   }

   private String normalizeRoleCode(String roleCode) {
      return roleCode != null && !roleCode.isBlank() ? roleCode.trim() : CLIENT_ROLE_CODE;
   }

   private void writeAuditLog(String operationType, Long targetUserId, String targetUsername, String roleCode, String actionResult, String detail, String operatorName) {
      SuperAuditLog log = new SuperAuditLog();
      log.setOperationType(operationType);
      log.setTargetUserId(targetUserId);
      log.setTargetUsername(targetUsername);
      log.setRoleCode(roleCode);
      log.setActionResult(actionResult);
      log.setDetail(detail);
      log.setOperatorName(operatorName == null || operatorName.isBlank() ? "unknown" : operatorName);
      this.superAuditLogMapper.insert(log);
   }
}
