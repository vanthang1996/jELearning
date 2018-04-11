package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.AnswerRepository;
import com.spring.service.AnswerService;

@Service
public class AnswerServiceImp implements AnswerService {
	@Autowired
	private AnswerRepository answerRepository;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.answerRepository.getAllRecord();
	}

}
