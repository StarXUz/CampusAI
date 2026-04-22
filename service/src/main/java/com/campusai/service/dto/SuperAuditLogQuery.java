package com.campusai.service.dto;

public class SuperAuditLogQuery extends PageQuery {
   private String operationType;
   private String operatorName;
   private String actionResult;
   private String startTime;
   private String endTime;

   public String getOperationType() {
      return this.operationType;
   }

   public void setOperationType(String operationType) {
      this.operationType = operationType;
   }

   public String getOperatorName() {
      return this.operatorName;
   }

   public void setOperatorName(String operatorName) {
      this.operatorName = operatorName;
   }

   public String getActionResult() {
      return this.actionResult;
   }

   public void setActionResult(String actionResult) {
      this.actionResult = actionResult;
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
