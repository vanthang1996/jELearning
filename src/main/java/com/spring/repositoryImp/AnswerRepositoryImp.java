package com.spring.repositoryImp;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.mapper.entities.Answer;
import com.spring.repository.AnswerRepository;

@Repository
public class AnswerRepositoryImp implements AnswerRepository {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<Object> getAllRecord() {
		SqlSession session = this.sessionFactory.openSession();
		List<Object> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.AnswerMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return list;
	}

	@Override
	public Answer addAnswer(Answer answer) {
		SqlSession session = this.sessionFactory.openSession();
		long answerId = 0;
		Map<String, Object> param = new HashMap<>();
		param.put("answer", answer);
		try {
			session.update("com.spring.mapper.AnswerMapper.addAnswer", param);
			answerId = (long) param.get("answerId");
		} catch (Exception e) {
			logger.error(e.getMessage());
			logger.error(e.getCause().getMessage());
		} finally {
			session.close();
		}
		return answerId != 0 ? findById(answerId) : null;
	}

	public Answer findById(long answerId) {
		SqlSession session = this.sessionFactory.openSession();
		Answer answer = null;
		try {
			answer = session.selectOne("com.spring.mapper.AnswerMapper.findById", answerId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return answer;
	}

	@Override
	public boolean deleteAnswer(long answerId) {
		SqlSession session = this.sessionFactory.openSession();
		int row = 0;
		try {
			row = session.delete("com.spring.mapper.AnswerMapper.deleteAnswerById", answerId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		System.out.println(row);
		return row > 0;
	}

	public boolean updateAnswer(Answer answer) {
		SqlSession session = this.sessionFactory.openSession();
		int row = 0;
		try {
			row = session.update("com.spring.mapper.AnswerMapper.updateAnswer", answer);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return row > 0;
	}
}
