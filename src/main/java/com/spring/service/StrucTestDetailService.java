package com.spring.service;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.StrucTestDetail;

public interface StrucTestDetailService {

	public List<?> getAllRecord();

	public Optional<?> getListStrucTestDetailBySubjectId(long subjectId);

	public int editStructureTestDetailByChapterId(StrucTestDetail strucTestDetail);

	public Optional<?> showStrucDetailBySubjectId(long subjectId);
}
