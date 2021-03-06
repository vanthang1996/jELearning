
package com.spring.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mobile.device.Device;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.google.api.services.drive.model.File;
import com.spring.config.jwt.JwtService;
import com.spring.domain.ApiMessage;
import com.spring.mapper.entities.Teacher;
import com.spring.service.GoogleDriveService;
import com.spring.service.JobService;
import com.spring.service.SubjectService;
import com.spring.service.TeacherService;

@RestController
@RequestMapping(value = "/teacher")
public class TeacherRest {

	@Autowired
	private TeacherService teacherService;
	@Autowired

	private SubjectService subjectService;

	@Autowired
	private JwtService jwtService;
	@Autowired
	private JobService jobService;
	@Autowired
	private ServletContext context;
	@Autowired
	private GoogleDriveService driveService;

	@RequestMapping(value = "/all-teacher", method = RequestMethod.GET)
	public ResponseEntity<?> getAllTeacher() {
		Optional<?> optional = this.teacherService.getAllTeacher();
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/info", method = RequestMethod.GET)
	public ResponseEntity<?> getTeacherInfo(HttpServletRequest request, Device device) {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		if (optional.isPresent()) {
			return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
		}
		ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, "Lỗi");
		return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
	}

	@RequestMapping(value = "/role")
	public ResponseEntity<?> getRoleOfTeacher(HttpServletRequest request) {
		String email = this.jwtService.getEmailFromToKen(this.jwtService.getToken(request));
		List<String> result = this.teacherService.getRoleOfUserByEmail(email);
		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@RequestMapping(value = "/subjects", method = RequestMethod.GET)
	public ResponseEntity<?> getListSubjectOfTeacher(HttpServletRequest request,
			@RequestParam(name = "page", required = false, defaultValue = "1") int page,
			@RequestParam(name = "size", required = false, defaultValue = "10") int size) {
		Optional<?> optional = this.subjectService.getListSubjectOfTeacherPaging(
				this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)), page, size);

		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/departments")
	public ResponseEntity<?> getListFacultyOfTeacher(HttpServletRequest request) {
		String email = this.jwtService.getEmailFromToKen(this.jwtService.getToken(request));
		Optional<?> optional = this.teacherService.getListDepartmentyByTeacherEmail(email);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/{teacherId}")
	public ResponseEntity<?> getTeacherNoCollectionByTeacherId(@PathVariable long teacherId) {
		Optional<?> optional = this.teacherService.getTeacherNoCollectionByTeacherId(teacherId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	@RequestMapping(value = "/jobs")
	public ResponseEntity<?> getJobsOfTeacher(HttpServletRequest request,
			@RequestParam(name = "page", required = false, defaultValue = "1") int page,
			@RequestParam(name = "size", required = false, defaultValue = "10") int size) {
		String email = this.jwtService.getEmailFromToKen(this.jwtService.getToken(request));
		try {
			Optional<Teacher> teacher = teacherService.getTeacherByEmail(email);
			Optional<?> optional = jobService.getJobsByTeacherIdPaging(teacher.get().getTeacherId(), page, size);
			return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
		} catch (Exception e) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.FORBIDDEN, e.getMessage());
			return new ResponseEntity<Object>(apiMessage, apiMessage.getStatusCode());
		}
	}

	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ResponseEntity<?> uploadAvatar(@RequestParam("file") List<MultipartFile> listFile) {
		List<Map<String, Object>> result = new ArrayList<>();
		try {

			for (MultipartFile f : listFile) {
				Map<String, Object> temp = new HashMap<>();
				String uploadFolder = this.context.getRealPath("/") + java.io.File.separator;

				java.io.File file = new java.io.File(uploadFolder + f.getOriginalFilename());
				f.transferTo(file);
				File fileUpload = driveService.uploadFile(file.getName(), file.getPath(), f.getContentType());
				temp.put("fileProperties", fileUpload.toPrettyString());
				result.add(temp);
				file.delete();
			}
		} catch (Exception e) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, e.getMessage());
			return new ResponseEntity<Object>(apiMessage, apiMessage.getStatusCode());
		}
		return new ResponseEntity<Object>(result, HttpStatus.OK);
	}
	
	@RequestMapping(value = "/create", method = RequestMethod.POST)
	public ResponseEntity<?> createTeacher(@RequestBody Teacher teacher) {
		boolean result = this.teacherService.createTeacher(teacher);
		if (result)
			return new ResponseEntity<Object>(result, HttpStatus.CREATED);
		return new ResponseEntity<Object>(result, HttpStatus.CONFLICT);
	}
	
	@RequestMapping(value = "department/{departmentId}", method = RequestMethod.GET)
	public ResponseEntity<?> getTeacherByDepartmentId(@PathVariable long departmentId) {
		Optional<?> optional = this.teacherService.getTeacherByDepartmentId(departmentId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}
	
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public ResponseEntity<?> updateTeacher(@RequestBody Teacher teacher) {
		boolean result = this.teacherService.updateTeacher(teacher);
		if (result)
			return new ResponseEntity<>(result, HttpStatus.OK);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}
	
	@RequestMapping(value = "/department/{departmentId}/not-in-subject/{subjectId}", method = RequestMethod.GET)
	public ResponseEntity<?> getTeacherInDepartmentNotInSubject(@PathVariable("departmentId") long departmentId, @PathVariable("subjectId") long subjectId) {
		Optional<?> optional = this.teacherService.getTeacherInDepartmentNotInSubject(departmentId, subjectId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}
	
	@RequestMapping(value="/add-teacher/{teacherId}/subject/{subjectId}", method = RequestMethod.GET)
	public ResponseEntity<?> insertQLMH(@PathVariable("teacherId") long teacherId, @PathVariable("subjectId") long subjectId) {
		boolean result = this.teacherService.insertQLMH(teacherId, subjectId);
		if (result)
			return new ResponseEntity<>(result, HttpStatus.CREATED);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}
	
	@RequestMapping(value="/delete-teacher/{teacherId}/subject/{subjectId}", method = RequestMethod.GET)
	public ResponseEntity<?> deleteQLMH(@PathVariable("teacherId") long teacherId, @PathVariable("subjectId") long subjectId) {
		boolean result = this.teacherService.deleteQLMH(teacherId, subjectId);
		if (result)
			return new ResponseEntity<>(result, HttpStatus.OK);
		return new ResponseEntity<>(result, HttpStatus.CONFLICT);
	}

}
