package com.campusai.service.entity;

public class Merchant {
   private Long id;
   private String name;
   private String canteenName;
   private String logoUrl;
   private String contactPhone;
   private String auditStatus;
   private Boolean recommended;

   public Long getId() {
      return this.id;
   }

   public void setId(Long id) {
      this.id = id;
   }

   public String getName() {
      return this.name;
   }

   public void setName(String name) {
      this.name = name;
   }

   public String getCanteenName() {
      return this.canteenName;
   }

   public void setCanteenName(String canteenName) {
      this.canteenName = canteenName;
   }

   public String getLogoUrl() {
      return this.logoUrl;
   }

   public void setLogoUrl(String logoUrl) {
      this.logoUrl = logoUrl;
   }

   public String getContactPhone() {
      return this.contactPhone;
   }

   public void setContactPhone(String contactPhone) {
      this.contactPhone = contactPhone;
   }

   public String getAuditStatus() {
      return this.auditStatus;
   }

   public void setAuditStatus(String auditStatus) {
      this.auditStatus = auditStatus;
   }

   public Boolean getRecommended() {
      return this.recommended;
   }

   public void setRecommended(Boolean recommended) {
      this.recommended = recommended;
   }
}
