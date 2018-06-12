package com.spring.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.mapper.entities.StructureTest;
import com.spring.service.StructureTestService;

@RestController
@RequestMapping(value = "/structure")
public class StructureTestRest {

	@Autowired
	private StructureTestService structureTestService;

	@RequestMapping(value = "/create-structure-test", method = RequestMethod.POST)
	public ResponseEntity<?> createOutline(@RequestBody StructureTest structureTest) {
		int result = this.structureTestService.createStructureTest(structureTest);
		if (result > 0)
			return new ResponseEntity<>(result, HttpStatus.CREATED);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}

	@RequestMapping(value = "/{subjectId}/submit-struc")
	public ResponseEntity<?> submitStruc(@PathVariable long subjectId) {
		boolean result = this.structureTestService.updateStatus(subjectId);
		if (result)
			return new ResponseEntity<>(result, HttpStatus.OK);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}
}
