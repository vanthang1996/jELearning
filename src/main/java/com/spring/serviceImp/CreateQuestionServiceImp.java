package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.CreateQuestionRepository;
import com.spring.service.CreateQuestionService;

@Service
public class CreateQuestionServiceImp implements CreateQuestionService {

	@Autowired
	private CreateQuestionRepository createQuestionRepository;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.createQuestionRepository.getAllRecord();
	}

}
