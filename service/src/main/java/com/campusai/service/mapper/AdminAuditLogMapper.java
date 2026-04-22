package com.campusai.service.mapper;

import com.campusai.service.entity.AdminAuditLog;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AdminAuditLogMapper {
   void ensureTable();

   void insert(AdminAuditLog var1);

   List<AdminAuditLog> pageByFilter(@Param("module") String var1, @Param("action") String var2, @Param("actionResult") String var3, @Param("operatorName") String var4, @Param("startTime") String var5, @Param("endTime") String var6, @Param("offset") int var7, @Param("pageSize") int var8);

   long countByFilter(@Param("module") String var1, @Param("action") String var2, @Param("actionResult") String var3, @Param("operatorName") String var4, @Param("startTime") String var5, @Param("endTime") String var6);
}
