package kr.ac.hansung.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardData {

	private Realtime realtime;
	
	private List<Realtime> realtimes;
	
	private List<Topic> topics;
	
	private List<Client> clients;
	
	private List<Component> components;
	
	private Map<String, Integer> platformMap;

	public DashboardData(Realtime realtime, List<Topic> topics, List<Component> components, Map<String, Integer> platformMap) {
		super();
		this.realtime = realtime;
		this.topics = topics;
		this.components = components;
		this.platformMap = platformMap;		
	}

	public DashboardData(List<Realtime> realtimes, List<Topic> topics, Map<String, Integer> platformMap) {
		super();
		this.realtimes = realtimes;
		this.topics = topics;
		this.platformMap = platformMap;
	}
	
	
	
}
