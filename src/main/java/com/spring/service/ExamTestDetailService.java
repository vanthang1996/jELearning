package com.spring.service;

import java.util.List;
import java.util.Optional;

public interface ExamTestDetailService {
	public List<?> getAllRecord();

	public Optional<?> getExamTestDetailById(long examTestId);

}
