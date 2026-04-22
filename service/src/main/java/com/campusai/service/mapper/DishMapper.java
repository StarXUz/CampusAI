package com.campusai.service.mapper;

import com.campusai.service.entity.Dish;
import com.campusai.service.entity.DishCategory;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface DishMapper {
   List<DishCategory> findCategoriesByMerchant(@Param("merchantId") Long var1);

   void insertCategory(DishCategory var1);

   List<Dish> findDishes(@Param("merchantId") Long var1, @Param("onlyOnSale") Boolean var2, @Param("categoryId") Long var3, @Param("keyword") String var4, @Param("includeSoldOut") Boolean var5, @Param("onSale") Boolean var6);

   Dish findDishById(@Param("id") Long var1);

   void insertDish(Dish var1);

   void updateDish(Dish var1);

   void deleteDish(@Param("id") Long var1);
}
