package com.campusai.web.config;

import com.campusai.common.api.ApiResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.campusai.service.security.DatabaseUserDetailsService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AuthorizeHttpRequestsConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {
   @Value("${app.startup.host:127.0.0.1}")
   private String host;
   @Value("${app.startup.admin-host:${app.startup.host:127.0.0.1}}")
   private String adminHost;
   @Value("${app.startup.client-host:${app.startup.host:127.0.0.1}}")
   private String clientHost;
   @Value("${app.startup.super-host:${app.startup.host:127.0.0.1}}")
   private String superHost;
   @Value("${app.startup.admin-port:${server.port:8091}}")
   private int adminPort;
   @Value("${app.startup.client-port:8092}")
   private int clientPort;
   @Value("${app.startup.super-port:8093}")
   private int superPort;
   private final ObjectMapper objectMapper;

   public SecurityConfig(ObjectMapper objectMapper) {
      this.objectMapper = objectMapper;
   }

   @Bean
   public SecurityFilterChain securityFilterChain(HttpSecurity http, DatabaseUserDetailsService userDetailsService) throws Exception {
      http.csrf((csrf) -> csrf.disable()).authorizeHttpRequests((auth) -> ((AuthorizeHttpRequestsConfigurer.AuthorizedUrl)((AuthorizeHttpRequestsConfigurer.AuthorizedUrl)((AuthorizeHttpRequestsConfigurer.AuthorizedUrl)((AuthorizeHttpRequestsConfigurer.AuthorizedUrl)auth.requestMatchers(new String[]{"/", "/favicon.ico", "/login", "/login/**", "/static/**", "/uploads/**", "/generated-static/**", "/api/auth/**", "/client", "/api/client/**"})).permitAll().requestMatchers(new String[]{"/super/**", "/api/super/**"})).hasAuthority("ROLE_SUPER_ADMIN").requestMatchers(new String[]{"/admin", "/admin/**", "/api/admin/**"})).hasAnyAuthority(new String[]{"ROLE_SUPER_ADMIN", "ROLE_MERCHANT_ADMIN"}).anyRequest()).authenticated()).exceptionHandling((exception) -> exception.authenticationEntryPoint((request, response, authException) -> {
         String path = request.getRequestURI();
         if (path.startsWith("/api/")) {
            this.writeJsonError(request, response, 401, "未登录或登录已过期，请重新登录");
            return;
         }

         if (path.startsWith("/super") || path.startsWith("/api/super")) {
            response.sendRedirect(this.portalUrl("super", "/login/super"));
         } else if (path.startsWith("/admin") || path.startsWith("/api/admin")) {
            response.sendRedirect(this.portalUrl("admin", "/login/admin"));
         } else if (path.startsWith("/client")) {
            response.sendRedirect(this.portalUrl("client", "/login/client?clientRequired=1"));
         } else {
            response.sendRedirect(this.portalUrl("admin", "/login/admin"));
         }
      }).accessDeniedHandler((request, response, accessDeniedException) -> {
         String path = request.getRequestURI();
         if (path.startsWith("/api/")) {
            this.writeJsonError(request, response, 403, "无权限访问该资源");
         } else if (path.startsWith("/super") || path.startsWith("/api/super")) {
            response.sendRedirect(this.portalUrl("super", "/login/super"));
         } else {
            response.sendRedirect(this.portalUrl("admin", "/login/admin"));
         }
      })).formLogin((form) -> form.loginPage("/login/admin").loginProcessingUrl("/login").successHandler((request, response, authentication) -> {
         boolean superAdmin = authentication.getAuthorities().stream().anyMatch((authority) -> "ROLE_SUPER_ADMIN".equals(authority.getAuthority()) || "SUPER_ADMIN".equals(authority.getAuthority()));
         String targetPortal = request.getParameter("portalTarget");
         String target;
         if ("super".equalsIgnoreCase(targetPortal) && superAdmin) {
            target = this.portalUrl("super", "/super/overview");
         } else if ("admin".equalsIgnoreCase(targetPortal)) {
            target = this.portalUrl("admin", "/admin/overview");
         } else {
            target = superAdmin ? this.portalUrl("super", "/super/overview") : this.portalUrl("admin", "/admin/overview");
         }
         response.sendRedirect(target);
      }).permitAll()).logout((logout) -> logout.logoutSuccessHandler((request, response, authentication) -> {
         String targetPortal = request.getLocalPort() == this.superPort ? "super" : (request.getLocalPort() == this.clientPort ? "client" : "admin");
         String logoutPath = "client".equals(targetPortal) ? "/login/client?logout" : (("super".equals(targetPortal) ? "/login/super?logout" : "/login/admin?logout"));
         response.sendRedirect(this.portalUrl(targetPortal, logoutPath));
      }).permitAll()).rememberMe((remember) -> remember.userDetailsService(userDetailsService));
      return (SecurityFilterChain)http.build();
   }

   @Bean
   public PasswordEncoder passwordEncoder() {
      return new BCryptPasswordEncoder();
   }

   private String portalUrl(String portal, String path) {
      String resolvedPortal = "super".equalsIgnoreCase(portal) ? "super" : ("client".equalsIgnoreCase(portal) ? "client" : "admin");
      String resolvedHost = "super".equals(resolvedPortal) ? this.superHost : ("client".equals(resolvedPortal) ? this.clientHost : this.adminHost);
      int resolvedPort = "super".equals(resolvedPortal) ? this.superPort : ("client".equals(resolvedPortal) ? this.clientPort : this.adminPort);
      return "http://" + this.formatHostForUrl(resolvedHost == null || resolvedHost.isBlank() ? this.host : resolvedHost) + ":" + resolvedPort + path;
   }

   private String formatHostForUrl(String value) {
      if (value == null || value.isBlank()) {
         return this.host;
      }

      return value.contains(":") && !value.startsWith("[") ? "[" + value + "]" : value;
   }

   private void writeJsonError(HttpServletRequest request, HttpServletResponse response, int status, String message) {
      try {
         String traceId = null;
         if (request != null) {
            Object traceAttr = request.getAttribute(RequestTraceFilter.TRACE_ATTR);
            traceId = traceAttr == null ? null : String.valueOf(traceAttr);
         }

         if (traceId == null || traceId.isBlank()) {
            traceId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
         }

         response.setStatus(status);
         response.setCharacterEncoding("UTF-8");
         response.setContentType("application/json");
         response.setHeader(RequestTraceFilter.TRACE_HEADER, traceId);
         response.getWriter().write(this.objectMapper.writeValueAsString(ApiResponse.failure(message)));
      } catch (IOException var5) {
         throw new IllegalStateException("写入鉴权错误响应失败", var5);
      }
   }
}
