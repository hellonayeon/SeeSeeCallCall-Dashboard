package kr.ac.hansung.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.hansung.dao.ComponentDao;
import kr.ac.hansung.model.Component;

@Service
public class ComponentService {

	@Autowired
	private ComponentDao componentDao;
	
	public Component getComponent(String topic) {
		return componentDao.getComponent(topic);
	}
	
	public List<Component> getComponents() {
		return componentDao.getComponents();
	}
	
	
}
