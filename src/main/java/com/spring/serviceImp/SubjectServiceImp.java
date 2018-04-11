package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.SubjectRepository;
import com.spring.service.SubjectService;

@Service
public class SubjectServiceImp implements SubjectService {

	@Autowired
	private SubjectRepository subjectRepository;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.subjectRepository.getAllRecord();
	}

}
