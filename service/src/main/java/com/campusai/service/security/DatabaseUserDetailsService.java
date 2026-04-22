package com.campusai.service.security;

import com.campusai.service.entity.Role;
import com.campusai.service.entity.User;
import com.campusai.service.mapper.UserMapper;
import java.util.ArrayList;
import java.util.List;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class DatabaseUserDetailsService implements UserDetailsService {
   private final UserMapper userMapper;

   public DatabaseUserDetailsService(UserMapper userMapper) {
      this.userMapper = userMapper;
   }

   public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
      User user = this.userMapper.findByUsername(username);
      if (user == null) {
         user = this.userMapper.findByPhone(username);
      }

      if (user == null) {
         throw new UsernameNotFoundException("用户不存在");
      } else {
         List<Role> roles = this.userMapper.findRolesByUserId(user.getId());
         List<GrantedAuthority> authorities = new ArrayList();

         for(Role role : roles) {
            authorities.add(new SimpleGrantedAuthority(role.getCode()));
         }

         return org.springframework.security.core.userdetails.User.withUsername(user.getUsername()).password(user.getPassword()).authorities(authorities).disabled(!Boolean.TRUE.equals(user.getEnabled())).build();
      }
   }
}
