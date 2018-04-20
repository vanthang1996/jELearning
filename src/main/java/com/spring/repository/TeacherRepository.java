package com.spring.repository;

import java.util.List;

import com.spring.mapper.entities.UserRole;

public interface TeacherRepository {

	public List<?> getAllRecord();

	public List<String> getRoleOfUserByEmail(String email);

	public List<UserRole> getAllUserRole();
}
