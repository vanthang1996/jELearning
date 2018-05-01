package com.spring.repository;

import java.util.List;
import java.util.Optional;

public interface ChapterRepository {

	List<?> getAllRecord();

	Optional<?> getChapterBySubjectId(long subjectId, int page, int size);

}
