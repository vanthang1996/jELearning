package com.spring.serviceImp;

import java.util.List;

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

}
