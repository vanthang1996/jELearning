package com.spring.repositoryImp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.mapper.entities.Subject;
import com.spring.repository.NotifyMessageRepository;

@Repository
public class NotifyMessageRepositoryImp implements NotifyMessageRepository {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public Map<String, Object> getMessageNotify(long receiveId, int page, int size) {
		SqlSession session = sessionFactory.openSession();
		List<Subject> list = null;
		Map<String, Object> param = new HashMap<>();
		Map<String, Object> result = new HashMap<>();
		param.put("page", page);
		param.put("size", size);
		param.put("tableName", "NOTIFY_MESSAGE");
		param.put("whereQuery", " USERRECEIVE = " + receiveId);
		param.put("orderByQuery", " DATETO DESC");

		try {
			list = session.selectList("com.spring.mapper.NotifyMessageMapper.getNotifyMessage", param);
			int numberOfPage = (int) param.get("sumPage");
			int numberOfRecord = (int) param.get("sumRecord");
			result.put("listOfResult", list);
			result.put("numberOfPage", numberOfPage);
			result.put("numberOfRecord", numberOfRecord);
		} catch (Exception e) {
			logger.error("[getMessageNotify(int page, int size)  is ERROR]" + e.getMessage());
		} finally {
			session.close();
		}
		return result;
	}

}
