package com.campusai.service.mapper;

import com.campusai.service.entity.Activity;
import com.campusai.service.entity.ActivityRegistration;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ActivityMapper {
   List<Activity> findAll();

   Activity findById(@Param("id") Long var1);

   void insertActivity(Activity var1);

   void updateActivity(Activity var1);

   void deleteActivity(@Param("id") Long var1);

   int countRegistrations(@Param("activityId") Long var1);

   List<ActivityRegistration> findRegistrationsByActivity(@Param("activityId") Long var1);

   ActivityRegistration findRegistration(@Param("activityId") Long var1, @Param("userId") Long var2);

   List<ActivityRegistration> findRegistrationsByUser(@Param("userId") Long var1);

   void insertRegistration(ActivityRegistration var1);

   void updateRegistration(ActivityRegistration var1);

   void cancelRegistration(@Param("activityId") Long var1, @Param("userId") Long var2);
}
