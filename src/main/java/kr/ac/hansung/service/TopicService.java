package kr.ac.hansung.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.hansung.dao.TopicDao;
import kr.ac.hansung.model.Topic;

@Service
public class TopicService {

	@Autowired
	private TopicDao topicDao;
	
	public Topic getTopic(String name) {
		return topicDao.getTopic(name);
	}
	
}
