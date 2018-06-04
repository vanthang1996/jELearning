package com.spring.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.service.QuestionService;

@RestController
@RequestMapping(value = "/question")
public class QuestionRest {
	@Autowired
	private QuestionService questionService;;

	@RequestMapping(value = "/{chapterId}")
	public ResponseEntity<?> getListQuestionByChapterIdPaging(@PathVariable("chapterId") long chapterId,
			@RequestParam(name = "page", required = false, defaultValue = "1") int page,
			@RequestParam(name = "size", required = false, defaultValue = "10") int size) {
		Optional<?> optional = this.questionService.getListQuestionByChapterIdPaging(chapterId, page, size);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}
}
