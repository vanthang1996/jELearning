package com.spring.mapper.entities;

import java.util.List;

public class Question {
	private long questionId;
	private String content;
	private long chapterId;
	private long subjectId;
	private long levelId;
	private long teacherCreateId;
	private int status;
	private List<Answer> answers;

	public Question() {
	}

	public long getQuestionId() {
		return questionId;
	}

	public void setQuestionId(long questionId) {
		this.questionId = questionId;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public long getChapterId() {
		return chapterId;
	}

	public void setChapterId(long chapterId) {
		this.chapterId = chapterId;
	}

	public long getSubjectId() {
		return subjectId;
	}

	public void setSubjectId(long subjectId) {
		this.subjectId = subjectId;
	}

	public long getLevelId() {
		return levelId;
	}

	public void setLevelId(long levelId) {
		this.levelId = levelId;
	}

	public long getTeacherCreateId() {
		return teacherCreateId;
	}

	public void setTeacherCreateId(long teacherCreateId) {
		this.teacherCreateId = teacherCreateId;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public List<Answer> getAnswers() {
		return answers;
	}

	public void setAnswers(List<Answer> answers) {
		this.answers = answers;
	}

	@Override
	public String toString() {
		return "Question [questionId=" + questionId + ", content=" + content + ", chapterId=" + chapterId
				+ ", subjectId=" + subjectId + ", levelId=" + levelId + ", teacherCreateId=" + teacherCreateId
				+ ", status=" + status + ", answers=" + answers + "]";
	}
}
