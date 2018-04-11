package com.spring.mapper.entities;

public class Answer {
	private long questionId;
	private long answerId;
	private String content;
	private boolean correctAnswer;

	public Answer() {
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
		return "Answer [questionId=" + questionId + ", answerId=" + answerId + ", content=" + content
				+ ", correctAnswer=" + correctAnswer + "]";
	}
}
