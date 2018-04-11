package com.spring.mapper.entities;

/**
 * @author vanth
 *
 */
public class Level {
	private long levelId;
	private String levelName;

	public Level() {
	}

	public Level(long levelId, String levelName) {
		this.levelId = levelId;
		this.levelName = levelName;
	}

	public long getLevelId() {
		return levelId;
	}

	public void setLevelId(long levelId) {
		this.levelId = levelId;
	}

	public String getLevelName() {
		return levelName;
	}

	public void setLevelName(String levelName) {
		this.levelName = levelName;
	}

	@Override
	public String toString() {
		return "Level [levelId=" + levelId + ", levelName=" + levelName + "]";
	}

}
