package com.spring.repositoryImp;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.dao.AnswerDao;
import com.spring.dao.ChapterDao;
import com.spring.dao.ExamDao;
import com.spring.dao.QuestionDao;
import com.spring.mapper.entities.StructureTest;
import com.spring.repository.StructureTestRepository;

@Repository
public class StructureTestRepositoryImp implements StructureTestRepository {

	private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
	@Autowired
	private SqlSessionFactory sessionFactory;

	@Override
	public List<StructureTest> getAllRecord() {
		SqlSession session = sessionFactory.openSession();
		List<StructureTest> list = Collections.emptyList();
		try {
			list = session.selectList("com.spring.mapper.StructureTestMapper.getAllRecord");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return list;
	}

	@Override
	public int createStructureTest(StructureTest structureTest) {
		SqlSession session = sessionFactory.openSession();
		int rowNum = -1;
		try {
			rowNum = session.insert("com.spring.mapper.StructureTestMapper.createStructureTest", structureTest);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rowNum;
	}

	@Override
	public boolean updateStatusStrucBySubjectId(long subjectId, boolean status) {
		// updateStatus
		SqlSession session = sessionFactory.openSession();
		int rowNum = 0;
		Map<String, Object> param = new HashMap<>();
		param.put("subjectId", subjectId);
		param.put("status", status);
		try {
			rowNum = session.update("com.spring.mapper.StructureTestMapper.updateStatus", param);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return rowNum > 0;
	}
	

	// function1 (mã cấu trúc đề thi) trả về de thi dao
	// lấy đối tượng từ mã trên
	// foreach từng strcudetal
	// { call function 2}

	// function 2 (ma chương, ma môn, độ khó, số lượng ) trả về danh sách câu hỏi
	// gồn đáp án và câu tl
	// lấy danh sách câu hỏi theo 4 cái trên đặt biệt nhớ số luọng bao nhiêu thì chỉ
	// lấy bấy nhiêu
	// su dung procedure addDeThi de lay danh sach cau hoi, vaf cau tl nau nhien

	// lấy thông tin cấu trúc
	public ExamDao getDeThiByIdMaCtdt(long maCtdt) {
		SqlSession session = sessionFactory.openSession();
		Connection connection = session.getConnection();
		CallableStatement callableStatement;
		ExamDao deThi = null;
		try {
			callableStatement = connection.prepareCall(
					" select * from CHI_TIET_CTDT  JOIN CHUONG_MUC ON CHUONG_MUC.MACHUONG=CHI_TIET_CTDT.MACHUONG WHERE  CHI_TIET_CTDT.MACTDT=?");
			callableStatement.setLong(1, maCtdt);
			ResultSet resultSet = callableStatement.executeQuery();
			deThi = new ExamDao(this.findById(maCtdt).getSubjectId(), maCtdt);

			List<ChapterDao> listChuong = new ArrayList<>();
			// duyệt tất cả các chương có trong đó để lấy lên những câu hỏi theo chương vs
			// độ khó

			while (resultSet.next()) {
				ChapterDao chuong = new ChapterDao(resultSet.getLong("MAMON"), resultSet.getLong("MACHUONG"),
						resultSet.getString("TIEUDE"), resultSet.getDouble("TONGDIEM"), resultSet.getString("MOTA"),
						resultSet.getLong("SLCAUHOI"), resultSet.getLong("MADOKHO"));
				addCauHoiIntoChuong(chuong);
				listChuong.add(chuong);
			}
			deThi.setChapters(listChuong);
			session.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return deThi;
	}

	// 2
	@Override
	public void addCauHoiIntoChuong(ChapterDao chapter) {
		SqlSession session = sessionFactory.openSession();
		Connection connection = session.getConnection();
		CallableStatement callableStatement;
		try {
			callableStatement = connection.prepareCall("execute addDeThi @MAMON =?,@MACHUONG=?,@SL=?,@MADOKHO=?");
			callableStatement.setLong(1, chapter.getSubjectId());
			callableStatement.setLong(2, chapter.getChapterId());
			callableStatement.setLong(3, chapter.getAmount());
			callableStatement.setLong(4, chapter.getLevelId());
			ResultSet row = callableStatement.executeQuery();
			List<QuestionDao> questionDaos = new ArrayList<>();
			while (row.next()) {
				QuestionDao questionDao = new QuestionDao(row.getLong("MACH"), row.getString("NOIDUNG"),
						row.getLong("MAMON"), row.getLong("MADOKHO"), row.getLong("MAGV"));
				addDapAnIntoCauHoi(questionDao);
				questionDaos.add(questionDao);
			}
			chapter.setQuestions(questionDaos);
			session.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	// 3
	public void addDapAnIntoCauHoi(QuestionDao questionDao) {
		SqlSession session = sessionFactory.openSession();
		Connection connection = session.getConnection();
		CallableStatement callableStatement;
		try {
			callableStatement = connection
					.prepareCall("select  MACH, MADAPAN, NOIDUNG,DAPANDUNG from DAP_AN where MACH=?");
			callableStatement.setLong(1, questionDao.getQuestionId());
			ResultSet row = callableStatement.executeQuery();
			List<AnswerDao> answerDaps = new ArrayList<>();
			while (row.next()) {
				AnswerDao anDao = new AnswerDao(row.getInt("MACH"), row.getInt("MADAPAN"), row.getString("NOIDUNG"),
						row.getInt("DAPANDUNG") == 1 ? true : false);
				answerDaps.add(anDao);

			}
			questionDao.setList(answerDaps);
			session.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public StructureTest findById(long strucTestId) {
		SqlSession session = sessionFactory.openSession();
		StructureTest structureTest = null;
		try {
			structureTest = session.selectOne("com.spring.mapper.StructureTestMapper.getStrucTestByStrucTestId",
					strucTestId);
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			session.close();
		}
		return structureTest;
	}
}
