package com.campusai.service.mapper;

import com.campusai.service.entity.Merchant;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MerchantMapper {
   List<Merchant> findAll(@Param("keyword") String var1);

   List<Merchant> findAllInIds(@Param("keyword") String var1, @Param("merchantIds") List<Long> var2);

   List<Merchant> findApproved();

   Merchant findById(@Param("id") Long var1);

   void insert(Merchant var1);

   void update(Merchant var1);

   void updateAuditStatus(@Param("id") Long var1, @Param("auditStatus") String var2);
}
