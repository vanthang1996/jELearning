package com.spring.repository;

import java.util.List;
import java.util.Optional;

import com.spring.mapper.entities.StrucTestDetail;

public interface StrucTestDetailRepository {

	public List<?> getAllRecord();

	public Optional<?> getListStrucTestDetailBySubjectId(long subjectId);

	public int editStructureTestDetailByChapterId(StrucTestDetail strucTestDetail);

	Optional<?> getListStrucTestDetailBySubjectIdAndStatus(long subjectId, boolean status);
}
