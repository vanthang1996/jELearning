package com.spring.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.service.FacultyService;

@RestController
@RequestMapping(value="/faculty")
public class FacultyRest {
	
	@Autowired
	private FacultyService facultyService;
	
	@RequestMapping(value = "/all-faculty", method = RequestMethod.GET)
	public ResponseEntity<?> getAllFaculty() {
		Optional<?> optional = this.facultyService.getAllFaculty();
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}
}
