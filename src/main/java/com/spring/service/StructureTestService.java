package com.spring.service;

import java.util.List;

import com.spring.mapper.entities.StructureTest;

public interface StructureTestService {

	public List<?> getAllRecord();

	public int createStructureTest(StructureTest structureTest);

	public boolean updateStatus(long subjectId);

}
