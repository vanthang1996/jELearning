package com.spring.repositoryImp;

import java.util.Collections;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.mapper.entities.CreateQuestion;
import com.spring.repository.CreateQuestionRepository;

@Repository
public class CreateQuestionRepositoryImp implements CreateQuestionRepository {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<Object> getAllRecord() {
		SqlSession session = this.sessionFactory.openSession();
		List<Object> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.CreateQuestionMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();

		}
		return list;
	}

	@Override
	public boolean addDetailCreateQuetionJob(CreateQuestion createQuestion) {
		SqlSession session = this.sessionFactory.openSession();
		boolean kq = false;
		try {
			int result = session.insert("com.spring.mapper.CreateQuestionMapper.addDetailCreateQuetionJob",
					createQuestion);
			kq = (result > 0);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();

		}
		return kq;
	}

	@Override
	public List<CreateQuestion> getCreateQuestionByJobId(long jobId) {
		SqlSession session = this.sessionFactory.openSession();
		List<CreateQuestion> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.CreateQuestionMapper.getCreateQuestionByJobId", jobId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();

		}
		return list;
	}
}
