package com.spring.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mobile.device.Device;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserRest {
	private static final Logger LOGGER = LoggerFactory.getLogger(UserRest.class);

	@RequestMapping(value = "/device", method = RequestMethod.GET)
	public void home(Device device) {
		if (device.isMobile()) {
			LOGGER.info("Hello mobile user!");
		} else if (device.isTablet()) {
			LOGGER.info("Hello tablet user!");
		} else {
			LOGGER.info("Hello desktop user!");
		}
	}

}