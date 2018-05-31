package com.spring.repository;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.Job;

public interface JobRepository {
	public List<?> getAllRecord();

	public Optional<?> getJobsByTeacherIdPaging(long teacherId, int page, int size);

	String addOutLine(Job job);
}
