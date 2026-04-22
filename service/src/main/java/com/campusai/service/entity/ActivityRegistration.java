package com.campusai.service.entity;

import java.time.LocalDateTime;

public class ActivityRegistration {
   private Long id;
   private Long activityId;
   private Long userId;
   private String realName;
   private String studentNo;
   private String phone;
   private String status;
   private LocalDateTime registeredAt;

   public Long getId() {
      return this.id;
   }

   public void setId(Long id) {
      this.id = id;
   }

   public Long getActivityId() {
      return this.activityId;
   }

   public void setActivityId(Long activityId) {
      this.activityId = activityId;
   }

   public Long getUserId() {
      return this.userId;
   }

   public void setUserId(Long userId) {
      this.userId = userId;
   }

   public String getRealName() {
      return this.realName;
   }

   public void setRealName(String realName) {
      this.realName = realName;
   }

   public String getStudentNo() {
      return this.studentNo;
   }

   public void setStudentNo(String studentNo) {
      this.studentNo = studentNo;
   }

   public String getPhone() {
      return this.phone;
   }

   public void setPhone(String phone) {
      this.phone = phone;
   }

   public String getStatus() {
      return this.status;
   }

   public void setStatus(String status) {
      this.status = status;
   }

   public LocalDateTime getRegisteredAt() {
      return this.registeredAt;
   }

   public void setRegisteredAt(LocalDateTime registeredAt) {
      this.registeredAt = registeredAt;
   }
}
