package com.spring.repository;

import java.util.List;
import java.util.Optional;

public interface ExamTestRepository {

	public List<?> getAllRecord();

	public Optional<?> getExamTestById(long examTestId);

}
