package com.spring.repository;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.Teacher;
import com.spring.mapper.entities.UserRole;

public interface TeacherRepository {

	public List<?> getAllRecord();

	public List<String> getRoleOfUserByEmail(String email);

	public List<UserRole> getAllUserRole();

	public Optional<UserRole> getUserRoleByEmail(String email);

	public Optional<Teacher> getTeacherByEmail(String emailFromToKen);

	public Optional<?> getListDepartmentyByTeacherEmail(String email);

	public Optional<?> getTeacherNoCollectionByTeacherId(long teacherId);

	public Optional<?> getAllTeacher();

	public int createTeacher(Teacher teacher);

	public Optional<?> getTeacherByDepartmentId(long departmentId);

	public int updateTeacher(Teacher teacher);

	public Optional<?> getTeacherInDepartmentNotInSubject(long departmentId, long subjectId);

	public int insertQLMH(long teacherId, long subjectId);

	public int deleteQLMH(long teacherId, long subjectId);

	public Teacher findById(long teacherReceiveId);
}
