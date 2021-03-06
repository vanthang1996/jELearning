package com.spring.controller;

import java.util.Date;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.dao.ExamDao;
import com.spring.mapper.entities.ExamTest;
import com.spring.service.ExamTestDetailService;
import com.spring.service.ExamTestService;

@RestController
@RequestMapping(value = "/exam-test")
public class ExamTestRest {

	@Autowired
	private ExamTestService examTestService;

	@Autowired
	private ExamTestDetailService examTestDetailService;

	@RequestMapping(value = "/{examTestId}", method = RequestMethod.GET)
	public ResponseEntity<?> getExamTestById(@PathVariable long examTestId) {
		ExamTest examTest = this.examTestService.getExamTestById(examTestId);
		return new ResponseEntity<>(examTest, HttpStatus.OK);
	}

	@RequestMapping(value = "/detail/{examTestId}", method = RequestMethod.GET)
	public ResponseEntity<?> getExamTestDetailById(@PathVariable long examTestId) {
		Optional<?> optional = this.examTestDetailService.getExamTestDetailById(examTestId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/subject/{subjectId}", method = RequestMethod.GET)
	public ResponseEntity<?> getExamTestBySubjectId(@PathVariable long subjectId) {
		Optional<?> optional = this.examTestDetailService.getExamTestBySubjectId(subjectId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/submit", method = RequestMethod.POST)
	public ResponseEntity<?> submitExamTest(@RequestBody ExamDao examDao) {
		examDao.setStatus(true);
		examDao.setCreateTime(new Date());
		long row = this.examTestService.insertExamDao(examDao);
		return new ResponseEntity<>(row, HttpStatus.OK);
	}
}
