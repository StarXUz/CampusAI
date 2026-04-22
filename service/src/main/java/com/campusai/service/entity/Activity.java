package com.campusai.service.entity;

import java.time.LocalDateTime;

public class Activity {
   private Long id;
   private String title;
   private String summary;
   private String location;
   private String posterUrl;
   private LocalDateTime startTime;
   private LocalDateTime endTime;
   private Integer maxParticipants;
   private String status;

   public Long getId() {
      return this.id;
   }

   public void setId(Long id) {
      this.id = id;
   }

   public String getTitle() {
      return this.title;
   }

   public void setTitle(String title) {
      this.title = title;
   }

   public String getSummary() {
      return this.summary;
   }

   public void setSummary(String summary) {
      this.summary = summary;
   }

   public String getLocation() {
      return this.location;
   }

   public void setLocation(String location) {
      this.location = location;
   }

   public String getPosterUrl() {
      return this.posterUrl;
   }

   public void setPosterUrl(String posterUrl) {
      this.posterUrl = posterUrl;
   }

   public LocalDateTime getStartTime() {
      return this.startTime;
   }

   public void setStartTime(LocalDateTime startTime) {
      this.startTime = startTime;
   }

   public LocalDateTime getEndTime() {
      return this.endTime;
   }

   public void setEndTime(LocalDateTime endTime) {
      this.endTime = endTime;
   }

   public Integer getMaxParticipants() {
      return this.maxParticipants;
   }

   public void setMaxParticipants(Integer maxParticipants) {
      this.maxParticipants = maxParticipants;
   }

   public String getStatus() {
      return this.status;
   }

   public void setStatus(String status) {
      this.status = status;
   }
}
