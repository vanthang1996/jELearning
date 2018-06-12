package com.spring.serviceImp;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.entities.Subject;
import com.spring.repository.SubjectRepository;
import com.spring.service.SubjectService;

@Service
public class SubjectServiceImp implements SubjectService {

	@Autowired
	private SubjectRepository subjectRepository;

	@Override
	public List<?> getAllRecord() {
		return this.subjectRepository.getAllRecord();
	}

	@Override
	public Optional<?> getListSubjectOfTeacherPaging(String email, int page, int size) {
		return this.subjectRepository.getListSubjectOfTeacherPaging(email, page, size);
	}

	@Override
	public Optional<?> getSubjectsDataByDepartmentId(long departmentId) {
		return this.subjectRepository.getSubjectsDataByDepartmentId(departmentId);
	}

	@Override
	public Optional<?> getSubjectBySubjectId(long subjectId) {
		return this.subjectRepository.getSubjectBySubjectId(subjectId);
	}

	@Override
	public Optional<?> getSubjectAddOutLineOrStructureTest(long departmentId, long jobTypeId) {
		return this.subjectRepository.getSubjectAddOutLineOrStructureTest(departmentId, jobTypeId);
	}

	@Override
	public List<Subject> getSubjectOfTeacherByTeacherId(long teacherId) {
		return this.subjectRepository.getListSubjectOfTeacher(teacherId, true);
	}

	@Override
	public int createSubject(Subject subject) {
		return this.subjectRepository.createSubject(subject);
	}

	@Override
	public boolean deleteTeacherOfSubject(long subjectId, long teacherManagementId) {
		if (this.subjectRepository.deleteTeacherOfSubject(subjectId, teacherManagementId) > 0)
			return true;
		return false;
	}

	@Override
	public List<Subject> getSubjectsByDepartmentId(long departmentId) {
		return this.subjectRepository.getSubjectsByDepartmentId(departmentId);
	}

	@Override
	public Optional<?> getSubjectInfoBySubjectId(long subjectId) {
		return this.subjectRepository.getSubjectInfoBySubjectId(subjectId);
	}

	public Optional<?> getSubjectBySubjectIdAllStatus(long subjectId) {
		return this.subjectRepository.getSubjectBySubjectIdAllStatus(subjectId);
	}

	@Override
	public boolean updateStatus(long subjectId, boolean status) {
		return this.subjectRepository.updateStatus(subjectId, status);
	}
}
