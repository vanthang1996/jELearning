package com.spring.service;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.Chapter;

public interface ChapterService {

	List<?> getAllRecord();

	Optional<?> getChapterBySubjectId(long subjectId, int page, int size);

	Optional<?> getListChapterBySubjectId(long subjectId);

	int createChapter(Chapter chapter);

	Optional<Chapter> getChapterByChapterIdNoCollect(long chapterId);

}
