package com.spring.mapper.entities;

public class ExamTestDetail {
	private long examTestId;
	private long questionId;
	private int correctLocation;
	private double score;

	public ExamTestDetail() {
	}

	public long getExamTestId() {
		return examTestId;
	}

	public void setExamTestId(long examTestId) {
		this.examTestId = examTestId;
	}

	public long getQuestionId() {
		return questionId;
	}

	public void setQuestionId(long questionId) {
		this.questionId = questionId;
	}

	public int getCorrectLocation() {
		return correctLocation;
	}

	public void setCorrectLocation(int correctLocation) {
		this.correctLocation = correctLocation;
	}

	public double getScore() {
		return score;
	}

	public void setScore(double score) {
		this.score = score;
	}

	@Override
	public String toString() {
		return "ExamTestDetail [examTestId=" + examTestId + ", questionId=" + questionId + ", correctLocation="
				+ correctLocation + ", score=" + score + "]";
	}

}
