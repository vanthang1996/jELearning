package com.spring.dao;

import java.io.Serializable;

public class AnswerDao  implements Serializable{
	private long questionId;
	private long answerId;
	private String content;
	private boolean correctAnswer;

	public AnswerDao() {
		super();
	}

	public AnswerDao(long questionId, long answerId, String content, boolean correctAnswer) {
		super();
		this.questionId = questionId;
		this.answerId = answerId;
		this.content = content;
		this.correctAnswer = correctAnswer;
	}

	public long getQuestionId() {
		return questionId;
	}

	public void setQuestionId(long questionId) {
		this.questionId = questionId;
	}

	public long getAnswerId() {
		return answerId;
	}

	public void setAnswerId(long answerId) {
		this.answerId = answerId;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public boolean isCorrectAnswer() {
		return correctAnswer;
	}

	public void setCorrectAnswer(boolean correctAnswer) {
		this.correctAnswer = correctAnswer;
	}

	@Override
	public String toString() {
		return "AnswerDao [questionId=" + questionId + ", answerId=" + answerId + ", content=" + content
				+ ", correctAnswer=" + correctAnswer + "]";
	}

}
