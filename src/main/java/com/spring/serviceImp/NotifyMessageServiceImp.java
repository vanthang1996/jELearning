package com.spring.serviceImp;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.NotifyMessage;
import com.spring.repository.NotifyMessageRepository;
import com.spring.service.NotifyMessageService;
import com.spring.service.TeacherService;

@Service
public class NotifyMessageServiceImp implements NotifyMessageService {
	@Autowired
	private NotifyMessageRepository messageRepository;
	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	@Autowired
	private TeacherService teacherService;

	@Override
	public Map<String, Object> getNotifyMessage(long receiveId, int page, int size) {
		return this.messageRepository.getMessageNotify(receiveId, page, size);
	}

	@Override
	public int insert(NotifyMessage message) {
		int result = this.messageRepository.insert(message);
		if (result > 0) {
			String user = this.teacherService.findById(message.getTeacherReceiveId()).getEmail();
			messagingTemplate.convertAndSendToUser(user, "/person/message", "You have a new message!");
		}
		return result;
	}

	@Override
	public int numberNotify(long teacherId) {
		return this.messageRepository.numberNotifyCurrent(teacherId);
	}

	@Override
	public int resetNotify(long teacherId) {
		return this.messageRepository.updateStatusByTeacherId(teacherId);
	}

}
