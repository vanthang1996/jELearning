package com.spring.mapper.entities;

import java.util.List;

public class Faculty {
	private long facultyId;
	private String facultyName;
	private long teacherManagementId;
	private List<Department> departments;

	public Faculty() {
	}

	public long getFacultyId() {
		return facultyId;
	}

	public void setFacultyId(long facultyId) {
		this.facultyId = facultyId;
	}

	public String getFacultyName() {
		return facultyName;
	}

	public void setFacultyName(String facultyName) {
		this.facultyName = facultyName;
	}

	public long getTeacherManagementId() {
		return teacherManagementId;
	}

	public void setTeacherManagementId(long teacherManagementId) {
		this.teacherManagementId = teacherManagementId;
	}

	public List<Department> getDepartments() {
		return departments;
	}

	public void setDepartments(List<Department> departments) {
		this.departments = departments;
	}

	@Override
	public String toString() {
		return "Faculty [facultyId=" + facultyId + ", facultyName=" + facultyName + ", teacherManagementId="
				+ teacherManagementId + ", departments=" + departments + "]";
	}

}
