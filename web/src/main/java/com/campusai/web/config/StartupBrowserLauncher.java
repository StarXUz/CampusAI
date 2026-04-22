package com.campusai.web.config;

import java.awt.Desktop;
import java.awt.GraphicsEnvironment;
import java.net.URI;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.boot.web.context.WebServerApplicationContext;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
public class StartupBrowserLauncher {
   private final WebServerApplicationContext webServerApplicationContext;
   @Value("${app.startup.open-browser:false}")
   private boolean openBrowserOnStartup;
   @Value("${app.startup.host:127.0.0.1}")
   private String host;
   @Value("${app.startup.admin-host:${app.startup.host:127.0.0.1}}")
   private String adminHost;
   @Value("${app.startup.client-host:${app.startup.host:127.0.0.1}}")
   private String clientHost;
   @Value("${app.startup.super-host:${app.startup.host:127.0.0.1}}")
   private String superHost;
   @Value("${app.startup.admin-port:${server.port:8091}}")
   private int adminPort;
   @Value("${app.startup.client-port:8092}")
   private int clientPort;
   @Value("${app.startup.super-port:8093}")
   private int superPort;

   public StartupBrowserLauncher(WebServerApplicationContext webServerApplicationContext) {
      this.webServerApplicationContext = webServerApplicationContext;
   }

   @EventListener({ApplicationReadyEvent.class})
   public void openBrowser() {
      int runningPort = this.webServerApplicationContext.getWebServer().getPort();
      int finalAdminPort = this.adminPort > 0 ? this.adminPort : runningPort;
      int finalClientPort = this.clientPort > 0 ? this.clientPort : finalAdminPort;
      int finalSuperPort = this.superPort > 0 ? this.superPort : finalAdminPort;
      List<String> startupUrls = this.buildStartupUrls(finalAdminPort, finalClientPort, finalSuperPort);
      this.printStartupLinks(startupUrls);
      if (this.openBrowserOnStartup) {
         Thread.startVirtualThread(() -> {
            try {
               for (String url : startupUrls) {
                  if (!this.tryOpenByCommand(url) && (!GraphicsEnvironment.isHeadless() || Desktop.isDesktopSupported())) {
                     Desktop.getDesktop().browse(URI.create(url));
                  }

                  Thread.sleep(200L);
               }
            } catch (Exception var2) {
               System.out.println("浏览器自动打开失败，请手动访问上方链接。");
            }

         });
      }
   }

   private List<String> buildStartupUrls(int finalAdminPort, int finalClientPort, int finalSuperPort) {
      Set<String> urls = new LinkedHashSet<>();
      urls.add("http://" + this.resolveHost(this.adminHost) + ":" + finalAdminPort + "/login/admin");
      urls.add("http://" + this.resolveHost(this.clientHost) + ":" + finalClientPort + "/client");
      urls.add("http://" + this.resolveHost(this.superHost) + ":" + finalSuperPort + "/login/super");
      return new ArrayList(urls);
   }

   private void printStartupLinks(List<String> startupUrls) {
      System.out.println();
      System.out.println("Campus Service Manager AI 已启动，端口说明如下：");
      if (!startupUrls.isEmpty()) {
         System.out.println(" - 管理端登录(ADMIN) : " + startupUrls.get(0));
      }

      if (startupUrls.size() > 1) {
         System.out.println(" - 学生端首页(CLIENT): " + startupUrls.get(1));
      }

      if (startupUrls.size() > 2) {
         System.out.println(" - 超级端登录(SUPER) : " + startupUrls.get(2));
      }

      System.out.println(" - 运维提示              : 所有API错误会返回JSON与追踪头 X-Request-Id");
      System.out.println(" - 订单超时任务          : 每60秒扫描一次未支付超时订单");

      System.out.println();
   }

   private boolean tryOpenByCommand(String url) {
      String osName = System.getProperty("os.name", "").toLowerCase(Locale.ROOT);

      try {
         Process process;
         if (osName.contains("mac")) {
            process = (new ProcessBuilder(new String[]{"open", url})).start();
         } else if (osName.contains("win")) {
            process = (new ProcessBuilder(new String[]{"rundll32", "url.dll,FileProtocolHandler", url})).start();
         } else {
            if (!osName.contains("nix") && !osName.contains("nux")) {
               return false;
            }

            process = (new ProcessBuilder(new String[]{"xdg-open", url})).start();
         }

         return process.isAlive() || process.exitValue() == 0;
      } catch (Exception var5) {
         return false;
      }
   }

   private String resolveHost(String preferredHost) {
      String resolved = preferredHost != null && !preferredHost.isBlank() ? preferredHost : this.host;
      return resolved.contains(":") && !resolved.startsWith("[") ? "[" + resolved + "]" : resolved;
   }
}
