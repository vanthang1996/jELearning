package com.spring.mapper.entities;

import java.util.Date;

public class Job {
	private long jobId;
	private long subjectId;
	private Subject subject;
	private long teacherId;
	private Teacher teacher;
	private long jobTypeId;
	private JobType jobType;
	private Date startTime;
	private Date endTime;
	private String jobContent;
	private int status;

	public Job() {
	}

	public long getJobId() {
		return jobId;
	}

	public void setJobId(long jobId) {
		this.jobId = jobId;
	}

	public long getSubjectId() {
		return subjectId;
	}

	public void setSubjectId(long subjectId) {
		this.subjectId = subjectId;
	}

	public Subject getSubject() {
		return subject;
	}

	public void setSubject(Subject subject) {
		this.subject = subject;
	}

	public long getTeacherId() {
		return teacherId;
	}

	public void setTeacherId(long teacherId) {
		this.teacherId = teacherId;
	}

	public Teacher getTeacher() {
		return teacher;
	}

	public void setTeacher(Teacher teacher) {
		this.teacher = teacher;
	}

	public long getJobTypeId() {
		return jobTypeId;
	}

	public void setJobTypeId(long jobTypeId) {
		this.jobTypeId = jobTypeId;
	}

	public JobType getJobType() {
		return jobType;
	}

	public void setJobType(JobType jobType) {
		this.jobType = jobType;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public String getJobContent() {
		return jobContent;
	}

	public void setJobContent(String jobContent) {
		this.jobContent = jobContent;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "Job [jobId=" + jobId + ", subjectId=" + subjectId + ", subject=" + subject + ", teacherId=" + teacherId
				+ ", teacher=" + teacher + ", jobTypeId=" + jobTypeId + ", jobType=" + jobType + ", startTime="
				+ startTime + ", endTime=" + endTime + ", jobContent=" + jobContent + ", status=" + status + "]";
	}

}
