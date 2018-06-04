package com.spring.serviceImp;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.Job;
import com.spring.repository.JobRepository;
import com.spring.service.JobService;

@Service
public class JobServiceImp implements JobService {

	@Autowired
	private JobRepository jobRepository;

	@Override
	public List<?> getAllRecord() {
		return this.jobRepository.getAllRecord();
	}

	@Override
	public Optional<?> getJobsByTeacherIdPaging(long teacherId, int page, int size) {
		return this.jobRepository.getJobsByTeacherIdPaging(teacherId, page, size);
	}

	@Override
	public String addOutLine(Job job) {
		return this.jobRepository.addOutLine(job);
	}

	@Override
	public String addStructureTest(Job job) {
		return this.jobRepository.addStructureTest(job);
	}

	@Override
	public Job addQuestionJob(Job job) {
		return this.jobRepository.addQuestionJob(job);
	}
	@Override
	public Map<String, Object> getJobByManageTeacher(long teacherId, long jobTypeId, boolean status, int page,
			int size) {
		return this.jobRepository.getJobByManageTeacher(teacherId, jobTypeId, status, page, size);
	}

}
