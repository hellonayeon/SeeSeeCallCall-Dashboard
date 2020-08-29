package kr.ac.hansung.controller;

import java.util.HashMap;
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

import kr.ac.hansung.model.Client;
import kr.ac.hansung.model.Component;
import kr.ac.hansung.model.Realtime;
import kr.ac.hansung.model.DashboardData;
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

	// 초기 데이터 세팅
	@RequestMapping("/")
	public String getCurrentRealtimeData(Model model) {

		Realtime realtime = realtimeService.getCurrentRealtimeData();

		List<Topic> topics = topicService.getTopics();
		
		List<Component> components = componentService.getComponents();
		
		Map<String, Integer> platformMap = clientService.getPlatforms();
		
		Gson gson = new Gson();

		model.addAttribute("msgSize", gson.toJson(gson.toJson(realtime.getAccumulatedMsgSize())));
		model.addAttribute("connections", gson.toJson(realtime.getNumberOfConnections()));
		model.addAttribute("msgPublishCount", gson.toJson(realtime.getMsgPublishCount()));
		model.addAttribute("senders", gson.toJson(realtime.getNumberOfSenders()));

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

	@RequestMapping("/update")
	public ResponseBodyEmitter update() {
		final SseEmitter emitter = new SseEmitter();

		Realtime realtime = realtimeService.getCurrentRealtimeData();
		List<Topic> topics = topicService.getTopics();
		List<Component> components = componentService.getComponents();
		
		Map<String, Integer> platformMap = clientService.getPlatforms();

		DashboardData chartData = new DashboardData(realtime, topics, components, platformMap);

		final String jsonString = new Gson().toJson(chartData);

		System.out.println(jsonString);

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

		System.out.println("********************");
		return emitter;
	}

}
