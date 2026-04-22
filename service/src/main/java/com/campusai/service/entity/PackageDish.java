package com.campusai.service.entity;

public class PackageDish {
   private Long packageId;
   private Long dishId;
   private Integer quantity;

   public Long getPackageId() {
      return this.packageId;
   }

   public void setPackageId(Long packageId) {
      this.packageId = packageId;
   }

   public Long getDishId() {
      return this.dishId;
   }

   public void setDishId(Long dishId) {
      this.dishId = dishId;
   }

   public Integer getQuantity() {
      return this.quantity;
   }

   public void setQuantity(Integer quantity) {
      this.quantity = quantity;
   }
}
