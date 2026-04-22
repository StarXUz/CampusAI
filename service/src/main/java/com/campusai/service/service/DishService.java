package com.campusai.service.service;

import com.campusai.common.api.PageResult;
import com.campusai.common.util.AssertUtils;
import com.campusai.service.dto.DishQuery;
import com.campusai.service.dto.PageQuery;
import com.campusai.service.entity.Dish;
import com.campusai.service.entity.DishCategory;
import com.campusai.service.mapper.DishMapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class DishService {
   private final DishMapper dishMapper;

   public DishService(DishMapper dishMapper) {
      this.dishMapper = dishMapper;
   }

   public List<DishCategory> listCategories(Long merchantId) {
      return this.dishMapper.findCategoriesByMerchant(merchantId);
   }

   public DishCategory saveCategory(DishCategory category) {
      AssertUtils.notNull(category.getMerchantId(), "商家ID不能为空");
      AssertUtils.notBlank(category.getName(), "分类名称不能为空");
      this.dishMapper.insertCategory(category);
      return category;
   }

   public PageResult pageMerchantDishes(Long merchantId, PageQuery query, boolean onlyOnSale) {
      DishQuery dishQuery;
      if (query instanceof DishQuery casted) {
         dishQuery = casted;
      } else {
         dishQuery = new DishQuery();
         dishQuery.setPageNum(query.getPageNum());
         dishQuery.setPageSize(query.getPageSize());
         dishQuery.setKeyword(query.getKeyword());
      }

      if (onlyOnSale) {
         dishQuery.setIncludeSoldOut(Boolean.FALSE);
         dishQuery.setOnSale(Boolean.TRUE);
      } else if (dishQuery.getIncludeSoldOut() == null) {
         dishQuery.setIncludeSoldOut(Boolean.TRUE);
      }

      PageHelper.startPage(query.getPageNum(), query.getPageSize());
      List<Dish> dishes = this.dishMapper.findDishes(merchantId, onlyOnSale, dishQuery.getCategoryId(), dishQuery.getKeyword(), dishQuery.getIncludeSoldOut(), dishQuery.getOnSale());
      return new PageResult(PageInfo.of(dishes).getTotal(), dishes);
   }

   public Dish findDish(Long id) {
      AssertUtils.notNull(id, "菜品ID不能为空");
      Dish dish = this.dishMapper.findDishById(id);
      AssertUtils.notNull(dish, "菜品不存在");
      return dish;
   }

   public Dish saveDish(Dish dish) {
      AssertUtils.notNull(dish.getMerchantId(), "商家ID不能为空");
      AssertUtils.notBlank(dish.getName(), "菜品名称不能为空");
      AssertUtils.notNull(dish.getCategoryId(), "菜品分类不能为空");
      if (dish.getOnSale() == null) {
         dish.setOnSale(Boolean.TRUE);
      }

      if (dish.getCalories() == null) {
         dish.setCalories(0);
      }

      if (dish.getId() == null) {
         this.dishMapper.insertDish(dish);
      } else {
         this.findDish(dish.getId());
         this.dishMapper.updateDish(dish);
      }

      return this.findDish(dish.getId());
   }

   public void deleteDish(Long id) {
      this.findDish(id);
      this.dishMapper.deleteDish(id);
   }
}
