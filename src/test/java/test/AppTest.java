package test;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.Optional;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.config.jwt.ConfigVariable;
import com.spring.mapper.entities.Answer;
import com.spring.mapper.entities.Job;
import com.spring.repository.AnswerRepository;
import com.spring.repository.JobRepository;
import com.spring.service.AnswerService;
import com.spring.service.ChapterService;
import com.spring.service.CreateQuestionService;
import com.spring.service.ExamTestDetailService;
import com.spring.service.ExamTestService;
import com.spring.service.GoogleDriveService;
import com.spring.service.JobService;
import com.spring.service.LevelService;
import com.spring.service.QuestionService;
import com.spring.service.StrucTestDetailService;
import com.spring.service.StructureTestService;
import com.spring.service.SubjectService;
import com.spring.service.TeacherService;

//@Ignore
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:/root-context.xml")
@WebAppConfiguration
@TestPropertySource("classpath:/google.properties")

public class AppTest {
//	@Autowired
//	private LevelService levelService;
//	ObjectMapper mapper = new ObjectMapper();
//
//	@Test
//	public void testGetAllRecord() {
//		this.levelService.getAllRecord().stream().forEach(x -> {
//			System.out.println(x);
//		});
//	}
//
//	@Autowired
//	private StructureTestService structureTestService;
//
//	@Test
//	public void testGetRecordStructureTest() {
//		this.structureTestService.getAllRecord().stream().forEach(x -> {
//			System.out.println(x);
//		});
//	}
//
//	@Autowired
//	private TeacherService teacherService;
//
//	@Test
//	public void testGetRecordTeacher() {
//		this.teacherService.getAllRecord().stream().forEach(value -> {
//			try {
//				System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(value));
//			} catch (JsonProcessingException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//		});
//
//	}
//
//	@Test
//	public void testGetListDepartmentyByTeacherEmail() throws JsonProcessingException {
//		Optional<?> optional = this.teacherService.getListDepartmentyByTeacherEmail("quynhnhu@gmail.com");
//		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
//		System.out.println(string);
//	}
//
//	@Autowired
//	private ExamTestService examTestService;
//
//	@Test
//	public void testGetRecordExamTest() {
//		this.examTestService.getAllRecord().stream().forEach(x -> {
//			System.out.println(x);
//		});
//	}
//
//	@Autowired
//	private AnswerService answerService;
//
//	@Test
//	public void testGetRecordAnswer() {
//		this.answerService.getAllRecord().stream().forEach(x -> {
//			System.out.println(x);
//		});
//	}
//
//	@Autowired
//	private CreateQuestionService createQuestionService;
//
//	@Test
//	public void testGetRecordCreateQuestionService() {
//		this.createQuestionService.getAllRecord().stream().forEach(x -> {
//			System.out.println(x);
//		});
//	}
//
//	@Test
//	public void deleteQuesionById() {
//		boolean kq = this.questionService.deleteQuestion(248);
//		assertTrue(kq);
//	}
//
//	@Autowired
//	private ExamTestDetailService detailService;
//
//	@Test
//	public void testGetRecordDetailRepositpory() {
//		this.detailService.getAllRecord().stream().forEach(x -> {
//			System.out.println(x);
//		});
//	}
//
//	@Autowired
//	private JobService jobService;
//
//	@Test
//	public void testGetRecordJobRepository() throws JsonProcessingException {
//		System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(this.jobService.getAllRecord()));
//	}
//
//	@Test
//	public void testGetJobsByTeacherIdPaging() throws JsonProcessingException {
//		System.out.println(mapper.writerWithDefaultPrettyPrinter()
//				.writeValueAsString(this.jobService.getJobsByTeacherIdPaging(11, 1, 5).get()));
//	}
//
//	@Autowired
//	private QuestionService questionService;
//
//	@Test
//	public void testGetRecordQuestionService() throws JsonProcessingException {
//		System.out.println(
//				mapper.writerWithDefaultPrettyPrinter().writeValueAsString(this.questionService.getAllRecord()));
//	}
//
//	@Test
//	public void testGetListQuestionByChapterIdPaging() throws JsonProcessingException {
//		System.out.println(mapper.writerWithDefaultPrettyPrinter()
//				.writeValueAsString(this.questionService.getListQuestionByChapterIdPaging(2, 1, 20).get()));
//	}
//
//	@Autowired
//	private ConfigVariable configVariable;
//
//	@Test
//	public void testConfig() {
//		System.out.println(this.configVariable.toString());
//	}
//
//	@Autowired
//	private SubjectService subjectService;
//
//	@Test
//	public void testGetSubjectAddOutLineOrStructureTest() throws JsonProcessingException {
//		Optional<?> optional = this.subjectService.getSubjectAddOutLineOrStructureTest(1, 1);
//		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
//		System.out.println(string);
//	}
//
//	@Test
//	public void testGetSubjectBySubejectId() throws JsonProcessingException {
//		Optional<?> optional = this.subjectService.getSubjectBySubjectId(2);
//		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
//		System.out.println(string);
//	}
//
//	@Test
//	public void testGetAllRecordSubject() {
//		this.subjectService.getAllRecord().stream().forEach(value -> {
//			try {
//				System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(value));
//			} catch (JsonProcessingException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//		});
//	}
//
//	@Test
//	public void testGetListSubjectOfTeacherPaging() throws JsonProcessingException {
//		Optional<?> optional = this.subjectService.getListSubjectOfTeacherPaging("quynhnhu@gmail.com", 1, 10);
//		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
//		System.out.println(string);
//	}
//
//	@Test
//	public void testGetSubjectsByDepartmentIdNoCollection() throws JsonProcessingException {
//		Optional<?> optional = this.subjectService.getSubjectsDataByDepartmentId(1);
//		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
//		System.out.println(string);
//	}
//
//	@Autowired
//	private ChapterService chapterService;
//
//	@Test
//	public void testGetChapterBySubjectId() throws JsonProcessingException {
//		Optional<?> optional = this.chapterService.getChapterBySubjectId(2, 1, 2);
//		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
//		System.out.println(string);
//	}
//
//	@Autowired
//	private StrucTestDetailService strucTestDetailService;
//
//	@Test
//	public void testGetStrucTestDetailById() throws JsonProcessingException {
//		Optional<?> optional = this.strucTestDetailService.getListStrucTestDetailBySubjectId(2);
//		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
//		System.out.println(string);
//	}
//
//	@Autowired
//	private JobRepository jobRepository;
//
//	@Test
//	public void testAddQuestionJob() {
//		Job job = new Job();
//		job.setSubjectId(2);
//		job.setJobContent("Làm nhanh em nhé!");
//		job.setStartTime(new Date(Calendar.getInstance().getTimeInMillis()));
//		job.setEndTime(new Date(Calendar.getInstance().getTimeInMillis() + 1000));
//		job.setTeacherId(12);
//		System.out.println(jobRepository.addQuestionJob(job));
//	}
//
//	@Test
//	public void testAddOutLine() {
//		Job job = new Job();
//		job.setSubjectId(6);
//		job.setJobContent("Làm nhanh em nhé!");
//		job.setStartTime(new Date(Calendar.getInstance().getTimeInMillis()));
//		job.setEndTime(new Date(Calendar.getInstance().getTimeInMillis() + 1000));
//		job.setTeacherId(2);
//
//		System.out.println(this.jobRepository.addOutLine(job));
//	}
//
//	@Test
//	public void testStructureTest() {
//		Job job = new Job();
//		job.setSubjectId(6);
//		job.setJobContent("Làm nhanh em nhé!");
//		job.setStartTime(new Date(Calendar.getInstance().getTimeInMillis()));
//		job.setEndTime(new Date(2018, 12, 12));
//		job.setTeacherId(2);
//		System.out.println(this.jobRepository.addStructureTest(job));
//	}
//
//	@Autowired
//	private AnswerRepository answerRepository;
//
//	@Test
//	public void testAddAnswer() {
//		Answer answer = new Answer();
//		answer.setContent("Đáp án");
//		answer.setCorrectAnswer(true);
//		answer.setQuestionId(247);
//		System.out.println(this.answerRepository.addAnswer(answer));
//	}
	
	@Autowired
	GoogleDriveService driveService;
	
	@Test
	public void testUploadFile() {
		File file = new File("D:\\B.jpg");
		com.google.api.services.drive.model.File file2 = driveService.uploadFile(file.getName(), file.getAbsolutePath(), "upload/*" );
		try {
			System.err.println(file2.toPrettyString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
