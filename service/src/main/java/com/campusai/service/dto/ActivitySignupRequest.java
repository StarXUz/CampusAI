package com.campusai.service.dto;

import com.fasterxml.jackson.annotation.JsonAlias;

public class ActivitySignupRequest {
   private Long activityId;
   private String realName;
   private String studentNo;
   private String phone;

   public Long getActivityId() {
      return this.activityId;
   }

   public void setActivityId(Long activityId) {
      this.activityId = activityId;
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

   @JsonAlias({"contactPhone"})
   public void setPhone(String phone) {
      this.phone = phone;
   }
}
