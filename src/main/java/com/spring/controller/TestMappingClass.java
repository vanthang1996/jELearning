
package com.spring.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.service.ChapterService;
import com.spring.service.DepartmentService;
import com.spring.service.FacultyService;
import com.spring.service.JobTypeService;
import com.spring.service.LevelService;
import com.spring.service.StrucTestDetailService;
import com.spring.service.StructureTestService;
import com.spring.service.SubjectService;

@RestController
public class TestMappingClass {

	@Autowired
	private JobTypeService jobTypeService;

	@RequestMapping(value = "/get-list-job-type")
	public ResponseEntity<?> getListJobType() {
		return new ResponseEntity<>(jobTypeService.getAll(), HttpStatus.OK);
	}

	@Autowired
	private LevelService levelService;

	@RequestMapping(value = "/level/all")
	public ResponseEntity<?> getAllRecordLevel() {
		return new ResponseEntity<>(this.levelService.getAllRecord(), HttpStatus.OK);
	}

	@Autowired
	private FacultyService facultyService;

	@RequestMapping(value = "/faculty/all")
	public ResponseEntity<?> getAllRecordFaculty() {
		return new ResponseEntity<>(this.facultyService.getAllRecord(), HttpStatus.OK);
	}

	@Autowired
	private DepartmentService departmentService;

	@RequestMapping(value = "/department/all")
	public ResponseEntity<?> getAllRecordDepartment() {
		return new ResponseEntity<>(this.departmentService.getAllRecord(), HttpStatus.OK);
	}

	@Autowired
	private SubjectService subjectService;

	@RequestMapping(value = "/subject/all")
	public ResponseEntity<?> getAllRecordSubject() {
		return new ResponseEntity<>(this.subjectService.getAllRecord(), HttpStatus.OK);
	}

	@Autowired
	private StructureTestService structureTestService;

	@RequestMapping(value = "/structure/all")
	public ResponseEntity<?> getAllRecordStructureTest() {
		return new ResponseEntity<>(this.structureTestService.getAllRecord(), HttpStatus.OK);
	}

	@Autowired
	private StrucTestDetailService strucTestDetailService;

	@RequestMapping(value = "/struc/detail/all")
	public ResponseEntity<?> getAllRecordStrucTestDetail() {
		return new ResponseEntity<>(this.strucTestDetailService.getAllRecord(), HttpStatus.OK);
	}

	@Autowired
	private ChapterService chapterService;

	@RequestMapping(value = "/chapter/all")
	public ResponseEntity<?> getAllRecordChapter() {
		return new ResponseEntity<>(this.chapterService.getAllRecord(), HttpStatus.OK);
	}

}
