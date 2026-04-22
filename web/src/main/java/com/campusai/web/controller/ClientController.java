package com.campusai.web.controller;

import com.campusai.common.api.ApiResponse;
import com.campusai.service.dto.ActivitySignupRequest;
import com.campusai.service.dto.AiChatRequest;
import com.campusai.service.dto.ClientOrderCreateRequest;
import com.campusai.service.dto.ClientOrderPayRequest;
import com.campusai.service.dto.DishQuery;
import com.campusai.service.dto.StudyRoomBookingRequest;
import com.campusai.service.entity.ReservationRecord;
import com.campusai.service.service.ActivityService;
import com.campusai.service.service.AiAssistantService;
import com.campusai.service.service.DishService;
import com.campusai.service.service.MealPackageService;
import com.campusai.service.service.MerchantService;
import com.campusai.service.service.OrderService;
import com.campusai.service.service.StudyRoomService;
import com.campusai.web.config.ClientSessionSupport;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping({"/api/client"})
public class ClientController {
   private final MerchantService merchantService;
   private final DishService dishService;
   private final MealPackageService mealPackageService;
   private final StudyRoomService studyRoomService;
   private final ActivityService activityService;
   private final OrderService orderService;
   private final AiAssistantService aiAssistantService;

   public ClientController(MerchantService merchantService, DishService dishService, MealPackageService mealPackageService, StudyRoomService studyRoomService, ActivityService activityService, OrderService orderService, AiAssistantService aiAssistantService) {
      this.merchantService = merchantService;
      this.dishService = dishService;
      this.mealPackageService = mealPackageService;
      this.studyRoomService = studyRoomService;
      this.activityService = activityService;
      this.orderService = orderService;
      this.aiAssistantService = aiAssistantService;
   }

   @GetMapping({"/merchants"})
   public ApiResponse listApprovedMerchants() {
      return ApiResponse.success(this.merchantService.listApprovedMerchants());
   }

   @GetMapping({"/merchants/{merchantId}/categories"})
   public ApiResponse listMerchantCategories(@PathVariable("merchantId") Long merchantId) {
      return ApiResponse.success(this.dishService.listCategories(merchantId));
   }

   @GetMapping({"/merchants/{merchantId}/dishes"})
   public ApiResponse listMerchantDishes(@PathVariable("merchantId") Long merchantId, @RequestParam(value = "pageNum",defaultValue = "1") int pageNum, @RequestParam(value = "pageSize",defaultValue = "10") int pageSize, @RequestParam(value = "keyword", required = false) String keyword, @RequestParam(value = "categoryId", required = false) Long categoryId, @RequestParam(value = "includeSoldOut", defaultValue = "true") boolean includeSoldOut) {
      DishQuery query = new DishQuery();
      query.setPageNum(pageNum);
      query.setPageSize(pageSize);
      query.setKeyword(keyword);
      query.setCategoryId(categoryId);
      query.setIncludeSoldOut(includeSoldOut);
      return ApiResponse.success(this.dishService.pageMerchantDishes(merchantId, query, !includeSoldOut));
   }

   @GetMapping({"/merchants/{merchantId}/packages"})
   public ApiResponse listMerchantPackages(@PathVariable("merchantId") Long merchantId) {
      return ApiResponse.success(this.mealPackageService.listPackages(merchantId));
   }

   @GetMapping({"/study-rooms"})
   public ApiResponse listRooms() {
      return ApiResponse.success(this.studyRoomService.listRooms());
   }

   @GetMapping({"/study-rooms/{roomId}/seats"})
   public ApiResponse listSeats(@PathVariable("roomId") Long roomId, @RequestParam(value = "reservationDate",required = false) LocalDate reservationDate, @RequestParam(value = "startTime",required = false) LocalTime startTime, @RequestParam(value = "endTime",required = false) LocalTime endTime) {
      return ApiResponse.success(this.studyRoomService.listSeats(roomId, reservationDate, startTime, endTime));
   }

   @GetMapping({"/study-rooms/reservations/mine"})
   public ApiResponse myReservations(HttpSession session) {
      return ApiResponse.success(this.studyRoomService.listMyReservations(this.currentUserId(session)));
   }

   @PostMapping({"/study-rooms/reserve"})
   public ApiResponse reserve(@RequestBody StudyRoomBookingRequest request, HttpSession session) {
      ReservationRecord record = this.studyRoomService.reserve(this.currentUserId(session), request);
      Map<String, Object> payload = new LinkedHashMap();
      payload.put("voucherCode", record.getVoucherCode());
      payload.put("status", record.getStatus());
      payload.put("reservationDate", record.getReservationDate());
      payload.put("startTime", record.getStartTime());
      payload.put("endTime", record.getEndTime());
      return ApiResponse.success("预约成功", payload);
   }

   @PostMapping({"/study-rooms/reservations/{reservationId}/cancel"})
   public ApiResponse cancelReservation(@PathVariable("reservationId") Long reservationId, HttpSession session) {
      this.studyRoomService.cancelReservation(this.currentUserId(session), reservationId);
      return ApiResponse.success("预约已取消", (Object)null);
   }

   @PostMapping({"/study-rooms/reservations/{reservationId}/reschedule"})
   public ApiResponse rescheduleReservation(@PathVariable("reservationId") Long reservationId, @RequestBody StudyRoomBookingRequest request, HttpSession session) {
      ReservationRecord record = this.studyRoomService.rescheduleReservation(this.currentUserId(session), reservationId, request);
      Map<String, Object> payload = new LinkedHashMap();
      payload.put("id", record.getId());
      payload.put("status", record.getStatus());
      payload.put("reservationDate", record.getReservationDate());
      payload.put("startTime", record.getStartTime());
      payload.put("endTime", record.getEndTime());
      payload.put("seatId", record.getSeatId());
      payload.put("studyRoomId", record.getStudyRoomId());
      return ApiResponse.success("改期成功", payload);
   }

   @GetMapping({"/activities"})
   public ApiResponse listActivities() {
      return ApiResponse.success(this.activityService.listActivities());
   }

   @GetMapping({"/activities/mine"})
   public ApiResponse myActivities(HttpSession session) {
      return ApiResponse.success(this.activityService.listMyRegistrations(this.currentUserId(session)));
   }

   @GetMapping({"/orders/mine"})
   public ApiResponse myOrders(HttpSession session) {
      return ApiResponse.success(this.orderService.listMyOrders(this.currentUserId(session)));
   }

   @PostMapping({"/orders"})
   public ApiResponse createOrder(@RequestBody ClientOrderCreateRequest request, HttpSession session) {
      return ApiResponse.success("订单已创建，请确认支付", this.orderService.createOrder(this.currentUserId(session), request));
   }

   @PostMapping({"/orders/{orderId}/pay"})
   public ApiResponse payOrder(@PathVariable("orderId") Long orderId, @RequestBody ClientOrderPayRequest request, HttpSession session) {
      return ApiResponse.success("支付成功", this.orderService.payOrder(this.currentUserId(session), orderId, request.getPayChannel()));
   }

   @PostMapping({"/activities/signup"})
   public ApiResponse signup(@RequestBody ActivitySignupRequest request, HttpSession session) {
      return ApiResponse.success("报名成功", this.activityService.signUp(this.currentUserId(session), request));
   }

   @PostMapping({"/activities/{activityId}/cancel"})
   public ApiResponse cancelSignup(@PathVariable("activityId") Long activityId, HttpSession session) {
      this.activityService.cancel(this.currentUserId(session), activityId);
      return ApiResponse.success("取消报名成功", (Object)null);
   }

   @PostMapping({"/ai/chat"})
   public ApiResponse chat(@RequestBody AiChatRequest request, HttpSession session) {
      Map<String, String> payload = new LinkedHashMap();
      payload.put("answer", this.aiAssistantService.ask(request.getScene(), request.getQuestion(), this.currentUserId(session)));
      return ApiResponse.success(payload);
   }

   private Long currentUserId(HttpSession session) {
      Long userId = ClientSessionSupport.getCurrentUserId(session);
      if (userId == null) {
         throw new IllegalStateException("请先登录后再使用功能");
      } else {
         return userId;
      }
   }
}
