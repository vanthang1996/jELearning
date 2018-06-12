package com.spring.dao;

import java.io.Serializable;
import java.util.List;

public class ChapterDao implements Serializable {
	private long subjectId;
	private long chapterId;
	private String title;
	private double totalScore;
	private String describe;
	private long amount;
	private long levelId;
	private List<QuestionDao> questions;

	public ChapterDao(long subjectId, long chapterId, String title, double totalScore, String describe, long amount,
			long levelId) {
		super();
		this.subjectId = subjectId;
		this.chapterId = chapterId;
		this.title = title;
		this.totalScore = totalScore;
		this.describe = describe;
		this.amount = amount;
		this.levelId = levelId;
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

	public long getChapterId() {
		return chapterId;
	}

	public void setChapterId(long chapterId) {
		this.chapterId = chapterId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public double getTotalScore() {
		return totalScore;
	}

	public void setTotalScore(double totalScore) {
		this.totalScore = totalScore;
	}

	public String getDescribe() {
		return describe;
	}

	public void setDescribe(String describe) {
		this.describe = describe;
	}

	public long getAmount() {
		return amount;
	}

	public void setAmount(long amount) {
		this.amount = amount;
	}

	public List<QuestionDao> getQuestions() {
		return questions;
	}

	public void setQuestions(List<QuestionDao> questions) {
		this.questions = questions;
	}

	public ChapterDao() {
		super();
	}

	@Override
	public String toString() {
		return "ChapterDao [subjectId=" + subjectId + ", chapterId=" + chapterId + ", title=" + title + ", totalScore="
				+ totalScore + ", describe=" + describe + ", amount=" + amount + ", levelId=" + levelId + ", questions="
				+ questions + "]";
	}

}
