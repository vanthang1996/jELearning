package com.spring.serviceImp;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.Department;
import com.spring.repository.DepartmentRepository;
import com.spring.service.DepartmentService;

@Service
public class DepartmentServiceImp implements DepartmentService {
	@Autowired
	private DepartmentRepository departmentRepository;

	@Override
	public List<Department> getAllRecord() {
		// TODO Auto-generated method stub
		return this.departmentRepository.getAllRecord();
	}

	@Override
	public Optional<?> getAllDepartment() {
		// TODO Auto-generated method stub
		return this.departmentRepository.getAllDepartment();
	}

	@Override
	public int createDepartment(Department department) {
		return this.departmentRepository.createDepartment(department);
	}

	@Override
	public Department getDepartmentById(long departmentId) {
		// TODO Auto-generated method stub
		return this.departmentRepository.getDepartmentById(departmentId);
	}
}
