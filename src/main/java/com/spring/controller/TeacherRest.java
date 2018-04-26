
package com.spring.controller;

import java.util.List;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mobile.device.Device;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.config.jwt.JwtService;
import com.spring.domain.ApiMessage;
import com.spring.mapper.entities.Teacher;
import com.spring.service.TeacherService;

@RestController
@RequestMapping(value = "/teacher")
public class TeacherRest {

	private static final Logger LOGGER = LoggerFactory.getLogger(TeacherRest.class);

	@Autowired
	private TeacherService teacherService;

	@Autowired
	private JwtService jwtService;

	@RequestMapping(value = "/info", method = RequestMethod.GET)
	public ResponseEntity<?> getTeacherInfo(HttpServletRequest request, Device device) {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		if (optional.isPresent()) {
			return new ResponseEntity<>(optional.get(), HttpStatus.OK);
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
}
