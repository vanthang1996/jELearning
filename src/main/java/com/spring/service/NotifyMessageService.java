package com.spring.service;

import java.util.Map;

public interface NotifyMessageService {

	Map<String, Object> getNotifyMessage(long receiveId, int page, int size);
}
