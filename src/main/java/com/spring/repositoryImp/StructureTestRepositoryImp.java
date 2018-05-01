package com.spring.repositoryImp;

import java.util.Collections;
import java.util.List;

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

	

}
