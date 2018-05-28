package com.spring.repository;

import java.util.List;
import java.util.Optional;

public interface JobRepository {
	public List<?> getAllRecord();

	public Optional<?> getJobsByTeacherIdPaging(long teacherId, int page, int size);
}
