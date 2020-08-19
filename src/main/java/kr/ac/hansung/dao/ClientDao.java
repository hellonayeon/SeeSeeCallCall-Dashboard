package kr.ac.hansung.dao;

import java.util.Arrays;
import java.util.List;

import javax.persistence.Query;
import javax.transaction.Transactional;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
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
		
		Query query = session.createQuery("FROM client", Client.class);
		List<Client> clients = query.getResultList();
		
		System.out.println("*** " + clients.toString());
		
		return clients;
	}

}
