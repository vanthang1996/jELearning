package com.spring.service;

import java.sql.SQLException;
import java.util.List;

import com.spring.dao.ExamDao;
import com.spring.mapper.entities.StructureTest;

public interface StructureTestService {

	public List<?> getAllRecord();

	public int createStructureTest(StructureTest structureTest);

	public boolean updateStatus(long subjectId);

	public ExamDao getExamByStrucId(long strucTestDetailId) throws SQLException;

}
