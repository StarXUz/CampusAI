package com.campusai.web.config;

import jakarta.servlet.http.HttpSession;

public final class ClientSessionSupport {
   public static final String CLIENT_USER_ID = "campusClientUserId";

   private ClientSessionSupport() {
   }

   public static Long getCurrentUserId(HttpSession session) {
      if (session == null) {
         return null;
      } else {
         Object value = session.getAttribute("campusClientUserId");
         if (value instanceof Long) {
            Long longValue = (Long)value;
            return longValue;
         } else if (value instanceof Number) {
            Number numberValue = (Number)value;
            return numberValue.longValue();
         } else {
            return null;
         }
      }
   }
}
