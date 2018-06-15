package com.spring.dao;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class ExamDao implements Serializable {
	private List<ChapterDao> chapters;
	private long examTestId;
	private long subjectId;
	private long strucTestId;
	private Date createTime;
	private Date doTime;
	private boolean status;

	public ExamDao() {
		super();
	}

	public ExamDao(long subjectId, long strucTestId) {
		super();
		this.subjectId = subjectId;
		this.strucTestId = strucTestId;
	}

	public ExamDao(long examTestId, long subjectId, long strucTestId, Date createTime, Date doTime, boolean status) {
		super();
		this.examTestId = examTestId;
		this.subjectId = subjectId;
		this.strucTestId = strucTestId;
		this.createTime = createTime;
		this.doTime = doTime;
		this.status = status;
	}

	public List<ChapterDao> getChapters() {
		return chapters;
	}

	public void setChapters(List<ChapterDao> chapters) {
		this.chapters = chapters;
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

	public long getStrucTestId() {
		return strucTestId;
	}

	public void setStrucTestId(long strucTestId) {
		this.strucTestId = strucTestId;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getDoTime() {
		return doTime;
	}

	public void setDoTime(Date doTime) {
		this.doTime = doTime;
	}

	public boolean isStatus() {
		return status;
	}

	public void setStatus(boolean status) {
		this.status = status;
	}

	@Override
	public String toString() {
		String rs = "";
		rs += this.chapters.size();
		for (int i = 0; i < this.chapters.size(); i++) {
			rs += "\n" + this.chapters.get(i);
		}
		return rs;
	}

}
