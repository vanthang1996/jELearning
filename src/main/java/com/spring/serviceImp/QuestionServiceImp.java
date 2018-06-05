package com.spring.serviceImp;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.QuestionRepository;
import com.spring.service.QuestionService;

@Service
public class QuestionServiceImp implements QuestionService {

	@Autowired
	private QuestionRepository questionRepository;

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

}
