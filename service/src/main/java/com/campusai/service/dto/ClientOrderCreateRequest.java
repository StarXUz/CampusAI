package com.campusai.service.dto;

import java.math.BigDecimal;

public class ClientOrderCreateRequest {
   private Long merchantId;
   private String itemType;
   private String itemName;
   private BigDecimal totalAmount;

   public Long getMerchantId() {
      return this.merchantId;
   }

   public void setMerchantId(Long merchantId) {
      this.merchantId = merchantId;
   }

   public String getItemType() {
      return this.itemType;
   }

   public void setItemType(String itemType) {
      this.itemType = itemType;
   }

   public String getItemName() {
      return this.itemName;
   }

   public void setItemName(String itemName) {
      this.itemName = itemName;
   }

   public BigDecimal getTotalAmount() {
      return this.totalAmount;
   }

   public void setTotalAmount(BigDecimal totalAmount) {
      this.totalAmount = totalAmount;
   }
}
