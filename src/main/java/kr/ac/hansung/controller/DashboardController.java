package kr.ac.hansung.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyEmitter;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import com.google.gson.Gson;

import kr.ac.hansung.model.Realtime;
import kr.ac.hansung.service.RealtimeService;

@Controller
public class DashboardController {

	@Autowired
	private RealtimeService realtimeService;

	private ExecutorService nonblockingService = Executors.newSingleThreadExecutor();
	
	@RequestMapping("/")
	public String getCurrentRealtimeData(Model model) {
		List<Realtime> realtimes = realtimeService.getAllRealtimeData();
		
		model.addAttribute("realtimes", realtimes);
		
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
		
		Gson gson = new Gson();
		final String jsonString = gson.toJson(realtime);
		
		System.out.println(jsonString);
		
		nonblockingService.execute(new Runnable() {
			@Override
			public void run() {
				try {
					
					emitter.send(jsonString);
					emitter.complete();
					Thread.sleep(5000);

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
