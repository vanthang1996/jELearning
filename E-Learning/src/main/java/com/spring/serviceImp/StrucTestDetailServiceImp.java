package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.StrucTestDetailRepository;
import com.spring.service.StrucTestDetailService;

@Service
public class StrucTestDetailServiceImp implements StrucTestDetailService {

	@Autowired
	private StrucTestDetailRepository strucTestDetailRepository;

	@Override
	public List<?> getAllRecord() {
		return this.strucTestDetailRepository.getAllRecord();
	}

}
