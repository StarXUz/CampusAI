package com.campusai.service.mapper;

import com.campusai.service.entity.MealPackage;
import com.campusai.service.entity.PackageDish;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MealPackageMapper {
   List<MealPackage> findByMerchant(@Param("merchantId") Long var1);

   MealPackage findById(@Param("id") Long var1);

   void insert(MealPackage var1);

   void update(MealPackage var1);

   void deletePackage(@Param("id") Long var1);

   void deleteDishRelations(@Param("packageId") Long var1);

   void insertDishRelation(PackageDish var1);

   List<PackageDish> findDishRelations(@Param("packageId") Long var1);
}
