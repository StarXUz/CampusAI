package com.campusai.web.controller;

import com.campusai.common.api.ApiResponse;
import com.campusai.service.dto.ClientProfileUpdateRequest;
import com.campusai.service.dto.LoginCodeRequest;
import com.campusai.service.dto.LoginRequest;
import com.campusai.service.entity.User;
import com.campusai.service.service.AuthService;
import com.campusai.web.config.ClientSessionSupport;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping({"/api/auth"})
public class AuthController {
   private final AuthService authService;
   private final Path uploadRoot;

   public AuthController(AuthService authService, @Value("${app.upload.dir:${user.dir}/runtime-uploads}") String uploadDir) {
      this.authService = authService;
      this.uploadRoot = Path.of(uploadDir).toAbsolutePath().normalize();
   }

   @PostMapping({"/send-code"})
   public ApiResponse sendCode(@RequestBody LoginCodeRequest request) {
      this.authService.sendLoginCode(request.getPhone());
      Map<String, Object> payload = new LinkedHashMap();
      payload.put("phone", request.getPhone());
      payload.put("expireInMinutes", 5);
      payload.put("delivery", "terminal");
      return ApiResponse.success("验证码已发送，请前往启动终端查看", payload);
   }

   @PostMapping({"/login"})
   public ApiResponse login(@RequestBody LoginRequest request, HttpSession session) {
      User user = this.authService.loginByCode(request);
      session.setAttribute("campusClientUserId", user.getId());
      return ApiResponse.success("登录成功", this.buildClientUserPayload(user));
   }

   @GetMapping({"/me"})
   public ApiResponse currentUser(HttpSession session) {
      Long userId = ClientSessionSupport.getCurrentUserId(session);
      return userId == null ? ApiResponse.failure("未登录") : ApiResponse.success(this.buildClientUserPayload(this.authService.getUserById(userId)));
   }

   @PostMapping({"/profile"})
   public ApiResponse updateProfile(@RequestBody ClientProfileUpdateRequest request, HttpSession session) {
      Long userId = ClientSessionSupport.getCurrentUserId(session);
      if (userId == null) {
         return ApiResponse.failure("未登录");
      } else {
         return ApiResponse.success("个人信息更新成功", this.buildClientUserPayload(this.authService.updateClientProfile(userId, request)));
      }
   }

   @PostMapping(
      value = {"/uploads/avatar"},
      consumes = {MediaType.MULTIPART_FORM_DATA_VALUE}
   )
   public ApiResponse uploadAvatar(@RequestPart("file") MultipartFile file, HttpSession session) throws IOException {
      Long userId = ClientSessionSupport.getCurrentUserId(session);
      if (userId == null) {
         return ApiResponse.failure("未登录");
      } else if (file.isEmpty()) {
         return ApiResponse.failure("请选择图片文件");
      } else {
         String contentType = file.getContentType();
         if (contentType == null || !contentType.startsWith("image/")) {
            return ApiResponse.failure("仅支持图片文件");
         } else {
            String extension = this.resolveExtension(file.getOriginalFilename(), contentType);
            Path targetDir = this.uploadRoot.resolve("avatar");
            Files.createDirectories(targetDir);
            String filename = "avatar-" + userId + "-" + UUID.randomUUID().toString().replace("-", "") + extension;
            Path targetFile = targetDir.resolve(filename);
            Files.copy(file.getInputStream(), targetFile, StandardCopyOption.REPLACE_EXISTING);
            Map<String, Object> payload = new LinkedHashMap();
            payload.put("url", "/uploads/avatar/" + filename);
            payload.put("name", filename);
            return ApiResponse.success("头像上传成功", payload);
         }
      }
   }

   @PostMapping({"/logout"})
   public ApiResponse logout(HttpSession session) {
      session.removeAttribute("campusClientUserId");
      return ApiResponse.success("已退出登录", (Object)null);
   }

   private Map buildClientUserPayload(User user) {
      Map<String, Object> payload = new LinkedHashMap();
      payload.put("id", user.getId());
      payload.put("username", user.getUsername());
      payload.put("phone", user.getPhone());
      payload.put("avatarUrl", user.getAvatarUrl());
      return payload;
   }

   private String resolveExtension(String originalFilename, String contentType) {
      if (originalFilename != null) {
         int dotIndex = originalFilename.lastIndexOf(46);
         if (dotIndex >= 0 && dotIndex < originalFilename.length() - 1) {
            return originalFilename.substring(dotIndex).toLowerCase();
         }
      }

      if ("image/png".equalsIgnoreCase(contentType)) {
         return ".png";
      } else if ("image/webp".equalsIgnoreCase(contentType)) {
         return ".webp";
      } else if ("image/gif".equalsIgnoreCase(contentType)) {
         return ".gif";
      } else {
         return ".jpg";
      }
   }
}
