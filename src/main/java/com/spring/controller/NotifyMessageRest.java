package com.spring.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class NotifyMessageRest {
	@Autowired
	private SimpMessagingTemplate messagingTemplate;

	@MessageMapping(value = "/notify")
	public void abc(@DestinationVariable("user") String user, @DestinationVariable("message") String message) {
		this.messagingTemplate.convertAndSendToUser(user, "/queue/message", message);
	}

}
