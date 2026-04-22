package com.campusai.common.util;

import com.campusai.common.exception.BusinessException;

public final class AssertUtils {
   private AssertUtils() {
   }

   public static void isTrue(boolean condition, String message) {
      if (!condition) {
         throw new BusinessException(message);
      }
   }

   public static void notBlank(String value, String message) {
      if (value == null || value.isBlank()) {
         throw new BusinessException(message);
      }
   }

   public static void notNull(Object value, String message) {
      if (value == null) {
         throw new BusinessException(message);
      }
   }
}
