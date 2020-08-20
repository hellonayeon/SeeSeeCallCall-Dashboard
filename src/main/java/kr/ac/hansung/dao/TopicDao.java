package kr.ac.hansung.dao;

import java.util.List;

import javax.transaction.Transactional;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.ac.hansung.model.Topic;

@Repository
@Transactional
public class TopicDao {

	@Autowired
	private SessionFactory sessionFactory;
	
	public Topic getTopic(String name) {
		
		Session session = sessionFactory.getCurrentSession();
		
		return (Topic) session.get(Topic.class, name);
	}
	
	public List<Topic> getTopics() {
		Session session = sessionFactory.getCurrentSession();

		Query<Topic> query = session.createQuery("from Topic", Topic.class);

		return  query.getResultList();
	}

}
