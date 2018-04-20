package com.spring.serviceImp;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.spring.domain.UserPrincipal;
import com.spring.mapper.entities.UserRole;
import com.spring.service.TeacherService;

@Service("userDetailService")
//this "ID"
public class UserDetailServiceImp implements UserDetailsService {
	@Autowired
	private TeacherService teacherService;

	@Override
	public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
		Optional<UserRole> user = teacherService.getUserRoleByEmail(email);
		System.out.println(email);
		if (!user.isPresent()) {
			throw new UsernameNotFoundException("Email not found!");
		}
		System.out.println(user.get());
		return new UserPrincipal(user.get());
	}

}
