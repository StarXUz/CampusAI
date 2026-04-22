package com.campusai.web.controller;

import com.campusai.web.config.ClientSessionSupport;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.ui.Model;

@Controller
public class PageController {
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

   @GetMapping({"/"})
   public String index(HttpServletRequest request) {
      int localPort = request.getLocalPort();
      if (localPort == 8092) {
         return "redirect:" + this.portalUrl("client", "/client");
      } else {
         return localPort == 8093 ? "redirect:" + this.portalUrl("super", "/super/overview") : "redirect:" + this.portalUrl("admin", "/admin/overview");
      }
   }

   @GetMapping({"/admin"})
   public String admin(HttpServletRequest request) {
      String redirect = this.ensurePortalOrigin("admin", request);
      return redirect != null ? redirect : "redirect:/admin/overview";
   }

   @GetMapping({"/admin/{page}"})
   public String adminPage(@PathVariable("page") String page, Model model, Authentication authentication, HttpServletRequest request) {
      String redirect = this.ensurePortalOrigin("admin", request);
      if (redirect != null) {
         return redirect;
      }
      this.bindPortalConfig(model);
      model.addAttribute("activeAdminPage", page);
      return "admin";
   }

   @GetMapping({"/super"})
   public String superRoot(HttpServletRequest request) {
      String redirect = this.ensurePortalOrigin("super", request);
      return redirect != null ? redirect : "redirect:/super/overview";
   }

   @GetMapping({"/super/{page}"})
   public String superPage(@PathVariable("page") String page, Model model, HttpServletRequest request) {
      String redirect = this.ensurePortalOrigin("super", request);
      if (redirect != null) {
         return redirect;
      }
      this.bindPortalConfig(model);
      model.addAttribute("activeSuperPage", page);
      return "super";
   }

   @GetMapping({"/client"})
   public String client(HttpServletRequest request, Model model) {
      String redirect = this.ensurePortalOrigin("client", request);
      if (redirect != null) {
         return redirect;
      }
      this.bindPortalConfig(model);
      return "client";
   }

   @GetMapping({"/favicon.ico"})
   public void favicon(HttpServletResponse response) throws IOException {
      response.setStatus(204);
   }

   @GetMapping({"/login"})
   public String login(Authentication authentication, HttpSession session, HttpServletRequest request, Model model) {
      return this.resolveLogin("admin", authentication, session, request, model);
   }

   @GetMapping({"/login/{portal}"})
   public String loginByPortal(@PathVariable("portal") String portal, Authentication authentication, HttpSession session, HttpServletRequest request, Model model) {
      String normalized = "super".equalsIgnoreCase(portal) ? "super" : ("client".equalsIgnoreCase(portal) ? "client" : "admin");
      return this.resolveLogin(normalized, authentication, session, request, model);
   }

   private String resolveLogin(String portal, Authentication authentication, HttpSession session, HttpServletRequest request, Model model) {
      if (request != null) {
         String currentHost = request.getServerName();
         int currentPort = request.getLocalPort();
         String expectedHost = this.resolvePortalHost(portal);
         int expectedPort = this.resolvePortalPort(portal);
         if (expectedPort > 0 && (currentPort != expectedPort || !this.normalizeHost(expectedHost).equalsIgnoreCase(this.normalizeHost(currentHost)))) {
            return "redirect:" + this.portalUrl(portal, "/login/" + portal);
         }
      }

      boolean authenticated = authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken);
      boolean superAdmin = authenticated && authentication.getAuthorities().stream().map(GrantedAuthority::getAuthority).anyMatch((authority) -> "ROLE_SUPER_ADMIN".equals(authority) || "SUPER_ADMIN".equals(authority));
      boolean clientLoggedIn = ClientSessionSupport.getCurrentUserId(session) != null;
      if ("client".equals(portal)) {
         if (clientLoggedIn) {
            return "redirect:" + this.portalUrl("client", "/client");
         }
      } else if ("super".equals(portal)) {
         if (superAdmin) {
            return "redirect:" + this.portalUrl("super", "/super/overview");
         }
      } else if (authenticated) {
         return "redirect:" + this.portalUrl("admin", "/admin/overview");
      }

      model.addAttribute("loginPortal", portal);
      this.bindPortalConfig(model);
      return "login";
   }

   private int resolvePortalPort(String portal) {
      if ("client".equals(portal)) {
         return this.clientPort;
      } else {
         return "super".equals(portal) ? this.superPort : this.adminPort;
      }
   }

   private String ensurePortalOrigin(String portal, HttpServletRequest request) {
      if (request == null) {
         return null;
      }

      String currentHost = request.getServerName();
      int currentPort = request.getLocalPort();
      String expectedHost = this.resolvePortalHost(portal);
      int expectedPort = this.resolvePortalPort(portal);
      if (expectedPort > 0 && (currentPort != expectedPort || !this.normalizeHost(expectedHost).equalsIgnoreCase(this.normalizeHost(currentHost)))) {
         String query = request.getQueryString();
         String path = request.getRequestURI();
         return "redirect:" + this.portalUrl(portal, path + (query == null || query.isBlank() ? "" : "?" + query));
      }

      return null;
   }

   private String resolvePortalHost(String portal) {
      if ("client".equals(portal)) {
         return this.clientHost;
      } else {
         return "super".equals(portal) ? this.superHost : this.adminHost;
      }
   }

   private String portalUrl(String portal, String path) {
      return "http://" + this.formatHostForUrl(this.resolvePortalHost(portal)) + ":" + this.resolvePortalPort(portal) + path;
   }

   private void bindPortalConfig(Model model) {
      model.addAttribute("adminHost", this.adminHost);
      model.addAttribute("clientHost", this.clientHost);
      model.addAttribute("superHost", this.superHost);
      model.addAttribute("adminPort", this.adminPort);
      model.addAttribute("clientPort", this.clientPort);
      model.addAttribute("superPort", this.superPort);
      model.addAttribute("adminBaseUrl", this.portalUrl("admin", ""));
      model.addAttribute("clientBaseUrl", this.portalUrl("client", ""));
      model.addAttribute("superBaseUrl", this.portalUrl("super", ""));
      model.addAttribute("adminOverviewUrl", this.portalUrl("admin", "/admin/overview"));
      model.addAttribute("clientHomeUrl", this.portalUrl("client", "/client"));
      model.addAttribute("superOverviewUrl", this.portalUrl("super", "/super/overview"));
      model.addAttribute("superClientsUrl", this.portalUrl("super", "/super/clients"));
      model.addAttribute("superAdminsUrl", this.portalUrl("super", "/super/admins"));
      model.addAttribute("adminLoginUrl", this.portalUrl("admin", "/login/admin"));
      model.addAttribute("clientLoginUrl", this.portalUrl("client", "/login/client"));
      model.addAttribute("superLoginUrl", this.portalUrl("super", "/login/super"));
   }

   private String formatHostForUrl(String value) {
      if (value == null || value.isBlank()) {
         return "127.0.0.1";
      }

      return value.contains(":") && !value.startsWith("[") ? "[" + value + "]" : value;
   }

   private String normalizeHost(String value) {
      if (value == null) {
         return "";
      }

      String normalized = value.replace("[", "").replace("]", "").trim();
      if ("0:0:0:0:0:0:0:1".equals(normalized)) {
         return "::1";
      }

      return normalized;
   }
}
