package com.campusai.service.entity;

public class DishCategory {
   private Long id;
   private Long merchantId;
   private String name;
   private Integer sortOrder;

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

   public Integer getSortOrder() {
      return this.sortOrder;
   }

   public void setSortOrder(Integer sortOrder) {
      this.sortOrder = sortOrder;
   }
}
