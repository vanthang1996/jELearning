package com.spring.service;

import java.util.List;
import java.util.Optional;

public interface ExamTestService {

	public List<?> getAllRecord();

	public Optional<?> getExamTestById(long examTestId);

}
