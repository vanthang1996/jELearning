package com.spring.repository;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.Department;

public interface DepartmentRepository {

	public List<Department> getAllRecord();

	public Optional<?> getAllDepartment();

}
