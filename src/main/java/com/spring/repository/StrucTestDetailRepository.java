package com.spring.repository;

import java.util.List;
import java.util.Optional;

public interface StrucTestDetailRepository {

	public List<?> getAllRecord();

	public Optional<?> getListStrucTestDetailBySubjectId(long subjectId);
}
