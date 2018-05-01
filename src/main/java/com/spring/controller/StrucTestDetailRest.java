package com.spring.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.service.StrucTestDetailService;

@RestController
@RequestMapping(value = "/struc-test-detail")
public class StrucTestDetailRest {
	@Autowired
	private StrucTestDetailService strucTestDetailService;

	@RequestMapping(value = "/{subjectId}")
	public ResponseEntity<?> getListStrucBySubjectId(@PathVariable long subjectId) {
		Optional<?> optional = this.strucTestDetailService.getListStrucTestDetailBySubjectId(subjectId);
		return new ResponseEntity<>(optional.get(), HttpStatus.OK);

	}
}
