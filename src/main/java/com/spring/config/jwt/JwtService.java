package com.spring.config.jwt;

import java.time.LocalDateTime;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.springframework.mobile.device.Device;
import org.springframework.security.core.userdetails.UserDetails;

import io.jsonwebtoken.Claims;

/**
 * @author vanth
 *
 */
public interface JwtService {

	public String getEmailFromToKen(String token);

	public LocalDateTime getIssuedDate(String token);

	/**
	 * get token from AUTH cookie if cookie value null get token from AUTH request
	 * start with BEAR
	 *
	 * @param request
	 *            HttpServletRequest
	 * @return String token
	 */
	
	public String getToken(HttpServletRequest request);

	public Claims getAllClaimsFromToken(String token);

	public boolean validateToken(String authToken, UserDetails userDetails);

	public String generateToken(String username, Device device);

	public long getExpiredIn(Device device);

	public Cookie createAuthCookie(String jwt, int expiresIn);

}