package com.campusai.common.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public final class TimeUtils {
   private static final DateTimeFormatter DEFAULT_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

   private TimeUtils() {
   }

   public static String format(LocalDateTime time) {
      return time == null ? null : time.format(DEFAULT_FORMATTER);
   }
}
