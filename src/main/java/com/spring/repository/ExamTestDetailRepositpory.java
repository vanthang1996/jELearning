package com.spring.repository;

import java.util.List;
import java.util.Optional;

public interface ExamTestDetailRepositpory {
	public List<?> getAllRecord();

	public Optional<?> getExamTestDetailById(long examTestId);

	public Optional<?> getExamTestBySubjectId(long subjectId);

	/**
	 * @param examTestId
	 * @param questionId
	 * @param score
	 * @param i
	 * @return  
	 */
	public int insertQuestion(long examTestId, long questionId, double score, int i);

}
