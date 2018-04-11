package com.spring.mapper.entities;

public class StrucTestDetail {
	private long structureTestId;
	private long chapterId;
	private long levelId;
	private int numberOfQuestion;
	private double totalScore;

	public StrucTestDetail() {
	}

	public long getStructureTestId() {
		return structureTestId;
	}

	public void setStructureTestId(long structureTestId) {
		this.structureTestId = structureTestId;
	}

	public long getChapterId() {
		return chapterId;
	}

	public void setChapterId(long chapterId) {
		this.chapterId = chapterId;
	}

	public long getLevelId() {
		return levelId;
	}

	public void setLevelId(long levelId) {
		this.levelId = levelId;
	}

	public int getNumberOfQuestion() {
		return numberOfQuestion;
	}

	public void setNumberOfQuestion(int numberOfQuestion) {
		this.numberOfQuestion = numberOfQuestion;
	}

	public double getTotalScore() {
		return totalScore;
	}

	public void setTotalScore(double totalScore) {
		this.totalScore = totalScore;
	}

	@Override
	public String toString() {
		return "StrucTestDetail [structureTestId=" + structureTestId + ", chapterId=" + chapterId + ", levelId="
				+ levelId + ", numberOfQuestion=" + numberOfQuestion + ", totalScore=" + totalScore + "]";
	}

}
