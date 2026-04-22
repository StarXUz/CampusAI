package com.campusai.service.service;

import com.campusai.common.util.AssertUtils;
import com.campusai.service.entity.User;
import com.campusai.service.mapper.UserMapper;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Service;

@Service
public class MerchantAdminScopeService implements InitializingBean {
   private static final Set<String> SUPER_ADMIN_CODES = Set.of("ROLE_SUPER_ADMIN", "SUPER_ADMIN");
   private static final Set<String> MERCHANT_ADMIN_CODES = Set.of("ROLE_MERCHANT_ADMIN", "MERCHANT_ADMIN");
   private final JdbcTemplate jdbcTemplate;
   private final UserMapper userMapper;

   public MerchantAdminScopeService(JdbcTemplate jdbcTemplate, UserMapper userMapper) {
      this.jdbcTemplate = jdbcTemplate;
      this.userMapper = userMapper;
   }

   public void afterPropertiesSet() {
      this.jdbcTemplate.execute("create table if not exists campus_admin_merchant_scope (" +
         "id bigint primary key auto_increment," +
         "user_id bigint not null," +
         "merchant_id bigint not null," +
         "created_at datetime not null default current_timestamp," +
         "unique key uk_admin_merchant_scope (user_id, merchant_id)," +
         "index idx_admin_scope_user (user_id)," +
         "index idx_admin_scope_merchant (merchant_id)," +
         "constraint fk_admin_scope_user foreign key (user_id) references campus_user(id) on delete cascade," +
         "constraint fk_admin_scope_merchant foreign key (merchant_id) references campus_merchant(id) on delete cascade" +
         ")");
      this.seedDefaultMappingsIfEmpty();
   }

   public boolean isSuperAdmin(Authentication authentication) {
      return this.hasAuthority(authentication, SUPER_ADMIN_CODES);
   }

   public boolean isMerchantAdmin(Authentication authentication) {
      return !this.isSuperAdmin(authentication) && this.hasAuthority(authentication, MERCHANT_ADMIN_CODES);
   }

   public List<Long> listAccessibleMerchantIds(Authentication authentication) {
      if (this.isSuperAdmin(authentication) || this.isMerchantAdmin(authentication)) {
         return this.queryAllMerchantIds();
      } else {
         return List.of();
      }
   }

   public void assertMerchantAccessible(Authentication authentication, Long merchantId) {
      AssertUtils.notNull(merchantId, "商家ID不能为空");
      if (!this.isSuperAdmin(authentication)) {
         List<Long> merchantIds = this.listAccessibleMerchantIds(authentication);
         AssertUtils.isTrue(merchantIds.contains(merchantId), "你没有当前商家数据权限");
      }
   }

   public Map<String, Object> buildAdminContext(Authentication authentication) {
      boolean superAdmin = this.isSuperAdmin(authentication);
      boolean admin = this.isMerchantAdmin(authentication);
      List<Long> merchantIds = admin || superAdmin ? this.listAccessibleMerchantIds(authentication) : List.of();
      Map<String, Object> payload = new LinkedHashMap<>();
      payload.put("roleScope", superAdmin ? "SUPER_ADMIN" : admin ? "ADMIN" : "UNKNOWN");
      payload.put("merchantScoped", false);
      payload.put("allowedMerchantIds", merchantIds);
      payload.put("canCreateMerchant", admin || superAdmin);
      payload.put("canAuditMerchants", admin || superAdmin);
      payload.put("canManageGlobalModules", admin || superAdmin);
      payload.put("operatorName", authentication != null ? authentication.getName() : "admin");
      return payload;
   }

   private boolean hasAuthority(Authentication authentication, Set<String> expectedCodes) {
      return authentication != null && authentication.getAuthorities() != null && authentication.getAuthorities().stream().map(GrantedAuthority::getAuthority).anyMatch(expectedCodes::contains);
   }

   private List<Long> queryAllMerchantIds() {
      return this.jdbcTemplate.queryForList("select id from campus_merchant order by id", Long.class);
   }

   private void seedDefaultMappingsIfEmpty() {
      Integer count = this.jdbcTemplate.queryForObject("select count(1) from campus_admin_merchant_scope", Integer.class);
      if (count != null && count > 0) {
         return;
      }

      this.insertDefaultScope("merchant_north", List.of(1L, 2L));
      this.insertDefaultScope("merchant_south", List.of(3L, 4L));
      this.insertDefaultScope("merchant_west", List.of(5L, 6L));
   }

   private void insertDefaultScope(String username, List<Long> merchantIds) {
      User user = this.userMapper.findByUsername(username);
      if (user == null || merchantIds == null || merchantIds.isEmpty()) {
         return;
      }

      List<Long> existingMerchantIds = this.queryAllMerchantIds();
      List<Long> validMerchantIds = merchantIds.stream().filter(existingMerchantIds::contains).collect(Collectors.toList());

      for(Long merchantId : validMerchantIds) {
         this.jdbcTemplate.update("insert ignore into campus_admin_merchant_scope (user_id, merchant_id) values (?, ?)", user.getId(), merchantId);
      }
   }
}
