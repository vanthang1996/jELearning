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
import com.spring.repository.JobRepository;

/**
 * @author vanth
 *
 */
/**
 * @author vanth
 *
 */
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

	@Override
	public String addStructureTest(Job job) {
		SqlSession session = sessionFactory.openSession();
		String message = "";
		try {
			int rowNum = session.update("com.spring.mapper.JobMapper.addStructureTest", job);
			message = rowNum > 0 ? "Add success!" : "Add failed!";
		} catch (Exception e) {
			message = e.getCause().getMessage();
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return message;
	}

	@Override
	public Job addQuestionJob(Job job) {
		SqlSession session = sessionFactory.openSession();
		long jobId = 0;
		try {
			jobId = session.selectOne("com.spring.mapper.JobMapper.addQuestionJob", job);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return jobId != 0 ? findById(jobId) : null;
	}

	@Override
	public Job findById(long jobId) {
		SqlSession session = sessionFactory.openSession();
		Job job = null;
		try {
			job = session.selectOne("com.spring.mapper.JobMapper.findById", jobId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return job;
	}

	@Override
	public Map<String, Object> getJobByManageTeacher(long teacherId, long jobTypeId, boolean status, int page,
			int size) {
		SqlSession session = sessionFactory.openSession();
		List<Job> list = null;
		Map<String, Object> param = new HashMap<>();
		Map<String, Object> result = new HashMap<>();
		param.put("page", page);
		param.put("size", size);
		param.put("teacherId", teacherId);
		param.put("jobTypeId", jobTypeId);
		param.put("status", status);
		try {
			list = session.selectList("com.spring.mapper.JobMapper.getJobByManageTeacher", param);
			int numberOfPage = (int) param.get("sumPage");
			int numberOfRecord = (int) param.get("sumRecord");
			result.put("listOfResult", list);
			result.put("numberOfPage", numberOfPage);
			result.put("numberOfRecord", numberOfRecord);
		} catch (Exception e) {
			logger.error("[getJobByManageTeacher() is ERROR]" + e.getMessage());
		} finally {
			session.close();
		}
		return result;
	}

	@Override
	public Map<String, Object> getJobsOfTeacherByTeacherId(long teacherId, boolean status, int page, int size) {
		SqlSession session = sessionFactory.openSession();
		List<Job> list = null;
		Map<String, Object> param = new HashMap<>();
		Map<String, Object> result = new HashMap<>();
		param.put("page", page);
		param.put("size", size);
		param.put("teacherId", teacherId);
		param.put("status", status);
		try {
			list = session.selectList("com.spring.mapper.JobMapper.getJobsOfTeacherByTeacherIdAndStatus", param);
			int numberOfPage = (int) param.get("sumPage");
			int numberOfRecord = (int) param.get("sumRecord");
			result.put("listOfResult", list);
			result.put("numberOfPage", numberOfPage);
			result.put("numberOfRecord", numberOfRecord);
		} catch (Exception e) {
			logger.error("[getJobsOfTeacherByTeacherId(long teacherId, boolean status, int page, int size) is ERROR]"
					+ e.getMessage());
		} finally {
			session.close();
		}
		return result;
	}

	@Override
	public Optional<?> getJobByTeacherId(long teacherId) {
		SqlSession session = sessionFactory.openSession();
		Job job = null;
		try {
			job = session.selectOne("com.spring.mapper.JobMapper.getJobByTeacherIdAndTypeJob", teacherId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(job);
	}

	@Override
	public boolean updateStatusJobByJobId(long jobId, boolean status) {
		SqlSession session = sessionFactory.openSession();
		int rows = 0;
		Map<String, Object> param = new HashMap<>();
		param.put("jobId", jobId);
		param.put("status", status);
		try {
			rows = session.update("com.spring.mapper.JobMapper.updateStatusJobByJobId", param);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rows > 0;
	}

	@Override
	public boolean progressOutLine(long jobId) {
		SqlSession session = sessionFactory.openSession();
		int rows = 0;
		try {
			rows = session.update("com.spring.mapper.JobMapper.progressOutLine", jobId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rows > 0;
	}

	@Override
	public boolean progressStruc(long jobId) {
		SqlSession session = sessionFactory.openSession();
		int rows = 0;
		try {
			rows = session.update("com.spring.mapper.JobMapper.progressStruc", jobId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rows > 0;
	}
	@Override
	public boolean reviewQuestion(long jobId) {
		SqlSession session = sessionFactory.openSession();
		int rows = 0;
		try {
			rows = session.update("com.spring.mapper.JobMapper.reviewQuestion", jobId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rows > 0;
	}

}
