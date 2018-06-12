package com.spring.domain;

public class SendMesssage {
	private String user;
	private String message;

	public SendMesssage() {
		super();
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	@Override
	public String toString() {
		return "SendMesssage [user=" + user + ", message=" + message + "]";
	}
}
