package com.campusai.service.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SuperSyncMapper {
   Map<String, Object> querySharedSummary();

   List<Map<String, Object>> queryLatestMerchants();

   List<Map<String, Object>> queryLatestActivities();

   List<Map<String, Object>> queryLatestOrders();

   List<Map<String, Object>> queryLatestReservations();

   Map<String, Object> queryUserBizUsage(@Param("userId") Long userId);
}
