package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.QuestionRepository;
import com.spring.service.QuestionService;

@Service
public class QuestionServiceImp implements QuestionService {

	@Autowired
	private QuestionRepository questionRepository;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.questionRepository.getAllRecord();
	}

}
