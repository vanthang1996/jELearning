package com.spring.dao;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class QuestionDao implements Serializable {
	private long questionId;
	private String content;
	private long subjectId;
	private long levelId;
	private long teacherId;
	private double score;
	List<AnswerDao> list = new ArrayList<>();

	public QuestionDao() {
		super();
	}

	public QuestionDao(long questionId, String content, long subjectId, long levelId, long teacherId) {
		super();
		this.questionId = questionId;
		this.content = content;
		this.subjectId = subjectId;
		this.levelId = levelId;
		this.teacherId = teacherId;
	}

	public QuestionDao(long questionId, String content, long subjectId, long levelId, long teacherId, double score,
			List<AnswerDao> list) {
		super();
		this.questionId = questionId;
		this.content = content;
		this.subjectId = subjectId;
		this.levelId = levelId;
		this.teacherId = teacherId;
		this.score = score;
		this.list = list;
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

	public long getTeacherId() {
		return teacherId;
	}

	public void setTeacherId(long teacherId) {
		this.teacherId = teacherId;
	}

	public double getScore() {
		return score;
	}

	public void setScore(double score) {
		this.score = score;
	}

	public List<AnswerDao> getList() {
		return list;
	}

	public void setList(List<AnswerDao> list) {
		this.list = list;
	}

	@Override
	public String toString() {
		return "QuestionDao [questionId=" + questionId + ", content=" + content + ", subjectId=" + subjectId
				+ ", levelId=" + levelId + ", teacherId=" + teacherId + ", score=" + score + ", list=" + list + "]";
	}

}
