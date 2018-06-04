package com.spring.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface QuestionService {
	public List<?> getAllRecord();

	public Optional<?> getListQuestionByChapterIdPaging(long chapterId, int page, int size);

	public Map<String, Object> getQuestionOfTeacherCompile(long subjectId, long teacherId, int page, int size);
}
