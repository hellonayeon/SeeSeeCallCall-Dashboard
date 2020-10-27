package kr.ac.hansung.controller;

import java.util.ArrayList;
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

import kr.ac.hansung.model.Component;
import kr.ac.hansung.model.SendData;
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
	private ComponentService componentService;

	@Autowired
	private Gson gson;

	private ExecutorService nonBlockingService = Executors.newSingleThreadExecutor();

	/* 초기에 보일 데이터 */
	@RequestMapping("/")
	public String getCurrentRealtimeData(Model model) {

		List<Realtime> realtimes = realtimeService.getRecentRealtimeData();

		List<Topic> topicsInUse = topicService.getTopicsInUse(); // 현재 사용중인 토픽 리스트

		List<Topic> terminatedTopic = topicService.getTerminatedTopic(); // 사용이 종료된 토픽 리스트

		Map<String, Integer> platformMap = clientService.getPlatforms(); // 플랫폼 맵

		List<Component> components = componentService.getComponents(); // 회의방에 그려진 컴포넌트 개수

		List<Integer> msgSize = new ArrayList<Integer>(); // 전체 회의방에 대한 메시지 사이즈
		List<Integer> connections = new ArrayList<Integer>(); // 참가자 수
		List<Integer> msgPublishCount = new ArrayList<Integer>(); // 메시지 전송 횟수
		List<Integer> senders = new ArrayList<Integer>(); // 메시지를 전송하고 있는 참가자 수

		for (int i = 0; i < realtimes.size(); i++) {
			msgSize.add(realtimes.get(i).getAccumulatedMsgSize());
			connections.add(realtimes.get(i).getNumberOfConnections());
			msgPublishCount.add(realtimes.get(i).getMsgPublishCount());
			senders.add(realtimes.get(i).getNumberOfSenders());
		}

		model.addAttribute("msgSize", gson.toJson(msgSize));
		model.addAttribute("connections", gson.toJson(connections));
		model.addAttribute("msgPublishCount", gson.toJson(msgPublishCount));
		model.addAttribute("senders", gson.toJson(senders));

		model.addAttribute("topicsInUse", gson.toJson(topicsInUse));
		model.addAttribute("terminatedTopics", gson.toJson(terminatedTopic));

		model.addAttribute("components", gson.toJson(components));

		model.addAttribute("Android", platformMap.get("Android"));
		model.addAttribute("iOS", platformMap.get("iOS"));

		model.addAttribute("msgAvgMap", calcMessageAverage(terminatedTopic));
		model.addAttribute("componentAvgMap", calcComponentAverage(components));

		model.addAttribute("msgTotalMap", calcMessageTotal(terminatedTopic));
		model.addAttribute("componentTotalMap", calcComponentTotal(components));

		return "dashboard";
	}

	@RequestMapping("/dashboard")
	public String showDashboard() {
		return "dashboard";
	}

	/* SSE URL */
	@RequestMapping("/update")
	public ResponseBodyEmitter update() {

		System.out.println("******************** update func start ********************");

		final SseEmitter emitter = new SseEmitter();

		nonBlockingService.execute(new Runnable() {

			@Override
			public void run() {
				while (true) {
					try {
						System.out.println("******************** run ********************");

						Realtime realtime = realtimeService.getCurrentRealtimeData();

						List<Topic> topicsInUse = topicService.getTopicsInUse();
						List<Topic> terminatedTopics = topicService.getTerminatedTopic();

						List<Component> components = componentService.getComponents();

						Map<String, Integer> platformMap = clientService.getPlatforms();

						SendData data = new SendData(realtime, topicsInUse, terminatedTopics, components, platformMap,
								calcMessageAverage(terminatedTopics), calcComponentAverage(components),
								calcMessageTotal(terminatedTopics), calcComponentTotal(components));

						final String jsonString = gson.toJson(data); // SendData to JSON string

						emitter.send(jsonString);
						// emitter.complete();
						Thread.sleep(3000);

					} catch (Exception e) {
						emitter.completeWithError(e);
						return;
					}
				}
			}
		});

		return emitter;

	}

	private Map<String, Integer> calcMessageAverage(List<Topic> termiatedTopics) {

		int msgSizeAvg = 0, msgPublishCountAvg = 0, participantAvg = 0;
		for (Topic t : termiatedTopics) {
			msgSizeAvg += t.getAccumulatedMsgSize();
			msgPublishCountAvg += t.getMsgPublishCount();
			participantAvg += t.getParticipants();
		}

		Map<String, Integer> msgAvgMap = new HashMap<String, Integer>();

		// msgAvgMap size = 0
		try {
			msgAvgMap.put("msgSizeAvg", msgSizeAvg / termiatedTopics.size());
			msgAvgMap.put("msgPublishCountAvg", msgPublishCountAvg / termiatedTopics.size());
			msgAvgMap.put("participantAvg", participantAvg / termiatedTopics.size());
		} catch (ArithmeticException ae) {
			msgAvgMap.put("msgSizeAvg", 0);
			msgAvgMap.put("msgPublishCountAvg", 0);
			msgAvgMap.put("participantAvg", 0);
		}
		return msgAvgMap;
	}

	private Map<String, Integer> calcComponentAverage(List<Component> components) {
		int strokeAvg = 0, rectAvg = 0, ovalAvg = 0, textAvg = 0, imageAvg = 0, eraseAvg = 0;
		for (Component c : components) {
			if (!c.getTopic().contains(":"))
				continue; // 사용중인 회의방 데이터는 카운트 X

			strokeAvg += c.getStroke();
			rectAvg += c.getRect();
			ovalAvg += c.getOval();
			textAvg += c.getText();
			imageAvg += c.getImage();
			eraseAvg += c.getErase();
		}

		Map<String, Integer> componentAvgMap = new HashMap<String, Integer>();

		// component size = 0
		try {
			componentAvgMap.put("strokeAvg", strokeAvg / components.size());
			componentAvgMap.put("rectAvg", rectAvg / components.size());
			componentAvgMap.put("ovalAvg", ovalAvg / components.size());
			componentAvgMap.put("textAvg", textAvg / components.size());
			componentAvgMap.put("imageAvg", imageAvg / components.size());
			componentAvgMap.put("eraseAvg", eraseAvg / components.size());
		} catch (ArithmeticException ae) {
			componentAvgMap.put("strokeAvg", 0);
			componentAvgMap.put("rectAvg", 0);
			componentAvgMap.put("ovalAvg", 0);
			componentAvgMap.put("textAvg", 0);
			componentAvgMap.put("imageAvg", 0);
			componentAvgMap.put("eraseAvg", 0);
		}

		return componentAvgMap;
	}

	private Map<String, Integer> calcMessageTotal(List<Topic> termiatedTopics) {

		int msgSizeTotal = 0, msgPublishCountTotal = 0, participantTotal = 0;
		for (Topic t : termiatedTopics) {
			msgSizeTotal += t.getAccumulatedMsgSize();
			msgPublishCountTotal += t.getMsgPublishCount();
			participantTotal += t.getParticipants();
		}

		Map<String, Integer> msgTotalMap = new HashMap<String, Integer>();

		msgTotalMap.put("msgSizeTotal", msgSizeTotal);
		msgTotalMap.put("msgPublishCountTotal", msgPublishCountTotal);
		msgTotalMap.put("participantTotal", participantTotal);

		return msgTotalMap;
	}

	private Map<String, Integer> calcComponentTotal(List<Component> components) {

		int strokeTotal = 0, rectTotal = 0, ovalTotal = 0, textTotal = 0, imageTotal = 0, eraseTotal = 0;
		for (Component c : components) {
			if (!c.getTopic().contains(":"))
				continue; // 사용중인 회의방 데이터는 카운트 X

			strokeTotal += c.getStroke();
			rectTotal += c.getRect();
			ovalTotal += c.getOval();
			textTotal += c.getText();
			imageTotal += c.getImage();
			eraseTotal += c.getErase();
		}

		Map<String, Integer> componentTotalMap = new HashMap<String, Integer>();

		componentTotalMap.put("strokeTotal", strokeTotal);
		componentTotalMap.put("rectTotal", rectTotal);
		componentTotalMap.put("ovalTotal", ovalTotal);
		componentTotalMap.put("textTotal", textTotal);
		componentTotalMap.put("imageTotal", imageTotal);
		componentTotalMap.put("eraseTotal", eraseTotal);

		return componentTotalMap;
	}

}
