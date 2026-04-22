package com.campusai.service.entity;

public class Seat {
   private Long id;
   private Long studyRoomId;
   private String seatCode;
   private Integer floorNo;
   private String zoneName;
   private String status;

   public Long getId() {
      return this.id;
   }

   public void setId(Long id) {
      this.id = id;
   }

   public Long getStudyRoomId() {
      return this.studyRoomId;
   }

   public void setStudyRoomId(Long studyRoomId) {
      this.studyRoomId = studyRoomId;
   }

   public String getSeatCode() {
      return this.seatCode;
   }

   public void setSeatCode(String seatCode) {
      this.seatCode = seatCode;
   }

   public Integer getFloorNo() {
      return this.floorNo;
   }

   public void setFloorNo(Integer floorNo) {
      this.floorNo = floorNo;
   }

   public String getZoneName() {
      return this.zoneName;
   }

   public void setZoneName(String zoneName) {
      this.zoneName = zoneName;
   }

   public String getStatus() {
      return this.status;
   }

   public void setStatus(String status) {
      this.status = status;
   }
}
