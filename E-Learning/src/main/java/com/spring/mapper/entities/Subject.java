package com.spring.mapper.entities;

import java.util.List;

public class Subject {
	private long subjectId;
	private String subjectName;
	private long departmentId;
	private long teacherManagementId;
	private int status;
	private List<SubjectManage> teachers;
	private StructureTest structureTest;
	private List<ExamTest> examTests;
	private List<Chapter> chapters;
	private List<Question> questions;

	public Subject() {
	}

	public long getSubjectId() {
		return subjectId;
	}

	public void setSubjectId(long subjectId) {
		this.subjectId = subjectId;
	}

	public String getSubjectName() {
		return subjectName;
	}

	public void setSubjectName(String subjectName) {
		this.subjectName = subjectName;
	}

	public long getDepartmentId() {
		return departmentId;
	}

	public void setDepartmentId(long departmentId) {
		this.departmentId = departmentId;
	}

	public long getTeacherManagementId() {
		return teacherManagementId;
	}

	public void setTeacherManagementId(long teacherManagementId) {
		this.teacherManagementId = teacherManagementId;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	/**
	 * Chức năng chưa được thực hiện
	 * 
	 * @return null
	 */
	public List<SubjectManage> getTeachers() {
		return teachers;
	}

	public void setTeachers(List<SubjectManage> teachers) {
		this.teachers = teachers;
	}

	public StructureTest getStructureTest() {
		return structureTest;
	}

	public void setStructureTest(StructureTest structureTest) {
		this.structureTest = structureTest;
	}

	public List<ExamTest> getExamTests() {
		return examTests;
	}

	public void setExamTests(List<ExamTest> examTests) {
		this.examTests = examTests;
	}

	public List<Chapter> getChapters() {
		return chapters;
	}

	public void setChapters(List<Chapter> chapters) {
		this.chapters = chapters;
	}

	public List<Question> getQuestions() {
		return questions;
	}

	public void setQuestions(List<Question> questions) {
		this.questions = questions;
	}

	@Override
	public String toString() {
		return "Subject [subjectId=" + subjectId + ", subjectName=" + subjectName + ", departmentId=" + departmentId
				+ ", teacherManagementId=" + teacherManagementId + ", status=" + status + ", teachers=" + teachers
				+ ", structureTest=" + structureTest + ", examTests=" + examTests + ", chapters=" + chapters
				+ ", questions=" + questions + "]";
	}

}
