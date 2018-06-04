package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.CreateQuestion;
import com.spring.repository.CreateQuestionRepository;
import com.spring.service.CreateQuestionService;

@Service
public class CreateQuestionServiceImp implements CreateQuestionService {

	@Autowired
	private CreateQuestionRepository createQuestionRepository;

	@Override
	public List<?> getAllRecord() {
		return this.createQuestionRepository.getAllRecord();
	}
	@Override
	public boolean insert(CreateQuestion createQuestion) {
		return this.createQuestionRepository.addDetailCreateQuetionJob(createQuestion);
	}
	@Override
	public List<CreateQuestion> getCreateQuestionByJobId(long jobId) {
		return this.createQuestionRepository.getCreateQuestionByJobId(jobId);
	}

}
