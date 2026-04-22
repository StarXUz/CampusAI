package com.campusai.service.ai;

import com.campusai.common.util.AssertUtils;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;
import java.time.Duration;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import org.springframework.stereotype.Component;

@Component
public class OpenAiCompatibleAiChatClient implements AiChatClient {
   private final AiPlatformProperties properties;
   private final ObjectMapper objectMapper;
   private final HttpClient httpClient;

   public OpenAiCompatibleAiChatClient(AiPlatformProperties properties) {
      this.properties = properties;
      this.objectMapper = new ObjectMapper();
      this.httpClient = HttpClient.newBuilder().connectTimeout(Duration.ofSeconds(10L)).build();
   }

   public String ask(String scene, String question) {
      AssertUtils.notBlank(question, "问题不能为空");
      if (this.properties.isEnabled() && this.properties.getApiKey() != null && !this.properties.getApiKey().isBlank()) {
         try {
            String payload = this.buildPayload(scene, question);
            HttpRequest request = HttpRequest.newBuilder(URI.create(this.properties.getApiUrl())).timeout(Duration.ofSeconds(30L)).header("Authorization", "Bearer " + this.properties.getApiKey()).header("Content-Type", "application/json").POST(BodyPublishers.ofString(payload)).build();
            HttpResponse<String> response = this.httpClient.send(request, BodyHandlers.ofString());
            return this.parseAnswer((String)response.body());
         } catch (IOException exception) {
            return "AI 服务调用失败：" + exception.getMessage();
         } catch (InterruptedException var7) {
            Thread.currentThread().interrupt();
            return "AI 服务调用被中断，请稍后重试。";
         }
      } else {
         return this.buildLocalAnswer(scene, question);
      }
   }

   private String parseAnswer(String responseBody) throws IOException {
      JsonNode root = this.objectMapper.readTree(responseBody);
      JsonNode contentNode = root.path("choices").path(0).path("message").path("content");
      if (!contentNode.isMissingNode() && !contentNode.isNull()) {
         return contentNode.asText();
      } else {
         JsonNode errorNode = root.path("error").path("message");
         return !errorNode.isMissingNode() && !errorNode.isNull() ? "AI 服务返回错误：" + errorNode.asText() : responseBody;
      }
   }

   private String buildPayload(String scene, String question) throws IOException {
      ObjectNode root = this.objectMapper.createObjectNode();
      root.put("model", this.properties.getModel());
      ArrayNode messages = root.putArray("messages");
      ObjectNode systemMessage = messages.addObject();
      systemMessage.put("role", "system");
      systemMessage.put("content", this.properties.getSystemPrompt());
      ObjectNode userMessage = messages.addObject();
      userMessage.put("role", "user");
      userMessage.put("content", "场景：" + (scene == null ? "" : scene) + "\n问题：" + question);
      return this.objectMapper.writeValueAsString(root);
   }

   private String buildLocalAnswer(String scene, String prompt) {
      String context = this.extractBetween(prompt, "实时业务数据上下文：", "用户问题：");
      String userQuestion = this.extractAfter(prompt, "用户问题：");
      if (context.isBlank()) {
         return "当前未连接外部 AI，且未找到可用上下文数据。";
      }

      List<String> contextLines = this.splitLines(context);
      List<String> matched = this.matchLines(contextLines, userQuestion);
      if (matched.isEmpty()) {
         matched = this.pickFirstDataLines(contextLines, 8);
      }

      StringBuilder builder = new StringBuilder();
      builder.append("当前处于本地智能模式（未连接外部 AI），以下回答基于数据库实时数据：\n");
      if (scene != null && !scene.isBlank()) {
         builder.append("场景：").append(scene).append("\n");
      }

      builder.append("问题：").append(userQuestion.isBlank() ? "未提供具体问题" : userQuestion).append("\n");
      builder.append("可参考信息：\n");
      matched.forEach((line) -> builder.append("- ").append(line).append("\n"));
      builder.append("如需更精准问答，可在后台配置 AI 平台参数后启用外部模型。");
      return builder.toString();
   }

   private String extractBetween(String text, String startToken, String endToken) {
      String source = text == null ? "" : text;
      int start = source.indexOf(startToken);
      if (start < 0) {
         return "";
      }

      int from = start + startToken.length();
      int end = source.indexOf(endToken, from);
      if (end < 0) {
         end = source.length();
      }

      return source.substring(from, end).trim();
   }

   private String extractAfter(String text, String token) {
      String source = text == null ? "" : text;
      int index = source.indexOf(token);
      if (index < 0) {
         return "";
      } else {
         return source.substring(index + token.length()).trim();
      }
   }

   private List<String> splitLines(String text) {
      List<String> lines = new ArrayList<>();
      String[] var3 = text.split("\\r?\\n");
      int var4 = var3.length;

      for(int var5 = 0; var5 < var4; ++var5) {
         String raw = var3[var5];
         String line = raw == null ? "" : raw.trim();
         if (!line.isEmpty() && !line.startsWith("【")) {
            lines.add(line.startsWith("-") ? line.substring(1).trim() : line);
         }
      }

      return lines;
   }

   private List<String> matchLines(List<String> contextLines, String question) {
      Set<String> keywords = this.extractKeywords(question);
      List<String> matched = new ArrayList<>();
      if (keywords.isEmpty()) {
         return matched;
      } else {
         for(String line : contextLines) {
            String text = line.toLowerCase(Locale.ROOT);
            for(String keyword : keywords) {
               if (text.contains(keyword)) {
                  matched.add(line);
                  break;
               }
            }
         }

         return matched.size() > 8 ? matched.subList(0, 8) : matched;
      }
   }

   private Set<String> extractKeywords(String question) {
      Set<String> tokens = new LinkedHashSet<>();
      String source = question == null ? "" : question.toLowerCase(Locale.ROOT);
      String[] var4 = source.split("[^0-9a-zA-Z\\u4e00-\\u9fa5]+");
      int var5 = var4.length;

      for(int var6 = 0; var6 < var5; ++var6) {
         String token = var4[var6];
         if (token.length() >= 2 && !"当前".equals(token) && !"数据".equals(token) && !"信息".equals(token)) {
            tokens.add(token);
         }
      }

      return tokens;
   }

   private List<String> pickFirstDataLines(List<String> contextLines, int limit) {
      List<String> picked = new ArrayList<>();

      for(String line : contextLines) {
         picked.add(line);
         if (picked.size() >= limit) {
            break;
         }
      }

      return picked;
   }
}
