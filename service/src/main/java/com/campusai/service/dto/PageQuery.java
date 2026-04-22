package com.campusai.service.dto;

public class PageQuery {
   private int pageNum = 1;
   private int pageSize = 10;
   private String keyword;

   public int getPageNum() {
      return this.pageNum;
   }

   public void setPageNum(int pageNum) {
      this.pageNum = pageNum;
   }

   public int getPageSize() {
      return this.pageSize;
   }

   public void setPageSize(int pageSize) {
      this.pageSize = pageSize;
   }

   public String getKeyword() {
      return this.keyword;
   }

   public void setKeyword(String keyword) {
      this.keyword = keyword;
   }
}
