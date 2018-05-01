package com.spring.service;

import java.util.List;
import java.util.Optional;

public interface StrucTestDetailService {

	public List<?> getAllRecord();

	public Optional<?> getListStrucTestDetailBySubjectId(long subjectId);
}
