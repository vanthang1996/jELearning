package com.spring.serviceImp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.ChapterDao;
import com.spring.dao.ExamDao;
import com.spring.dao.QuestionDao;
import com.spring.mapper.entities.ExamTest;
import com.spring.repository.ExamTestDetailRepositpory;
import com.spring.repository.ExamTestRepository;
import com.spring.service.ExamTestService;

@Service
public class ExamTestServiceImp implements ExamTestService {
	@Autowired
	private ExamTestRepository examTestRepository;
	@Autowired
	private ExamTestDetailRepositpory detailRepositpory;

	@Override
	public List<?> getAllRecord() {
		// TODO Auto-generated method stub
		return this.examTestRepository.getAllRecord();
	}

	@Override
	public ExamTest getExamTestById(long examTestId) {
		// TODO Auto-generated method stub
		return this.examTestRepository.getExamTestById(examTestId);
	}

	@Override
	public long insertExamDao(ExamDao examDao) {
		long examTestId = this.examTestRepository.insertExamDao(examDao);
		List<ChapterDao> chapterDaos = examDao.getChapters();
		if (chapterDaos != null && examTestId != 0)
			for (ChapterDao chapterDao : chapterDaos) {
				List<QuestionDao> questionDaos = chapterDao.getQuestions();
				for (QuestionDao questionDao : questionDaos) {
					 this.detailRepositpory.insertQuestion(examTestId, questionDao.getQuestionId(),
							questionDao.getScore(), 0);
				}
			}
		return examTestId;
	}
}
