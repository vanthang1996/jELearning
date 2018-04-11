package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

}
