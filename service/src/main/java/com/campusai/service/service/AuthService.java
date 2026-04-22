package com.campusai.service.service;

import com.campusai.common.util.AssertUtils;
import com.campusai.common.util.RandomCodeUtils;
import com.campusai.service.dto.ClientProfileUpdateRequest;
import com.campusai.service.dto.LoginRequest;
import com.campusai.service.entity.User;
import com.campusai.service.mapper.UserMapper;
import java.time.Duration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
   private static final Logger log = LoggerFactory.getLogger(AuthService.class);
   private static final String LOGIN_CODE_PREFIX = "campus:login:code:";
   private static final String LOGIN_LOCK_PREFIX = "campus:login:lock:";
   private static final Long CLIENT_ROLE_ID = 3L;
   private final StringRedisTemplate redisTemplate;
   private final UserMapper userMapper;
   private final PasswordEncoder passwordEncoder;

   public AuthService(StringRedisTemplate redisTemplate, UserMapper userMapper, PasswordEncoder passwordEncoder) {
      this.redisTemplate = redisTemplate;
      this.userMapper = userMapper;
      this.passwordEncoder = passwordEncoder;
   }

   public String sendLoginCode(String phone) {
      AssertUtils.notBlank(phone, "手机号不能为空");
      String lockKey = "campus:login:lock:" + phone;
      Boolean exists = this.redisTemplate.hasKey(lockKey);
      AssertUtils.isTrue(Boolean.FALSE.equals(exists), "60秒内不可重复发送验证码");
      String code = RandomCodeUtils.sixDigitCode();
      this.redisTemplate.opsForValue().set("campus:login:code:" + phone, code, Duration.ofMinutes(5L));
      this.redisTemplate.opsForValue().set(lockKey, "1", Duration.ofSeconds(60L));
      log.info("CampusAI 登录验证码 -> 手机号: {}, 验证码: {}, 有效期: 5分钟", phone, code);
      return code;
   }

   public User loginByCode(LoginRequest request) {
      AssertUtils.notBlank(request.getPhone(), "手机号不能为空");
      AssertUtils.notBlank(request.getCode(), "验证码不能为空");
      String cacheCode = (String)this.redisTemplate.opsForValue().get("campus:login:code:" + request.getPhone());
      AssertUtils.isTrue(request.getCode().equals(cacheCode), "验证码错误或已过期");
      User user = this.userMapper.findByPhone(request.getPhone());
      if (user == null) {
         user = new User();
         user.setPhone(request.getPhone());
         String var10001 = request.getPhone();
         user.setUsername("user_" + var10001.substring(Math.max(0, request.getPhone().length() - 4)));
         user.setPassword(this.passwordEncoder.encode("campus123"));
         user.setEnabled(Boolean.TRUE);
         user.setAvatarUrl("/static/img/user.svg");
         this.userMapper.insertUser(user);
         this.userMapper.insertUserRole(user.getId(), CLIENT_ROLE_ID);
         user = this.userMapper.findByPhone(request.getPhone());
      }

      this.redisTemplate.delete("campus:login:code:" + request.getPhone());
      return user;
   }

   public User getUserById(Long userId) {
      AssertUtils.notNull(userId, "用户信息不存在，请重新登录");
      User user = this.userMapper.findById(userId);
      AssertUtils.notNull(user, "用户不存在，请重新登录");
      user.setRoles(this.userMapper.findRolesByUserId(userId));
      return user;
   }

   public User updateClientProfile(Long userId, ClientProfileUpdateRequest request) {
      AssertUtils.notNull(userId, "未登录，无法更新个人信息");
      AssertUtils.notNull(request, "请求参数不能为空");
      String username = request.getUsername() == null ? null : request.getUsername().trim();
      String phone = request.getPhone() == null ? null : request.getPhone().trim();
      AssertUtils.notBlank(username, "姓名不能为空");
      AssertUtils.notBlank(phone, "手机号不能为空");
      User current = this.getUserById(userId);
      User existed = this.userMapper.findByPhone(phone);
      AssertUtils.isTrue(existed == null || existed.getId().equals(userId), "该手机号已被其他账号使用");
      current.setUsername(username);
      current.setPhone(phone);
      String avatarUrl = request.getAvatarUrl() == null ? "" : request.getAvatarUrl().trim();
      if (!avatarUrl.isBlank()) {
         current.setAvatarUrl(avatarUrl);
      } else if (current.getAvatarUrl() == null || current.getAvatarUrl().isBlank()) {
         current.setAvatarUrl("/static/img/user.svg");
      }

      this.userMapper.updateUser(current);
      return this.getUserById(userId);
   }
}
