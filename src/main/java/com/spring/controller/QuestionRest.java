package com.spring.controller;

import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.config.jwt.JwtService;
import com.spring.domain.ApiMessage;
import com.spring.mapper.entities.Chapter;
import com.spring.mapper.entities.Question;
import com.spring.mapper.entities.Teacher;
import com.spring.service.ChapterService;
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
	@Autowired
	private ChapterService chapterService;

	@RequestMapping(value = "/{chapterId}")
	public ResponseEntity<?> getListQuestionByChapterIdPaging(@PathVariable("chapterId") long chapterId,
			@RequestParam(name = "page", required = false, defaultValue = "1") int page,
			@RequestParam(name = "size", required = false, defaultValue = "10") int size) {
		Optional<?> optional = this.questionService.getListQuestionByChapterIdAndStatusPaging(chapterId, true, page,
				size);
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

	/**
	 * question has answers(content, correctAnswer), chapterId, content, levelId
	 * 
	 * @param request
	 * @param question
	 * @return
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public ResponseEntity<?> insertQuestion(HttpServletRequest request, @RequestBody Question question) {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		Optional<Chapter> optional2 = chapterService.getChapterByChapterIdNoCollect(question.getChapterId());
		if (!optional.isPresent() || !optional2.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.NOT_FOUND, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		long teacherId = optional.get().getTeacherId();
		question.setTeacherCreateId(teacherId);
		question.setSubjectId(optional2.get().getSubjectId());
		question.setStatus(0);
		Question question2 = this.questionService.addQuestion(question);
		return new ResponseEntity<>(question2, HttpStatus.OK);
	}

	@RequestMapping(value = "/delete", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_UTF8_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<?> deleteQuestion(HttpServletRequest request, @RequestBody Map<String, Long> json) {
		long questionId = json.get("questionId").longValue();
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		Optional<Question> optional2 = questionService.getQuestionByQuestionId(questionId);
		if (!optional.isPresent() || !optional2.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.NOT_FOUND, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		if (optional2.get().getTeacherCreateId() != optional.get().getTeacherId()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.FORBIDDEN, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		boolean result = this.questionService.deleteQuestion(questionId);
		ApiMessage apiMessage;
		if (result)
			apiMessage = new ApiMessage(HttpStatus.OK, "OK");
		else
			apiMessage = new ApiMessage(HttpStatus.CONFLICT, "FAILED!");
		return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
	}

	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public ResponseEntity<?> updateQuestion(HttpServletRequest request, @RequestBody Question question) {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		Optional<Question> optional2 = questionService.getQuestionByQuestionId(question.getQuestionId());
		if (!optional.isPresent() || !optional2.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.NOT_FOUND, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		if (optional2.get().getTeacherCreateId() != optional.get().getTeacherId()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.FORBIDDEN, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		boolean result = this.questionService.updateQuestion(question);
		ApiMessage apiMessage;
		if (result)
			apiMessage = new ApiMessage(HttpStatus.OK, "OK");
		else
			apiMessage = new ApiMessage(HttpStatus.CONFLICT, "FAILED!");
		return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		// return new ResponseEntity<>(question, HttpStatus.OK);
	}

	@RequestMapping(value = "/teacher/{teacherId}", method = RequestMethod.GET)
	public ResponseEntity<?> getQuestionByTeacherId(@PathVariable long teacherId) {
		Optional<?> optional = this.questionService.getQuestionByTeacherId(teacherId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}
}
