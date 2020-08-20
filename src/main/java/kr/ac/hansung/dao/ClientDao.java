package kr.ac.hansung.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.ac.hansung.model.Client;

@Repository
@Transactional
public class ClientDao {

	@Autowired
	private SessionFactory sessionFactory;
	
	public List<Client> getClients() {
		Session session = sessionFactory.getCurrentSession();
		
		Query<Client> query = session.createQuery("from Client", Client.class);
		
		return query.getResultList();
	}
	
	public Map<String, Integer> getPlatforms() {
		
		int android = 0;
		int iOS = 0;
		
		Session session = sessionFactory.getCurrentSession();
		Query<Client> query = session.createQuery("from Client", Client.class);
		
		List<Client> clients = query.getResultList();
		
		for(Client c : clients) {
			if(c.getPlatform().equals("Android"))
				android++;
			else
				iOS++;
		}
		
		Map<String, Integer> platformMap = new HashMap<String, Integer>();
		
		platformMap.put("Android", android);
		platformMap.put("iOS", iOS);
		
		return platformMap;
	}

}
