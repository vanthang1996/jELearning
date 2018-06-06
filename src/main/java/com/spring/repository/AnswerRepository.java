package com.spring.repository;

import java.util.List;

import com.spring.mapper.entities.Answer;

public interface AnswerRepository {
	public List<?> getAllRecord();

	public Answer addAnswer(Answer answer);

	public boolean deleteAnswer(long answerId);

	public boolean updateAnswer(Answer answer);
}
