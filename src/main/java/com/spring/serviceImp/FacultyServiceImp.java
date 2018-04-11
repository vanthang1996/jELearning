package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.FacultyRepository;
import com.spring.service.FacultyService;

@Service
public class FacultyServiceImp implements FacultyService {

	@Autowired
	private FacultyRepository facultyRepository;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.facultyRepository.getAllRecord();
	}

}
