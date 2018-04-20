package com.spring.domain;

public class UserTokenState {
	private String token;
	private int ExpiredIn;

	public UserTokenState(String token, int expiredIn) {
		super();
		this.token = token;
		ExpiredIn = expiredIn;
	}

	public UserTokenState() {
		super();
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public int getExpiredIn() {
		return ExpiredIn;
	}

	public void setExpiredIn(int expiredIn) {
		ExpiredIn = expiredIn;
	}

	@Override
	public String toString() {
		return "UserTokenState [token=" + token + ", ExpiredIn=" + ExpiredIn + "]";
	}

}