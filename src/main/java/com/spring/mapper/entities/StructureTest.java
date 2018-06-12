package com.spring.mapper.entities;

import java.util.Date;
import java.util.List;

public class StructureTest {
	private long structureTestId;
	private long subjectId;
	private Date updateTime;
	private long teacherManagementId;
	private int status;
	private int maxStructure;
	private List<StrucTestDetail> strucTestDetails;

	public StructureTest() {
	}

	public long getStructureTestId() {
		return structureTestId;
	}

	public void setStructureTestId(long structureTestId) {
		this.structureTestId = structureTestId;
	}

	public long getSubjectId() {
		return subjectId;
	}

	public void setSubjectId(long subjectId) {
		this.subjectId = subjectId;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
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

	public int getMaxStructure() {
		return maxStructure;
	}

	public void setMaxStructure(int maxStructure) {
		this.maxStructure = maxStructure;
	}

	public List<StrucTestDetail> getStrucTestDetails() {
		return strucTestDetails;
	}

	public void setStrucTestDetails(List<StrucTestDetail> strucTestDetails) {
		this.strucTestDetails = strucTestDetails;
	}

	@Override
	public String toString() {
		return "StructureTest [structureTestId=" + structureTestId + ", subjectId=" + subjectId + ", updateTime="
				+ updateTime + ", teacherManagementId=" + teacherManagementId + ", status=" + status + ", maxStructure="
				+ maxStructure + ", strucTestDetails=" + strucTestDetails + "]";
	}

}
