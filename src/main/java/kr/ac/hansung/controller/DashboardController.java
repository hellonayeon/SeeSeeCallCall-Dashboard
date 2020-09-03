package kr.ac.hansung.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyEmitter;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.google.gson.Gson;

import kr.ac.hansung.model.Component;
import kr.ac.hansung.model.DashboardData;
import kr.ac.hansung.model.Realtime;
import kr.ac.hansung.model.Topic;
import kr.ac.hansung.service.ClientService;
import kr.ac.hansung.service.ComponentService;
import kr.ac.hansung.service.RealtimeService;
import kr.ac.hansung.service.TopicService;

@Controller
public class DashboardController {

	@Autowired
	private RealtimeService realtimeService;

	@Autowired
	private TopicService topicService;

	@Autowired
	private ClientService clientService;
	
	@Autowired 
	ComponentService componentService;

	private ExecutorService nonblockingService = Executors.newSingleThreadExecutor();

	/* 초기에 보일 데이터  */
	@RequestMapping("/")
	public String getCurrentRealtimeData(Model model) {
		
		List<Realtime> realtimes = realtimeService.getRecentRealtimeData();
		
		List<Topic> topics = topicService.getTopics(); // 현재 사용중인 토픽 리스트 
		
		Map<String, Integer> platformMap = clientService.getPlatforms(); // 플랫폼 맵
		
		List<Component> components = componentService.getComponents(); // 회의방에 그려진 컴포넌트 개수

		
		List<Integer> msgSize = new ArrayList<Integer>(); // 전체 회의방에 대한 메시지 사이즈 
		List<Integer> connections = new ArrayList<Integer>(); // 참가자 수 
		List<Integer> msgPublishCount = new ArrayList<Integer>(); // 메시지 전송 횟수
		List<Integer> senders = new ArrayList<Integer>(); // 메시지를 전송하고 있는 참가자 수 
		
		
		for(int i=0; i<realtimes.size(); i++) {
			msgSize.add(realtimes.get(i).getAccumulatedMsgSize());
			connections.add(realtimes.get(i).getNumberOfConnections());
			msgPublishCount.add(realtimes.get(i).getMsgPublishCount());
			senders.add(realtimes.get(i).getNumberOfSenders());
		}
		
		Gson gson = new Gson();
		
		model.addAttribute("msgSize", gson.toJson(msgSize)); 
		model.addAttribute("connections", gson.toJson(connections)); 
		model.addAttribute("msgPublishCount", gson.toJson(msgPublishCount));
		model.addAttribute("senders", gson.toJson(senders)); 

		model.addAttribute("topics", gson.toJson(topics)); 
		model.addAttribute("components", gson.toJson(components)); 

		
		model.addAttribute("Android", platformMap.get("Android"));
		model.addAttribute("iOS", platformMap.get("iOS"));

		return "realtimeChart";
	}

	@RequestMapping("/realtimeChart")
	public String showRealtimeChart() {
		return "realtimeChart";
	}

	/* SSE URL */
	@RequestMapping("/update")
	public ResponseBodyEmitter update() {
		final SseEmitter emitter = new SseEmitter();

		Realtime realtime = realtimeService.getCurrentRealtimeData();
		List<Topic> topics = topicService.getTopics();
		List<Component> components = componentService.getComponents();
		
		Map<String, Integer> platformMap = clientService.getPlatforms();

		DashboardData chartData = new DashboardData(realtime, topics, components, platformMap);

		final String jsonString = new Gson().toJson(chartData);

		nonblockingService.execute(new Runnable() {
			@Override
			public void run() {
				try {
					emitter.send(jsonString);
					emitter.complete();
					Thread.sleep(1000);

				} catch (Exception e) {
					emitter.completeWithError(e);
					return;
				}
			}
		});

		return emitter;
	}

}
