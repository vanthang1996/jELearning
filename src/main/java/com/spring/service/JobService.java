package com.spring.service;

import java.util.List;
import java.util.Optional;

public interface JobService {
	public List<?> getAllRecord();

	public Optional<?> getJobsByTeacherIdPaging(long teacherId, int page, int size);
}
