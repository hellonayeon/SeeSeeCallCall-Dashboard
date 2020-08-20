package kr.ac.hansung.model;

import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class RealtimeChartData {

	private Realtime realtime;
	
	private List<Topic> topics;
	
	private Map<String, Integer> platformMap;
	
	
}
