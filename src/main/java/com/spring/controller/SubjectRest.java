package com.spring.controller;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.config.jwt.JwtService;
import com.spring.domain.ApiMessage;
import com.spring.mapper.entities.Department;
import com.spring.mapper.entities.NotifyMessage;
import com.spring.mapper.entities.Subject;
import com.spring.mapper.entities.Teacher;
import com.spring.service.ChapterService;
import com.spring.service.DepartmentService;
import com.spring.service.NotifyMessageService;
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
	@Autowired
	private DepartmentService departmentService;
	@Autowired
	private NotifyMessageService messageService;

	@RequestMapping(value = "/{subjectId}/chapter")
	public ResponseEntity<?> getChapterBySubjectId(@PathVariable long subjectId,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "size", required = false, defaultValue = "10") int size) {
		Optional<?> optional = this.chapterService.getChapterBySubjectId(subjectId, page, size);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	// @Autowired
	// private SimpMessagingTemplate messagingTemplate;
	//
	// @MessageMapping("/chat")
	// public void send() {
	// this.messagingTemplate.convertAndSendToUser("quynhnhu@gmail.com",
	// "/queue/message", "Ok");
	// }

	@RequestMapping(value = "/{departmentId}/subjects")
	public ResponseEntity<?> getSubjectsDataByDepartmentId(@PathVariable long departmentId) {
		// this.messagingTemplate.convertAndSendToUser("vanthang1996@gmail.com",
		// "/queue/message", "Ok");
		Optional<?> optional = this.subjectService.getSubjectsDataByDepartmentId(departmentId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/{subjectId}", method = RequestMethod.GET)
	public ResponseEntity<?> getSubjectBySubjectId(@PathVariable long subjectId) {
		Optional<?> optional = this.subjectService.getSubjectBySubjectId(subjectId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/{subjectId}/all-status")
	public ResponseEntity<?> getSubjectBySubjectIdAllStatus(@PathVariable long subjectId) {
		Optional<?> optional = this.subjectService.getSubjectBySubjectIdAllStatus(subjectId);
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

	@RequestMapping(value = "/create", method = RequestMethod.POST)
	public ResponseEntity<?> createSubject(@RequestBody Subject subject) {
		int result = this.subjectService.createSubject(subject);
		if (result > 0)
			return new ResponseEntity<>(result, HttpStatus.CREATED);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}

	@RequestMapping(value = "/delete/{subjectId}/{teacherManagementId}", method = RequestMethod.GET)
	public ResponseEntity<?> deleteTeacherOfSubject(@PathVariable("subjectId") long subjectId,
			@PathVariable("teacherManagementId") long teacherManagementId) {
		boolean result = this.subjectService.deleteTeacherOfSubject(subjectId, teacherManagementId);
		if (result)
			return new ResponseEntity<>(result, HttpStatus.OK);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}

	@RequestMapping(value = "department/{departmentId}", method = RequestMethod.GET)
	public ResponseEntity<?> getSubjectsByDepartmentId(@PathVariable long departmentId) {
		List<Subject> optional = this.subjectService.getSubjectsByDepartmentId(departmentId);
		return new ResponseEntity<>(optional, HttpStatus.OK);
	}

	@RequestMapping(value = "/{subjectId}/info", method = RequestMethod.GET)
	public ResponseEntity<?> getSubjectInfoBySubjectId(@PathVariable long subjectId) {
		Optional<?> optional = this.subjectService.getSubjectInfoBySubjectId(subjectId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/{subjectId}/submit-subject")
	public ResponseEntity<?> updateStatus(@PathVariable long subjectId, HttpServletRequest request) {
		boolean result = this.subjectService.updateStatus(subjectId, true);

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
			message.setBody("Hoàn thành công việc Tạo đề cương! Môn: " + ((Subject) subject.get()).getSubjectName());
			message.setDateTo(new Date());
			message.setStatus(0);
			message.setTeacherSendId(teacherId);
			message.setTeacherReceiveId(department.getTeacherManagementId());
			
			this.messageService.insert(message);

			// tạo thông báo đến tbm

			return new ResponseEntity<>(result, HttpStatus.OK);
		}
		ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, "Lỗi");
		return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
	}
}
