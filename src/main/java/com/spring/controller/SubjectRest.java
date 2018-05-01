package com.spring.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.service.ChapterService;

@RestController
@RequestMapping(value = "/subject")
public class SubjectRest {

	@Autowired
	private ChapterService chapterService;

	@RequestMapping(value = "/{subjectId}/chapter")
	public ResponseEntity<?> getChapterBySubjectId(@PathVariable long subjectId,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "size", required = false, defaultValue = "10") int size) {
		Optional<?> optional = this.chapterService.getChapterBySubjectId(subjectId, page, size);
		return new ResponseEntity<>(optional.get(), HttpStatus.OK);
	}

}
