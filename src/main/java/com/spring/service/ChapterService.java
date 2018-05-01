package com.spring.service;

import java.util.List;
import java.util.Optional;

public interface ChapterService {

	 List<?> getAllRecord();

	 Optional<?> getChapterBySubjectId(long subjectId, int page, int size);

}
