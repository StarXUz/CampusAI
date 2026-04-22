package com.campusai.web.config;

import com.campusai.service.service.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class OrderTimeoutScheduler {
   private static final Logger log = LoggerFactory.getLogger(OrderTimeoutScheduler.class);
   private final OrderService orderService;

   public OrderTimeoutScheduler(OrderService orderService) {
      this.orderService = orderService;
   }

   @Scheduled(fixedDelayString = "${app.order.timeout-scan-ms:60000}", initialDelay = 15000L)
   public void cancelTimeoutOrders() {
      int cancelled = this.orderService.cancelTimeoutOrders();
      if (cancelled > 0) {
         log.info("订单超时自动取消执行完成，本轮取消 {} 条未支付订单", cancelled);
      }
   }
}
