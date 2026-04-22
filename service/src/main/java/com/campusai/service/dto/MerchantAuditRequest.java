package com.campusai.service.dto;

public class MerchantAuditRequest {
   private Long merchantId;
   private String auditStatus;

   public Long getMerchantId() {
      return this.merchantId;
   }

   public void setMerchantId(Long merchantId) {
      this.merchantId = merchantId;
   }

   public String getAuditStatus() {
      return this.auditStatus;
   }

   public void setAuditStatus(String auditStatus) {
      this.auditStatus = auditStatus;
   }
}
