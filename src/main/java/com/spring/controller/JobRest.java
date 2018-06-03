package com.spring.controller;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.mapper.entities.CreateQuestion;
import com.spring.mapper.entities.Job;
import com.spring.service.CreateQuestionService;
import com.spring.service.JobService;

@RestController
@RequestMapping("/job")
public class JobRest {
	@Autowired
	private JobService jobService;
	@Autowired
	private CreateQuestionService createQuestionService;

	@RequestMapping(value = "/add-out-line", method = RequestMethod.POST)
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

	@RequestMapping(value = "/add-structure-test", method = RequestMethod.POST)
	public ResponseEntity<?> addStructureTest(@RequestBody Job job) throws JsonProcessingException {
		Date startTime = new Date();
		ObjectMapper mapper = new ObjectMapper();
		String message;
		if (job.getEndTime().after(startTime)) {
			job.setStartTime(startTime);
			message = this.jobService.addStructureTest(job);
		} else
			message = "Invalid end date!";
		return new ResponseEntity<>(mapper.writeValueAsString(message), HttpStatus.OK);
	}

	@RequestMapping(value = "/add-question", method = RequestMethod.POST)
	public ResponseEntity<?> addQuestion(@RequestBody Job job, @RequestParam long[] listChapter,
			@RequestParam int numberQuestion) throws JsonProcessingException {
		Date startTime = new Date();
		ObjectMapper mapper = new ObjectMapper();
		String message;
		if (job.getEndTime().after(startTime)) {
			job.setStartTime(startTime);
			Job job2 = this.jobService.addQuestionJob(job);
			if (job2 == null)
				message = "Can't add job. Please try again!";
			else {
				CreateQuestion createQuestion = new CreateQuestion();
				createQuestion.setJobId(job2.getJobId());
				for (long chapterId : listChapter) {
					createQuestion.setChapterId(chapterId);
					createQuestion.setAmount(numberQuestion);
					this.createQuestionService.insert(createQuestion);
				}
				System.out.println(job2);
				message = "Add success!";
			}

		} else
			message = "Invalid end date!";
		// ObjectMapper mapper = new ObjectMapper();
		// String message = "{job: " + mapper.writeValueAsString(job) + ", listChapter:
		// "
		// + mapper.writeValueAsString(listChapter) + ", numberQuestion: " +
		// numberQuestion + "}";
		// return new ResponseEntity<>(mapper.writeValueAsString(message),
		// HttpStatus.OK);
		return new ResponseEntity<>(mapper.writeValueAsString(message), HttpStatus.OK);
	}

}
