package com.spring.service;

import java.util.List;

import com.spring.mapper.entities.UserRole;

public interface TeacherService {

	public List<?> getAllRecord();

	public List<String> getRoleOfUserByEmail(String email);

	public List<UserRole> getAllRecordUserRole();
}
