package kr.ac.hansung.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.hansung.dao.RealtimeDao;
import kr.ac.hansung.model.Realtime;

@Service
public class RealtimeService {

	@Autowired
	private RealtimeDao realtimeDao;
	
	public Realtime getCurrentRealtimeData() {
		return realtimeDao.getCurrentRealtimeData();
	}
	
	public List<Realtime> getAllRealtimeData() {
		return realtimeDao.getAllRealtimeData();
	}
	
	public List<Realtime> getRecentRealtimeData() {
		return realtimeDao.getRecentRealtimData();
	}
	
}
