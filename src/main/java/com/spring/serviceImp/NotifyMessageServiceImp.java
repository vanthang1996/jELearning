package com.spring.serviceImp;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.NotifyMessageRepository;
import com.spring.service.NotifyMessageService;

@Service
public class NotifyMessageServiceImp implements NotifyMessageService {
	@Autowired
	private NotifyMessageRepository messageRepository;

	@Override
	public Map<String, Object> getNotifyMessage(long receiveId, int page, int size) {
		return this.messageRepository.getMessageNotify(receiveId, page, size);
	}
}
