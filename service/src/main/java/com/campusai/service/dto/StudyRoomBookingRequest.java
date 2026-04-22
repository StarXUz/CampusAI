package com.campusai.service.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import java.time.LocalDate;
import java.time.LocalTime;

public class StudyRoomBookingRequest {
   private Long roomId;
   private Long seatId;
   private LocalDate reservationDate;
   private LocalTime startTime;
   private LocalTime endTime;

   public Long getRoomId() {
      return this.roomId;
   }

   @JsonAlias({"studyRoomId"})
   public void setRoomId(Long roomId) {
      this.roomId = roomId;
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
}
