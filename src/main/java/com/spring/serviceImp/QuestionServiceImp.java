package com.spring.serviceImp;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.Answer;
import com.spring.mapper.entities.Question;
import com.spring.repository.AnswerRepository;
import com.spring.repository.QuestionRepository;
import com.spring.service.QuestionService;

@Service
public class QuestionServiceImp implements QuestionService {

	@Autowired
	private QuestionRepository questionRepository;
	@Autowired
	private AnswerRepository answerRepository;

	@Override
	public List<?> getAllRecord() {
		return this.questionRepository.getAllRecord();
	}

	@Override
	public Optional<?> getListQuestionByChapterIdPaging(long chapterId, int page, int size) {
		return this.questionRepository.getListQuestionByChapterIdPaging(chapterId, page, size);
	}

	@Override
	public Map<String, Object> getQuestionOfTeacherCompile(long subjectId, long teacherId, int page, int size) {
		return this.questionRepository.getQuestionOfTeacherCompile(subjectId, teacherId, false, page, size);
	}

	@Override
	public Question addQuestion(Question question) {
		Question question2 = this.questionRepository.addQuestion(question);
		if (question.getAnswers() != null) {
			List<Answer> answers = question.getAnswers();
			List<Answer> results = new LinkedList<>();
			for (Answer answer : answers) {
				answer.setQuestionId(question2.getQuestionId());
				results.add(this.answerRepository.addAnswer(answer));
			}
			question2.setAnswers(results);
		}
		return question2;
	}

	@Override
	public Optional<Question> getQuestionByQuestionId(long questionId) {
		return this.questionRepository.getQuestionByQuestionId(questionId, false);
	}

	@Override
	public boolean deleteQuestion(long questionId) {
		Question question = getQuestionByQuestionId(questionId).orElse(null);
		if (question == null)
			return false;
		List<Answer> answers = question.getAnswers();
		for (Answer answer : answers)
			this.answerRepository.deleteAnswer(answer.getAnswerId());
		return this.questionRepository.deleteQuestion(questionId);
	}

	@Override
	public boolean updateQuestion(Question question) {
		if (question == null)
			return false;
		if (question.getAnswers() != null) {
			List<Answer> answers = question.getAnswers();
			for (Answer answer : answers)
				this.answerRepository.updateAnswer(answer);
		}
		return this.questionRepository.updateQuestion(question);

	}

}
