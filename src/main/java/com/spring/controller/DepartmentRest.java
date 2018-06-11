package com.spring.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.mapper.entities.Department;
import com.spring.service.DepartmentService;

@RestController
@RequestMapping (value = "/department")
public class DepartmentRest {
	
	@Autowired
	private DepartmentService departmentService;
	
	@RequestMapping(value = "/all-department")
	public ResponseEntity<?> getAllDepartment() {
		Optional<?> optional = this.departmentService.getAllDepartment();
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}
	
	@RequestMapping(value = "/create", method = RequestMethod.POST)
	public ResponseEntity<?> createDepartment(@RequestBody Department department) {
		int result = this.departmentService.createDepartment(department);
		if (result > 0)
			return new ResponseEntity<>(result, HttpStatus.CREATED);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}
	
	@RequestMapping(value = "/{departmentId}", method = RequestMethod.GET)
	public ResponseEntity<?> getDepartmentById(@PathVariable long departmentId) {
		Department department = this.departmentService.getDepartmentById(departmentId);
		return new ResponseEntity<>(department, HttpStatus.OK);
	}

}
