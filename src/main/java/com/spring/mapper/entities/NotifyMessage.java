package com.spring.mapper.entities;

import java.util.Date;

public class NotifyMessage {
	private long messageId;
	private String title;
	private String body;
	private Date dateTo;
	private Date dateView;
	private long teacherSendId;
	private long teacherReceiveId;
	private int status;
	private Teacher teacherSend;
	private Teacher teacherReceive;

	public NotifyMessage() {
		super();
	}

	public long getMessageId() {
		return messageId;
	}

	public void setMessageId(long messageId) {
		this.messageId = messageId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	public Date getDateTo() {
		return dateTo;
	}

	public void setDateTo(Date dateTo) {
		this.dateTo = dateTo;
	}

	public Date getDateView() {
		return dateView;
	}

	public void setDateView(Date dateView) {
		this.dateView = dateView;
	}

	public long getTeacherSendId() {
		return teacherSendId;
	}

	public void setTeacherSendId(long teacherSendId) {
		this.teacherSendId = teacherSendId;
	}

	public long getTeacherReceiveId() {
		return teacherReceiveId;
	}

	public void setTeacherReceiveId(long teacherReceiveId) {
		this.teacherReceiveId = teacherReceiveId;
	}

	public Teacher getTeacherSend() {
		return teacherSend;
	}

	public void setTeacherSend(Teacher teacherSend) {
		this.teacherSend = teacherSend;
	}

	public Teacher getTeacherReceive() {
		return teacherReceive;
	}

	public void setTeacherReceive(Teacher teacherReceive) {
		this.teacherReceive = teacherReceive;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "NotifyMessage [messageId=" + messageId + ", title=" + title + ", body=" + body + ", dateTo=" + dateTo
				+ ", dateView=" + dateView + ", teacherSendId=" + teacherSendId + ", teacherReceiveId="
				+ teacherReceiveId + ", status=" + status + ", teacherSend=" + teacherSend + ", teacherReceive="
				+ teacherReceive + "]";
	}
	

}
