package com.spring.mapper.entities;

import java.util.List;

public class Chapter {
	private long chapterId;
	private String chapterName;
	private String describe;
	private long subjectId;
	private Subject subject;
	private List<Question> questions;

	public Chapter() {
	}

	public long getChapterId() {
		return chapterId;
	}

	public void setChapterId(long chapterId) {
		this.chapterId = chapterId;
	}

	public String getChapterName() {
		return chapterName;
	}

	public void setChapterName(String chapterName) {
		this.chapterName = chapterName;
	}

	public String getDescribe() {
		return describe;
	}

	public void setDescribe(String describe) {
		this.describe = describe;
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

	public List<Question> getQuestions() {
		return questions;
	}

	public void setQuestions(List<Question> questions) {
		this.questions = questions;
	}

	@Override
	public String toString() {
		return "Chapter [chapterId=" + chapterId + ", chapterName=" + chapterName + ", describe=" + describe
				+ ", subjectId=" + subjectId + ", subject=" + subject + ", questions=" + questions + "]";
	}

}
