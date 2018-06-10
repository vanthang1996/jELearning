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

import com.spring.mapper.entities.Chapter;
import com.spring.service.ChapterService;

@RestController
@RequestMapping(value="/chapter")
public class ChapterRest {

	@Autowired
	private ChapterService chapterService;
	
	@RequestMapping(value = "/{subjectId}", method = RequestMethod.GET)
	public ResponseEntity<?> getListChapterBySubjectId(@PathVariable long subjectId) {
		Optional<?> optional = this.chapterService.getListChapterBySubjectId(subjectId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}
	
	@RequestMapping(value = "/create", method = RequestMethod.POST)
	public ResponseEntity<?> createChapter(@RequestBody Chapter chapter) {
		boolean result = this.chapterService.createChapter(chapter);
		if (result)
			return new ResponseEntity<>(result, HttpStatus.CREATED);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}
	
	@RequestMapping(value = "/delete/{subjectId}/{chapterId}", method = RequestMethod.GET)
	public ResponseEntity<?> deleteChapterByChapterId(@PathVariable("subjectId") long subjectId, @PathVariable("chapterId") long chapterId) {
		boolean result = this.chapterService.deleteChapterByChapterId(subjectId, chapterId);
		if (result)
			return new ResponseEntity<>(result, HttpStatus.OK);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}
}
