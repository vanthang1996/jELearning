package com.spring.mapper.entities;

import java.util.Date;

public class Job {
	private long jobId;
	private long subjectId;
	private long teacherId;
	private long jobTypeId;
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

	public long getTeacherId() {
		return teacherId;
	}

	public void setTeacherId(long teacherId) {
		this.teacherId = teacherId;
	}

	public long getJobTypeId() {
		return jobTypeId;
	}

	public void setJobTypeId(long jobTypeId) {
		this.jobTypeId = jobTypeId;
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
		return "Job [jobId=" + jobId + ", subjectId=" + subjectId + ", teacherId=" + teacherId + ", jobTypeId="
				+ jobTypeId + ", startTime=" + startTime + ", endTime=" + endTime + ", jobContent=" + jobContent
				+ ", status=" + status + "]";
	}

}
