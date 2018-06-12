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
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.Subject;
import com.spring.repository.SubjectRepository;

@Service
public class SubjectRepositoryImp implements SubjectRepository {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<Subject> getAllRecord() {
		SqlSession session = sessionFactory.openSession();
		List<Subject> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.SubjectMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return list;
	}

	@Override
	public Optional<?> getListSubjectOfTeacherPaging(String email, int page, int size) {
		return getListSubjectOfTeacherPaging(email, true, page, size);
	}

	@Override
	public Optional<?> getListSubjectOfTeacherPaging(String email, boolean status, int page, int size) {
		SqlSession session = sessionFactory.openSession();
		List<Subject> list = null;
		Map<String, Object> param = new HashMap<>();
		Map<String, Object> result = new HashMap<>();
		param.put("page", page);
		param.put("size", size);
		param.put("email", email);
		param.put("status", status);
		try {
			list = session.selectList("com.spring.mapper.SubjectMapper.getListSubjectOfTeacherPaging", param);
			int numberOfPage = (int) param.get("sumPage");
			int numberOfRecord = (int) param.get("sumRecord");
			result.put("listOfResult", list);
			result.put("numberOfPage", numberOfPage);
			result.put("numberOfRecord", numberOfRecord);
		} catch (Exception e) {
			logger.error("[getListSubjectOfTeacherPaging() is ERROR]" + e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(result);
	}

	@Override
	public Optional<?> getSubjectsDataByDepartmentId(long departmentId) {
		SqlSession session = sessionFactory.openSession();
		List<Subject> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.SubjectMapper.getSubjectsDataByDepartmentId_no_collection",
					departmentId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(list);
	}

	@Override
	public Optional<?> getSubjectBySubjectId(long subjectId) {
		SqlSession session = sessionFactory.openSession();
		Subject list = null;
		try {
			list = session.selectOne("com.spring.mapper.SubjectMapper.getSubjectBySubjectId", subjectId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(list);
	}

	/**
	 * @param departmentId,
	 *            jobTypeId ==1 addOutLine jobTypeId ==3 addStructureTest
	 * @return List<Subject>
	 */
	@Override
	public Optional<?> getSubjectAddOutLineOrStructureTest(long departmentId, long jobTypeId) {
		SqlSession session = this.sessionFactory.openSession();
		List<Subject> list = Collections.emptyList();
		Map<String, Object> params = new HashMap<>();
		params.put("departmentId", departmentId);
		params.put("jobTypeId", jobTypeId);
		try {
			list = session.selectList("com.spring.mapper.SubjectMapper.getSubjectAddOutLineOrStructureTest", params);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();

		}
		return Optional.ofNullable(list);
	}

	@Override
	public List<Subject> getListSubjectOfTeacher(long teacherId, boolean status) {
		SqlSession session = this.sessionFactory.openSession();
		List<Subject> list = Collections.emptyList();
		Map<String, Object> params = new HashMap<>();
		params.put("teacherId", teacherId);
		params.put("status", status);
		try {
			list = session.selectList("com.spring.mapper.SubjectMapper.getListSubjectOfTeacher", params);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();

		}
		return list;
	}

	@Override
	public int createSubject(Subject subject) {
		SqlSession session = this.sessionFactory.openSession();
		int rowNum = 0;
		try {
			rowNum = session.insert("com.spring.mapper.SubjectMapper.createSubject", subject);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rowNum;
	}

	@Override
	public int deleteTeacherOfSubject(long subjectId, long teacherManagementId) {
		SqlSession session = sessionFactory.openSession();
		Map<String, Object> params = new HashMap<>();
		params.put("subjectId", subjectId);
		params.put("teacherManagementId", teacherManagementId);
		int rowNum = 0;
		try {
			rowNum = session.delete("com.spring.mapper.SubjectMapper.deleteTeacherOfSubject", params);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rowNum;
	}

	@Override
<<<<<<< HEAD
	public List<Subject> getSubjectsByDepartmentId(long departmentId) {
		SqlSession session = this.sessionFactory.openSession();
		List<Subject> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.SubjectMapper.getSubjectsByDepartmentId", departmentId);
=======
	public Optional<?> getSubjectBySubjectIdAllStatus(long subjectId) {
		SqlSession session = sessionFactory.openSession();
		Subject list = null;
		try {
			list = session.selectOne("com.spring.mapper.SubjectMapper.getSubjectBySubjectIdAllStatus", subjectId);
>>>>>>> master
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
<<<<<<< HEAD

		}
		return list;
	}

	@Override
	public Optional<?> getSubjectInfoBySubjectId(long subjectId) {
		SqlSession session = sessionFactory.openSession();
		Subject list = null;
		try {
			list = session.selectOne("com.spring.mapper.SubjectMapper.getSubjectInfoBySubjectId", subjectId);
=======
		}
		return Optional.ofNullable(list);
	}

	@Override
	public boolean updateStatus(long subjectId, boolean status) {
		SqlSession session = sessionFactory.openSession();
		int row = 0;
		Map<String, Object> param = new HashMap<>();
		param.put("subjectId", subjectId);
		param.put("status", status);
		try {
			row = session.update("com.spring.mapper.SubjectMapper.updateStatus", param);
>>>>>>> master
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
<<<<<<< HEAD
		return Optional.ofNullable(list);
	}

=======
		return row > 0;
	}
>>>>>>> master
}
