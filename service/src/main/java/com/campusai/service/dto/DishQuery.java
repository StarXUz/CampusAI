package com.campusai.service.dto;

public class DishQuery extends PageQuery {
   private Long categoryId;
   private Boolean includeSoldOut;
   private Boolean onSale;

   public Long getCategoryId() {
      return this.categoryId;
   }

   public void setCategoryId(Long categoryId) {
      this.categoryId = categoryId;
   }

   public Boolean getIncludeSoldOut() {
      return this.includeSoldOut;
   }

   public void setIncludeSoldOut(Boolean includeSoldOut) {
      this.includeSoldOut = includeSoldOut;
   }

   public Boolean getOnSale() {
      return this.onSale;
   }

   public void setOnSale(Boolean onSale) {
      this.onSale = onSale;
   }
}
