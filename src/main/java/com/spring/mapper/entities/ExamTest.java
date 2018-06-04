package com.spring.mapper.entities;

import java.util.Date;

public class ExamTest {
	private long examTestId;
	private long subjectId;
	private Date createTime;
	private Date testDay;
	private int timeDo;
	private int status;
	private Subject subject;

	public ExamTest() {
	}

	public long getExamTestId() {
		return examTestId;
	}

	public void setExamTestId(long examTestId) {
		this.examTestId = examTestId;
	}

	public long getSubjectId() {
		return subjectId;
	}

	public void setSubjectId(long subjectId) {
		this.subjectId = subjectId;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getTestDay() {
		return testDay;
	}

	public void setTestDay(Date testDay) {
		this.testDay = testDay;
	}

	public int getTimeDo() {
		return timeDo;
	}

	public void setTimeDo(int timeDo) {
		this.timeDo = timeDo;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public Subject getSubject() {
		return subject;
	}

	public void setSubject(Subject subject) {
		this.subject = subject;
	}

	@Override
	public String toString() {
		return "ExamTest [examTestId=" + examTestId + ", subjectId=" + subjectId + ", createTime=" + createTime
				+ ", testDay=" + testDay + ", timeDo=" + timeDo + ", status=" + status + ", subject=" + subject + "]";
	}

}
