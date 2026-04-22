package com.campusai.service.dto;

public class ClientProfileUpdateRequest {
   private String username;
   private String phone;
   private String avatarUrl;

   public String getUsername() {
      return this.username;
   }

   public void setUsername(String username) {
      this.username = username;
   }

   public String getPhone() {
      return this.phone;
   }

   public void setPhone(String phone) {
      this.phone = phone;
   }

   public String getAvatarUrl() {
      return this.avatarUrl;
   }

   public void setAvatarUrl(String avatarUrl) {
      this.avatarUrl = avatarUrl;
   }
}
