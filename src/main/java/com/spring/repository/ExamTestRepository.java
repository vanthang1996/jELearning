package com.spring.repository;

import java.util.List;

import com.spring.dao.ExamDao;
import com.spring.mapper.entities.ExamTest;

public interface ExamTestRepository {

	public List<?> getAllRecord();

	public ExamTest getExamTestById(long examTestId);

	public long insertExamDao(ExamDao examDao);

}
