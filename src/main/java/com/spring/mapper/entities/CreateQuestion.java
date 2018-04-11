package com.spring.mapper.entities;

public class CreateQuestion {
	private long jobId;
	private long chapterId;
	private int amount;

	public CreateQuestion() {
	}

	public long getJobId() {
		return jobId;
	}

	public void setJobId(long jobId) {
		this.jobId = jobId;
	}

	public long getChapterId() {
		return chapterId;
	}

	public void setChapterId(long chapterId) {
		this.chapterId = chapterId;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	@Override
	public String toString() {
		return "CreateQuestion [jobId=" + jobId + ", chapterId=" + chapterId + ", amount=" + amount + "]";
	}

}
