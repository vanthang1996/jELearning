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

import com.spring.mapper.entities.Question;
import com.spring.mapper.entities.Subject;
import com.spring.repository.QuestionRepository;

/**
 * @author vanth
 *
 */
@Repository
public class QuestionRepositoryImp implements QuestionRepository {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<Object> getAllRecord() {
		SqlSession session = this.sessionFactory.openSession();
		List<Object> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.QuestionMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();

		}
		return list;
	}

	@Override
	public Optional<?> getListQuestionByChapterIdPaging(long chapterId, int page, int size) {
		SqlSession session = sessionFactory.openSession();
		List<Subject> list = null;
		Map<String, Object> param = new HashMap<>();
		Map<String, Object> result = new HashMap<>();
		param.put("page", page);
		param.put("size", size);
		param.put("chapterId", chapterId);
		try {
			list = session.selectList("com.spring.mapper.QuestionMapper.getListQuestionByChapterIdPaging", param);
			int numberOfPage = (int) param.get("sumPage");
			int numberOfRecord = (int) param.get("sumRecord");
			result.put("listOfResult", list);
			result.put("numberOfPage", numberOfPage);
			result.put("numberOfRecord", numberOfRecord);
		} catch (Exception e) {
			logger.error("[getListQuestionByChapterIdPaging() is ERROR]" + e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(result);
	}

	@Override
	public Map<String, Object> getQuestionOfTeacherCompile(long subjectId, long teacherId, boolean status, int page,
			int size) {
		SqlSession session = sessionFactory.openSession();
		List<Subject> list = null;
		Map<String, Object> param = new HashMap<>();
		Map<String, Object> result = new HashMap<>();
		param.put("page", page);
		param.put("size", size);
		param.put("subjectId", subjectId);
		param.put("teacherId", teacherId);
		param.put("status", status);
		try {
			list = session.selectList("com.spring.mapper.QuestionMapper.getQuestionOfTeacherCompile", param);
			int numberOfPage = (int) param.get("sumPage");
			int numberOfRecord = (int) param.get("sumRecord");
			result.put("listOfResult", list);
			result.put("numberOfPage", numberOfPage);
			result.put("numberOfRecord", numberOfRecord);
		} catch (Exception e) {
			logger.error("[getQuestionOfTeacherCompile(long subjectId, long teacherId, boolean status, int page,\r\n"
					+ "	int size) is ERROR]" + e.getMessage());
		} finally {
			session.close();
		}
		return result;
	}

	@Override
	public Question addQuestion(Question question) {
		SqlSession session = sessionFactory.openSession();
		long questionId = 0;
		Map<String, Object> param = new HashMap<>();
		param.put("question", question);
		try {
			session.update("com.spring.mapper.QuestionMapper.insertQuestion", param);
			questionId = (long) param.get("questionId");
		} catch (Exception e) {
			logger.error("addQuestion(Question question)" + e.getMessage());
		} finally {
			session.close();
		}
		return questionId != 0 ? finById(questionId) : null;
	}

	public Question finById(long questionId) {
		SqlSession session = this.sessionFactory.openSession();
		Question question = null;
		try {
			question = session.selectOne("com.spring.mapper.QuestionMapper.findByIdNoCollection", questionId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return question;
	}

	@Override
	public Optional<Question> getQuestionByQuestionId(long questionId, boolean status) {
		SqlSession session = this.sessionFactory.openSession();
		Question question = null;
		Map<String, Object> param = new HashMap<>();
		param.put("questionId", questionId);
		param.put("status", status);
		try {
			question = session.selectOne("com.spring.mapper.QuestionMapper.getQuestionByQuestionIdAndStatus", param);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(question);
	}

	@Override
	public boolean deleteQuestion(long questionId) {
		SqlSession session = this.sessionFactory.openSession();
		int row = 0;
		try {
			row = session.delete("com.spring.mapper.QuestionMapper.deleteQuestionById", questionId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return row > 0;
	}

	public boolean updateQuestion(Question question) {
		SqlSession session = this.sessionFactory.openSession();
		int row = 0;
		try {
			row = session.update("com.spring.mapper.QuestionMapper.updateQuestion", question);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return row > 0;
	}
}
