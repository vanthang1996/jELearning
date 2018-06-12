package com.spring.controller;

import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.dao.ExamDao;
import com.spring.service.StructureTestService;

@RestController
@RequestMapping(value = "/create-exam")
public class CreateExam {
	
	@Autowired
	private StructureTestService structureTestService;
	
	@RequestMapping(value = "/getExam/{strucTestDetailId}", method = RequestMethod.GET)
	public ResponseEntity<?> getExamByStrucId(@PathVariable long strucTestDetailId) throws SQLException {
		System.out.println(strucTestDetailId);
		ExamDao exam = this.structureTestService.getExamByStrucId(strucTestDetailId);
		return new ResponseEntity<>(exam, HttpStatus.OK);
	}

}
