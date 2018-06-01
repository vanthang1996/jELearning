package com.spring.repository;

import java.util.List;
import java.util.Optional;

public interface SubjectRepository {

	List<?> getAllRecord();

	Optional<?> getListSubjectOfTeacherPaging(String email, int page, int size);

	Optional<?> getSubjectsDataByDepartmentId(long departmentId);

	Optional<?> getSubjectBySubjectId(long subjectId);

	Optional<?> getSubjectAddOutLineOrStructureTest(long departmentId, long jobTypeId);
}
