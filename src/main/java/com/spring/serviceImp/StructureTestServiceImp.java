package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.StructureTest;
import com.spring.repository.StructureTestRepository;
import com.spring.service.StructureTestService;

@Service
public class StructureTestServiceImp implements StructureTestService {
	@Autowired

	private StructureTestRepository structureTestRepository;

	@Override
	public List<?> getAllRecord() {
		return this.structureTestRepository.getAllRecord();
	}

	@Override
	public int createStructureTest(StructureTest structureTest) {
		return this.structureTestRepository.createStructureTest(structureTest);
	}

	@Override
	public boolean updateStatus(long subjectId) {
		return this.structureTestRepository.updateStatusStrucBySubjectId(subjectId, true);
	}
}
