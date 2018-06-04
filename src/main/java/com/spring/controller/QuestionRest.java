package com.spring.controller;

import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.config.jwt.JwtService;
import com.spring.domain.ApiMessage;
import com.spring.mapper.entities.Teacher;
import com.spring.service.QuestionService;
import com.spring.service.TeacherService;

@RestController
@RequestMapping(value = "/question")
public class QuestionRest {
	@Autowired
	private QuestionService questionService;;
	@Autowired
	private JwtService jwtService;
	@Autowired
	private TeacherService teacherService;

	@RequestMapping(value = "/{chapterId}")
	public ResponseEntity<?> getListQuestionByChapterIdPaging(@PathVariable("chapterId") long chapterId,
			@RequestParam(name = "page", required = false, defaultValue = "1") int page,
			@RequestParam(name = "size", required = false, defaultValue = "10") int size) {
		Optional<?> optional = this.questionService.getListQuestionByChapterIdPaging(chapterId, page, size);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping("/{subjectId}/of-subject-teacher")
	public ResponseEntity<?> getQuestionOfTeacherCompile(HttpServletRequest request,
			@PathVariable("subjectId") long subjectId,
			@RequestParam(name = "page", required = false, defaultValue = "1") int page,
			@RequestParam(name = "size", required = false, defaultValue = "10") int size) {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		if (!optional.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.NOT_FOUND, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		long teacherId = optional.get().getTeacherId();
		Map<String, Object> map = this.questionService.getQuestionOfTeacherCompile(subjectId, teacherId, page, size);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
