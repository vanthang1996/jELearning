package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.UserRole;
import com.spring.repository.TeacherRepository;
import com.spring.service.TeacherService;

@Service
public class TeacherServiceImp implements TeacherService {
	@Autowired
	private TeacherRepository teacherRepository;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.teacherRepository.getAllRecord();
	}

	@Override
	public List<String> getRoleOfUserByEmail(String email) {
		// TODO Auto-generated method stub
		return this.teacherRepository.getRoleOfUserByEmail(email);
	}

	@Override
	public List<UserRole> getAllRecordUserRole() {
		// TODO Auto-generated method stub
		return this.teacherRepository.getAllUserRole();
	}

}
