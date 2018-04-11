package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.StructureTestRepository;
import com.spring.service.StructureTestService;

@Service
public class StructureTestServiceImp implements StructureTestService {
	@Autowired

	private StructureTestRepository structureTestRepository;;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.structureTestRepository.getAllRecord();
	}

}
