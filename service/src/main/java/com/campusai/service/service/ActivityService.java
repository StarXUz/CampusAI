package com.campusai.service.service;

import com.campusai.common.util.AssertUtils;
import com.campusai.service.dto.ActivitySignupRequest;
import com.campusai.service.entity.Activity;
import com.campusai.service.entity.ActivityRegistration;
import com.campusai.service.mapper.ActivityMapper;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.time.LocalDateTime;
import java.util.List;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ActivityService {
   private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
   private static final String[] PDF_FONT_CANDIDATES = new String[]{
      "/System/Library/Fonts/Supplemental/Arial Unicode.ttf",
      "/Library/Fonts/Arial Unicode.ttf",
      "/System/Library/Fonts/Supplemental/Songti.ttc",
      "/System/Library/Fonts/STHeiti Light.ttc",
      "/System/Library/Fonts/STHeiti Medium.ttc"
   };
   private final ActivityMapper activityMapper;
   private final StaticPageService staticPageService;

   public ActivityService(ActivityMapper activityMapper, StaticPageService staticPageService) {
      this.activityMapper = activityMapper;
      this.staticPageService = staticPageService;
   }

   public List<Activity> listActivities() {
      return this.activityMapper.findAll();
   }

   public Activity findActivity(Long id) {
      AssertUtils.notNull(id, "活动ID不能为空");
      Activity activity = this.activityMapper.findById(id);
      AssertUtils.notNull(activity, "活动不存在");
      return activity;
   }

   public List<ActivityRegistration> listMyRegistrations(Long userId) {
      return this.activityMapper.findRegistrationsByUser(userId);
   }

   public Activity saveActivity(Activity activity) {
      AssertUtils.notBlank(activity.getTitle(), "活动标题不能为空");
      AssertUtils.notBlank(activity.getSummary(), "活动简介不能为空");
      AssertUtils.notBlank(activity.getLocation(), "活动地点不能为空");
      AssertUtils.notNull(activity.getStartTime(), "活动开始时间不能为空");
      AssertUtils.notNull(activity.getEndTime(), "活动结束时间不能为空");
      AssertUtils.notNull(activity.getMaxParticipants(), "活动名额不能为空");
      if (activity.getPosterUrl() == null || activity.getPosterUrl().isBlank()) {
         activity.setPosterUrl("/static/img/activity-1.svg");
      }

      if (activity.getStatus() == null || activity.getStatus().isBlank()) {
         activity.setStatus("OPEN");
      }

      if (activity.getId() == null) {
         this.activityMapper.insertActivity(activity);
      } else {
         this.findActivity(activity.getId());
         this.activityMapper.updateActivity(activity);
      }

      Activity saved = this.findActivity(activity.getId());
      this.staticPageService.generateActivityStaticPage(saved, this.activityMapper.countRegistrations(saved.getId()));
      return saved;
   }

   public void deleteActivity(Long id) {
      this.findActivity(id);
      this.activityMapper.deleteActivity(id);
   }

   public Path regenerateStaticPage(Long activityId) {
      Activity activity = this.findActivity(activityId);
      return this.staticPageService.generateActivityStaticPage(activity, this.activityMapper.countRegistrations(activityId));
   }

   @Transactional
   public ActivityRegistration signUp(Long userId, ActivitySignupRequest request) {
      Activity activity = this.activityMapper.findById(request.getActivityId());
      AssertUtils.notNull(activity, "活动不存在");
      AssertUtils.isTrue(this.activityMapper.countRegistrations(activity.getId()) < activity.getMaxParticipants(), "活动名额已满");
      ActivityRegistration existing = this.activityMapper.findRegistration(request.getActivityId(), userId);
      if (existing != null) {
         existing.setRealName(request.getRealName());
         existing.setStudentNo(request.getStudentNo());
         existing.setPhone(request.getPhone());
         existing.setStatus("REGISTERED");
         this.activityMapper.updateRegistration(existing);
         this.staticPageService.generateActivityStaticPage(activity, this.activityMapper.countRegistrations(activity.getId()));
         return existing;
      } else {
         ActivityRegistration registration = new ActivityRegistration();
         registration.setActivityId(request.getActivityId());
         registration.setUserId(userId);
         registration.setRealName(request.getRealName());
         registration.setStudentNo(request.getStudentNo());
         registration.setPhone(request.getPhone());
         registration.setStatus("REGISTERED");
         registration.setRegisteredAt(LocalDateTime.now());
         this.activityMapper.insertRegistration(registration);
         this.staticPageService.generateActivityStaticPage(activity, this.activityMapper.countRegistrations(activity.getId()));
         return registration;
      }
   }

   public void cancel(Long userId, Long activityId) {
      this.activityMapper.cancelRegistration(activityId, userId);
      Activity activity = this.activityMapper.findById(activityId);
      if (activity != null) {
         this.staticPageService.generateActivityStaticPage(activity, this.activityMapper.countRegistrations(activityId));
      }
   }

   public int refreshExpiredActivities() {
      int changed = 0;
      LocalDateTime now = LocalDateTime.now();

      for(Activity activity : this.activityMapper.findAll()) {
         if (activity.getEndTime() != null && activity.getEndTime().isBefore(now) && !"CLOSED".equalsIgnoreCase(activity.getStatus())) {
            activity.setStatus("CLOSED");
            this.activityMapper.updateActivity(activity);
            ++changed;
            this.staticPageService.generateActivityStaticPage(activity, this.activityMapper.countRegistrations(activity.getId()));
         }
      }

      return changed;
   }

   public byte[] exportSignupReport(Long activityId) {
      Activity activity = this.findActivity(activityId);
      List<ActivityRegistration> registrations = this.activityMapper.findRegistrationsByActivity(activityId);
      List<ActivityReportRow> rows = this.buildReportRows(registrations);
      try {
         ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
         Document document = new Document(PageSize.A4, 40.0F, 40.0F, 32.0F, 32.0F);

         byte[] pdfBytes;
         try {
            PdfWriter.getInstance(document, outputStream);
            document.open();
            BaseFont baseFont = this.resolvePdfBaseFont();
            Font titleFont = new Font(baseFont, 20.0F, Font.BOLD, new Color(31, 45, 61));
            Font subtitleFont = new Font(baseFont, 15.0F, Font.BOLD, new Color(31, 45, 61));
            Font labelFont = new Font(baseFont, 10.0F, Font.BOLD, new Color(31, 45, 61));
            Font valueFont = new Font(baseFont, 10.0F, Font.NORMAL, new Color(66, 84, 102));
            Font tableHeaderFont = new Font(baseFont, 10.0F, Font.BOLD, Color.WHITE);
            Font tableCellFont = new Font(baseFont, 10.0F, Font.NORMAL, new Color(34, 49, 66));
            Font noteFont = new Font(baseFont, 9.0F, Font.NORMAL, new Color(91, 107, 124));

            Paragraph title = new Paragraph("校园活动报名统计报表", titleFont);
            title.setSpacingAfter(10.0F);
            document.add(title);

            Paragraph activityTitleLine = new Paragraph(this.safe(activity.getTitle()), subtitleFont);
            activityTitleLine.setSpacingAfter(8.0F);
            document.add(activityTitleLine);

            Paragraph summary = new Paragraph(this.safe(activity.getSummary()), valueFont);
            summary.setSpacingAfter(12.0F);
            document.add(summary);

            PdfPTable metaTable = new PdfPTable(new float[]{1.0F, 2.6F, 1.0F, 2.0F});
            metaTable.setWidthPercentage(100.0F);
            metaTable.setSpacingAfter(14.0F);
            metaTable.getDefaultCell().setBorder(Rectangle.NO_BORDER);
            this.addMetaCell(metaTable, "活动地点", labelFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, this.safe(activity.getLocation()), valueFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, "活动时间", labelFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, this.formatTimeRange(activity.getStartTime(), activity.getEndTime()), valueFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, "活动状态", labelFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, this.formatActivityStatus(activity.getStatus()), valueFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, "报名情况", labelFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, "已报名 " + registrations.size() + " / 名额 " + (activity.getMaxParticipants() == null ? "-" : activity.getMaxParticipants()), valueFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, "导出时间", labelFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, DATE_TIME_FORMATTER.format(LocalDateTime.now()), valueFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, "", valueFont, Element.ALIGN_LEFT);
            this.addMetaCell(metaTable, "", valueFont, Element.ALIGN_LEFT);
            document.add(metaTable);

            if (rows.isEmpty()) {
               Paragraph emptyTitle = new Paragraph("当前活动暂无报名记录", subtitleFont);
               emptyTitle.setAlignment(Element.ALIGN_CENTER);
               emptyTitle.setSpacingBefore(24.0F);
               emptyTitle.setSpacingAfter(8.0F);
               document.add(emptyTitle);

               Paragraph emptyNote = new Paragraph("可在活动开放报名后再次导出，系统将自动补充报名明细。", valueFont);
               emptyNote.setAlignment(Element.ALIGN_CENTER);
               document.add(emptyNote);
            } else {
               PdfPTable table = new PdfPTable(new float[]{0.7F, 1.4F, 1.8F, 1.8F, 1.0F, 1.7F});
               table.setWidthPercentage(100.0F);
               table.setHeaderRows(1);
               table.setSpacingBefore(4.0F);
               this.addTableHeaderCell(table, "序号", tableHeaderFont);
               this.addTableHeaderCell(table, "姓名", tableHeaderFont);
               this.addTableHeaderCell(table, "学号", tableHeaderFont);
               this.addTableHeaderCell(table, "手机号", tableHeaderFont);
               this.addTableHeaderCell(table, "状态", tableHeaderFont);
               this.addTableHeaderCell(table, "报名时间", tableHeaderFont);

               for(int i = 0; i < rows.size(); ++i) {
                  ActivityReportRow row = (ActivityReportRow)rows.get(i);
                  Color background = i % 2 == 0 ? Color.WHITE : new Color(246, 249, 252);
                  this.addTableCell(table, String.valueOf(row.getSeq()), tableCellFont, Element.ALIGN_CENTER, background);
                  this.addTableCell(table, row.getRealName(), tableCellFont, Element.ALIGN_LEFT, background);
                  this.addTableCell(table, row.getStudentNo(), tableCellFont, Element.ALIGN_LEFT, background);
                  this.addTableCell(table, row.getPhone(), tableCellFont, Element.ALIGN_LEFT, background);
                  this.addTableCell(table, row.getStatusLabel(), tableCellFont, Element.ALIGN_CENTER, background);
                  this.addTableCell(table, row.getRegisteredAtLabel(), tableCellFont, Element.ALIGN_LEFT, background);
               }

               document.add(table);
            }

            Paragraph footer = new Paragraph("Campus Service Manager AI · 活动报名报表", noteFont);
            footer.setSpacingBefore(18.0F);
            footer.setAlignment(Element.ALIGN_RIGHT);
            document.add(footer);
            pdfBytes = null;
         } catch (Throwable exception) {
            if (document.isOpen()) {
               document.close();
            }

            try {
               outputStream.close();
            } catch (Throwable closeException) {
               exception.addSuppressed(closeException);
            }

            throw exception;
         }

         if (document.isOpen()) {
            document.close();
         }

         pdfBytes = outputStream.toByteArray();
         outputStream.close();
         return pdfBytes;
      } catch (DocumentException | IOException exception) {
         throw new IllegalStateException("导出活动报名报表失败", exception);
      }
   }

   private List<ActivityReportRow> buildReportRows(List<ActivityRegistration> registrations) {
      List<ActivityReportRow> rows = new ArrayList<>();
      if (registrations == null) {
         return rows;
      }

      for(int i = 0; i < registrations.size(); ++i) {
         ActivityRegistration registration = (ActivityRegistration)registrations.get(i);
         rows.add(new ActivityReportRow(i + 1, this.safe(registration.getRealName()), this.safe(registration.getStudentNo()), this.safe(registration.getPhone()), this.formatRegistrationStatus(registration.getStatus()), this.formatDateTime(registration.getRegisteredAt())));
      }

      return rows;
   }

   private String safe(String value) {
      return value == null || value.isBlank() ? "-" : value;
   }

   private BaseFont resolvePdfBaseFont() throws DocumentException, IOException {
      for(String candidate : PDF_FONT_CANDIDATES) {
         if ((new File(candidate)).isFile()) {
            String fontPath = candidate.endsWith(".ttc") ? candidate + ",0" : candidate;
            return BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
         }
      }

      return BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
   }

   private void addMetaCell(PdfPTable table, String text, Font font, int alignment) {
      PdfPCell cell = new PdfPCell(new Phrase(this.safe(text), font));
      cell.setBorder(Rectangle.NO_BORDER);
      cell.setPaddingBottom(6.0F);
      cell.setHorizontalAlignment(alignment);
      cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
      table.addCell(cell);
   }

   private void addTableHeaderCell(PdfPTable table, String text, Font font) {
      PdfPCell cell = new PdfPCell(new Phrase(text, font));
      cell.setBackgroundColor(new Color(78, 141, 247));
      cell.setHorizontalAlignment(Element.ALIGN_CENTER);
      cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
      cell.setPadding(7.0F);
      cell.setBorderColor(new Color(222, 230, 240));
      table.addCell(cell);
   }

   private void addTableCell(PdfPTable table, String text, Font font, int alignment, Color background) {
      PdfPCell cell = new PdfPCell(new Phrase(this.safe(text), font));
      cell.setBackgroundColor(background);
      cell.setHorizontalAlignment(alignment);
      cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
      cell.setPadding(6.0F);
      cell.setBorderColor(new Color(230, 236, 243));
      table.addCell(cell);
   }

   private String formatDateTime(LocalDateTime value) {
      return value == null ? "-" : DATE_TIME_FORMATTER.format(value);
   }

   private String formatTimeRange(LocalDateTime startTime, LocalDateTime endTime) {
      if (startTime == null && endTime == null) {
         return "-";
      } else {
         String start = this.formatDateTime(startTime);
         String end = this.formatDateTime(endTime);
         return start + " - " + end;
      }
   }

   private String formatActivityStatus(String status) {
      if ("OPEN".equalsIgnoreCase(status)) {
         return "报名中";
      } else if ("CLOSED".equalsIgnoreCase(status)) {
         return "已结束";
      } else {
         return this.safe(status);
      }
   }

   private String formatRegistrationStatus(String status) {
      if ("REGISTERED".equalsIgnoreCase(status)) {
         return "已报名";
      } else if ("CANCELLED".equalsIgnoreCase(status)) {
         return "已取消";
      } else {
         return this.safe(status);
      }
   }

   public static class ActivityReportRow {
      private final Integer seq;
      private final String realName;
      private final String studentNo;
      private final String phone;
      private final String statusLabel;
      private final String registeredAtLabel;

      public ActivityReportRow(Integer seq, String realName, String studentNo, String phone, String statusLabel, String registeredAtLabel) {
         this.seq = seq;
         this.realName = realName;
         this.studentNo = studentNo;
         this.phone = phone;
         this.statusLabel = statusLabel;
         this.registeredAtLabel = registeredAtLabel;
      }

      public Integer getSeq() {
         return this.seq;
      }

      public String getRealName() {
         return this.realName;
      }

      public String getStudentNo() {
         return this.studentNo;
      }

      public String getPhone() {
         return this.phone;
      }

      public String getStatusLabel() {
         return this.statusLabel;
      }

      public String getRegisteredAtLabel() {
         return this.registeredAtLabel;
      }
   }
}
