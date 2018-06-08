package com.spring.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.mapper.entities.CreateQuestion;
import com.spring.service.CreateQuestionService;

@RestController
@RequestMapping(value = "/create-question")
public class CreateQuestionRest {

	@Autowired
	private CreateQuestionService createQuestionService;
	
	@RequestMapping(value = "/{jobId}", method = RequestMethod.GET)
	public ResponseEntity<?> getCreateQuestionByJobId(@PathVariable long jobId) {
		List<CreateQuestion> optional = this.createQuestionService.getCreateQuestionByJobId(jobId);
		return new ResponseEntity<>(optional, HttpStatus.OK);
	}
}
