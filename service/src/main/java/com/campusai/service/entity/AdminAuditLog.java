package com.campusai.service.entity;

import java.time.LocalDateTime;

public class AdminAuditLog {
   private Long id;
   private String module;
   private String action;
   private Long targetId;
   private String targetName;
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

   public String getModule() {
      return this.module;
   }

   public void setModule(String module) {
      this.module = module;
   }

   public String getAction() {
      return this.action;
   }

   public void setAction(String action) {
      this.action = action;
   }

   public Long getTargetId() {
      return this.targetId;
   }

   public void setTargetId(Long targetId) {
      this.targetId = targetId;
   }

   public String getTargetName() {
      return this.targetName;
   }

   public void setTargetName(String targetName) {
      this.targetName = targetName;
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
