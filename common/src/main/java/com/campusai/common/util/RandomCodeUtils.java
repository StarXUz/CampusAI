package com.campusai.common.util;

import java.security.SecureRandom;

public final class RandomCodeUtils {
   private static final SecureRandom RANDOM = new SecureRandom();

   private RandomCodeUtils() {
   }

   public static String sixDigitCode() {
      int code = 100000 + RANDOM.nextInt(900000);
      return String.valueOf(code);
   }
}
