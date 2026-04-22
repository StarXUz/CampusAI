package com.campusai.service.mapper;

import com.campusai.service.entity.Role;
import com.campusai.service.entity.User;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserMapper {
   User findById(@Param("id") Long var1);

   User findByUsername(@Param("username") String var1);

   User findByPhone(@Param("phone") String var1);

   List<Role> findRolesByUserId(@Param("userId") Long var1);

   Role findRoleByCode(@Param("code") String var1);

   List<User> findUsersByRoleCode(@Param("roleCode") String var1, @Param("keyword") String var2);

   List<User> findUsersByRoleCodes(@Param("roleCodes") List<String> var1, @Param("keyword") String var2);

   void insertUser(User var1);

   void updateUser(User var1);

   void insertUserRole(@Param("userId") Long var1, @Param("roleId") Long var2);

   void deleteUserRoles(@Param("userId") Long var1);

   void deleteUser(@Param("userId") Long var1);
}
