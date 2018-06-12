package com.spring.service;

import java.util.List;

import com.spring.mapper.entities.ExamTest;

public interface ExamTestService {

	public List<?> getAllRecord();

	public ExamTest getExamTestById(long examTestId);

}
