package com.campusai.service.service;

import org.apache.curator.framework.CuratorFramework;
import org.apache.curator.framework.CuratorFrameworkFactory;
import org.apache.curator.retry.ExponentialBackoffRetry;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class ZookeeperConfigService {
   @Value("${zookeeper.enabled:false}")
   private boolean enabled;
   @Value("${zookeeper.connect-string:127.0.0.1:2181}")
   private String connectString;

   public String loadConfig(String path) {
      if (!this.enabled) {
         return "ZooKeeper 未启用，当前使用本地配置";
      } else {
         try {
            CuratorFramework client = CuratorFrameworkFactory.newClient(this.connectString, new ExponentialBackoffRetry(1000, 3));

            String var4;
            try {
               client.start();
               byte[] bytes = (byte[])client.getData().forPath(path);
               var4 = new String(bytes);
            } catch (Throwable var6) {
               if (client != null) {
                  try {
                     client.close();
                  } catch (Throwable var5) {
                     var6.addSuppressed(var5);
                  }
               }

               throw var6;
            }

            if (client != null) {
               client.close();
            }

            return var4;
         } catch (Exception exception) {
            return "ZooKeeper 读取失败：" + exception.getMessage();
         }
      }
   }
}
