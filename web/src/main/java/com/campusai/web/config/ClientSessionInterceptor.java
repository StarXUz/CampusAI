package com.campusai.web.config;

import com.campusai.common.api.ApiResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class ClientSessionInterceptor implements HandlerInterceptor {
   private final ObjectMapper objectMapper;

   public ClientSessionInterceptor(ObjectMapper objectMapper) {
      this.objectMapper = objectMapper;
   }

   public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
      HttpSession session = request.getSession(false);
      if (ClientSessionSupport.getCurrentUserId(session) != null) {
         return true;
      } else if (request.getRequestURI().startsWith("/api/")) {
         response.setStatus(401);
         response.setCharacterEncoding("UTF-8");
         response.setContentType("application/json");
         response.getWriter().write(this.objectMapper.writeValueAsString(ApiResponse.failure("请先登录后再使用功能")));
         return false;
      } else {
         response.sendRedirect("/login/client?clientRequired=1");
         return false;
      }
   }
}
