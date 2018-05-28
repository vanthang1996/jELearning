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

import com.spring.mapper.entities.Subject;
import com.spring.repository.QuestionRepository;

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
}
