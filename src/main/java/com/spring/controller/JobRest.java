package com.spring.controller;

import java.util.Date;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.config.jwt.JwtService;
import com.spring.domain.ApiMessage;
import com.spring.mapper.entities.CreateQuestion;
import com.spring.mapper.entities.Job;
import com.spring.mapper.entities.NotifyMessage;
import com.spring.mapper.entities.Subject;
import com.spring.mapper.entities.Teacher;
import com.spring.service.CreateQuestionService;
import com.spring.service.JobService;
import com.spring.service.NotifyMessageService;
import com.spring.service.StructureTestService;
import com.spring.service.SubjectService;
import com.spring.service.TeacherService;

/**
 * @author vanth
 *
 */
@RestController
@RequestMapping("/job")
public class JobRest {
	@Autowired
	private JobService jobService;
	@Autowired
	private CreateQuestionService createQuestionService;
	@Autowired
	private TeacherService teacherService;
	@Autowired
	private JwtService jwtService;
	@Autowired
	private SubjectService subjectService;
	@Autowired
	private NotifyMessageService messageService;
	@Autowired
	private StructureTestService structureTestService;

	@RequestMapping(value = "/add-out-line", method = RequestMethod.POST)
	public ResponseEntity<?> addOutLine(@RequestBody Job job, HttpServletRequest request)
			throws JsonProcessingException {
		Date startTime = new Date();
		System.out.println(job);
		ObjectMapper mapper = new ObjectMapper();
		String message;
		if (job.getEndTime().after(startTime)) {
			job.setStartTime(startTime);
			message = this.jobService.addOutLine(job);
			Optional<Teacher> optional = teacherService
					.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
			if (!optional.isPresent()) {
				ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, "Lỗi");
				return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
			}
			Teacher teacher = optional.get();
			long teacherId = teacher.getTeacherId();
			Optional<?> subject = this.subjectService.getSubjectBySubjectIdAllStatus(job.getSubjectId());
			NotifyMessage notifyMsg = new NotifyMessage();
			notifyMsg.setTitle("Phân công:");
			notifyMsg.setBody("Bạn được giao Tạo đề cương! Môn: " + ((Subject) subject.get()).getSubjectName());
			notifyMsg.setDateTo(new Date());
			notifyMsg.setStatus(0);
			notifyMsg.setTeacherSendId(teacherId);
			notifyMsg.setTeacherReceiveId(job.getTeacherId());
			this.messageService.insert(notifyMsg);
		} else
			message = "Invalid end date!";
		return new ResponseEntity<>(mapper.writeValueAsString(message), HttpStatus.OK);
	}

	@RequestMapping(value = "/add-structure-test", method = RequestMethod.POST)
	public ResponseEntity<?> addStructureTest(@RequestBody Job job, HttpServletRequest request)
			throws JsonProcessingException {
		Date startTime = new Date();
		ObjectMapper mapper = new ObjectMapper();
		String message;
		if (job.getEndTime().after(startTime)) {
			job.setStartTime(startTime);
			message = this.jobService.addStructureTest(job);
			Optional<Teacher> optional = teacherService
					.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
			if (!optional.isPresent()) {
				ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, "Lỗi");
				return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
			}
			Teacher teacher = optional.get();
			long teacherId = teacher.getTeacherId();
			Optional<?> subject = this.subjectService.getSubjectBySubjectIdAllStatus(job.getSubjectId());
			NotifyMessage notifyMsg = new NotifyMessage();
			notifyMsg.setTitle("Phân công:");
			notifyMsg.setBody("Bạn được giao Tạo cấu trúc đề thi! Môn: " + ((Subject) subject.get()).getSubjectName());
			notifyMsg.setDateTo(new Date());
			notifyMsg.setStatus(0);
			notifyMsg.setTeacherSendId(teacherId);
			notifyMsg.setTeacherReceiveId(job.getTeacherId());
			this.messageService.insert(notifyMsg);
		} else
			message = "Invalid end date!";
		return new ResponseEntity<>(mapper.writeValueAsString(message), HttpStatus.OK);
	}

	@RequestMapping(value = "/add-question", method = RequestMethod.POST)
	public ResponseEntity<?> addQuestion(@RequestBody Job job, @RequestParam long[] listChapter,
			@RequestParam int numberQuestion, HttpServletRequest request) throws JsonProcessingException {
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
				Optional<Teacher> optional = teacherService
						.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
				if (!optional.isPresent()) {
					ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, "Lỗi");
					return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
				}
				Teacher teacher = optional.get();
				long teacherId = teacher.getTeacherId();
				Optional<?> subject = this.subjectService.getSubjectBySubjectIdAllStatus(job.getSubjectId());
				NotifyMessage notifyMsg = new NotifyMessage();
				notifyMsg.setTitle("Phân công:");
				notifyMsg.setBody("Bạn được giao Thêm câu hỏi! Môn: " + ((Subject) subject.get()).getSubjectName());
				notifyMsg.setDateTo(new Date());
				notifyMsg.setStatus(0);
				notifyMsg.setTeacherSendId(teacherId);
				notifyMsg.setTeacherReceiveId(job.getTeacherId());
				this.messageService.insert(notifyMsg);
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

	/**
	 * @return list job all teacher in department (x)
	 * @throws JsonProcessingException
	 */
	@RequestMapping(value = "/browse-job/{jobTypeId}/{status}")
	public ResponseEntity<?> browseJob(HttpServletRequest request, @PathVariable long jobTypeId,
			@PathVariable boolean status, @RequestParam(name = "page", required = false, defaultValue = "1") int page,
			@RequestParam(name = "size", required = false, defaultValue = "10") int size)
			throws JsonProcessingException {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		if (!optional.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		long teacherId = optional.get().getTeacherId();
		// ObjectMapper mapper = new ObjectMapper();
		// String message = "{jobTypeId: " + jobTypeId + ", status: " + status + ",
		// page: " + page + ", size: " + size
		// + ", teacherId: " + optional.get().getTeacherId() + "}";
		// System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(message));
		// return new
		// ResponseEntity<>(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(message),
		// HttpStatus.OK);
		Map<String, Object> map = this.jobService.getJobByManageTeacher(teacherId, jobTypeId, status, page, size);
		// System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(map));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	@RequestMapping("/{jobId}/question-detail")
	public ResponseEntity<?> getJobQuestionDetail(@PathVariable long jobId) {
		return new ResponseEntity<>(this.createQuestionService.getCreateQuestionByJobId(jobId), HttpStatus.OK);
	}

	@RequestMapping("/teacher")
	public ResponseEntity<?> getJobsOfTeacher(HttpServletRequest request,
			@RequestParam(name = "page", required = false, defaultValue = "1") int page,
			@RequestParam(name = "size", required = false, defaultValue = "10") int size) {
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		if (!optional.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		long teacherId = optional.get().getTeacherId();
		Map<String, Object> map = this.jobService.getJobsOfTeacher(teacherId, page, size);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	// xác nhận công việc hoàn thành@preauthor là người quản lý bộ môn theo mã công
	// việc

	@RequestMapping(value = "/teacher/{teacherId}", method = RequestMethod.GET)
	public ResponseEntity<?> getJobByTeacherId(@PathVariable long teacherId) {
		Optional<?> optional = this.jobService.getJobByTeacherId(teacherId);
		return new ResponseEntity<>(optional.orElse(null), HttpStatus.OK);
	}

	// duyệt công việc
	@RequestMapping(value = "/review-job/{jobId}")
	public ResponseEntity<?> reviewOutLine(@PathVariable long jobId, HttpServletRequest request) {
		Job job = this.jobService.getJobByJobId(jobId);
		boolean result = false;
		Optional<Teacher> optional = teacherService
				.getTeacherByEmail(this.jwtService.getEmailFromToKen(this.jwtService.getToken(request)));
		if (!optional.isPresent()) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.CONFLICT, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		Teacher teacher = optional.get();
		long teacherId = teacher.getTeacherId();
		Optional<?> subject = this.subjectService.getSubjectBySubjectIdAllStatus(job.getSubjectId());
		NotifyMessage notifyMsg = new NotifyMessage();
		notifyMsg.setTitle("Xác nhận hoàn tất:");
		notifyMsg.setDateTo(new Date());
		notifyMsg.setStatus(0);
		notifyMsg.setTeacherSendId(teacherId);
		notifyMsg.setTeacherReceiveId(job.getTeacherId());

		if (job.getJobTypeId() == 1 || job.getJobTypeId() == 3) {
			if (job.getJobTypeId() == 1) {
				this.subjectService.updateStatus(job.getSubjectId(), true);
				notifyMsg.setBody("Công việc Tạo đề cương! Môn: " + ((Subject) subject.get()).getSubjectName());
			}
			if (job.getJobTypeId() == 3) {
				this.structureTestService.updateStatus(job.getSubjectId());
				notifyMsg.setBody("Công việc Tạo cấu trúc đề thi! Môn: " + ((Subject) subject.get()).getSubjectName());
			}
			result = this.jobService.updateStatusJob(jobId, true);

		} else {
			result = this.jobService.reviewQuestion(jobId);
			notifyMsg.setBody("Công việc Thêm câu hỏi! Môn: " + ((Subject) subject.get()).getSubjectName());
		}
		System.out.println(result);
		if (result) {
			this.messageService.insert(notifyMsg);
			return new ResponseEntity<>(result, HttpStatus.OK);
		}
		ApiMessage apiMessage = new ApiMessage(HttpStatus.NOT_FOUND, "Lỗi");
		return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
	}

	// nộp công việc chuyển trạng thái tiến độ công việc
	@RequestMapping(value = "/submit-job/{jobId}")
	public ResponseEntity<?> submitJob(@PathVariable long jobId) {
		Job job = this.jobService.getJobByJobId(jobId);
		boolean result = false;
		if (job.getJobId() == 1)
			result = this.jobService.submitOutLine(jobId);
		if (job.getJobId() == 3)
			result = this.jobService.submitStruc(jobId);
		if (result) {
			ApiMessage apiMessage = new ApiMessage(HttpStatus.NOT_FOUND, "Lỗi");
			return new ResponseEntity<>(apiMessage, apiMessage.getStatusCode());
		}
		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@RequestMapping(value = "/{jobId}", method = RequestMethod.GET)
	public ResponseEntity<?> geJobByJobId(@PathVariable long jobId) {
		Job job = this.jobService.geJobByJobId(jobId);
		return new ResponseEntity<>(job, HttpStatus.OK);
	}
}
