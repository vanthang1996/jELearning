package com.spring.domain;

import org.springframework.http.HttpStatus;

public class ApiMessage {
	private HttpStatus statusCode;
	private String message;
	
	public ApiMessage(HttpStatus statusCode, String message) {
		super();
		this.statusCode = statusCode;
		this.message = message;
	}

	public ApiMessage() {
		super();
	}

	public HttpStatus getStatusCode() {
		return statusCode;
	}

	public void setStatusCode(HttpStatus statusCode) {
		this.statusCode = statusCode;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	@Override
	public String toString() {
		return "ApiMessage [statusCode=" + statusCode + ", message=" + message + "]";
	}
}
