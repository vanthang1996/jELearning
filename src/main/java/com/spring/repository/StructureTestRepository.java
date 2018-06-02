package com.spring.repository;

import java.util.List;

import com.spring.mapper.entities.StructureTest;

public interface StructureTestRepository {

	public List<?> getAllRecord();

	public int createStructureTest(StructureTest structureTest);

}
