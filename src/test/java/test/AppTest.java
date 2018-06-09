package test;

import java.io.File;
import java.io.IOException;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.spring.config.jwt.ConfigVariable;
import com.spring.service.GoogleDriveService;
import com.spring.service.NotifyMessageService;

//@Ignore
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:/root-context.xml")
@WebAppConfiguration
@TestPropertySource("classpath:/google.properties")

public class AppTest {
	// @Autowired
	// private LevelService levelService;
	// ObjectMapper mapper = new ObjectMapper();
	//
	// @Test
	// public void testGetAllRecord() {
	// this.levelService.getAllRecord().stream().forEach(x -> {
	// System.out.println(x);
	// });
	// }
	//
	// @Autowired
	// private StructureTestService structureTestService;
	//
	// @Test
	// public void testGetRecordStructureTest() {
	// this.structureTestService.getAllRecord().stream().forEach(x -> {
	// System.out.println(x);
	// });
	// }
	//
	// @Autowired
	// private TeacherService teacherService;
	//
	// @Test
	// public void testGetRecordTeacher() {
	// this.teacherService.getAllRecord().stream().forEach(value -> {
	// try {
	// System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(value));
	// } catch (JsonProcessingException e) {
	// // TODO Auto-generated catch block
	// e.printStackTrace();
	// }
	// });
	//
	// }
	//
	// @Test
	// public void testGetListDepartmentyByTeacherEmail() throws
	// JsonProcessingException {
	// Optional<?> optional =
	// this.teacherService.getListDepartmentyByTeacherEmail("quynhnhu@gmail.com");
	// String string =
	// mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
	// System.out.println(string);
	// }
	//
	// @Autowired
	// private ExamTestService examTestService;
	//
	// @Test
	// public void testGetRecordExamTest() {
	// this.examTestService.getAllRecord().stream().forEach(x -> {
	// System.out.println(x);
	// });
	// }
	//
	// @Autowired
	// private AnswerService answerService;
	//
	// @Test
	// public void testGetRecordAnswer() {
	// this.answerService.getAllRecord().stream().forEach(x -> {
	// System.out.println(x);
	// });
	// }
	//
	// @Autowired
	// private CreateQuestionService createQuestionService;
	//
	// @Test
	// public void testGetRecordCreateQuestionService() {
	// this.createQuestionService.getAllRecord().stream().forEach(x -> {
	// System.out.println(x);
	// });
	// }
	//
	// @Test
	// public void deleteQuesionById() {
	// boolean kq = this.questionService.deleteQuestion(248);
	// assertTrue(kq);
	// }
	//
	// @Autowired
	// private ExamTestDetailService detailService;
	//
	// @Test
	// public void testGetRecordDetailRepositpory() {
	// this.detailService.getAllRecord().stream().forEach(x -> {
	// System.out.println(x);
	// });
	// }
	//
	// @Autowired
	// private JobService jobService;
	//
	// @Test
	// public void testGetRecordJobRepository() throws JsonProcessingException {
	// System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(this.jobService.getAllRecord()));
	// }
	//
	// @Test
	// public void testGetJobsByTeacherIdPaging() throws JsonProcessingException {
	// System.out.println(mapper.writerWithDefaultPrettyPrinter()
	// .writeValueAsString(this.jobService.getJobsByTeacherIdPaging(11, 1,
	// 5).get()));
	// }
	//
	// @Autowired
	// private QuestionService questionService;
	//
	// @Test
	// public void testGetRecordQuestionService() throws JsonProcessingException {
	// System.out.println(
	// mapper.writerWithDefaultPrettyPrinter().writeValueAsString(this.questionService.getAllRecord()));
	// }
	//
	// @Test
	// public void testGetListQuestionByChapterIdPaging() throws
	// JsonProcessingException {
	// System.out.println(mapper.writerWithDefaultPrettyPrinter()
	// .writeValueAsString(this.questionService.getListQuestionByChapterIdPaging(2,
	// 1, 20).get()));
	// }
	//
	// @Autowired
	// private ConfigVariable configVariable;
	//
	// @Test
	// public void testConfig() {
	// System.out.println(this.configVariable.toString());
	// }
	//
	// @Autowired
	// private SubjectService subjectService;
	//
	// @Test
	// public void testGetSubjectAddOutLineOrStructureTest() throws
	// JsonProcessingException {
	// Optional<?> optional =
	// this.subjectService.getSubjectAddOutLineOrStructureTest(1, 1);
	// String string =
	// mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
	// System.out.println(string);
	// }
	//
	// @Test
	// public void testGetSubjectBySubejectId() throws JsonProcessingException {
	// Optional<?> optional = this.subjectService.getSubjectBySubjectId(2);
	// String string =
	// mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
	// System.out.println(string);
	// }
	//
	// @Test
	// public void testGetAllRecordSubject() {
	// this.subjectService.getAllRecord().stream().forEach(value -> {
	// try {
	// System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(value));
	// } catch (JsonProcessingException e) {
	// // TODO Auto-generated catch block
	// e.printStackTrace();
	// }
	// });
	// }
	//
	// @Test
	// public void testGetListSubjectOfTeacherPaging() throws
	// JsonProcessingException {
	// Optional<?> optional =
	// this.subjectService.getListSubjectOfTeacherPaging("quynhnhu@gmail.com", 1,
	// 10);
	// String string =
	// mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
	// System.out.println(string);
	// }
	//
	// @Test
	// public void testGetSubjectsByDepartmentIdNoCollection() throws
	// JsonProcessingException {
	// Optional<?> optional = this.subjectService.getSubjectsDataByDepartmentId(1);
	// String string =
	// mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
	// System.out.println(string);
	// }
	//
	// @Autowired
	// private ChapterService chapterService;
	//
	// @Test
	// public void testGetChapterBySubjectId() throws JsonProcessingException {
	// Optional<?> optional = this.chapterService.getChapterBySubjectId(2, 1, 2);
	// String string =
	// mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
	// System.out.println(string);
	// }
	//
	// @Autowired
	// private StrucTestDetailService strucTestDetailService;
	//
	// @Test
	// public void testGetStrucTestDetailById() throws JsonProcessingException {
	// Optional<?> optional =
	// this.strucTestDetailService.getListStrucTestDetailBySubjectId(2);
	// String string =
	// mapper.writerWithDefaultPrettyPrinter().writeValueAsString(optional.get());
	// System.out.println(string);
	// }
	//
	// @Autowired
	// private JobRepository jobRepository;
	//
	// @Test
	// public void testAddQuestionJob() {
	// Job job = new Job();
	// job.setSubjectId(2);
	// job.setJobContent("Làm nhanh em nhé!");
	// job.setStartTime(new Date(Calendar.getInstance().getTimeInMillis()));
	// job.setEndTime(new Date(Calendar.getInstance().getTimeInMillis() + 1000));
	// job.setTeacherId(12);
	// System.out.println(jobRepository.addQuestionJob(job));
	// }
	//
	// @Test
	// public void testAddOutLine() {
	// Job job = new Job();
	// job.setSubjectId(6);
	// job.setJobContent("Làm nhanh em nhé!");
	// job.setStartTime(new Date(Calendar.getInstance().getTimeInMillis()));
	// job.setEndTime(new Date(Calendar.getInstance().getTimeInMillis() + 1000));
	// job.setTeacherId(2);
	//
	// System.out.println(this.jobRepository.addOutLine(job));
	// }
	//
	// @Test
	// public void testStructureTest() {
	// Job job = new Job();
	// job.setSubjectId(6);
	// job.setJobContent("Làm nhanh em nhé!");
	// job.setStartTime(new Date(Calendar.getInstance().getTimeInMillis()));
	// job.setEndTime(new Date(2018, 12, 12));
	// job.setTeacherId(2);
	// System.out.println(this.jobRepository.addStructureTest(job));
	// }
	//
	// @Autowired
	// private AnswerRepository answerRepository;
	//
	// @Test
	// public void testAddAnswer() {
	// Answer answer = new Answer();
	// answer.setContent("Đáp án");
	// answer.setCorrectAnswer(true);
	// answer.setQuestionId(247);
	// System.out.println(this.answerRepository.addAnswer(answer));
	// }

	@Autowired
	GoogleDriveService driveService;
	@Autowired
	ConfigVariable configVariable;

	@Test
	public void testUploadFile() throws IOException {
		System.out.println(configVariable);
		File file = new File("C:\\Users\\vanth\\OneDrive\\Desktop\\mail.txt");
		com.google.api.services.drive.model.File file2 = driveService.uploadFile(file.getName(), file.getAbsolutePath(),
				"upload/txt");
		System.err.println(file2.toPrettyString());
	}

	@Autowired
	private NotifyMessageService messageService;

	@Test
	public void testGetNotifyMessage() {
		System.out.println(this.messageService.getNotifyMessage(2, 2, 2));
	}
}
