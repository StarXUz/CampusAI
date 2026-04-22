package com.campusai.service.entity;

public class ReservationRule {
   private Long id;
   private Long studyRoomId;
   private Integer maxHours;
   private Integer dailyLimit;
   private Integer cancelBeforeMinutes;
   private Boolean enabled;

   public Long getId() {
      return this.id;
   }

   public void setId(Long id) {
      this.id = id;
   }

   public Long getStudyRoomId() {
      return this.studyRoomId;
   }

   public void setStudyRoomId(Long studyRoomId) {
      this.studyRoomId = studyRoomId;
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

   public Integer getCancelBeforeMinutes() {
      return this.cancelBeforeMinutes;
   }

   public void setCancelBeforeMinutes(Integer cancelBeforeMinutes) {
      this.cancelBeforeMinutes = cancelBeforeMinutes;
   }

   public Boolean getEnabled() {
      return this.enabled;
   }

   public void setEnabled(Boolean enabled) {
      this.enabled = enabled;
   }
}
