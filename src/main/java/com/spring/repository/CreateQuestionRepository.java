package com.spring.repository;

import java.util.List;

import com.spring.mapper.entities.CreateQuestion;

public interface CreateQuestionRepository {
	public List<?> getAllRecord();

	boolean addDetailCreateQuetionJob(CreateQuestion createQuestion);

	List<CreateQuestion> getCreateQuestionByJobId(long jobId);
}
