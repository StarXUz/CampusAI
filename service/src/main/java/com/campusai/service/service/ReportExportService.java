package com.campusai.service.service;

import com.campusai.service.mapper.DashboardMapper;
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
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

@Service
public class ReportExportService {
   private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
   private static final String[] PDF_FONT_CANDIDATES = new String[]{
      "/System/Library/Fonts/Supplemental/Arial Unicode.ttf",
      "/Library/Fonts/Arial Unicode.ttf",
      "/System/Library/Fonts/Supplemental/Songti.ttc",
      "/System/Library/Fonts/STHeiti Light.ttc",
      "/System/Library/Fonts/STHeiti Medium.ttc"
   };
   private final DashboardMapper dashboardMapper;

   public ReportExportService(DashboardMapper dashboardMapper) {
      this.dashboardMapper = dashboardMapper;
   }

   public byte[] exportMonthlyOperationReport() {
      return this.exportMonthlyOperationReport((List<Long>)null);
   }

   public byte[] exportMonthlyOperationReport(List<Long> merchantIds) {
      try {
         XSSFWorkbook workbook = new XSSFWorkbook();

         byte[] var14;
         try {
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

            try {
               XSSFSheet sheet = workbook.createSheet("monthly-operation-report");
               Row header = sheet.createRow(0);
               header.createCell(0).setCellValue("商家");
               header.createCell(1).setCellValue("营收");
               header.createCell(2).setCellValue("订单量");
               header.createCell(3).setCellValue("退款率");
               List<Map<String, Object>> rows = this.loadMonthlyOperationRows(merchantIds);

               for(int i = 0; i < rows.size(); ++i) {
                  Row row = sheet.createRow(i + 1);
                  Map<String, Object> item = (Map)rows.get(i);
                  row.createCell(0).setCellValue(String.valueOf(item.getOrDefault("merchantName", "-")));
                  row.createCell(1).setCellValue(this.decimalValue(item.get("revenue")).doubleValue());
                  row.createCell(2).setCellValue(String.valueOf(item.getOrDefault("orderCount", "0")));
                  row.createCell(3).setCellValue(String.valueOf(item.getOrDefault("refundRate", "0%")));
               }

               sheet.setColumnWidth(0, 22 * 256);
               sheet.setColumnWidth(1, 14 * 256);
               sheet.setColumnWidth(2, 14 * 256);
               sheet.setColumnWidth(3, 14 * 256);
               workbook.write(outputStream);
               var14 = outputStream.toByteArray();
            } catch (Throwable var11) {
               try {
                  outputStream.close();
               } catch (Throwable var10) {
                  var11.addSuppressed(var10);
               }

               throw var11;
            }

            outputStream.close();
         } catch (Throwable var12) {
            try {
               workbook.close();
            } catch (Throwable var9) {
               var12.addSuppressed(var9);
            }

            throw var12;
         }

         workbook.close();
         return var14;
      } catch (IOException exception) {
         throw new IllegalStateException("导出月度运营报表失败", exception);
      }
   }

   public byte[] exportMonthlyOperationPdf(List<Long> merchantIds) {
      List<Map<String, Object>> rows = this.loadMonthlyOperationRows(merchantIds);

      try {
         ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
         Document document = new Document(PageSize.A4, 40.0F, 40.0F, 32.0F, 32.0F);

         byte[] pdfBytes;
         try {
            PdfWriter.getInstance(document, outputStream);
            document.open();
            BaseFont baseFont = this.resolvePdfBaseFont();
            Font titleFont = new Font(baseFont, 20.0F, Font.BOLD, new Color(31, 45, 61));
            Font subtitleFont = new Font(baseFont, 10.0F, Font.NORMAL, new Color(91, 107, 124));
            Font tableHeaderFont = new Font(baseFont, 10.0F, Font.BOLD, Color.WHITE);
            Font tableCellFont = new Font(baseFont, 10.0F, Font.NORMAL, new Color(34, 49, 66));
            Font noteFont = new Font(baseFont, 9.0F, Font.NORMAL, new Color(91, 107, 124));

            Paragraph title = new Paragraph("月度运营报表", titleFont);
            title.setSpacingAfter(6.0F);
            document.add(title);

            Paragraph subtitle = new Paragraph("统计口径：最近 30 天数据库订单数据，内容与后台预览保持同源。导出时间：" + DATE_TIME_FORMATTER.format(LocalDateTime.now()), subtitleFont);
            subtitle.setSpacingAfter(14.0F);
            document.add(subtitle);

            if (rows.isEmpty()) {
               Paragraph emptyState = new Paragraph("当前没有可导出的月度运营数据。", tableCellFont);
               emptyState.setSpacingBefore(24.0F);
               emptyState.setAlignment(Element.ALIGN_CENTER);
               document.add(emptyState);
            } else {
               PdfPTable table = new PdfPTable(new float[]{2.5F, 1.2F, 1.0F, 1.0F});
               table.setWidthPercentage(100.0F);
               table.setHeaderRows(1);
               this.addTableHeaderCell(table, "商家", tableHeaderFont);
               this.addTableHeaderCell(table, "营收", tableHeaderFont);
               this.addTableHeaderCell(table, "订单量", tableHeaderFont);
               this.addTableHeaderCell(table, "退款率", tableHeaderFont);

               for(int i = 0; i < rows.size(); ++i) {
                  Map<String, Object> item = (Map)rows.get(i);
                  Color background = i % 2 == 0 ? Color.WHITE : new Color(246, 249, 252);
                  this.addTableCell(table, String.valueOf(item.getOrDefault("merchantName", "-")), tableCellFont, Element.ALIGN_LEFT, background);
                  this.addTableCell(table, "￥" + this.formatMoney(item.get("revenue")), tableCellFont, Element.ALIGN_LEFT, background);
                  this.addTableCell(table, String.valueOf(item.getOrDefault("orderCount", "0")), tableCellFont, Element.ALIGN_CENTER, background);
                  this.addTableCell(table, String.valueOf(item.getOrDefault("refundRate", "0%")), tableCellFont, Element.ALIGN_CENTER, background);
               }

               document.add(table);
            }

            Paragraph footer = new Paragraph("Campus Service Manager AI · Monthly Operation Report", noteFont);
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
         throw new IllegalStateException("导出月度运营报表 PDF 失败", exception);
      }
   }

   private List<Map<String, Object>> loadMonthlyOperationRows(List<Long> merchantIds) {
      return merchantIds == null ? this.dashboardMapper.queryMonthlyOperationReport() : (merchantIds.isEmpty() ? Collections.emptyList() : this.dashboardMapper.queryMonthlyOperationReportByMerchantIds(merchantIds));
   }

   private BigDecimal decimalValue(Object value) {
      if (value instanceof BigDecimal decimal) {
         return decimal;
      } else {
         return value == null ? BigDecimal.ZERO : new BigDecimal(String.valueOf(value));
      }
   }

   private String formatMoney(Object value) {
      BigDecimal decimal = this.decimalValue(value).stripTrailingZeros();
      return decimal.scale() < 0 ? decimal.setScale(0).toPlainString() : decimal.toPlainString();
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
      PdfPCell cell = new PdfPCell(new Phrase(text, font));
      cell.setBackgroundColor(background);
      cell.setHorizontalAlignment(alignment);
      cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
      cell.setPadding(6.0F);
      cell.setBorderColor(new Color(230, 236, 243));
      table.addCell(cell);
   }
}
