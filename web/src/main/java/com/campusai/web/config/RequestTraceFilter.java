package com.campusai.web.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class RequestTraceFilter extends OncePerRequestFilter {
   public static final String TRACE_HEADER = "X-Request-Id";
   public static final String TRACE_ATTR = "requestTraceId";

   protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
      String traceId = request.getHeader(TRACE_HEADER);
      if (traceId == null || traceId.isBlank()) {
         traceId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
      }

      request.setAttribute(TRACE_ATTR, traceId);
      response.setHeader(TRACE_HEADER, traceId);
      filterChain.doFilter(request, response);
   }
}
