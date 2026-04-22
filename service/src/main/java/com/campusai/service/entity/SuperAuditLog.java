package com.campusai.service.entity;

import java.time.LocalDateTime;

public class SuperAuditLog {
   private Long id;
   private String operationType;
   private Long targetUserId;
   private String targetUsername;
   private String roleCode;
   private String actionResult;
   private String detail;
   private String operatorName;
   private LocalDateTime createdAt;

   public Long getId() {
      return this.id;
   }

   public void setId(Long id) {
      this.id = id;
   }

   public String getOperationType() {
      return this.operationType;
   }

   public void setOperationType(String operationType) {
      this.operationType = operationType;
   }

   public Long getTargetUserId() {
      return this.targetUserId;
   }

   public void setTargetUserId(Long targetUserId) {
      this.targetUserId = targetUserId;
   }

   public String getTargetUsername() {
      return this.targetUsername;
   }

   public void setTargetUsername(String targetUsername) {
      this.targetUsername = targetUsername;
   }

   public String getRoleCode() {
      return this.roleCode;
   }

   public void setRoleCode(String roleCode) {
      this.roleCode = roleCode;
   }

   public String getActionResult() {
      return this.actionResult;
   }

   public void setActionResult(String actionResult) {
      this.actionResult = actionResult;
   }

   public String getDetail() {
      return this.detail;
   }

   public void setDetail(String detail) {
      this.detail = detail;
   }

   public String getOperatorName() {
      return this.operatorName;
   }

   public void setOperatorName(String operatorName) {
      this.operatorName = operatorName;
   }

   public LocalDateTime getCreatedAt() {
      return this.createdAt;
   }

   public void setCreatedAt(LocalDateTime createdAt) {
      this.createdAt = createdAt;
   }
}
