package com.spring.repository;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.spring.mapper.entities.Job;

public interface JobRepository {
	public List<?> getAllRecord();

	public Optional<?> getJobsByTeacherIdPaging(long teacherId, int page, int size);

	String addOutLine(Job job);

	public String addStructureTest(Job job);

	/**
	 * @param job
	 * @return null if can not insert
	 */
	Job addQuestionJob(Job job);

	Job findById(long jobId);

	public Map<String, Object> getJobByManageTeacher(long teacherId, long jobTypeId, boolean status, int page,
			int size);

}
