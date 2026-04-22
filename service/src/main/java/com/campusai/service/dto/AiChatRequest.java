package com.campusai.service.dto;

public class AiChatRequest {
   private String scene;
   private String question;

   public String getScene() {
      return this.scene;
   }

   public void setScene(String scene) {
      this.scene = scene;
   }

   public String getQuestion() {
      return this.question;
   }

   public void setQuestion(String question) {
      this.question = question;
   }
}
