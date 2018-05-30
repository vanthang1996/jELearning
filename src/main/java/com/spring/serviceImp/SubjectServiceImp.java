package com.spring.serviceImp;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.repository.SubjectRepository;
import com.spring.service.SubjectService;

@Service
public class SubjectServiceImp implements SubjectService {

	@Autowired
	private SubjectRepository subjectRepository;

	@Override
	public List<?> getAllRecord() {
		return this.subjectRepository.getAllRecord();
	}

	@Override
	public Optional<?> getListSubjectOfTeacherPaging(String email, int page, int size) {
		return this.subjectRepository.getListSubjectOfTeacherPaging(email, page, size);
	}

	@Override
	public Optional<?> getSubjectsDataByDepartmentId(long departmentId) {
		return this.subjectRepository.getSubjectsDataByDepartmentId(departmentId);
	}

	@Override
	public Optional<?> getSubjectBySubjectId(long subjectId) {
		return this.subjectRepository.getSubjectBySubjectId(subjectId);
	}

}
