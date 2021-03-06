package com.spring.serviceImp;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.Teacher;
import com.spring.mapper.entities.UserRole;
import com.spring.repository.TeacherRepository;
import com.spring.service.TeacherService;

@Service
public class TeacherServiceImp implements TeacherService {

	@Autowired
	private TeacherRepository teacherRepository;

	@Override
	public List<?> getAllRecord() {
		return this.teacherRepository.getAllRecord();
	}

	@Override
	public List<String> getRoleOfUserByEmail(String email) {
		return this.teacherRepository.getRoleOfUserByEmail(email);
	}

	@Override
	public List<UserRole> getAllRecordUserRole() {
		return this.teacherRepository.getAllUserRole();
	}

	@Override
	public Optional<UserRole> getUserRoleByEmail(String email) {
		return this.teacherRepository.getUserRoleByEmail(email);
	}

	@Override
	public Optional<Teacher> getTeacherByEmail(String emailFromToKen) {
		return this.teacherRepository.getTeacherByEmail(emailFromToKen);
	}

	@Override
	public Optional<?> getListDepartmentyByTeacherEmail(String email) {
		return this.teacherRepository.getListDepartmentyByTeacherEmail(email);
	}

	@Override
	public Optional<?> getTeacherNoCollectionByTeacherId(long teacherId) {
		return this.teacherRepository.getTeacherNoCollectionByTeacherId(teacherId);
	}

	@Override
	public Optional<?> getAllTeacher() {
		// TODO Auto-generated method stub
		return this.teacherRepository.getAllTeacher();
	}

	@Override
	public boolean createTeacher(Teacher teacher) {
		if (this.teacherRepository.createTeacher(teacher) > 0)
			return true;
		return false;
	}

	@Override
	public Optional<?> getTeacherByDepartmentId(long departmentId) {
		// TODO Auto-generated method stub
		return this.teacherRepository.getTeacherByDepartmentId(departmentId);
	}

	@Override
	public boolean updateTeacher(Teacher teacher) {
		if (this.teacherRepository.updateTeacher(teacher) > 0)
			return true;
		return false;
	}

	@Override
	public Optional<?> getTeacherInDepartmentNotInSubject(long departmentId, long subjectId) {
		// TODO Auto-generated method stub
		return this.teacherRepository.getTeacherInDepartmentNotInSubject(departmentId, subjectId);
	}

	@Override
	public boolean insertQLMH(long teacherId, long subjectId) {
		if (this.teacherRepository.insertQLMH(teacherId, subjectId) > 0)
			return true;
		return false;
	}

	@Override
	public boolean deleteQLMH(long teacherId, long subjectId) {
		if (this.teacherRepository.deleteQLMH(teacherId, subjectId) > 0)
			return true;
		return false;
	}

	@Override
	public Teacher findById(long teacherReceiveId) {
		return this.teacherRepository.findById(teacherReceiveId);
	}

}
