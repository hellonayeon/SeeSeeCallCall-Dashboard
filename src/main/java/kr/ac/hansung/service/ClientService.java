package kr.ac.hansung.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.hansung.dao.ClientDao;
import kr.ac.hansung.model.Client;

@Service
public class ClientService {

	@Autowired
	private ClientDao clientDao;
	
	public List<Client> getClients() {
		return clientDao.getClients();
	}
	
	public Map<String, Integer> getPlatforms() {
		return clientDao.getPlatforms();
	}
	
}
