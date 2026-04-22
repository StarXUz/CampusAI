package com.campusai.service.service;

import com.campusai.common.util.AssertUtils;
import com.campusai.service.dto.ClientOrderCreateRequest;
import com.campusai.service.entity.Order;
import com.campusai.service.mapper.OrderMapper;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OrderService {
   private static final long ORDER_TIMEOUT_MINUTES = 15L;
   private static final Set<String> ITEM_TYPES = Set.of("DISH", "PACKAGE");
   private static final Set<String> PAY_CHANNELS = Set.of("CAMPUS_CARD", "WECHAT", "ALIPAY");
   private final OrderMapper orderMapper;
   private final MerchantService merchantService;

   public OrderService(OrderMapper orderMapper, MerchantService merchantService) {
      this.orderMapper = orderMapper;
      this.merchantService = merchantService;
   }

   public List<Order> listMyOrders(Long userId) {
      this.cancelTimeoutOrders();
      return this.orderMapper.findByUserId(userId);
   }

   public Order findOrder(Long id) {
      AssertUtils.notNull(id, "订单ID不能为空");
      Order order = this.orderMapper.findById(id);
      AssertUtils.notNull(order, "订单不存在");
      return order;
   }

   @Transactional
   public Order createOrder(Long userId, ClientOrderCreateRequest request) {
      AssertUtils.notNull(userId, "用户不能为空");
      AssertUtils.notNull(request.getMerchantId(), "商家不能为空");
      AssertUtils.notBlank(request.getItemType(), "商品类型不能为空");
      AssertUtils.notBlank(request.getItemName(), "商品名称不能为空");
      AssertUtils.notNull(request.getTotalAmount(), "订单金额不能为空");
      AssertUtils.isTrue(request.getTotalAmount().doubleValue() > (double)0.0F, "订单金额必须大于0");
      AssertUtils.isTrue(ITEM_TYPES.contains(request.getItemType()), "不支持的商品类型");
      this.merchantService.findMerchant(request.getMerchantId());
      Order order = new Order();
      order.setUserId(userId);
      order.setMerchantId(request.getMerchantId());
      order.setItemType(request.getItemType());
      order.setItemName(request.getItemName());
      order.setTotalAmount(request.getTotalAmount());
      order.setStatus("UNPAID");
      order.setCreatedAt(LocalDateTime.now());
      this.orderMapper.insert(order);
      return this.findOrder(order.getId());
   }

   @Transactional
   public Order payOrder(Long userId, Long orderId, String payChannel) {
      this.cancelTimeoutOrders();
      AssertUtils.notBlank(payChannel, "支付方式不能为空");
      AssertUtils.isTrue(PAY_CHANNELS.contains(payChannel), "不支持的支付方式");
      Order order = this.orderMapper.findByIdForUpdate(orderId);
      AssertUtils.notNull(order, "订单不存在");
      AssertUtils.isTrue(order.getUserId().equals(userId), "只能支付自己的订单");
      if ("PAID".equals(order.getStatus())) {
         return order;
      }
      AssertUtils.isTrue("UNPAID".equals(order.getStatus()), "该订单不可支付，可能已超时取消");
      int updated = this.orderMapper.markPaid(orderId, payChannel, LocalDateTime.now());
      if (updated > 0) {
         return this.findOrder(orderId);
      } else {
         Order latest = this.findOrder(orderId);
         if ("PAID".equals(latest.getStatus())) {
            return latest;
         } else {
            throw new IllegalStateException("订单状态已变化，请刷新后重试");
         }
      }
   }

   public int cancelTimeoutOrders() {
      return this.orderMapper.cancelTimeoutUnpaid(LocalDateTime.now().minusMinutes(ORDER_TIMEOUT_MINUTES));
   }
}
