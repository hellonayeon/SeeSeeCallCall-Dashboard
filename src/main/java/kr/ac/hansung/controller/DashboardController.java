package kr.ac.hansung.controller;

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

import kr.ac.hansung.model.Realtime;
import kr.ac.hansung.model.RealtimeChartData;
import kr.ac.hansung.model.Topic;
import kr.ac.hansung.service.ClientService;
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

	private ExecutorService nonblockingService = Executors.newSingleThreadExecutor();
	
	@RequestMapping("/")
	public String getCurrentRealtimeData(Model model) {
		
		
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
		Map<String, Integer> platformMap = clientService.getPlatforms();
		
		RealtimeChartData chartData = new RealtimeChartData(realtime, topics, platformMap);
		
		final String jsonString = new Gson().toJson(chartData);
		
		System.out.println(jsonString);
		
		nonblockingService.execute(new Runnable() {
			@Override
			public void run() {
				try {
					
					emitter.send(jsonString);
					emitter.complete();
					Thread.sleep(1000);

				} catch(Exception e) {
					emitter.completeWithError(e);
					return;
				}
			}
		});
		
		System.out.println("********************");
		return emitter;
	}
	
	
	
}
