package com.spring.config.jwt;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/*
 * Mapping cac gia tri nam trong file jwt.properties
 * 
 * */

@Component
public class ConfigVariable {

	@Value("${jwt.header}")
	private String jwtRequestHeader;

	@Value("${jwt.secret}")
	private String jwtSecret;

	@Value("${jwt.prefix}")
	private String jwtPrefix;

	@Value("${jwt.expiration}")
	private String jwtExpiration;

	@Value("${jwt.expiration.mobile}")
	private String jwtExpirationMobile;

	@Value("${jwt.cookie}")
	private String jwtCookie;

	@Value("${jwt.route.authentication.path}")
	private String jwtRouteAuthenticationPath;

	@Value("${jwt.route.authentication.refresh}")
	private String jwtRouteAuthenticationRefresh;
	@Value("${google.service_account_email}")
	private String serviceAccountId;

	@Value("${google.application_name}")
	private String applicationName;

	@Value("${google.service_account_key}")
	private String serviceAccountKey;

	@Value("${google.folder_id}")
	private String folderId;

	public String getServiceAccountId() {
		return serviceAccountId;
	}

	public String getApplicationName() {
		return applicationName;
	}

	public String getServiceAccountKey() {
		return serviceAccountKey;
	}

	public String getFolderId() {
		return folderId;
	}

	public String getJwtRequestHeader() {
		return jwtRequestHeader;
	}

	public String getJwtSecret() {
		return jwtSecret;
	}

	public String getJwtPrefix() {
		return jwtPrefix;
	}

	public String getJwtExpiration() {
		return jwtExpiration;
	}

	public String getJwtExpirationMobile() {
		return jwtExpirationMobile;
	}

	public String getJwtCookie() {
		return jwtCookie;
	}

	public String getJwtRouteAuthenticationPath() {
		return jwtRouteAuthenticationPath;
	}

	public String getJwtRouteAuthenticationRefresh() {
		return jwtRouteAuthenticationRefresh;
	}

	@Override
	public String toString() {
		return "ConfigVariable [jwtRequestHeader=" + jwtRequestHeader + ", jwtSecret=" + jwtSecret + ", jwtPrefix="
				+ jwtPrefix + ", jwtExpiration=" + jwtExpiration + ", jwtExpirationMobile=" + jwtExpirationMobile
				+ ", jwtCookie=" + jwtCookie + ", jwtRouteAuthenticationPath=" + jwtRouteAuthenticationPath
				+ ", jwtRouteAuthenticationRefresh=" + jwtRouteAuthenticationRefresh + ", serviceAccountId="
				+ serviceAccountId + ", applicationName=" + applicationName + ", serviceAccountKey=" + serviceAccountKey
				+ ", folderId=" + folderId + "]";
	}

}
