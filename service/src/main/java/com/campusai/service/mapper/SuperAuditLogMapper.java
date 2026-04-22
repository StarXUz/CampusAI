package com.campusai.service.mapper;

import com.campusai.service.entity.SuperAuditLog;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SuperAuditLogMapper {
   void ensureTable();

   void insert(SuperAuditLog var1);

   List<SuperAuditLog> listLatest(@Param("limit") int var1);

   List<SuperAuditLog> listByFilter(@Param("operationType") String var1, @Param("operatorName") String var2, @Param("actionResult") String var3, @Param("startTime") String var4, @Param("endTime") String var5, @Param("limit") int var6);

   List<SuperAuditLog> pageByFilter(@Param("operationType") String var1, @Param("operatorName") String var2, @Param("actionResult") String var3, @Param("startTime") String var4, @Param("endTime") String var5, @Param("offset") int var6, @Param("pageSize") int var7);

   long countByFilter(@Param("operationType") String var1, @Param("operatorName") String var2, @Param("actionResult") String var3, @Param("startTime") String var4, @Param("endTime") String var5);

   List<Map<String, Object>> queryDailyStats(@Param("startDate") String var1);
}
