package com.spring.controller;

import java.util.List;
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
import com.spring.mapper.entities.Subject;
import com.spring.mapper.entities.Teacher;
import com.spring.service.ChapterService;
import com.spring.service.SubjectService;
import com.spring.service.TeacherService;

@RestController
@RequestMapping(value = "/subject")
public class SubjectRest {

	@Autowired
	private ChapterService chapterService;
	@Autowired
	private SubjectService subjectService;
	@Autowired
	private TeacherService teacherService;
	@Autowired
	private JwtService jwtService;

	@RequestMapping(value = "/{subjectId}/chapter")
	public ResponseEntity<?> getChapterBySubjectId(@PathVariable long subjectId,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "size", required = false, defaultValue = "10") int size) {
		Optional<?> optional = this.chapterService.getChapterBySubjectId(subjectId, page, size);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/{departmentId}/subjects")
	public ResponseEntity<?> getSubjectsDataByDepartmentId(@PathVariable long departmentId) {
		Optional<?> optional = this.subjectService.getSubjectsDataByDepartmentId(departmentId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/{subjectId}")
	public ResponseEntity<?> getSubjectBySubjectId(@PathVariable long subjectId) {
		Optional<?> optional = this.subjectService.getSubjectBySubjectId(subjectId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/{departmentId}/add-out-line/subjects")
	public ResponseEntity<?> getSubjectsAddOutLine(@PathVariable long departmentId) {
		Optional<?> optional = this.subjectService.getSubjectAddOutLineOrStructureTest(departmentId, 1);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/{departmentId}/add-structure-test/subjects")
	public ResponseEntity<?> getSubjectsAddStructureTest(@PathVariable long departmentId) {
		Optional<?> optional = this.subjectService.getSubjectAddOutLineOrStructureTest(departmentId, 3);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/of-teacher")
	public ResponseEntity<?> getSubjectOfTeacher(HttpServletRequest request) {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		if (!optional.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		long teacherId = optional.get().getTeacherId();
		List<Subject> list = this.subjectService.getSubjectOfTeacherByTeacherId(teacherId);
		System.out.println(list);
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
}
