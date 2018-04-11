package com.spring.mapper.entities;

public class SubjectManage {
	private long teacherId;
	private long subjectId;

	public SubjectManage() {
	}

	public long getTeacherId() {
		return teacherId;
	}

	public void setTeacherId(long teacherId) {
		this.teacherId = teacherId;
	}

	public long getSubjectId() {
		return subjectId;
	}

	public void setSubjectId(long subjectId) {
		this.subjectId = subjectId;
	}

	@Override
	public String toString() {
		return "SubjectManage [teacherId=" + teacherId + ", subjectId=" + subjectId + "]";
	}
}
