package com.campusai.service.service;

import com.campusai.common.util.AssertUtils;
import com.campusai.service.entity.MealPackage;
import com.campusai.service.entity.PackageDish;
import com.campusai.service.mapper.MealPackageMapper;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MealPackageService {
   private final MealPackageMapper mealPackageMapper;

   public MealPackageService(MealPackageMapper mealPackageMapper) {
      this.mealPackageMapper = mealPackageMapper;
   }

   public List<MealPackage> listPackages(Long merchantId) {
      return this.mealPackageMapper.findByMerchant(merchantId);
   }

   public MealPackage findPackage(Long id) {
      AssertUtils.notNull(id, "套餐ID不能为空");
      MealPackage mealPackage = this.mealPackageMapper.findById(id);
      AssertUtils.notNull(mealPackage, "套餐不存在");
      return mealPackage;
   }

   public List<PackageDish> findPackageRelations(Long packageId) {
      this.findPackage(packageId);
      return this.mealPackageMapper.findDishRelations(packageId);
   }

   @Transactional
   public MealPackage savePackage(MealPackage mealPackage, List<PackageDish> relations) {
      AssertUtils.notNull(mealPackage.getMerchantId(), "商家ID不能为空");
      AssertUtils.notBlank(mealPackage.getName(), "套餐名称不能为空");
      if (mealPackage.getId() == null) {
         this.mealPackageMapper.insert(mealPackage);
      } else {
         this.findPackage(mealPackage.getId());
         this.mealPackageMapper.update(mealPackage);
         this.mealPackageMapper.deleteDishRelations(mealPackage.getId());
      }

      if (relations != null) {
         for(PackageDish relation : relations) {
            relation.setPackageId(mealPackage.getId());
            this.mealPackageMapper.insertDishRelation(relation);
         }
      }

      return this.findPackage(mealPackage.getId());
   }

   @Transactional
   public void deletePackage(Long packageId) {
      this.findPackage(packageId);
      this.mealPackageMapper.deleteDishRelations(packageId);
      this.mealPackageMapper.deletePackage(packageId);
   }
}
