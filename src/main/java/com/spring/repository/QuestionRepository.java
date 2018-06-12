package com.spring.repository;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.spring.mapper.entities.Question;

public interface QuestionRepository {
	public List<?> getAllRecord();

	public Optional<?> getListQuestionByChapterIdPaging(long chapterId, int page, int size);

	/**
	 * @param subjectId
	 * @param teacherId
	 * @param status
	 *            of question
	 * @param page
	 * @param size
	 * @return
	 */
	Map<String, Object> getQuestionOfTeacherCompile(long subjectId, long teacherId, boolean status, int page, int size);

	public Question addQuestion(Question question);

	public Optional<Question> getQuestionByQuestionId(long questionId, boolean status);

	public boolean deleteQuestion(long questionId);

	public boolean updateQuestion(Question question);

	public Optional<?> getQuestionByTeacherId(long teacherId);

	Optional<?> getListQuestionByChapterIdAndStatusPaging(long chapterId, boolean status, int page, int size);
}
