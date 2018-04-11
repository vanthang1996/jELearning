package com.spring.repositoryImp;

import java.util.Collections;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.mapper.entities.Department;
import com.spring.repository.DepartmentRepository;

@Repository
public class DepartmentRepositoryImp implements DepartmentRepository {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<Department> getAllRecord() {
		SqlSession session = this.sessionFactory.openSession();
		List<Department> departments = Collections.emptyList();
		try {
			departments = session.selectList("com.spring.mapper.DepartmentMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();

		}
		return departments;
	}

}
