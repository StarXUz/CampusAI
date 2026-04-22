package com.campusai.service.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface DashboardMapper {
   Map<String, Object> querySummary();

   Map<String, Object> querySummaryByMerchantIds(@Param("merchantIds") List<Long> var1);

   List queryRegisterTrend();

   List queryOrderRatio();

   List queryOrderRatioByMerchantIds(@Param("merchantIds") List<Long> var1);

   List queryStudyRoomUsage();

   List queryActivityHotRank();

   List queryMonthlyOperationReport();

   List queryMonthlyOperationReportByMerchantIds(@Param("merchantIds") List<Long> var1);
}
