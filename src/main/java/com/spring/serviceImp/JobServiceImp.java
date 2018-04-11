package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.JobRepository;
import com.spring.service.JobService;

@Service
public class JobServiceImp implements JobService {

	@Autowired
	private JobRepository jobRepository;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.jobRepository.getAllRecord();
	}

}
