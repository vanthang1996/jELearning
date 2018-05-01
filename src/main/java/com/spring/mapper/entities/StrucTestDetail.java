package com.spring.mapper.entities;

public class StrucTestDetail {
	private long structureTestId;
	private long chapterId;
	private long levelId;
	private int numberOfQuestion;
	private double totalScore;
	private StructureTest structureTest;
	private Chapter chapter;
	private Level level;

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

	public StructureTest getStructureTest() {
		return structureTest;
	}

	public void setStructureTest(StructureTest structureTest) {
		this.structureTest = structureTest;
	}

	public Chapter getChapter() {
		return chapter;
	}

	public void setChapter(Chapter chapter) {
		this.chapter = chapter;
	}

	public Level getLevel() {
		return level;
	}

	public void setLevel(Level level) {
		this.level = level;
	}

	@Override
	public String toString() {
		return "StrucTestDetail [structureTestId=" + structureTestId + ", chapterId=" + chapterId + ", levelId="
				+ levelId + ", numberOfQuestion=" + numberOfQuestion + ", totalScore=" + totalScore + ", structureTest="
				+ structureTest + ", chapter=" + chapter + ", level=" + level + "]";
	}

}
