package com.spring.controller;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.mapper.entities.Job;
import com.spring.service.JobService;

@RestController
@RequestMapping("/job")
public class JobRest {
	@Autowired
	private JobService jobService;

	@RequestMapping("/add-out-line")
	public ResponseEntity<?> addOutLine(@RequestBody Job job) throws JsonProcessingException {
		Date startTime = new Date();
		ObjectMapper mapper = new ObjectMapper();
		String message;
		if (job.getEndTime().after(startTime)) {
			job.setStartTime(startTime);
			message = this.jobService.addOutLine(job);
		} else
			message = "Invalid end date!";
		return new ResponseEntity<>(mapper.writeValueAsString(message), HttpStatus.OK);
	}

}
