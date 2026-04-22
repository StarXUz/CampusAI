package com.campusai.service.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class ReservationRecord {
   private Long id;
   private Long userId;
   private Long studyRoomId;
   private Long seatId;
   private LocalDate reservationDate;
   private LocalTime startTime;
   private LocalTime endTime;
   private String status;
   private String voucherCode;
   private LocalDateTime createdAt;
   private Integer rescheduleCount;
   private String studyRoomName;
   private String seatCode;

   public Long getId() {
      return this.id;
   }

   public void setId(Long id) {
      this.id = id;
   }

   public Long getUserId() {
      return this.userId;
   }

   public void setUserId(Long userId) {
      this.userId = userId;
   }

   public Long getStudyRoomId() {
      return this.studyRoomId;
   }

   public void setStudyRoomId(Long studyRoomId) {
      this.studyRoomId = studyRoomId;
   }

   public Long getSeatId() {
      return this.seatId;
   }

   public void setSeatId(Long seatId) {
      this.seatId = seatId;
   }

   public LocalDate getReservationDate() {
      return this.reservationDate;
   }

   public void setReservationDate(LocalDate reservationDate) {
      this.reservationDate = reservationDate;
   }

   public LocalTime getStartTime() {
      return this.startTime;
   }

   public void setStartTime(LocalTime startTime) {
      this.startTime = startTime;
   }

   public LocalTime getEndTime() {
      return this.endTime;
   }

   public void setEndTime(LocalTime endTime) {
      this.endTime = endTime;
   }

   public String getStatus() {
      return this.status;
   }

   public void setStatus(String status) {
      this.status = status;
   }

   public String getVoucherCode() {
      return this.voucherCode;
   }

   public void setVoucherCode(String voucherCode) {
      this.voucherCode = voucherCode;
   }

   public LocalDateTime getCreatedAt() {
      return this.createdAt;
   }

   public void setCreatedAt(LocalDateTime createdAt) {
      this.createdAt = createdAt;
   }

   public Integer getRescheduleCount() {
      return this.rescheduleCount;
   }

   public void setRescheduleCount(Integer rescheduleCount) {
      this.rescheduleCount = rescheduleCount;
   }

   public String getStudyRoomName() {
      return this.studyRoomName;
   }

   public void setStudyRoomName(String studyRoomName) {
      this.studyRoomName = studyRoomName;
   }

   public String getSeatCode() {
      return this.seatCode;
   }

   public void setSeatCode(String seatCode) {
      this.seatCode = seatCode;
   }
}
