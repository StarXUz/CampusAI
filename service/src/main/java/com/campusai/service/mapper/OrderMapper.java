package com.campusai.service.mapper;

import com.campusai.service.entity.Order;
import java.time.LocalDateTime;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface OrderMapper {
   void insert(Order var1);

   Order findById(@Param("id") Long var1);

   Order findByIdForUpdate(@Param("id") Long var1);

   List<Order> findByUserId(@Param("userId") Long var1);

   int markPaid(@Param("id") Long var1, @Param("payChannel") String var2, @Param("paidAt") LocalDateTime var3);

   int cancelTimeoutUnpaid(@Param("deadline") LocalDateTime var1);
}
