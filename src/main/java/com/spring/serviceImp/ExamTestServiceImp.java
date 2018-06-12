package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.ExamTest;
import com.spring.repository.ExamTestRepository;
import com.spring.service.ExamTestService;

@Service
public class ExamTestServiceImp implements ExamTestService {
	@Autowired
	private ExamTestRepository examTestRepository;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.examTestRepository.getAllRecord();
	}

	@Override
	public ExamTest getExamTestById(long examTestId) {
		// TODO Auto-generated method stub
		return this.examTestRepository.getExamTestById(examTestId);
	}

}
