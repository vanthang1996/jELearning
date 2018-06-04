package com.spring.service;

import java.util.List;

import com.spring.mapper.entities.CreateQuestion;

public interface CreateQuestionService {
	public List<?> getAllRecord();

	public boolean insert(CreateQuestion createQuestion);

	public List<CreateQuestion> getCreateQuestionByJobId(long jobId);
}
