package test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.spring.service.AnswerService;
import com.spring.service.CreateQuestionService;
import com.spring.service.ExamTestDetailService;
import com.spring.service.ExamTestService;
import com.spring.service.JobService;
import com.spring.service.LevelService;
import com.spring.service.QuestionService;
import com.spring.service.StructureTestService;
import com.spring.service.TeacherService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:root-context.xml")
@WebAppConfiguration

public class AppTest {
	@Autowired
	private LevelService levelService;

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
		this.teacherService.getAllRecord().stream().forEach(x -> {
			System.out.println(x);
		});
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

}
