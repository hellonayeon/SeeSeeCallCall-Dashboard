package kr.ac.hansung.dao;

import java.util.List;

import javax.transaction.Transactional;

import org.hibernate.query.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.ac.hansung.model.Realtime;

@Repository
@Transactional
public class RealtimeDao {
	
	@Autowired
	private SessionFactory sessionFactory;

	public Realtime getCurrentRealtimeData() {
		
		Session session = sessionFactory.getCurrentSession();
		
		String hql = "from Realtime"; // TODO: load only last one record
		
		Query<Realtime> query = session.createQuery(hql, Realtime.class);
		Realtime realtime = query.getResultList().get(query.getResultList().size()-1);
		
		
		return realtime;
	}
	
	public List<Realtime> getAllRealtimeData() {
		Session session = sessionFactory.getCurrentSession();

		Query<Realtime> query = session.createQuery("from Realtime", Realtime.class);

		return  query.getResultList();
	}

}
