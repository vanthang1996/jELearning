package com.spring.repository;

import java.util.List;
import java.util.Optional;

public interface QuestionRepository {
	public List<?> getAllRecord();

	public Optional<?> getListQuestionByChapterIdPaging(long chapterId, int page, int size);
}
