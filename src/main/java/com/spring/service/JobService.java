package com.spring.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.spring.mapper.entities.Job;

public interface JobService {
	public List<?> getAllRecord();

	public Optional<?> getJobsByTeacherIdPaging(long teacherId, int page, int size);

	String addOutLine(Job job);

	public String addStructureTest(Job job);

	public Job addQuestionJob(Job job);

	public Map<String, Object> getJobByManageTeacher(long teacherId, long jobTypeId, boolean status, int page,
			int size);

	/**
	 * @param teacherId
	 * @param size
	 * @param page
	 * @return Map Job paging with status= false,
	 */
	public Map<String, Object> getJobsOfTeacher(long teacherId, int page, int size);

	public Optional<?> getJobByTeacherId(long teacherId);

	public Job getJobByJobId(long jobId);

	public boolean updateStatusJob(long jobId, boolean b);

	public boolean reviewQuestion(long jobId);


	public boolean submitOutLine(long jobId);

	public boolean submitStruc(long jobId);

}
