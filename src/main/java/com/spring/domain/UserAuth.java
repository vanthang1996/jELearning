package com.spring.domain;

public class UserAuth {
	private String email;
	private String pwd;

	public UserAuth() {

	}

	public UserAuth(String email, String pwd) {
		super();
		this.email = email;
		this.pwd = pwd;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	@Override
	public String toString() {
		return "UserAuth [email=" + email + ", pwd=" + pwd + "]";
	}

}
