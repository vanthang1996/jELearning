package com.spring.config.api;

import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ClientExeptionHandle {

	// @ExceptionHandler({ Exception.class })
	// @ResponseStatus(HttpStatus.NOT_FOUND)
	// public ResponseEntity<ApiError> exceptionHandlerForNoHandleFound(Exception e,
	// HttpServletRequest request) {
	// ApiError apiError = new ApiError(HttpStatus.NOT_FOUND,
	// HttpStatus.NOT_FOUND.value(),
	// ApiError.getFullURL(request), Arrays.asList(e.getMessage()));
	// return new ResponseEntity<>(apiError, apiError.getStatus());
	// }
}
