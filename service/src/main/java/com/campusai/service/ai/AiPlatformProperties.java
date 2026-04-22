package com.campusai.service.ai;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(
   prefix = "app.ai"
)
public class AiPlatformProperties {
   private boolean enabled = false;
   private String provider = "qwen-compatible";
   private String apiKey = "";
   private String apiUrl = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions";
   private String model = "qwen-plus";
   private String systemPrompt = "你是智慧校园生活服务平台的AI助手，回答要简洁实用。";

   public boolean isEnabled() {
      return this.enabled;
   }

   public void setEnabled(boolean enabled) {
      this.enabled = enabled;
   }

   public String getProvider() {
      return this.provider;
   }

   public void setProvider(String provider) {
      this.provider = provider;
   }

   public String getApiKey() {
      return this.apiKey;
   }

   public void setApiKey(String apiKey) {
      this.apiKey = apiKey;
   }

   public String getApiUrl() {
      return this.apiUrl;
   }

   public void setApiUrl(String apiUrl) {
      this.apiUrl = apiUrl;
   }

   public String getModel() {
      return this.model;
   }

   public void setModel(String model) {
      this.model = model;
   }

   public String getSystemPrompt() {
      return this.systemPrompt;
   }

   public void setSystemPrompt(String systemPrompt) {
      this.systemPrompt = systemPrompt;
   }
}
