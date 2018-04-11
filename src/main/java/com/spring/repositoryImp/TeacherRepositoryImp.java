package com.spring.repositoryImp;

import java.util.Collections;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.mapper.entities.Teacher;
import com.spring.repository.TeacherRepository;

@Repository
public class TeacherRepositoryImp implements TeacherRepository {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired

	private SqlSessionFactory sessionFactory;

	@Override
	public List<Teacher> getAllRecord() {
		SqlSession session = this.sessionFactory.openSession();
		List<Teacher> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.TeacherMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return list;
	}

}
