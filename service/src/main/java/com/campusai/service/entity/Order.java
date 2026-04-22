package com.campusai.service.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Order {
   private Long id;
   private Long userId;
   private Long merchantId;
   private String merchantName;
   private String itemType;
   private String itemName;
   private BigDecimal totalAmount;
   private String status;
   private String payChannel;
   private LocalDateTime paidAt;
   private LocalDateTime createdAt;

   public Long getId() {
      return this.id;
   }

   public void setId(Long id) {
      this.id = id;
   }

   public Long getUserId() {
      return this.userId;
   }

   public void setUserId(Long userId) {
      this.userId = userId;
   }

   public Long getMerchantId() {
      return this.merchantId;
   }

   public void setMerchantId(Long merchantId) {
      this.merchantId = merchantId;
   }

   public String getMerchantName() {
      return this.merchantName;
   }

   public void setMerchantName(String merchantName) {
      this.merchantName = merchantName;
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

   public String getStatus() {
      return this.status;
   }

   public void setStatus(String status) {
      this.status = status;
   }

   public String getPayChannel() {
      return this.payChannel;
   }

   public void setPayChannel(String payChannel) {
      this.payChannel = payChannel;
   }

   public LocalDateTime getPaidAt() {
      return this.paidAt;
   }

   public void setPaidAt(LocalDateTime paidAt) {
      this.paidAt = paidAt;
   }

   public LocalDateTime getCreatedAt() {
      return this.createdAt;
   }

   public void setCreatedAt(LocalDateTime createdAt) {
      this.createdAt = createdAt;
   }
}
