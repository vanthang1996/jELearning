package com.spring.repositoryImp;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.mapper.entities.Faculty;
import com.spring.repository.FacultyRepository;

@Repository
public class FacultyRepositoryImp implements FacultyRepository {
	private  final org.slf4j.Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sqlSessionFactory;

	@Override
	public List<Faculty> getAllRecord() {
		List<Faculty> faculties = Collections.emptyList();
		SqlSession session = this.sqlSessionFactory.openSession();
		try {
			faculties = session.selectList("com.spring.mapper.FacultyMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return faculties;
	}

	@Override
	public Optional<?> getAllFaculty() {
		SqlSession session = sqlSessionFactory.openSession();
		List<Faculty> list = null;
		try {
			list = session.selectList("com.spring.mapper.FacultyMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(list);
	}
}
