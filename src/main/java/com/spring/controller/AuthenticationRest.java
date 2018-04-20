
package com.spring.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mobile.device.Device;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.config.jwt.JwtService;
import com.spring.domain.ApiMessage;
import com.spring.domain.UserAuth;
import com.spring.domain.UserTokenState;

@RestController
@EnableWebSecurity
@RequestMapping(value = "/auth")
public class AuthenticationRest {

	@Autowired
	private AuthenticationManager authenticationManager;
	@Autowired
	private JwtService jwtService;

	@Autowired
	private UserDetailsService userDetailsService;

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public ResponseEntity<?> createAuthenticationToken(@RequestBody UserAuth authenticationRequest,
			HttpServletResponse response, Device device) throws AuthenticationException, IOException {

		UserDetails userDetails;

		try {
			Authentication authentication = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(
					authenticationRequest.getEmail(), authenticationRequest.getPwd()));
			SecurityContextHolder.getContext().setAuthentication(authentication);

			userDetails = userDetailsService.loadUserByUsername(authenticationRequest.getEmail());

		} catch (Exception e) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.FORBIDDEN, e.getMessage());
			return new ResponseEntity<Object>(apiMessage, apiMessage.getStatusCode());
		}

		String jws = jwtService.generateToken(userDetails.getUsername(), device);
		int expiresIn = (int) jwtService.getExpiredIn(device);
		// Add cookie to response
		response.addCookie(jwtService.createAuthCookie(jws, expiresIn));
		// Return the token
		return ResponseEntity.ok(new UserTokenState(jws, expiresIn));
	}

}
