package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.LevelRepositpory;
import com.spring.service.LevelService;

@Service
public class LevelServiceImp implements LevelService {

	@Autowired
	private LevelRepositpory levelRepositpory;

	@Override
	public List<?> getAllRecord() {
		return this.levelRepositpory.getAllRecord();
	}

}
