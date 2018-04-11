package com.spring.mapper.entities;

import java.util.List;

public class Department {
	private long departmentId;
	private String departmentName;
	private long facultyId;
	private long teacherManagementId;
	private List<Teacher> teachers;
	private List<Subject> subjects;

	public Department() {
	}

	public long getDepartmentId() {
		return departmentId;
	}

	public void setDepartmentId(long departmentId) {
		this.departmentId = departmentId;
	}

	public String getDepartmentName() {
		return departmentName;
	}

	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}

	public long getFacultyId() {
		return facultyId;
	}

	public void setFacultyId(long facultyId) {
		this.facultyId = facultyId;
	}

	public long getTeacherManagementId() {
		return teacherManagementId;
	}

	public void setTeacherManagementId(long teacherManagementId) {
		this.teacherManagementId = teacherManagementId;
	}

	public List<Teacher> getTeachers() {
		return teachers;
	}

	public void setTeachers(List<Teacher> teachers) {
		this.teachers = teachers;
	}

	public List<Subject> getSubjects() {
		return subjects;
	}

	public void setSubjects(List<Subject> subjects) {
		this.subjects = subjects;
	}

	@Override
	public String toString() {
		return "Department [departmentId=" + departmentId + ", departmentName=" + departmentName + ", facultyId="
				+ facultyId + ", teacherManagementId=" + teacherManagementId + ", teachers=" + teachers + ", subjects="
				+ subjects + "]";
	}

}
