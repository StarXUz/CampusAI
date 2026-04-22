package com.campusai.service.dto;

public class AdminAuditLogQuery extends PageQuery {
   private String module;
   private String action;
   private String actionResult;
   private String operatorName;
   private String startTime;
   private String endTime;

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

   public String getActionResult() {
      return this.actionResult;
   }

   public void setActionResult(String actionResult) {
      this.actionResult = actionResult;
   }

   public String getOperatorName() {
      return this.operatorName;
   }

   public void setOperatorName(String operatorName) {
      this.operatorName = operatorName;
   }

   public String getStartTime() {
      return this.startTime;
   }

   public void setStartTime(String startTime) {
      this.startTime = startTime;
   }

   public String getEndTime() {
      return this.endTime;
   }

   public void setEndTime(String endTime) {
      this.endTime = endTime;
   }
}
