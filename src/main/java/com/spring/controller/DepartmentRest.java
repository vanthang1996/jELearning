package com.spring.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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

}
