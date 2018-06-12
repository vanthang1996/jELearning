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

import com.spring.mapper.entities.StrucTestDetail;
import com.spring.repository.StrucTestDetailRepository;

@Repository
public class StrucTestDetailRepositoryImp implements StrucTestDetailRepository {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<StrucTestDetail> getAllRecord() {
		SqlSession session = sessionFactory.openSession();
		List<StrucTestDetail> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.StrucTestDetailMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return list;
	}

	@Override
	public Optional<?> getListStrucTestDetailBySubjectId(long subjectId) {
		SqlSession session = sessionFactory.openSession();
		List<StrucTestDetail> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.StrucTestDetailMapper.getListStrucTestDetailBySubjectId",
					subjectId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(list);
	}

	@Override
	public int editStructureTestDetailByChapterId(StrucTestDetail strucTestDetail) {
		SqlSession session = sessionFactory.openSession();
		int rowNum = -1;
		try {
			rowNum = session.insert("com.spring.mapper.StrucTestDetailMapper.editStructureTestDetailByChapterId",
					strucTestDetail);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rowNum;
	}

	@Override
	public Optional<?> getListStrucTestDetailBySubjectIdAndStatus(long subjectId, boolean status) {
		SqlSession session = sessionFactory.openSession();
		List<StrucTestDetail> list = Collections.emptyList();
		Map<String, Object> param = new HashMap<>();
		param.put("subjectId", subjectId);
		param.put("status", status);
		try {
			list = session.selectList(
					"com.spring.mapper.StrucTestDetailMapper.getListStrucTestDetailBySubjectIdAndStatus", param);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return Optional.ofNullable(list);
	}
}
