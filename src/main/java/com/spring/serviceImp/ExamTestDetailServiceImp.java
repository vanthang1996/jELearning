package com.spring.serviceImp;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.ExamTestDetailRepositpory;
import com.spring.service.ExamTestDetailService;

@Service
public class ExamTestDetailServiceImp implements ExamTestDetailService {

	@Autowired
	private ExamTestDetailRepositpory examTestDetailRepositpory;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.examTestDetailRepositpory.getAllRecord();
	}

	@Override
	public Optional<?> getExamTestDetailById(long examTestId) {
		// TODO Auto-generated method stub
		return this.examTestDetailRepositpory.getExamTestDetailById(examTestId);
	}

	@Override
	public Optional<?> getExamTestBySubjectId(long subjectId) {
		// TODO Auto-generated method stub
		return this.examTestDetailRepositpory.getExamTestBySubjectId(subjectId);
	}

}
