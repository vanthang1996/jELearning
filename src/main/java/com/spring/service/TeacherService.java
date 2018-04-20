package com.spring.service;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.UserRole;

public interface TeacherService {

	public List<?> getAllRecord();

	public List<String> getRoleOfUserByEmail(String email);

	public List<UserRole> getAllRecordUserRole();

	public Optional<UserRole> getUserRoleByEmail(String email);
}
