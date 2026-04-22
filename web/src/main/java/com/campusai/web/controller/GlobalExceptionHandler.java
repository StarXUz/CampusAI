package com.campusai.web.controller;

import com.campusai.common.api.ApiResponse;
import com.campusai.common.exception.BusinessException;
import com.campusai.web.config.RequestTraceFilter;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
   private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

   @ExceptionHandler({BusinessException.class})
   public ResponseEntity<ApiResponse> handleBusinessException(BusinessException exception, HttpServletRequest request) {
      String traceId = this.extractTraceId(request);
      log.warn("业务异常 traceId={} uri={} message={}", traceId, request.getRequestURI(), exception.getMessage());
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.failure(exception.getMessage()));
   }

   @ExceptionHandler({Exception.class})
   public ResponseEntity<ApiResponse> handleException(Exception exception, HttpServletRequest request) {
      String traceId = this.extractTraceId(request);
      log.error("系统异常 traceId={} uri={}", traceId, request.getRequestURI(), exception);
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ApiResponse.failure("系统异常，请联系管理员（追踪ID: " + traceId + "）"));
   }

   private String extractTraceId(HttpServletRequest request) {
      if (request == null) {
         return "-";
      } else {
         Object trace = request.getAttribute(RequestTraceFilter.TRACE_ATTR);
         return trace == null ? "-" : String.valueOf(trace);
      }
   }
}
