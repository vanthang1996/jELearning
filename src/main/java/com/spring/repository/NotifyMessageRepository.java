package com.spring.repository;

import java.util.Map;

import com.spring.mapper.entities.NotifyMessage;

public interface NotifyMessageRepository {

	Map<String, Object> getMessageNotify(long receiveId, int page, int size);

	int insert(NotifyMessage message);

	int numberNotifyCurrent(long teacherId);

	int updateStatusByTeacherId(long teacherId);
}
