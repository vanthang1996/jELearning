package com.spring.serviceImp;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.Chapter;
import com.spring.repository.ChapterRepository;
import com.spring.service.ChapterService;

@Service
public class ChapterServiceImp implements ChapterService {
	@Autowired
	private ChapterRepository chapterRepository;

	@Override
	public List<?> getAllRecord() {
		return this.chapterRepository.getAllRecord();
	}

	@Override
	public Optional<?> getChapterBySubjectId(long subjectId, int page, int size) {
		return this.chapterRepository.getChapterBySubjectId(subjectId, page, size);
	}

	@Override
	public Optional<?> getListChapterBySubjectId(long subjectId) {
		return this.chapterRepository.getListChapterBySubjectId(subjectId);
	}

	@Override
	public int createChapter(Chapter chapter) {
		return this.chapterRepository.createChapter(chapter);
	}

}
