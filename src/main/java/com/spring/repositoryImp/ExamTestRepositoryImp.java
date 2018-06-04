package com.spring.repositoryImp;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.mapper.entities.Chapter;
import com.spring.mapper.entities.ExamTest;
import com.spring.repository.ExamTestRepository;

@Repository
public class ExamTestRepositoryImp implements ExamTestRepository {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<ExamTest> getAllRecord() {
		SqlSession session = this.sessionFactory.openSession();
		List<ExamTest> departments = Collections.emptyList();
		try {
			departments = session.selectList("com.spring.mapper.ExamTestMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();

		}
		return departments;
	}

	@Override
	public Optional<?> getExamTestById(long examTestId) {
		SqlSession session = sessionFactory.openSession();
		List<ExamTest> list = null;
		try {
			list = session.selectList("com.spring.mapper.ExamTestMapper.getExamTestById", examTestId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(list);
	}
}
