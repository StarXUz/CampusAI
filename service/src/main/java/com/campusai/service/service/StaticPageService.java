package com.campusai.service.service;

import com.campusai.service.entity.Activity;
import freemarker.cache.StringTemplateLoader;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import java.io.IOException;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class StaticPageService {
   private final Path outputDir;

   public StaticPageService(@Value("${app.static.output-dir:generated-static/activities}") String outputDir) {
      this.outputDir = Path.of(outputDir).toAbsolutePath().normalize();
   }

   public Path generateActivityStaticPage(Activity activity) {
      return this.generateActivityStaticPage(activity, (Integer)null);
   }

   public Path generateActivityStaticPage(Activity activity, Integer registeredCount) {
      try {
         StringTemplateLoader loader = new StringTemplateLoader();
         loader.putTemplate("activity", "<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<title>${title}</title>\n<style>\nbody{margin:0;font-family:\"Microsoft YaHei\",\"PingFang SC\",sans-serif;background:#f4f7fb;color:#203248;} .shell{max-width:960px;margin:0 auto;padding:48px 24px;} .hero{background:linear-gradient(135deg,#23435f,#3e78ab);color:#fff;border-radius:28px;padding:36px;box-shadow:0 24px 48px rgba(31,58,94,.18);} .hero h1{margin:0 0 12px;font-size:36px;} .hero p{margin:0;line-height:1.8;color:rgba(255,255,255,.88);} .meta{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px;margin-top:24px;} .meta article{background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.14);border-radius:18px;padding:16px;} .meta span{display:block;font-size:12px;opacity:.75;letter-spacing:.04em;} .meta strong{display:block;margin-top:8px;font-size:16px;line-height:1.5;} .content{display:grid;grid-template-columns:1.3fr .7fr;gap:22px;margin-top:24px;} .card{background:#fff;border:1px solid #dfe8f2;border-radius:24px;padding:24px;box-shadow:0 18px 38px rgba(95,123,156,.08);} .tag{display:inline-flex;padding:6px 12px;border-radius:999px;background:#edf5ff;color:#2a6fb7;font-size:12px;font-weight:700;} .footer{margin-top:20px;color:#7b8a9a;font-size:13px;} @media (max-width:860px){.meta,.content{grid-template-columns:1fr;}}\n</style>\n</head>\n<body>\n<div class=\"shell\">\n<div class=\"hero\">\n<div class=\"tag\">CampusAI 活动静态页</div>\n<h1>${title}</h1>\n<p>${summary}</p>\n<div class=\"meta\">\n<article><span>活动地点</span><strong>${location}</strong></article>\n<article><span>开始时间</span><strong>${startTime}</strong></article>\n<article><span>结束时间</span><strong>${endTime}</strong></article>\n<article><span>当前状态</span><strong>${status}</strong></article>\n</div>\n</div>\n<div class=\"content\">\n<section class=\"card\">\n<h2>活动亮点</h2>\n<p style=\"line-height:1.9;color:#546579;\">${summary}</p>\n<p style=\"line-height:1.9;color:#546579;\">本页面由 FreeMarker 自动静态化生成，适合通过 Nginx 直接发布，降低活动详情页的动态请求压力。</p>\n</section>\n<aside class=\"card\">\n<h2>报名概况</h2>\n<p><strong>${registeredCount}</strong> 人已报名</p>\n<p>适合用于课堂演示“活动发布 -> 静态页生成 -> 报名变化 -> 静态页更新”的完整链路。</p>\n<div class=\"footer\">最后生成时间：${generatedAt}</div>\n</aside>\n</div>\n</div>\n</body>\n</html>\n");
         Configuration configuration = new Configuration(Configuration.VERSION_2_3_33);
         configuration.setTemplateLoader(loader);
         Template template = configuration.getTemplate("activity", StandardCharsets.UTF_8.name());
         Map<String, Object> model = new HashMap();
         model.put("title", activity.getTitle());
         model.put("location", activity.getLocation());
         model.put("startTime", activity.getStartTime());
         model.put("endTime", activity.getEndTime());
         model.put("summary", activity.getSummary());
         model.put("status", activity.getStatus());
         model.put("registeredCount", registeredCount == null ? 0 : registeredCount);
         model.put("generatedAt", LocalDateTime.now());
         StringWriter writer = new StringWriter();
         template.process(model, writer);
         Files.createDirectories(this.outputDir);
         Path outputFile = this.outputDir.resolve("activity-" + activity.getId() + ".html");
         Files.writeString(outputFile, writer.toString(), StandardCharsets.UTF_8);
         return outputFile;
      } catch (TemplateException | IOException exception) {
         throw new IllegalStateException("生成活动静态页失败", exception);
      }
   }

   public Map<String, Object> snapshot() {
      Map<String, Object> payload = new HashMap();
      payload.put("outputDir", this.outputDir.toString());
      List<String> files = new ArrayList<>();
      long generatedCount = 0L;

      try {
         Files.createDirectories(this.outputDir);
         try (var stream = Files.list(this.outputDir)) {
            List<Path> allFiles = stream.filter(Files::isRegularFile).sorted().toList();
            generatedCount = (long)allFiles.size();
            allFiles.stream().limit(6L).forEach((path) -> files.add(path.getFileName().toString()));
         }
      } catch (IOException exception) {
         payload.put("error", exception.getMessage());
      }

      payload.put("generatedCount", generatedCount);
      payload.put("sampleFiles", files);
      return payload;
   }
}
