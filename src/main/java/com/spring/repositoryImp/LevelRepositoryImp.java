package com.spring.repositoryImp;

import java.util.Collections;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.mapper.entities.Level;
import com.spring.repository.LevelRepositpory;

@Repository
public class LevelRepositoryImp implements LevelRepositpory {
	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.spring.repository.LevelRepositpory#getAllRecord()
	 */
	@Override
	public List<Level> getAllRecord() {
		SqlSession session = this.sessionFactory.openSession();
		List<Level> levels = Collections.emptyList();
		try {
			levels = session.selectList("com.spring.mapper.LevelMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return levels;
	}

}
