package com.campusai.service.entity;

import java.time.LocalDateTime;
import java.util.List;

public class User {
   private Long id;
   private String username;
   private String phone;
   private String password;
   private Boolean enabled;
   private String avatarUrl;
   private LocalDateTime createdAt;
   private List<Role> roles;

   public Long getId() {
      return this.id;
   }

   public void setId(Long id) {
      this.id = id;
   }

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

   public String getPassword() {
      return this.password;
   }

   public void setPassword(String password) {
      this.password = password;
   }

   public Boolean getEnabled() {
      return this.enabled;
   }

   public void setEnabled(Boolean enabled) {
      this.enabled = enabled;
   }

   public String getAvatarUrl() {
      return this.avatarUrl;
   }

   public void setAvatarUrl(String avatarUrl) {
      this.avatarUrl = avatarUrl;
   }

   public LocalDateTime getCreatedAt() {
      return this.createdAt;
   }

   public void setCreatedAt(LocalDateTime createdAt) {
      this.createdAt = createdAt;
   }

   public List<Role> getRoles() {
      return this.roles;
   }

   public void setRoles(List<Role> roles) {
      this.roles = roles;
   }
}
