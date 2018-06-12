package com.spring.service;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.Subject;

public interface SubjectService {
	public List<?> getAllRecord();

	public Optional<?> getListSubjectOfTeacherPaging(String emailFromToKen, int page, int size);

	public Optional<?> getSubjectsDataByDepartmentId(long departmentId);

	public Optional<?> getSubjectBySubjectId(long subjectId);

	Optional<?> getSubjectAddOutLineOrStructureTest(long departmentId, long jobTypeId);

	public List<Subject> getSubjectOfTeacherByTeacherId(long teacherId);

	public int createSubject(Subject subject);

	public boolean deleteTeacherOfSubject(long subjectId, long teacherManagementId);

<<<<<<< HEAD
	public List<Subject> getSubjectsByDepartmentId(long departmentId);

	public Optional<?> getSubjectInfoBySubjectId(long subjectId);
=======
	public Optional<?> getSubjectBySubjectIdAllStatus(long subjectId);

	public boolean updateStatus(long subjectId, boolean status);
>>>>>>> master
}
