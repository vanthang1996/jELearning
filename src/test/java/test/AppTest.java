package test;

import java.util.Optional;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.config.jwt.ConfigVariable;
import com.spring.service.AnswerService;
import com.spring.service.ChapterService;
import com.spring.service.CreateQuestionService;
import com.spring.service.ExamTestDetailService;
import com.spring.service.ExamTestService;
import com.spring.service.JobService;
import com.spring.service.LevelService;
import com.spring.service.QuestionService;
import com.spring.service.StrucTestDetailService;
import com.spring.service.StructureTestService;
import com.spring.service.SubjectService;
import com.spring.service.TeacherService;

//@Ignore
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:root-context.xml")
@WebAppConfiguration

public class AppTest {
	@Autowired
	private LevelService levelService;
	ObjectMapper mapper = new ObjectMapper();

	@Test
	public void testGetAllRecord() {
		this.levelService.getAllRecord().stream().forEach(x -> {
			System.out.println(x);
		});
	}

	@Autowired
	private StructureTestService structureTestService;

	@Test
	public void testGetRecordStructureTest() {
		this.structureTestService.getAllRecord().stream().forEach(x -> {
			System.out.println(x);
		});
	}

	@Autowired
	private TeacherService teacherService;

	@Test
	public void testGetRecordTeacher() {
		this.teacherService.getAllRecord().stream().forEach(value -> {
			try {
				System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(value));
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		});

	}

	@Test
	public void testGetListDepartmentyByTeacherEmail() throws JsonProcessingException {
		Optional<?> optional = this.teacherService.getListDepartmentyByTeacherEmail("quynhnhu@gmail.com");
		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
		System.out.println(string);
	}

	@Autowired
	private ExamTestService examTestService;

	@Test
	public void testGetRecordExamTest() {
		this.examTestService.getAllRecord().stream().forEach(x -> {
			System.out.println(x);
		});
	}

	@Autowired
	private AnswerService answerService;

	@Test
	public void testGetRecordAnswer() {
		this.answerService.getAllRecord().stream().forEach(x -> {
			System.out.println(x);
		});
	}

	@Autowired
	private CreateQuestionService createQuestionService;

	@Test
	public void testGetRecordCreateQuestionService() {
		this.createQuestionService.getAllRecord().stream().forEach(x -> {
			System.out.println(x);
		});
	}

	@Autowired
	private ExamTestDetailService detailService;

	@Test
	public void testGetRecordDetailRepositpory() {
		this.detailService.getAllRecord().stream().forEach(x -> {
			System.out.println(x);
		});
	}

	@Autowired
	private JobService jobService;

	@Test
	public void testGetRecordJobRepository() {
		this.jobService.getAllRecord().stream().forEach(x -> {
			System.out.println(x);
		});
	}

	@Autowired
	private QuestionService questionService;

	@Test
	public void testGetRecordQuestionService() {
		this.questionService.getAllRecord().stream().forEach(x -> {
			System.out.println(x);
		});
	}

	@Autowired
	private ConfigVariable configVariable;

	@Test
	public void testConfig() {
		System.out.println(this.configVariable.toString());
	}

	@Autowired
	private SubjectService subjectService;

	@Test
	public void testGetAllRecordSubject() {
		this.subjectService.getAllRecord().stream().forEach(value -> {
			try {
				System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(value));
			} catch (JsonProcessingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		});
	}

	@Test
	public void testGetListSubjectOfTeacherPaging() throws JsonProcessingException {
		Optional<?> optional = this.subjectService.getListSubjectOfTeacherPaging("quynhnhu@gmail.com", 1, 10);
		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
		System.out.println(string);
	}

	@Autowired
	private ChapterService chapterService;

	@Test
	public void testGetChapterBySubjectId() throws JsonProcessingException {
		Optional<?> optional = this.chapterService.getChapterBySubjectId(2, 1, 2);
		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
		System.out.println(string);
	}

	@Autowired
	private StrucTestDetailService strucTestDetailService;

	@Test
	public void testGetStrucTestDetailById() throws JsonProcessingException {
		Optional<?> optional = this.strucTestDetailService.getListStrucTestDetailBySubjectId(2);
		String string = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
		System.out.println(string);
	}

}
