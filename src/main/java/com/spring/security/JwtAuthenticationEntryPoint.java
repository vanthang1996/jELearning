package com.spring.security;

import java.io.IOException;
import java.io.Serializable;
import java.util.Arrays;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.domain.ApiErrorMessage;

/**
*
* @author tyler.intern
*/
/**
 * throw 401 exception when user try to access API without Unauthorized
 *
 */
@Component
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void commence(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException authException) throws IOException, ServletException {

		response.setContentType("application/json");
		response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
		ApiErrorMessage apiError = new ApiErrorMessage();
		apiError.setStatus(HttpStatus.UNAUTHORIZED);

		apiError.setUrl(ApiErrorMessage.getFullURL(request));
		apiError.setCode(HttpStatus.UNAUTHORIZED.value());
		apiError.setErrors(Arrays.asList(authException.getMessage()));
		/**
		 * convert object to JSON String using JACKSON lib
		 */
		ObjectMapper mapper = new ObjectMapper();
		String jsonObject = mapper.writeValueAsString(apiError);

		response.getOutputStream().println(jsonObject);
		response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
	}

}