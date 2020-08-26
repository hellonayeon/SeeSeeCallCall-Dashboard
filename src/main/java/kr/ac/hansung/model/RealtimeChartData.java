package kr.ac.hansung.model;

import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;

public class RealtimeChartData {

	private Realtime realtime;
	
	private List<Realtime> realtimes;
	
	private List<Topic> topics;
	
	private Map<String, Integer> platformMap;

	public RealtimeChartData(Realtime realtime, List<Topic> topics, Map<String, Integer> platformMap) {
		super();
		this.realtime = realtime;
		this.topics = topics;
		this.platformMap = platformMap;
	}

	public RealtimeChartData(List<Realtime> realtimes, List<Topic> topics, Map<String, Integer> platformMap) {
		super();
		this.realtimes = realtimes;
		this.topics = topics;
		this.platformMap = platformMap;
	}
	
	
	
}
