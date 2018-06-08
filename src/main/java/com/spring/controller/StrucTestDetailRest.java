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

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.mapper.entities.StrucTestDetail;
import com.spring.service.StrucTestDetailService;

@RestController
@RequestMapping(value = "/struc-test-detail")
public class StrucTestDetailRest {
	@Autowired
	private StrucTestDetailService strucTestDetailService;

	@RequestMapping(value = "/{subjectId}")
	public ResponseEntity<?> getListStrucBySubjectId(@PathVariable long subjectId) {
		Optional<?> optional = this.strucTestDetailService.getListStrucTestDetailBySubjectId(subjectId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);

	}

	@RequestMapping(value = "/edit", method = RequestMethod.POST)
	public ResponseEntity<?> editStructureTestDetailByChapterId(@RequestBody StrucTestDetail strucTestDetail) {
		int result = this.strucTestDetailService.editStructureTestDetailByChapterId(strucTestDetail);
		System.out.println(strucTestDetail);
		if (result > 0)
			return new ResponseEntity<>(result, HttpStatus.CREATED);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
		// return new ResponseEntity<>(strucTestDetail, HttpStatus.OK);
	}

	@RequestMapping(value = "/create", method = RequestMethod.POST)
	public ResponseEntity<?> createStrureTestDetail(@RequestBody StrucTestDetail strucTestDetail) {
		// throws JsonProcessingException {
		// ObjectMapper mapper = new ObjectMapper();
		// System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(strucTestDetail));
		int result = this.strucTestDetailService.editStructureTestDetailByChapterId(strucTestDetail);
		if (result > 0)
			return new ResponseEntity<>(result, HttpStatus.CREATED);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}
}
