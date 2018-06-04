package com.spring.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.service.JobTypeService;

@RestController
@RequestMapping("/job-type")
public class JobTypeRest {
	@Autowired
	private JobTypeService jobTypeService;

	@RequestMapping("/all")
	public ResponseEntity<?> getAll() {
		return new ResponseEntity<>(jobTypeService.getAll(), HttpStatus.OK);
	}

}
