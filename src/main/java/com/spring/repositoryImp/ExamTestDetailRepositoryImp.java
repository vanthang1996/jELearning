package com.spring.repositoryImp;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.mapper.entities.ExamTest;
import com.spring.repository.ExamTestDetailRepositpory;

@Repository
public class ExamTestDetailRepositoryImp implements ExamTestDetailRepositpory {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<Object> getAllRecord() {
		SqlSession session = this.sessionFactory.openSession();
		List<Object> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.ExamTestDetailMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();

		}
		return list;
	}

	@Override
	public Optional<?> getExamTestDetailById(long examTestId) {
		SqlSession session = sessionFactory.openSession();
		List<ExamTest> list = null;
		try {
			list = session.selectList("com.spring.mapper.ExamTestDetailMapper.getExamTestDetailById", examTestId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(list);
	}

	@Override
	public Optional<?> getExamTestBySubjectId(long subjectId) {
		SqlSession session = this.sessionFactory.openSession();
		List<ExamTest> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.ExamTestDetailMapper.getExamTestBySubjectIdTT", subjectId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(list);
	}

	@Override
	public int insertQuestion(long examTestId, long questionId, double score, int position) {
		SqlSession session = this.sessionFactory.openSession();
		int row = 0;
		Map<String, Object> param = new HashMap<>();
		param.put("examTestId", examTestId);
		param.put("questionId", questionId);
		param.put("score", score);
		param.put("position", position);
		try {
			row = session.insert("com.spring.mapper.ExamTestDetailMapper.insertQuestion", param);

		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return row;
	}
}
