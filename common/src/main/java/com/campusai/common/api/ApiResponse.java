package com.campusai.common.api;

public class ApiResponse {
   private boolean success;
   private String message;
   private Object data;

   public ApiResponse() {
   }

   public ApiResponse(boolean success, String message, Object data) {
      this.success = success;
      this.message = message;
      this.data = data;
   }

   public static ApiResponse success(Object data) {
      return new ApiResponse(true, "操作成功", data);
   }

   public static ApiResponse success(String message, Object data) {
      return new ApiResponse(true, message, data);
   }

   public static ApiResponse failure(String message) {
      return new ApiResponse(false, message, (Object)null);
   }

   public boolean isSuccess() {
      return this.success;
   }

   public void setSuccess(boolean success) {
      this.success = success;
   }

   public String getMessage() {
      return this.message;
   }

   public void setMessage(String message) {
      this.message = message;
   }

   public Object getData() {
      return this.data;
   }

   public void setData(Object data) {
      this.data = data;
   }
}
