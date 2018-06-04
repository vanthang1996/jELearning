package com.spring.mapper.entities;

public class CreateQuestion {
	private long jobId;
	private long chapterId;
	private int amount;
	private Job job;
	private Chapter chapter;

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

	public Job getJob() {
		return job;
	}

	public void setJob(Job job) {
		this.job = job;
	}

	public Chapter getChapter() {
		return chapter;
	}

	public void setChapter(Chapter chapter) {
		this.chapter = chapter;
	}

	@Override
	public String toString() {
		return "CreateQuestion [jobId=" + jobId + ", chapterId=" + chapterId + ", amount=" + amount + ", job=" + job
				+ ", chapter=" + chapter + "]";
	}

}
