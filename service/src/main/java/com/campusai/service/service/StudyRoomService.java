package com.campusai.service.service;

import com.campusai.common.util.AssertUtils;
import com.campusai.service.dto.StudyRoomBookingRequest;
import com.campusai.service.entity.ReservationRecord;
import com.campusai.service.entity.ReservationRule;
import com.campusai.service.entity.Seat;
import com.campusai.service.entity.StudyRoom;
import com.campusai.service.mapper.StudyRoomMapper;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StudyRoomService {
   private static final int MAX_RESCHEDULE_TIMES = 2;
   private final StudyRoomMapper studyRoomMapper;
   private final SubmissionGuardService submissionGuardService;

   public StudyRoomService(StudyRoomMapper studyRoomMapper, SubmissionGuardService submissionGuardService) {
      this.studyRoomMapper = studyRoomMapper;
      this.submissionGuardService = submissionGuardService;
      if (this.studyRoomMapper.countRescheduleColumn() == 0) {
         this.studyRoomMapper.addRescheduleColumn();
      }
   }

   public List<com.campusai.service.entity.StudyRoom> listRooms() {
      return this.studyRoomMapper.findAllRooms();
   }

   public StudyRoom findRoom(Long roomId) {
      AssertUtils.notNull(roomId, "自习室ID不能为空");
      StudyRoom room = this.studyRoomMapper.findRoomById(roomId);
      AssertUtils.notNull(room, "自习室不存在");
      return room;
   }

   @Transactional
   public StudyRoom saveRoom(StudyRoom room) {
      AssertUtils.notNull(room, "自习室参数不能为空");
      AssertUtils.notBlank(room.getName(), "自习室名称不能为空");
      AssertUtils.notBlank(room.getLocation(), "自习室位置不能为空");
      AssertUtils.notNull(room.getOpenTime(), "开放时间不能为空");
      AssertUtils.notNull(room.getCloseTime(), "关闭时间不能为空");
      AssertUtils.notNull(room.getMaxHours(), "单次最大时长不能为空");
      AssertUtils.notNull(room.getDailyLimit(), "每日预约上限不能为空");
      AssertUtils.isTrue(room.getCloseTime().isAfter(room.getOpenTime()), "关闭时间必须晚于开放时间");
      AssertUtils.isTrue(room.getMaxHours() > 0, "单次最大时长必须大于0");
      AssertUtils.isTrue(room.getDailyLimit() > 0, "每日预约上限必须大于0");
      if (room.getId() == null) {
         this.studyRoomMapper.insertRoom(room);
      } else {
         this.findRoom(room.getId());
         this.studyRoomMapper.updateRoom(room);
      }

      return this.findRoom(room.getId());
   }

   @Transactional
   public void deleteRoom(Long roomId) {
      this.findRoom(roomId);
      int reservationCount = this.studyRoomMapper.countReservationsByRoomId(roomId);
      AssertUtils.isTrue(reservationCount == 0, "该自习室已有预约记录，不能删除");
      this.studyRoomMapper.deleteSeatsByRoomId(roomId);
      this.studyRoomMapper.deleteRuleByRoomId(roomId);
      this.studyRoomMapper.deleteRoom(roomId);
   }

   public List<Seat> listSeats(Long roomId) {
      return this.studyRoomMapper.findSeatsByRoomId(roomId);
   }

   public ReservationRule findRule(Long roomId) {
      this.findRoom(roomId);
      ReservationRule rule = this.studyRoomMapper.findRuleByRoomId(roomId);
      if (rule == null) {
         rule = new ReservationRule();
         rule.setStudyRoomId(roomId);
         StudyRoom room = this.findRoom(roomId);
         rule.setMaxHours(room.getMaxHours());
         rule.setDailyLimit(room.getDailyLimit());
         rule.setCancelBeforeMinutes(30);
         rule.setEnabled(Boolean.TRUE);
      }

      return rule;
   }

   public List<Seat> listSeats(Long roomId, LocalDate reservationDate, LocalTime startTime, LocalTime endTime) {
      List<Seat> seats = this.studyRoomMapper.findSeatsByRoomId(roomId);
      if (reservationDate != null && startTime != null && endTime != null) {
         for(Seat seat : seats) {
            int conflicts = this.studyRoomMapper.countSeatConflicts(seat.getId(), reservationDate, startTime, endTime);
            seat.setStatus(conflicts > 0 ? "BOOKED" : "FREE");
         }

         return seats;
      } else {
         return seats;
      }
   }

   public List<ReservationRecord> listMyReservations(Long userId) {
      AssertUtils.notNull(userId, "用户未登录");
      return this.studyRoomMapper.findReservationsByUser(userId);
   }

   public List<ReservationRecord> listReservationsByRoom(Long roomId, LocalDate startDate, LocalDate endDate) {
      AssertUtils.notNull(roomId, "自习室不能为空");
      this.findRoom(roomId);
      LocalDate safeStart = startDate == null ? LocalDate.now().minusDays(7L) : startDate;
      LocalDate safeEnd = endDate == null ? safeStart.plusDays(30L) : endDate;
      return this.studyRoomMapper.findReservationsByRoomAndRange(roomId, safeStart, safeEnd);
   }

   @Transactional
   public ReservationRule saveRule(ReservationRule rule) {
      AssertUtils.notNull(rule, "预约规则不能为空");
      AssertUtils.notNull(rule.getStudyRoomId(), "请选择自习室");
      this.findRoom(rule.getStudyRoomId());
      AssertUtils.notNull(rule.getMaxHours(), "单次最大时长不能为空");
      AssertUtils.notNull(rule.getDailyLimit(), "每日上限不能为空");
      AssertUtils.notNull(rule.getCancelBeforeMinutes(), "取消时限不能为空");
      AssertUtils.isTrue(rule.getMaxHours() > 0, "单次最大时长必须大于0");
      AssertUtils.isTrue(rule.getDailyLimit() > 0, "每日上限必须大于0");
      AssertUtils.isTrue(rule.getCancelBeforeMinutes() >= 0, "取消时限不能小于0");
      if (rule.getEnabled() == null) {
         rule.setEnabled(Boolean.TRUE);
      }

      ReservationRule existing = this.studyRoomMapper.findRuleByRoomId(rule.getStudyRoomId());
      if (existing == null) {
         this.studyRoomMapper.insertRule(rule);
      } else {
         existing.setMaxHours(rule.getMaxHours());
         existing.setDailyLimit(rule.getDailyLimit());
         existing.setCancelBeforeMinutes(rule.getCancelBeforeMinutes());
         existing.setEnabled(rule.getEnabled());
         this.studyRoomMapper.updateRule(existing);
      }

      return this.studyRoomMapper.findRuleByRoomId(rule.getStudyRoomId());
   }

   public byte[] generateSeatTemplate() {
      try {
         XSSFWorkbook workbook = new XSSFWorkbook();

         byte[] var5;
         try {
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

            try {
               XSSFSheet sheet = workbook.createSheet("seats");
               Row header = sheet.createRow(0);
               header.createCell(0).setCellValue("study_room_id");
               header.createCell(1).setCellValue("seat_code");
               header.createCell(2).setCellValue("floor_no");
               header.createCell(3).setCellValue("zone_name");
               Row exampleOne = sheet.createRow(1);
               exampleOne.createCell(0).setCellValue(1);
               exampleOne.createCell(1).setCellValue("A101");
               exampleOne.createCell(2).setCellValue(1);
               exampleOne.createCell(3).setCellValue("临窗静音区");
               Row exampleTwo = sheet.createRow(2);
               exampleTwo.createCell(0).setCellValue(1);
               exampleTwo.createCell(1).setCellValue("B208");
               exampleTwo.createCell(2).setCellValue(2);
               exampleTwo.createCell(3).setCellValue("开放学习区");
               sheet.setColumnWidth(0, 18 * 256);
               sheet.setColumnWidth(1, 18 * 256);
               sheet.setColumnWidth(2, 14 * 256);
               sheet.setColumnWidth(3, 24 * 256);
               XSSFSheet guide = workbook.createSheet("guide");
               Row guideHeader = guide.createRow(0);
               guideHeader.createCell(0).setCellValue("字段");
               guideHeader.createCell(1).setCellValue("说明");
               guideHeader.createCell(2).setCellValue("示例");
               String[][] guides = new String[][]{{"study_room_id", "自习室ID，必须先在后台创建自习室。", "1"}, {"seat_code", "座位编号，建议按楼层+区域+序号统一编码。", "A101 / 3F-C-018"}, {"floor_no", "楼层编号，用于学生端分层展示。", "1 / 2 / 3"}, {"zone_name", "分区名称，会直接显示在学生端。", "临窗静音区 / 开放学习区"}};

               for(int i = 0; i < guides.length; ++i) {
                  Row guideRow = guide.createRow(i + 1);
                  guideRow.createCell(0).setCellValue(guides[i][0]);
                  guideRow.createCell(1).setCellValue(guides[i][1]);
                  guideRow.createCell(2).setCellValue(guides[i][2]);
               }

               Row extra = guide.createRow(guides.length + 3);
               extra.createCell(0).setCellValue("导入提示");
               extra.createCell(1).setCellValue("请从第2行开始填写；空白行会自动跳过；重复 seat_code 不建议导入。");
               guide.setColumnWidth(0, 18 * 256);
               guide.setColumnWidth(1, 48 * 256);
               guide.setColumnWidth(2, 24 * 256);
               workbook.write(outputStream);
               var5 = outputStream.toByteArray();
            } catch (Throwable var8) {
               try {
                  outputStream.close();
               } catch (Throwable var7) {
                  var8.addSuppressed(var7);
               }

               throw var8;
            }

            outputStream.close();
         } catch (Throwable var9) {
            try {
               workbook.close();
            } catch (Throwable var6) {
               var9.addSuppressed(var6);
            }

            throw var9;
         }

         workbook.close();
         return var5;
      } catch (IOException exception) {
         throw new IllegalStateException("模板生成失败", exception);
      }
   }

   @Transactional
   public int importSeats(InputStream inputStream) {
      List<Seat> seats = new ArrayList<>();

      try {
         XSSFWorkbook workbook = new XSSFWorkbook(inputStream);

         try {
            XSSFSheet sheet = workbook.getSheetAt(0);
            DataFormatter formatter = new DataFormatter();

            for(int i = 1; i <= sheet.getLastRowNum(); ++i) {
               Row row = sheet.getRow(i);
               if (row != null && !this.isSeatRowEmpty(row, formatter)) {
                  Seat seat = new Seat();
                  seat.setStudyRoomId(this.parseLongCell(row, 0, formatter, i, "study_room_id"));
                  seat.setSeatCode(this.parseTextCell(row, 1, formatter, i, "seat_code"));
                  seat.setFloorNo(this.parseIntegerCell(row, 2, formatter, i, "floor_no"));
                  seat.setZoneName(this.parseTextCell(row, 3, formatter, i, "zone_name"));
                  seat.setStatus("FREE");
                  seats.add(seat);
               }
            }
         } catch (Throwable var9) {
            try {
               workbook.close();
            } catch (Throwable var8) {
               var9.addSuppressed(var8);
            }

            throw var9;
         }

         workbook.close();
      } catch (IOException exception) {
         throw new IllegalStateException("座位导入失败", exception);
      }

      if (!seats.isEmpty()) {
         this.studyRoomMapper.insertSeatBatch(seats);
      }

      return seats.size();
   }

   private boolean isSeatRowEmpty(Row row, DataFormatter formatter) {
      for(int index = 0; index <= 3; ++index) {
         if (!formatter.formatCellValue(row.getCell(index)).trim().isEmpty()) {
            return false;
         }
      }

      return true;
   }

   private Long parseLongCell(Row row, int cellIndex, DataFormatter formatter, int rowIndex, String fieldName) {
      String text = formatter.formatCellValue(row.getCell(cellIndex)).trim();
      AssertUtils.notBlank(text, "第" + (rowIndex + 1) + "行的 " + fieldName + " 不能为空");

      try {
         return Long.valueOf(text.replace(".0", ""));
      } catch (NumberFormatException exception) {
         throw new IllegalArgumentException("第" + (rowIndex + 1) + "行的 " + fieldName + " 不是有效数字");
      }
   }

   private Integer parseIntegerCell(Row row, int cellIndex, DataFormatter formatter, int rowIndex, String fieldName) {
      String text = formatter.formatCellValue(row.getCell(cellIndex)).trim();
      AssertUtils.notBlank(text, "第" + (rowIndex + 1) + "行的 " + fieldName + " 不能为空");

      try {
         return Integer.valueOf(text.replace(".0", ""));
      } catch (NumberFormatException exception) {
         throw new IllegalArgumentException("第" + (rowIndex + 1) + "行的 " + fieldName + " 不是有效数字");
      }
   }

   private String parseTextCell(Row row, int cellIndex, DataFormatter formatter, int rowIndex, String fieldName) {
      String text = formatter.formatCellValue(row.getCell(cellIndex)).trim();
      AssertUtils.notBlank(text, "第" + (rowIndex + 1) + "行的 " + fieldName + " 不能为空");
      return text;
   }

   @Transactional
   public ReservationRecord reserve(Long userId, StudyRoomBookingRequest request) {
      AssertUtils.notNull(userId, "用户未登录");
      AssertUtils.notNull(request, "预约参数不能为空");
      AssertUtils.notNull(request.getRoomId(), "自习室不能为空");
      AssertUtils.notNull(request.getSeatId(), "座位不能为空");
      AssertUtils.notNull(request.getReservationDate(), "预约日期不能为空");
      AssertUtils.notNull(request.getStartTime(), "开始时间不能为空");
      AssertUtils.notNull(request.getEndTime(), "结束时间不能为空");
      this.submissionGuardService.guard("study-reserve", userId + ":" + request.getRoomId() + ":" + request.getSeatId() + ":" + request.getReservationDate() + ":" + request.getStartTime() + ":" + request.getEndTime(), Duration.ofSeconds(3L), "请勿重复提交预约");
      ReservationRule rule = this.studyRoomMapper.findRuleByRoomId(request.getRoomId());
      AssertUtils.notNull(rule, "未配置预约规则");
      AssertUtils.isTrue(Boolean.TRUE.equals(rule.getEnabled()), "当前自习室预约暂未开放");
      long durationHours = Duration.between(request.getStartTime(), request.getEndTime()).toHours();
      AssertUtils.isTrue(durationHours > 0L, "预约时长必须大于0");
      AssertUtils.isTrue(durationHours <= (long)rule.getMaxHours(), "超过单次最大预约时长");
      int dayCount = this.studyRoomMapper.countUserReservationsByDate(userId, request.getReservationDate());
      AssertUtils.isTrue(dayCount < rule.getDailyLimit(), "超过当日预约上限");
      int userConflict = this.studyRoomMapper.countUserReservationConflicts(userId, request.getReservationDate(), request.getStartTime(), request.getEndTime());
      AssertUtils.isTrue(userConflict == 0, "该时段您已有预约，请勿重复提交");
      Seat lockedSeat = this.studyRoomMapper.lockSeatByIdForUpdate(request.getSeatId());
      AssertUtils.notNull(lockedSeat, "座位不存在");
      AssertUtils.isTrue(request.getRoomId().equals(lockedSeat.getStudyRoomId()), "所选座位不在当前自习室");
      int conflictCount = this.studyRoomMapper.countSeatConflicts(request.getSeatId(), request.getReservationDate(), request.getStartTime(), request.getEndTime());
      AssertUtils.isTrue(conflictCount == 0, "当前座位该时段已被预约");
      ReservationRecord record = new ReservationRecord();
      record.setUserId(userId);
      record.setStudyRoomId(request.getRoomId());
      record.setSeatId(request.getSeatId());
      record.setReservationDate(request.getReservationDate());
      record.setStartTime(request.getStartTime());
      record.setEndTime(request.getEndTime());
      record.setStatus("BOOKED");
      record.setCreatedAt(LocalDateTime.now());
      record.setRescheduleCount(0);
      String var10001 = UUID.randomUUID().toString();
      record.setVoucherCode("RSV-" + var10001.substring(0, 8).toUpperCase());
      this.studyRoomMapper.insertReservation(record);
      return record;
   }

   @Transactional
   public void cancelReservation(Long userId, Long reservationId) {
      AssertUtils.notNull(userId, "用户未登录");
      AssertUtils.notNull(reservationId, "预约记录不能为空");
      this.submissionGuardService.guard("study-cancel", userId + ":" + reservationId, Duration.ofSeconds(2L), "请勿重复点击取消");
      ReservationRecord record = this.studyRoomMapper.lockReservationByIdAndUserForUpdate(reservationId, userId);
      AssertUtils.notNull(record, "预约记录不存在");
      AssertUtils.isTrue("BOOKED".equals(record.getStatus()), "当前预约状态不可取消");
      ReservationRule rule = this.studyRoomMapper.findRuleByRoomId(record.getStudyRoomId());
      AssertUtils.notNull(rule, "预约规则不存在");
      AssertUtils.isTrue(Boolean.TRUE.equals(rule.getEnabled()), "当前自习室预约暂未开放");
      int cancelBeforeMinutes = rule.getCancelBeforeMinutes() == null ? 0 : rule.getCancelBeforeMinutes();
      LocalDateTime reservationStart = LocalDateTime.of(record.getReservationDate(), record.getStartTime());
      LocalDateTime latestCancelAt = reservationStart.minusMinutes((long)cancelBeforeMinutes);
      AssertUtils.isTrue(LocalDateTime.now().isBefore(latestCancelAt), "已超过可取消时间");
      this.studyRoomMapper.cancelReservation(reservationId, "CANCELLED");
   }

   @Transactional
   public ReservationRecord rescheduleReservation(Long userId, Long reservationId, StudyRoomBookingRequest request) {
      AssertUtils.notNull(userId, "用户未登录");
      AssertUtils.notNull(reservationId, "预约记录不能为空");
      AssertUtils.notNull(request, "改期参数不能为空");
      AssertUtils.notNull(request.getRoomId(), "自习室不能为空");
      AssertUtils.notNull(request.getSeatId(), "座位不能为空");
      AssertUtils.notNull(request.getReservationDate(), "预约日期不能为空");
      AssertUtils.notNull(request.getStartTime(), "开始时间不能为空");
      AssertUtils.notNull(request.getEndTime(), "结束时间不能为空");
      this.submissionGuardService.guard("study-reschedule", userId + ":" + reservationId + ":" + request.getReservationDate() + ":" + request.getStartTime() + ":" + request.getEndTime(), Duration.ofSeconds(3L), "请勿重复提交改期");
      ReservationRecord record = this.studyRoomMapper.lockReservationByIdAndUserForUpdate(reservationId, userId);
      AssertUtils.notNull(record, "预约记录不存在");
      AssertUtils.isTrue("BOOKED".equals(record.getStatus()), "当前预约状态不可改期");
      AssertUtils.isTrue(this.safeRescheduleCount(record) < MAX_RESCHEDULE_TIMES, "该预约最多可改期 " + MAX_RESCHEDULE_TIMES + " 次");
      ReservationRule rule = this.studyRoomMapper.findRuleByRoomId(request.getRoomId());
      AssertUtils.notNull(rule, "未配置预约规则");
      AssertUtils.isTrue(Boolean.TRUE.equals(rule.getEnabled()), "当前自习室预约暂未开放");
      long durationHours = Duration.between(request.getStartTime(), request.getEndTime()).toHours();
      AssertUtils.isTrue(durationHours > 0L, "预约时长必须大于0");
      AssertUtils.isTrue(durationHours <= (long)rule.getMaxHours(), "超过单次最大预约时长");
      Seat lockedSeat = this.studyRoomMapper.lockSeatByIdForUpdate(request.getSeatId());
      AssertUtils.notNull(lockedSeat, "座位不存在");
      AssertUtils.isTrue(request.getRoomId().equals(lockedSeat.getStudyRoomId()), "所选座位不在当前自习室");
      int dayCount = this.studyRoomMapper.countUserReservationsByDateExclude(userId, request.getReservationDate(), reservationId);
      AssertUtils.isTrue(dayCount < rule.getDailyLimit(), "超过当日预约上限");
      int userConflict = this.studyRoomMapper.countUserReservationConflictsExclude(userId, request.getReservationDate(), request.getStartTime(), request.getEndTime(), reservationId);
      AssertUtils.isTrue(userConflict == 0, "该时段您已有其他预约，请先取消后再改期");
      int conflictCount = this.studyRoomMapper.countSeatConflictsExclude(request.getSeatId(), request.getReservationDate(), request.getStartTime(), request.getEndTime(), reservationId);
      AssertUtils.isTrue(conflictCount == 0, "当前座位该时段已被预约");
      record.setStudyRoomId(request.getRoomId());
      record.setSeatId(request.getSeatId());
      record.setReservationDate(request.getReservationDate());
      record.setStartTime(request.getStartTime());
      record.setEndTime(request.getEndTime());
      record.setRescheduleCount(this.safeRescheduleCount(record) + 1);
      this.studyRoomMapper.updateReservation(record);
      return this.studyRoomMapper.findReservationById(reservationId);
   }

   private int safeRescheduleCount(ReservationRecord record) {
      return record != null && record.getRescheduleCount() != null ? record.getRescheduleCount() : 0;
   }
}
