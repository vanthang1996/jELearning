package com.spring.mapper.entities;

import java.time.LocalDateTime;
import java.util.List;

public class UserRole {
	private String email, pwd;
	private List<String> roles;
	private int status;

	
	public UserRole() {
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

	public List<String> getRoles() {
		return roles;
	}

	public void setRoles(List<String> roles) {
		this.roles = roles;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "User [email=" + email + ", pwd=" + pwd + ", roles=" + roles + ", status=" + status + "]";
	}

	public LocalDateTime getLastPasswordchange() {
		// TODO Auto-generated method stub
		return null;
	}
}
