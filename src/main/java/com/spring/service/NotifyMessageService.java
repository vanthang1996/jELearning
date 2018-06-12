package com.spring.service;

import java.util.Map;

import com.spring.mapper.entities.NotifyMessage;

public interface NotifyMessageService {

	Map<String, Object> getNotifyMessage(long receiveId, int page, int size);

	int insert(NotifyMessage message);

	int numberNotify(long teacherId);

	int resetNotify(long teacherId);
}
