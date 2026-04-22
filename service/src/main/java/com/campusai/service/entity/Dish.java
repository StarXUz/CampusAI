package com.campusai.service.entity;

import java.math.BigDecimal;

public class Dish {
   private Long id;
   private Long merchantId;
   private Long categoryId;
   private String name;
   private String description;
   private BigDecimal price;
   private String imageUrl;
   private Boolean onSale;
   private Integer calories;

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

   public Long getCategoryId() {
      return this.categoryId;
   }

   public void setCategoryId(Long categoryId) {
      this.categoryId = categoryId;
   }

   public String getName() {
      return this.name;
   }

   public void setName(String name) {
      this.name = name;
   }

   public String getDescription() {
      return this.description;
   }

   public void setDescription(String description) {
      this.description = description;
   }

   public BigDecimal getPrice() {
      return this.price;
   }

   public void setPrice(BigDecimal price) {
      this.price = price;
   }

   public String getImageUrl() {
      return this.imageUrl;
   }

   public void setImageUrl(String imageUrl) {
      this.imageUrl = imageUrl;
   }

   public Boolean getOnSale() {
      return this.onSale;
   }

   public void setOnSale(Boolean onSale) {
      this.onSale = onSale;
   }

   public Integer getCalories() {
      return this.calories;
   }

   public void setCalories(Integer calories) {
      this.calories = calories;
   }
}
