package com.campusai.service.entity;

import java.time.LocalTime;

public class StudyRoom {
   private Long id;
   private String name;
   private String location;
   private LocalTime openTime;
   private LocalTime closeTime;
   private Integer maxHours;
   private Integer dailyLimit;

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

   public String getLocation() {
      return this.location;
   }

   public void setLocation(String location) {
      this.location = location;
   }

   public LocalTime getOpenTime() {
      return this.openTime;
   }

   public void setOpenTime(LocalTime openTime) {
      this.openTime = openTime;
   }

   public LocalTime getCloseTime() {
      return this.closeTime;
   }

   public void setCloseTime(LocalTime closeTime) {
      this.closeTime = closeTime;
   }

   public Integer getMaxHours() {
      return this.maxHours;
   }

   public void setMaxHours(Integer maxHours) {
      this.maxHours = maxHours;
   }

   public Integer getDailyLimit() {
      return this.dailyLimit;
   }

   public void setDailyLimit(Integer dailyLimit) {
      this.dailyLimit = dailyLimit;
   }
}
