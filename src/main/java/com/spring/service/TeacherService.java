package com.spring.service;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.Teacher;
import com.spring.mapper.entities.UserRole;

public interface TeacherService {

	public List<?> getAllRecord();

	public List<String> getRoleOfUserByEmail(String email);

	public List<UserRole> getAllRecordUserRole();

	public Optional<UserRole> getUserRoleByEmail(String email);

	public Optional<Teacher> getTeacherByEmail(String emailFromToKen);

	public Optional<?> getListDepartmentyByTeacherEmail(String email);

	public Optional<?> getTeacherNoCollectionByTeacherId(long teacherId);

	public Optional<?> getAllTeacher();

	public boolean createTeacher(Teacher teacher);

//	public int saveAvatar(String fileName,int teacherID);
}
