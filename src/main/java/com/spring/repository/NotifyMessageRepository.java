package com.spring.repository;

import java.util.Map;

public interface NotifyMessageRepository {

	Map<String, Object> getMessageNotify(long receiveId, int page, int size);
}
