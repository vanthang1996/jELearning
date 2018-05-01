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
import com.spring.mapper.entities.Teacher;
import com.spring.mapper.entities.UserRole;
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

	@Override
	public List<String> getRoleOfUserByEmail(String email) {
		SqlSession session = this.sessionFactory.openSession();
		List<String> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.TeacherMapper.getRoleOfUserByEmail", email);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return list;
	}

	public List<UserRole> getAllUserRole() {
		SqlSession session = this.sessionFactory.openSession();
		List<UserRole> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.UserRoleMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return list;
	}

	@Override
	public Optional<UserRole> getUserRoleByEmail(String email) {
		SqlSession session = this.sessionFactory.openSession();
		UserRole userRole = null;
		try {
			userRole = session.selectOne("com.spring.mapper.UserRoleMapper.getUserRoleByEmail", email);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(userRole);
	}

	@Override
	public Optional<Teacher> getTeacherByEmail(String email) {
		SqlSession session = this.sessionFactory.openSession();
		Teacher teacher = null;
		try {
			teacher = session.selectOne("com.spring.mapper.TeacherMapper.getTeacherByEmail", email);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(teacher);
	}

	@Override
	public Optional<?> getListDepartmentyByTeacherEmail(String email) {
		SqlSession session = this.sessionFactory.openSession();
		List<Department> list = null;
		try {
			list = session.selectList("com.spring.mapper.DepartmentMapper.getListDepartmentyByTeacherEmail", email);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(list);
	}

	@Override
	public Optional<?> getTeacherNoCollectionByTeacherId(long teacherId) {
		SqlSession session = this.sessionFactory.openSession();
		Teacher teacher = null;
		try {
			teacher = session.selectOne("com.spring.mapper.TeacherMapper.getTeacherByTeacherManagementId", teacherId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(teacher);
	}
}
