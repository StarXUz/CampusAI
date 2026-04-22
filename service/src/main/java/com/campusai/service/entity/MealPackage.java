package com.campusai.service.entity;

import java.math.BigDecimal;

public class MealPackage {
   private Long id;
   private Long merchantId;
   private String name;
   private String theme;
   private String status;
   private BigDecimal price;
   private String description;

   public Long getId() {
      return this.id;
   }

   public void setId(Long id) {
      this.id = id;
   }

   public Long getMerchantId() {
      return this.merchantId;
   }

   public void setMerchantId(Long merchantId) {
      this.merchantId = merchantId;
   }

   public String getName() {
      return this.name;
   }

   public void setName(String name) {
      this.name = name;
   }

   public String getTheme() {
      return this.theme;
   }

   public void setTheme(String theme) {
      this.theme = theme;
   }

   public String getStatus() {
      return this.status;
   }

   public void setStatus(String status) {
      this.status = status;
   }

   public BigDecimal getPrice() {
      return this.price;
   }

   public void setPrice(BigDecimal price) {
      this.price = price;
   }

   public String getDescription() {
      return this.description;
   }

   public void setDescription(String description) {
      this.description = description;
   }
}
