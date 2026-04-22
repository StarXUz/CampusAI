package com.campusai.service.service;

import com.campusai.common.api.PageResult;
import com.campusai.service.dto.AdminAuditLogQuery;
import com.campusai.service.entity.AdminAuditLog;
import com.campusai.service.mapper.AdminAuditLogMapper;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class AdminAuditLogService {
   private final AdminAuditLogMapper adminAuditLogMapper;

   public AdminAuditLogService(AdminAuditLogMapper adminAuditLogMapper) {
      this.adminAuditLogMapper = adminAuditLogMapper;
      this.adminAuditLogMapper.ensureTable();
   }

   public void logSuccess(String module, String action, Long targetId, String targetName, String detail, String operatorName) {
      AdminAuditLog log = new AdminAuditLog();
      log.setModule(module);
      log.setAction(action);
      log.setTargetId(targetId);
      log.setTargetName(targetName);
      log.setActionResult("SUCCESS");
      log.setDetail(detail);
      log.setOperatorName(operatorName);
      this.adminAuditLogMapper.insert(log);
   }

   public PageResult page(AdminAuditLogQuery query) {
      int pageNum = query != null && query.getPageNum() > 0 ? query.getPageNum() : 1;
      int pageSize = query != null && query.getPageSize() > 0 ? query.getPageSize() : 20;
      int offset = (pageNum - 1) * pageSize;
      String module = query == null ? null : query.getModule();
      String action = query == null ? null : query.getAction();
      String actionResult = query == null ? null : query.getActionResult();
      String operatorName = query == null ? null : query.getOperatorName();
      String startTime = query == null ? null : query.getStartTime();
      String endTime = query == null ? null : query.getEndTime();
      long total = this.adminAuditLogMapper.countByFilter(module, action, actionResult, operatorName, startTime, endTime);
      List<AdminAuditLog> rows = this.adminAuditLogMapper.pageByFilter(module, action, actionResult, operatorName, startTime, endTime, offset, pageSize);
      return new PageResult(total, rows);
   }
}
