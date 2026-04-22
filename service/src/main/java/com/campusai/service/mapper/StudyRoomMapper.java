package com.campusai.service.mapper;

import com.campusai.service.entity.ReservationRecord;
import com.campusai.service.entity.ReservationRule;
import com.campusai.service.entity.Seat;
import com.campusai.service.entity.StudyRoom;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface StudyRoomMapper {
   List<StudyRoom> findAllRooms();

   StudyRoom findRoomById(@Param("roomId") Long var1);

   void insertRoom(StudyRoom var1);

   void updateRoom(StudyRoom var1);

   void deleteRoom(@Param("roomId") Long var1);

   List<Seat> findSeatsByRoomId(@Param("roomId") Long var1);

   ReservationRule findRuleByRoomId(@Param("roomId") Long var1);

   void insertRule(ReservationRule var1);

   void updateRule(ReservationRule var1);

   int countReservationsByRoomId(@Param("roomId") Long var1);

   void deleteSeatsByRoomId(@Param("roomId") Long var1);

   void deleteRuleByRoomId(@Param("roomId") Long var1);

   int countRescheduleColumn();

   void addRescheduleColumn();

   int countUserReservationsByDate(@Param("userId") Long var1, @Param("reservationDate") LocalDate var2);

   int countSeatConflicts(@Param("seatId") Long var1, @Param("reservationDate") LocalDate var2, @Param("startTime") LocalTime var3, @Param("endTime") LocalTime var4);

   int countSeatConflictsExclude(@Param("seatId") Long var1, @Param("reservationDate") LocalDate var2, @Param("startTime") LocalTime var3, @Param("endTime") LocalTime var4, @Param("excludeReservationId") Long var5);

   int countUserReservationConflicts(@Param("userId") Long var1, @Param("reservationDate") LocalDate var2, @Param("startTime") LocalTime var3, @Param("endTime") LocalTime var4);

   int countUserReservationConflictsExclude(@Param("userId") Long var1, @Param("reservationDate") LocalDate var2, @Param("startTime") LocalTime var3, @Param("endTime") LocalTime var4, @Param("excludeReservationId") Long var5);

   int countUserReservationsByDateExclude(@Param("userId") Long var1, @Param("reservationDate") LocalDate var2, @Param("excludeReservationId") Long var3);

   int countSeatInRoom(@Param("roomId") Long var1, @Param("seatId") Long var2);

   Seat lockSeatByIdForUpdate(@Param("seatId") Long var1);

   List<ReservationRecord> findReservationsByUser(@Param("userId") Long var1);

   List<ReservationRecord> findReservationsByRoomAndRange(@Param("roomId") Long var1, @Param("startDate") LocalDate var2, @Param("endDate") LocalDate var3);

   ReservationRecord findReservationById(@Param("id") Long var1);

   ReservationRecord findReservationByIdAndUser(@Param("id") Long var1, @Param("userId") Long var2);

   ReservationRecord lockReservationByIdAndUserForUpdate(@Param("id") Long var1, @Param("userId") Long var2);

   void insertReservation(ReservationRecord var1);

   void updateReservation(ReservationRecord var1);

   void cancelReservation(@Param("id") Long var1, @Param("status") String var2);

   void insertSeatBatch(@Param("seats") List<Seat> var1);
}
