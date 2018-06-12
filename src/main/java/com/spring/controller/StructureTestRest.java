package com.spring.controller;

import java.util.Date;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.config.jwt.JwtService;
import com.spring.domain.ApiMessage;
import com.spring.mapper.entities.Department;
import com.spring.mapper.entities.NotifyMessage;
import com.spring.mapper.entities.StructureTest;
import com.spring.mapper.entities.Subject;
import com.spring.mapper.entities.Teacher;
import com.spring.service.DepartmentService;
import com.spring.service.NotifyMessageService;
import com.spring.service.StructureTestService;
import com.spring.service.SubjectService;
import com.spring.service.TeacherService;

@RestController
@RequestMapping(value = "/structure")
public class StructureTestRest {

	@Autowired
	private StructureTestService structureTestService;
	@Autowired
	private NotifyMessageService messageService;
	@Autowired
	private DepartmentService departmentService;
	@Autowired
	private SubjectService subjectService;
	@Autowired
	private TeacherService teacherService;
	@Autowired
	private JwtService jwtService;

	@RequestMapping(value = "/create-structure-test", method = RequestMethod.POST)
	public ResponseEntity<?> createOutline(@RequestBody StructureTest structureTest) {
		int result = this.structureTestService.createStructureTest(structureTest);
		if (result > 0)
			return new ResponseEntity<>(result, HttpStatus.CREATED);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}

	@RequestMapping(value = "/{subjectId}/submit-struc")
	public ResponseEntity<?> submitStruc(@PathVariable long subjectId, HttpServletRequest request) {
		boolean result = this.structureTestService.updateStatus(subjectId);
		if (result) {
			Optional<Teacher> optional = teacherService
					.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
			if (!optional.isPresent()) {
				ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, "Lỗi");
				return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
			}
			Teacher teacher = optional.get();
			long teacherId = teacher.getTeacherId();
			Optional<?> subject = this.subjectService.getSubjectBySubjectId(subjectId);
			Department department = this.departmentService.getDepartmentById(teacher.getDepartmentId());
			NotifyMessage message = new NotifyMessage();
			message.setTitle("Nộp bài");
			message.setBody(
					"Hoàn thành công việc Tạo cấu trúc đề thi! Môn: " + ((Subject) subject.get()).getSubjectName());
			message.setDateTo(new Date());
			message.setStatus(0);
			message.setTeacherSendId(teacherId);
			message.setTeacherReceiveId(department.getTeacherManagementId());
			this.messageService.insert(message);
			return new ResponseEntity<>(result, HttpStatus.OK);
		}
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}
}
