package kr.ac.hansung.dao;

import java.util.List;

import javax.transaction.Transactional;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.ac.hansung.model.Component;

@Repository
@Transactional
public class ComponentDao {

	@Autowired
	private SessionFactory sessionFactory;
	
	public Component getComponent(String topic) {
		Session session = sessionFactory.getCurrentSession();
		
		return (Component) session.get(Component.class, topic);
	}
	
	public List<Component> getComponents() {
		Session session = sessionFactory.getCurrentSession();
		
		Query<Component> query = session.createQuery("from Component", Component.class);
	
		return query.getResultList();
	}
	
	
	
}
