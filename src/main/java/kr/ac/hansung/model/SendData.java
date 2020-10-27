package kr.ac.hansung.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SendData {

	private Realtime realtime;
	
	private List<Realtime> realtimes;
	
	private List<Topic> topicsInUse;
	
	private List<Topic> terminatedTopics;
	
	private List<Client> clients;
	
	private List<Component> components;
	
	private Map<String, Integer> platformMap;
	
	private Map<String, Integer> msgAvgMap;
	
	private Map<String, Integer> componentAvgMap;
	
	private Map<String, Integer> msgTotalMap;
	
	private Map<String, Integer> componentTotalMap;

	public SendData(Realtime realtime, List<Topic> topicsInUse, List<Topic> terminatedTopics, List<Component> components, Map<String, Integer> platformMap,
			Map<String, Integer> msgAvgMap, Map<String, Integer> componentAvgMap, Map<String, Integer> msgTotalMap, Map<String, Integer> componentTotalMap) {
		
		/* 실시간 데이터 */
		this.realtime = realtime;
		this.topicsInUse = topicsInUse;
		this.terminatedTopics = terminatedTopics;
		this.components = components;
		this.platformMap = platformMap;	
		
		/* 누적 데이터 */
		this.msgAvgMap = msgAvgMap;
		this.componentAvgMap = componentAvgMap;
		
		this.msgTotalMap = msgTotalMap;
		this.componentTotalMap = componentTotalMap;
		
	}
}
