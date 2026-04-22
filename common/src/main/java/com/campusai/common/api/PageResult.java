package com.campusai.common.api;

import java.util.List;

public class PageResult {
   private long total;
   private List records;

   public PageResult() {
   }

   public PageResult(long total, List records) {
      this.total = total;
      this.records = records;
   }

   public long getTotal() {
      return this.total;
   }

   public void setTotal(long total) {
      this.total = total;
   }

   public List getRecords() {
      return this.records;
   }

   public void setRecords(List records) {
      this.records = records;
   }
}
