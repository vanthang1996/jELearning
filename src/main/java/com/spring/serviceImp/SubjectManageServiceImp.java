package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.SubjectManageRepository;
import com.spring.service.SubjectManageService;

@Service
public class SubjectManageServiceImp implements SubjectManageService {

	@Autowired
	private SubjectManageRepository subjectManageRepository;

	@Override
	public List<?> getAllRecord() {
		return this.subjectManageRepository.getAllRecord();
	}

}
