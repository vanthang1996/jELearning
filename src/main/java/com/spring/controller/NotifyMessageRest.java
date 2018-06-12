package com.spring.controller;

import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.config.jwt.JwtService;
import com.spring.domain.ApiMessage;
import com.spring.domain.SendMesssage;
import com.spring.mapper.entities.Teacher;
import com.spring.service.NotifyMessageService;
import com.spring.service.TeacherService;

@RestController
public class NotifyMessageRest {
	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	@Autowired
	private JwtService jwtService;
	@Autowired
	private TeacherService teacherService;
	@Autowired
	private NotifyMessageService messageService;

	@MessageMapping(value = "/message-box-user")
	public void abc(@Payload SendMesssage message) {
		System.out.println(message);
		this.messagingTemplate.convertAndSendToUser(message.getUser(), "/person/message", message.getMessage());
	}

	@RequestMapping(value = "/notify", method = RequestMethod.GET)
	public ResponseEntity<?> getNotify(HttpServletRequest request,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "size", required = false, defaultValue = "10") int size) {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		if (!optional.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.NOT_FOUND, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		long teacherId = optional.get().getTeacherId();
		Map<String, Object> map = this.messageService.getNotifyMessage(teacherId, page, size);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	@RequestMapping(value = "/number-notify")
	public ResponseEntity<?> numberNotify(HttpServletRequest request) {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		if (!optional.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.NOT_FOUND, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		long teacherId = optional.get().getTeacherId();
		return new ResponseEntity<>(this.messageService.numberNotify(teacherId), HttpStatus.OK);
	}

	@RequestMapping(value = "/reset-notify")
	public ResponseEntity<?> resetNotify(HttpServletRequest request) {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		if (!optional.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.NOT_FOUND, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		long teacherId = optional.get().getTeacherId();
		return new ResponseEntity<>(this.messageService.resetNotify(teacherId), HttpStatus.OK);
	}

}
