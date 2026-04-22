package com.campusai.service.service;

import com.campusai.common.api.PageResult;
import com.campusai.common.util.AssertUtils;
import com.campusai.service.dto.PageQuery;
import com.campusai.service.entity.Merchant;
import com.campusai.service.mapper.MerchantMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class MerchantService {
   private final MerchantMapper merchantMapper;

   public MerchantService(MerchantMapper merchantMapper) {
      this.merchantMapper = merchantMapper;
   }

   public PageResult pageMerchants(PageQuery query) {
      return this.pageMerchants(query, (List<Long>)null);
   }

   public PageResult pageMerchants(PageQuery query, List<Long> merchantIds) {
      if (merchantIds != null && merchantIds.isEmpty()) {
         return new PageResult(0L, List.of());
      }

      PageHelper.startPage(query.getPageNum(), query.getPageSize());
      List<Merchant> merchants = merchantIds == null ? this.merchantMapper.findAll(query.getKeyword()) : this.merchantMapper.findAllInIds(query.getKeyword(), merchantIds);
      return new PageResult(PageInfo.of(merchants).getTotal(), merchants);
   }

   public List<Merchant> listApprovedMerchants() {
      return this.merchantMapper.findApproved();
   }

   public List<Merchant> listAllMerchants() {
      return this.listAllMerchants((List<Long>)null);
   }

   public List<Merchant> listAllMerchants(List<Long> merchantIds) {
      if (merchantIds != null && merchantIds.isEmpty()) {
         return List.of();
      }

      return merchantIds == null ? this.merchantMapper.findAll((String)null) : this.merchantMapper.findAllInIds((String)null, merchantIds);
   }

   public Merchant findMerchant(Long id) {
      AssertUtils.notNull(id, "商家ID不能为空");
      Merchant merchant = this.merchantMapper.findById(id);
      AssertUtils.notNull(merchant, "商家不存在");
      return merchant;
   }

   public Merchant saveMerchant(Merchant merchant) {
      AssertUtils.notBlank(merchant.getName(), "商家名称不能为空");
      if (merchant.getAuditStatus() == null) {
         merchant.setAuditStatus("PENDING");
      }

      if (merchant.getRecommended() == null) {
         merchant.setRecommended(Boolean.FALSE);
      }

      if (merchant.getId() == null) {
         this.merchantMapper.insert(merchant);
      } else {
         this.findMerchant(merchant.getId());
         this.merchantMapper.update(merchant);
      }

      return this.findMerchant(merchant.getId());
   }

   public void auditMerchant(Long id, String auditStatus) {
      AssertUtils.notNull(id, "商家ID不能为空");
      AssertUtils.notBlank(auditStatus, "审核状态不能为空");
      this.merchantMapper.updateAuditStatus(id, auditStatus);
   }
}
