package com.spring.repository;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.Subject;

public interface SubjectRepository {

	List<?> getAllRecord();

	Optional<?> getListSubjectOfTeacherPaging(String email, int page, int size);

	Optional<?> getSubjectsDataByDepartmentId(long departmentId);

	Optional<?> getSubjectBySubjectId(long subjectId);

	Optional<?> getSubjectAddOutLineOrStructureTest(long departmentId, long jobTypeId);

	/**
	 * @param teacherId
	 * @param status
	 * @return get list subject of teacher by status
	 */
	List<Subject> getListSubjectOfTeacher(long teacherId, boolean status);

	Optional<?> getListSubjectOfTeacherPaging(String email, boolean status, int page, int size);

	int createSubject(Subject subject);

	int deleteTeacherOfSubject(long subjectId, long teacherManagementId);
}
