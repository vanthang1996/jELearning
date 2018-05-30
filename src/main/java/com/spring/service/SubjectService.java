package com.spring.service;

import java.util.List;
import java.util.Optional;

public interface SubjectService {
	public List<?> getAllRecord();

	public Optional<?> getListSubjectOfTeacherPaging(String emailFromToKen, int page, int size);

	public Optional<?> getSubjectsDataByDepartmentId(long departmentId);

	public Optional<?> getSubjectBySubjectId(long subjectId);
}
