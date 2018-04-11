package com.spring.mapper.entities;

import java.util.Date;
import java.util.List;

public class Teacher {
	private long teacherId;
	private String firstName;
	private String lastName;
	private Date birthDay;
	private String email;
	private String avatar;
	private String address;
	private String phoneNumber;
	private boolean sex;
	private long departmentId;
	private List<SubjectManage> subjects;
	private List<Job> jobs;

	public Teacher() {
	}

	public long getTeacherId() {
		return teacherId;
	}

	public void setTeacherId(long teacherId) {
		this.teacherId = teacherId;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public Date getBirthDay() {
		return birthDay;
	}

	public void setBirthDay(Date birthDay) {
		this.birthDay = birthDay;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public boolean isSex() {
		return sex;
	}

	public void setSex(boolean sex) {
		this.sex = sex;
	}

	public long getDepartmentId() {
		return departmentId;
	}

	public void setDepartmentId(long departmentId) {
		this.departmentId = departmentId;
	}

	public List<SubjectManage> getSubjects() {
		return subjects;
	}

	public void setSubjects(List<SubjectManage> subjects) {
		this.subjects = subjects;
	}

	public List<Job> getJobs() {
		return jobs;
	}

	public void setJobs(List<Job> jobs) {
		this.jobs = jobs;
	}

	@Override
	public String toString() {
		return "Teacher [teacherId=" + teacherId + ", firstName=" + firstName + ", lastName=" + lastName + ", birthDay="
				+ birthDay + ", email=" + email + ", avatar=" + avatar + ", address=" + address + ", phoneNumber="
				+ phoneNumber + ", sex=" + sex + ", departmentId=" + departmentId + ", subjects=" + subjects + ", jobs="
				+ jobs + "]";
	}

}
