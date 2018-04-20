package com.spring.repository;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.UserRole;

public interface TeacherRepository {

	public List<?> getAllRecord();

	public List<String> getRoleOfUserByEmail(String email);

	public List<UserRole> getAllUserRole();

	public Optional<UserRole> getUserRoleByEmail(String email);
}
