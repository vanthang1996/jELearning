package com.spring.repositoryImp;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.mapper.entities.StructureTest;
import com.spring.repository.StructureTestRepository;

@Repository
public class StructureTestRepositoryImp implements StructureTestRepository {

	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<StructureTest> getAllRecord() {
		SqlSession session = sessionFactory.openSession();
		List<StructureTest> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.StructureTestMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return list;
	}

	@Override
	public int createStructureTest(StructureTest structureTest) {
		SqlSession session = sessionFactory.openSession();
		int rowNum = -1;
		try {
			rowNum = session.insert("com.spring.mapper.StructureTestMapper.createStructureTest", structureTest);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rowNum;
	}

	@Override
	public boolean updateStatusStrucBySubjectId(long subjectId, boolean status) {
		// updateStatus
		SqlSession session = sessionFactory.openSession();
		int rowNum = 0;
		Map<String, Object> param = new HashMap<>();
		param.put("subjectId", subjectId);
		param.put("status", status);
		try {
			rowNum = session.update("com.spring.mapper.StructureTestMapper.updateStatus", param);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rowNum > 0;
	}
}
