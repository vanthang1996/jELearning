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

import com.spring.mapper.entities.Job;
import com.spring.mapper.entities.Subject;
import com.spring.repository.JobRepository;

@Repository
public class JobRepositoryImp implements JobRepository {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<Object> getAllRecord() {
		SqlSession session = this.sessionFactory.openSession();
		List<Object> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.JobMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();

		}
		return list;
	}

	@Override
	public Optional<?> getJobsByTeacherIdPaging(long teacherId, int page, int size) {
		SqlSession session = sessionFactory.openSession();
		List<Job> list = null;
		Map<String, Object> param = new HashMap<>();
		Map<String, Object> result = new HashMap<>();
		param.put("page", page);
		param.put("size", size);
		param.put("teacherId", teacherId);
		try {
			list = session.selectList("com.spring.mapper.JobMapper.getJobsByTeacherIdPaging", param);
			int numberOfPage = (int) param.get("sumPage");
			int numberOfRecord = (int) param.get("sumRecord");
			result.put("listOfResult", list);
			result.put("numberOfPage", numberOfPage);
			result.put("numberOfRecord", numberOfRecord);
		} catch (Exception e) {
			logger.error("[getJobsByTeacherIdPaging() is ERROR]" + e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(result);
	}

	@Override
	public String addOutLine(Job job) {
		SqlSession session = sessionFactory.openSession();
		String message = "";
		try {
			int rowNum = session.update("com.spring.mapper.JobMapper.addOutLine", job);
			message = rowNum > 0 ? "Add success!" : "Add failed!";
		} catch (Exception e) {
			message = e.getCause().getMessage();
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return message;
	}
}
