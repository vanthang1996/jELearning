package com.spring.repository;

import java.sql.SQLException;
import java.util.List;

import com.spring.dao.ExamDao;
import com.spring.mapper.entities.StructureTest;

public interface StructureTestRepository {

	public List<?> getAllRecord();

	public int createStructureTest(StructureTest structureTest);

	public boolean updateStatusStrucBySubjectId(long subjectId, boolean status);

	public ExamDao getDeThiByIdMaCtdt(long strucTestDetailId) ;

}
