package com.spring.repository;

import java.util.List;
import java.util.Optional;

public interface ExamTestDetailRepositpory {
	public List<?> getAllRecord();

	public Optional<?> getExamTestDetailById(long examTestId);
}
