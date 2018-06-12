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

	@Override
	public Optional<?> getAllDepartment() {
		SqlSession session = this.sessionFactory.openSession();
		List<Department> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.DepartmentMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(list);
	}

	@Override
	public int createDepartment(Department department) {
		SqlSession session = this.sessionFactory.openSession();
		int rowNum = 0;
		try {
			rowNum = session.insert("com.spring.mapper.DepartmentMapper.createDepartment", department);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rowNum;
	}

	@Override
	public Department getDepartmentById(long departmentId) {
		SqlSession session = sessionFactory.openSession();
		Department department = new Department();
		try {
			department = session.selectOne("com.spring.mapper.DepartmentMapper.getDepartmentById", departmentId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return department;
	}

}
