package com.spring.service;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.Department;

public interface DepartmentService {
	public List<?> getAllRecord();

	public Optional<?> getAllDepartment();

	public int createDepartment(Department department);

	public Department getDepartmentById(long departmentId);
}