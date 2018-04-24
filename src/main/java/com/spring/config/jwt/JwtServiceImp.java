package com.spring.config.jwt;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.Enumeration;
import java.util.Optional;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mobile.device.Device;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.UserRole;
import com.spring.service.TeacherService;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.SignatureException;
import io.jsonwebtoken.impl.TextCodec;

/**
 *
 * @author tyler.intern
 */
@Service
public class JwtServiceImp implements JwtService {

	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass().getName());

	@Autowired
	private TeacherService teacherService;

	@Autowired
	private ConfigVariable configVariable;

	private static final SignatureAlgorithm SIGNATURE_ALGORITHM = SignatureAlgorithm.HS256;

	public static final String AUDIENCE_UNKNOWN = "unknown";
	public static final String AUDIENCE_WEB = "web";
	public static final String AUDIENCE_MOBILE = "mobile";
	public static final String AUDIENCE_TABLET = "tablet";

	@Override
	public String getEmailFromToKen(String token) {
		String userName;
		try {
			Claims claims = this.getAllClaimsFromToken(token);
			userName = claims.getSubject();
		} catch (Exception e) {
			userName = null;
			LOGGER.error("[User Name  get from token is null ]" + e.getMessage());
		}
		return userName;
	}

	@Override
	public LocalDateTime getIssuedDate(String token) {
		LocalDateTime issueAt = null;
		try {
			Claims claims = this.getAllClaimsFromToken(token);
			issueAt = LocalDateTime.ofInstant(claims.getIssuedAt().toInstant(), ZoneId.systemDefault());
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
		}
		return issueAt;
	}

	@Override
	public String getToken(HttpServletRequest request) {

		/**
		 * get token from from request header
		 */
		String authRequest = request.getHeader(this.configVariable.getJwtRequestHeader());
		Enumeration<String> headerNames = request.getHeaderNames();
		while (headerNames.hasMoreElements()) {
			String headerName = headerNames.nextElement();
			LOGGER.info("Header Name - " + headerName + ", Value - " + request.getHeader(headerName));
		}
		Enumeration<String> params = request.getParameterNames();
		while (params.hasMoreElements()) {
			String paramName = params.nextElement();
			LOGGER.info("Parameter Name - " + paramName + ", Value - " + request.getParameter(paramName));
		}
		if (authRequest != null) {
			if (authRequest.startsWith(this.configVariable.getJwtPrefix())) {
				/**
				 * subString token with (BEAR) length + space " "
				 */
				LOGGER.info("[Token get by Request of Client]: "
						+ authRequest.substring(this.configVariable.getJwtPrefix().length()));
				return authRequest.substring(this.configVariable.getJwtPrefix().length());
			}
		}

		/**
		 * get token from AUTH cookie
		 */
		Cookie cookie = this.getCookieByCookieName(this.configVariable.getJwtCookie(), request);

		if (cookie != null) {
			LOGGER.info(cookie.toString());
			return cookie.getValue();
		}

		return null;

	}

	public Cookie getCookieByCookieName(String cookieName, HttpServletRequest request) {
		if (request.getCookies() == null) {
			return null;
		}
		for (Cookie cookie : request.getCookies()) {
			if (cookie.getName().equals(cookieName)) {
				return cookie;
			}
		}
		return null;

	}

	@Override
	public Claims getAllClaimsFromToken(String token) {
		Claims claims;
		try {
			String jwtSerect = this.configVariable.getJwtSecret();
			LOGGER.info(jwtSerect);
			claims = (Claims) Jwts.parser().setSigningKey(TextCodec.BASE64.decode(jwtSerect)).parse(token).getBody();
		} catch (ExpiredJwtException | MalformedJwtException | SignatureException | IllegalArgumentException e) {
			LOGGER.error(e.getMessage());
			claims = null;
		}
		return claims;
	}

	@Override
	public boolean validateToken(String authToken, UserDetails userDetails) {
		/**
		 * check user name is exist on system user was login and store in UserDetails
		 */
		LOGGER.info(userDetails.getUsername());
		Optional<UserRole> user = this.teacherService.getUserRoleByEmail(userDetails.getUsername());
		LOGGER.info(user.toString());
		if (!user.isPresent()) {
			return false;
		}
		String userNameFromToken = this.getEmailFromToKen(authToken);
		LOGGER.info("[username form token] " + userNameFromToken);
		LocalDateTime issueDate = this.getIssuedDate(authToken);
		LOGGER.info("[issue date of token] " + issueDate.toString());
		// LocalDateTime userLastPasswordResetDate = user.get().getLastPasswordchange();
		LocalDateTime userLastPasswordResetDate = LocalDateTime.now();
		LOGGER.info("[last password reset date of user]" + userLastPasswordResetDate.toString());
		LOGGER.info("[isCreatedBeforeLastPasswordReset] : "
				+ !isCreatedBeforeLastPasswordReset(issueDate, userLastPasswordResetDate));
		return (userNameFromToken != null && user.get().getEmail().equals(userNameFromToken)
				&& (!isCreatedBeforeLastPasswordReset(issueDate, userLastPasswordResetDate)));
	}

	/**
	 * check issue date of token is before last password reset date of user
	 *
	 * @param issueDate
	 *            issue date of token
	 * @param userLastPasswordResetDate
	 *            last password reset date of user
	 * @return boolean
	 */
	private boolean isCreatedBeforeLastPasswordReset(LocalDateTime issueDate, LocalDateTime userLastPasswordResetDate) {
		return false;
		// return issueDate.isBefore(userLastPasswordResetDate);
	}

	@Override
	public String generateToken(String username, Device device) {
		String token = null;
		try {
			Date dateIssued = new Date();
			token = Jwts.builder().setSubject(username).setAudience(this.getAudience(device)).setIssuedAt(dateIssued)
					.setExpiration(this.generateExpirationDate(device, dateIssued))
					.signWith(SIGNATURE_ALGORITHM, TextCodec.BASE64.decode(this.configVariable.getJwtSecret()))
					.compact();
		} catch (Exception e) {
			LOGGER.error("[Generate Token is Failed]: " + e.getMessage());
		}

		return token;
	}

	private Date generateExpirationDate(Device device, Date dateIssued) {
		long expiresIn = 0;
		try {
			/**
			 * get expire time by device
			 */
			expiresIn = this.getExpiredIn(device);

			LOGGER.info(expiresIn + " [expire time in second]");
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
		}
		return new Date(dateIssued.getTime() + (expiresIn * 1000));

	}

	private String getAudience(Device device) {
		String audience = AUDIENCE_UNKNOWN;
		if (device.isNormal()) {
			audience = AUDIENCE_WEB;
		} else if (device.isTablet()) {
			audience = AUDIENCE_TABLET;
		} else if (device.isMobile()) {
			audience = AUDIENCE_MOBILE;
		}

		return audience;

	}

	@Override
	public long getExpiredIn(Device device) {
		long timeExpiredIn = 0;

		if (device.isNormal()) {
			timeExpiredIn = Long.valueOf(this.configVariable.getJwtExpiration());
		} else {
			if (device.isTablet() || device.isMobile()) {
				timeExpiredIn = Long.valueOf(this.configVariable.getJwtExpirationMobile());
			}
		}
		return timeExpiredIn;
	}

	/**
	 * create authentication cookie
	 *
	 * @param jwt
	 *            JSON web token
	 * @param expiresIn
	 *            cookie expiration time
	 * @return authentication cookie
	 */
	@Override
	public Cookie createAuthCookie(String jwt, int expiresIn) {
		Cookie authCookie = new Cookie(this.configVariable.getJwtCookie(), jwt);
		authCookie.setPath("/");
		authCookie.setHttpOnly(true);
		authCookie.setMaxAge(expiresIn);
		return authCookie;

	}

}