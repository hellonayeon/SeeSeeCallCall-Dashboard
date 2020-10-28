<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script src="<c:url value="/resources/js/Chart.js/Chart.min.js"/>"></script>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.16.0/moment-with-locales.min.js"></script>


<style>
canvas {
	-moz-user-select: none;
	-webkit-user-select: none;
	-ms-user-select: none;
}

/* 테이블 표시 영역 (최대 3개의 행 표시) */
#topic-table-wrapper {
	overflow-y: auto;
	height: 250px;
}

#terminated-topic-table-wrapper {
	overflow-y: auto;
	height: 300px;
}

thead th {
	position: sticky;
	top: 0;
	background: white;
}

/* Just common table stuff. Really. */
table {
	/*border-collapse: collapse;*/
	width: 100%;
  	table-layout: fixed;
}

.rounded-background {
	background: white;
	border-radius: 5px;
}

.topic-msg-size-wrapper {
	margin-top: -60px; /* -80px */
}

.client-msg-wrapper {
	margin-top: 5px;
}

.platform-content {
	padding-top: 50px;
	padding-bottom: 50px; /* 80px; */
}

.platform-label {
	margin-right: 10px;
	margin-left: 5px;
	font-size: 25px;
	font-weight: bold;
	display: inline-block;
	width: 30px;
	text-align: center;
}

.platform-figures-name {
	margin-right: 10px;
	font-size: 15px;
	font-weight: bold;
}

.partition {
	margin-top: -20px;
}

.sub-title-partition {
	margin-top: 20px;
}

.accumulated-partition {
	margin-top: 10px;
}

.average-partition {
	margin-top: 20px;
}

.msg-avg-label {
	height: 110px;
}


.msg-total-label  {
	height: 110px;

}

.component-total-label {
	height: 200px;
}

.msg-total-partition {
	margin-top: -340px;
}

.component-total-partition {
	margin-top: 20px;
}


</style>
<div class="partition">
	<!--  <div class="partition-title"> Total amount of topic figures </div> -->
	<div class="container-wrapper">
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-3">
					<div class="col-md-12 rounded-background">
						<p class="chart-title">메시지 크기</p>
						<canvas id="msgSizeChart"></canvas>
					</div>
				</div>
				<div class="col-md-3">
					<div class="col-md-12 rounded-background">
						<p class="chart-title">참가자 수 및 메시지 송신자 수</p>
						<canvas id="connectionAndSenderChart"></canvas>
					</div>
				</div>
				<div class="col-md-3">
					<div class="col-md-12 rounded-background">
						<p class="chart-title">메시지 전송 횟수</p>
						<canvas id="msgPublishCountChart"></canvas>
					</div>
				</div>
				<div class="col-md-3">
					<div class="col-md-12 rounded-background">
						<p class="chart-title">운영체제</p>
						<p class="platform-content">
							<img src="<c:url value="/resources/images/android-logo.png"/>"
								width="80" height="80"> <span class="platform-label"
								id="androidLabel">00</span><span class="platform-figures-name">users</span>
							<img src="<c:url value="/resources/images/ios-logo.png"/>"
								width="80" height="80"> <span class="platform-label"
								id="iOSLabel">00</span><span class="platform-figures-name">users</span>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- </div> -->


	<!--  <div class="partition-title"> Each amount of topic figures </div> -->
	<div class="container-wrapper">
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-6">
					<div class="col-md-12 rounded-background" id="topic-table-wrapper">
						<p class="chart-title">진행중인 회의방 리스트</p>
						<table id="topicsInUseTable" class="table table-hover">
							<thead>
								<tr>
									<th scope="col" style="width: 5%">#</th>
									<th scope="col" style="width: 20%">회의명</th>
									<th scope="col" style="width: 30%">시작시간</th>
									<th scope="col" style="width: 20%">참가자 수</th>
									<th scope="col" style="width: 25%">사용시간</th>
								</tr>
							</thead>
							<tbody id="topicsInUseTableBody">
								<tr></tr>
								<tr></tr>
								<tr></tr>
								<tr></tr>
								<tr></tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="col-md-6">
					<div class="col-md-12 rounded-background">
						<p class="chart-title">컴포넌트</p>
						<canvas id="componentChart" height="110"></canvas>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="container-wrapper">
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-6">
					<div class="col-md-12 rounded-background topic-msg-size-wrapper">
						<p class="chart-title">토픽 메시지 크기</p>
						<canvas id="topicMsgSizeChart" height="120"></canvas>
					</div>
				</div>
				<div class="col-md-3">
					<div class="col-md-12 rounded-background client-msg-wrapper">
						<p class="chart-title">클라이언트 메시지 크기</p>
						<canvas id="clientMsgSizeChart" height="205"></canvas>
					</div>
				</div>
				<div class="col-md-3">
					<div class="col-md-12 rounded-background client-msg-wrapper">
						<p class="chart-title">클라이언트 메시지 전송 횟수</p>
						<canvas id="clientMsgPublishCountChart" height="205"></canvas>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div></div>

<div class="sub-title-partition">
	<div class="container-fluid">
			<div class="row">
				<div class="col-12" id="page-sub-title" align="center">
					누적 사용 현황
				</div>
			</div>
		</div>
</div>

<div class="accumulated-partition">
	<div class="container-wrapper">
		<div class="container-fluid">
			<div class="row">
				<div class="col-12">
					<div class="col-md-12 rounded-background" >
						<p class="chart-title">종료된 회의방 리스트</p>
						<div id="terminated-topic-table-wrapper">
						<table id="terminatedTopicsTable" class="table table-hover">
							<thead>
								<tr>
									<th scope="col" style="width: 5%">#</th>
									<th scope="col" style="width: 10%">회의명</th>
									<th scope="col" style="width: 15%">시작시간</th>
									<th scope="col" style="width: 15%">사용시간</th>
									<th scope="col" style="width: 20%">메시지 크기</th>
									<th scope="col" style="width: 20%">메시지 전송 횟수</th>
									<th scope="col" style="width: 15%">참가자 수</th>
								</tr>
							</thead>
							<tbody id="terminatedTopicsTableBody">
								<tr></tr>
								<tr></tr>
								<tr></tr>
								<tr></tr>
								<tr></tr>
								<tr></tr>
								<tr></tr>
							</tbody>
						</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="average-partition">
	<!--  <div class="partition-title"> Each amount of topic figures </div> -->
	<div class="container-wrapper">
		<div class="container-fluid">
			<div class="row">
			
				<div class="col-md-2">
					<div class="col-md-12 rounded-background msg-avg-label">
						<p class="chart-title">평균 메시지 전송량</p>
						<p><span id="msgSizeAvgLabel"></span></p>
					</div>
				</div>
				
				<div class="col-md-2">
					<div class="col-md-12 rounded-background msg-avg-label">
						<p class="chart-title">평균 메시지 전송 횟수</p>
						<p><span id="msgPublishCountAvgLabel"></span></p>
					</div>
				</div>
				
				<div class="col-md-2">
					<div class="col-md-12 rounded-background msg-avg-label">
						<p class="chart-title">평균 참가자 수</p>
						<p><span id="participantAvgLabel"></span></p>
					</div>
				</div>
			
				<div class="col-md-6">
					<div class="col-md-12 rounded-background">
						<p class="chart-title">평균 컴포넌트 개수</p>
						<canvas id="componentAvgChart" height="160"></canvas>
					</div>
				</div>
				
			</div>
		</div>
</div>
	
<div class="msg-total-partition">
	<div class="container-wrapper">
		<div class="container-fluid">
			<div class="row">
			
				<div class="col-md-2">
					<div class="col-md-12 rounded-background msg-total-label">
						<p class="chart-title">누적 메시지 전송량</p>
						<p><span id="msgSizeTotalLabel"></span></p>
					</div>
				</div>
				
				<div class="col-md-2">
					<div class="col-md-12 rounded-background msg-total-label">
						<p class="chart-title">누적 메시지 전송 횟수</p>
						<p><span id="msgPublishCountTotalLabel"></span></p>
					</div>
				</div>
				
				<div class="col-md-2">
					<div class="col-md-12 rounded-background msg-total-label">
						<p class="chart-title">누적 참가자 수</p>
						<p><span id="participantTotalLabel"></span></p>
					</div>
				</div>
			
				
			</div>
		</div>
	</div>
	</div>
</div>

<div class="component-total-partition">	
	<div class="container-wrapper">
		<div class="container-fluid">
			<div class="row">
			
				<div class="col-md-6">
					<div class="col-md-12 rounded-background component-total-label">
						<p class="chart-title">누적 컴포넌트 개수</p>
						<div class="row">
						<div class="col-1">
							<img src="<c:url value="/resources/images/pen.png"/>" width="30" height="30"> 
							<span id="strokeTotal"></span>
						</div>
						<div class="col-1">
							<img src="<c:url value="/resources/images/rect.png"/>" 
								width="30" height="30"><span id="rectTotal"></span>
						</div>
						<div class="col-1">
							<img src="<c:url value="/resources/images/oval.png"/>" width="30" height="30"> 
							<span id="ovalTotal"></span>
						</div>
						<div class="col-1">
							<img src="<c:url value="/resources/images/text.png"/>" width="30" height="30"> 
							<span id="textTotal"></span>
						</div>
						<div class="col-1">
							<img src="<c:url value="/resources/images/photo.png"/>" width="30" height="30"> 
							<span id="imageTotal"></span>
						</div>
						<div class="col-1">
							<img src="<c:url value="/resources/images/eraser.png"/>" width="30" height="30"> 
							<span id="eraseTotal"></span>
						</div>
						</div>
						<!-- <p>
						<span id="strokeTotal"></span>
						<span id="rectTotal"></span>
						<span id="ovalTotal"></span>
						<span id="textTotal"></span>
						<span id="imageTotal"></span>
						<span id="eraseTotal"></span>
						</p> -->
					</div>
				</div>
			
				<div class="col-md-6">
					<%-- <div class="col-md-12 rounded-background">
						<p class="chart-title">평균 컴포넌트 개수</p>
						<canvas id="componentAvgChart" height="110"></canvas>
					</div> --%>
				</div>
				
			</div>
		</div>
	</div>
</div>
	
<script>

	var labels = [ '30', '27', '24', '21', '18', '15', '12', '9', '6', '3', '0' ];
	
	var charts = []; // 차트 배열
	var durations = []; // 지속 시간 배열 -> 동적 생성 테이블의 마지막 열 데이터

	
	/** 전체 회의방 실시간 데이터 **/
	var msgSize = [];
	var connections = [];
	var msgPublishCount = [];
	var senders = [];

	var Android; // number of
	var iOS;

	
	/** 개별 회의방 실시간 데이터 **/
	var topicsInUse = [];
	var components = [];

	var selectedTopic = null;
	var selectedComponent = null;
	
	var selectedComponentCount = []; // stroke, rect, oval, text, image, erase

	var topicMsgSize = []; // 선 차트 데이터

	var selectedClients = []; // 현재 선택된 회의방의 참가자들 리스트
	var selectedClientsName = []; // 파이 차트 레이블
	var selectedClientsMsgSize = []; // 파이차트1 데이터
	var selectedClientsMsgPublishCount = []; // 파이차트2 데이터

	
	/** 평균 데이터 (사용이 종료된 회의방) **/
	var terminatedTopics = [];
	var useTimeCheck = [];
	
	/* var msgSizeAvg; // 평균 메시지 전송량
	var msgPublishCountAvg; // 평균 메시지 전송 횟수
	var participantAvg; // 평균 참여자 수 */
	
	var msgAvgMap; // 메시지 평균 데이터 (평균 메시지 전송량, 평균 메시지 전송 횟수, 평균 참여자 수)
	var componentAvgMap; // 평균 컴포넌트 개수 (Map)
	
	var msgTotalMap; // 메시지 누적 데이터 (누적 메시지 전송량, 누적 메시지 전송 횟수, 누적 참여자 수)
	var componentTotalMap; // 누적 컴포넌트 개수 (Map)
	
	
	/** 차트 **/
	// 전체 회의 차트
	var msgSizeChart;
	var connectionAndSenderChart;
	var msgPublishCountChart;
	var platformRatioChart;

	// 개별 회의 차트
	var componentChart;
	var topicMsgSizeChart;
	var clientMsgSizeChart;
	var clientMsgPublishCountChart;

	// 평균 차트
	var componentAvgChart;

	window.onload = function() {
		console.log("window.onload");

		initializeData();
		initializeChart();

		connect(); // SSE connection

		startTimer(); // 회의 지속 시간 count
	};

	
	// 3초 간격으로 갱신되는 서버로 부터 받은 참가자들(Client) 데이터에서
	// 이름, 메시지 전송량, 메시지 전송 횟수를 각각 추출해서 리스트로 관리하기 위해
	function initTopicClientData() {
		
		selectedClients = [];

		selectedClientsName = [];
		selectedClientsMsgSize = [];
		selectedClientsMsgPublishCount = [];
		
	}

	// 차트 초기 데이터 세팅
	function initializeData() {
		console.log("initialize data func.");
		
		msgSize = ${msgSize};
		connections = ${connections};
		msgPublishCount = ${msgPublishCount};
		senders = ${senders};
		
		Android = ${Android};
		iOS = ${iOS};
		
		topicsInUse = ${topicsInUse};
		components = ${components};
		
		terminatedTopics = ${terminatedTopics};
		
		
		msgAvgMap = { "msgSizeAvg": ${msgAvgMap.msgSizeAvg}, "msgPublishCountAvg": ${msgAvgMap.msgPublishCountAvg}, "participantAvg": ${msgAvgMap.participantAvg}  };
		
		componentAvgMap = { "strokeAvg": ${componentAvgMap.strokeAvg}, "rectAvg": ${componentAvgMap.rectAvg}, "ovalAvg": ${componentAvgMap.ovalAvg}, "textAvg": ${componentAvgMap.textAvg}, "imageAvg": ${componentAvgMap.imageAvg}, "eraseAvg": ${componentAvgMap.eraseAvg}};
		
		msgTotalMap = { "msgSizeTotal": ${msgTotalMap.msgSizeTotal}, "msgPublishCountTotal": ${msgTotalMap.msgPublishCountTotal}, "participantTotal": ${msgTotalMap.participantTotal} };
		
		componentTotalMap = { "strokeTotal": ${componentTotalMap.strokeTotal}, "rectTotal": ${componentTotalMap.rectTotal}, "ovalTotal": ${componentTotalMap.ovalTotal}, "textTotal": ${componentTotalMap.textTotal}, "imageTotal": ${componentTotalMap.imageTotal}, "eraseTotal": ${componentTotalMap.eraseTotal} }
		
		// 현재 사용중인 토픽이 하나라도 있으면
		// 리스트의 첫 번째 토픽으로 개별 토픽 차트 출력
		
		if (topicsInUse.length == 0) return;
		
		/* 개별 토픽 차트 출력을 위한 데이터 저장 */
		if (topicsInUse[0] != null) { 
			console.log("topic is not null");

			initTopicClientData();

			selectedTopic = topicsInUse[0];
			selectedClients = selectedTopic.clients;

			topicMsgSize.push(selectedTopic.accumulatedMsgSize);

			for (var i = 0; i < selectedClients.length; i++) {
				selectedClientsName.push(selectedClients[i].name);
				selectedClientsMsgSize
						.push(selectedClients[i].accumulatedMsgSize);
				selectedClientsMsgPublishCount
						.push(selectedClients[i].msgPublishCount);
			}

			for (var i = 0; i < components.length; i++) {
				console.log(components[i].topic + " " + selectedTopic.topic);
				if (components[i].topic == selectedTopic.topic) {
					selectedComponent = components[i];
					break;
				}
			}
		}
	}
	

	function connect() {
		var es = new EventSource("http://localhost:8080/Dashboard/update");

		es.onopen = function(evt) {
			console.log("connection success.");
		}

		es.onerror = function(evt) {
			console.log("connection error.");
		}

		es.onmessage = function(evt) {
			console.log("sever sent event");

			var obj = JSON.parse(evt.data);
			// console.log(evt.data);

			// 서버로부터 받은 데이터 저장
			// (배열에 요소 하나씩 추가)
			msgSize.push(obj.realtime.accumulatedMsgSize);
			connections.push(obj.realtime.numberOfConnections);
			msgPublishCount.push(obj.realtime.msgPublishCount);
			senders.push(obj.realtime.numberOfSenders);
			
			Android = parseInt(obj.platformMap.Android);
			iOS = parseInt(obj.platformMap.iOS);

			topicsInUse = obj.topicsInUse;
			components = obj.components;
			
			terminatedTopics = obj.terminatedTopics;
			msgAvgMap = obj.msgAvgMap;
			componentAvgMap = obj.componentAvgMap;	
			msgTotalMap = obj.msgTotalMap;
			componentTotalMap = obj.componentTotalMap;

			shiftArrays();

			if(topicsInUse.length == 0) {		
				initTopicClientData(); // 클라이언트 데이터 초기화
				
				topicMsgSize = [];
				selectedComponentCount = [0, 0, 0, 0, 0, 0];
			}
			else {
				if(topicsInUse.length == 1) {
					console.log("topicsInUse length = 1");

					initTopicClientData();

					selectedTopic = topicsInUse[0];
					selectedClients = selectedTopic.clients;

					topicMsgSize.push(selectedTopic.accumulatedMsgSize);
				}
				else {
					console.log("topicsInUse length > 1");
					
					for (var i = 0; i < topicsInUse.length; i++) {
						
						// 갱신된 데이터 저장
						if (topicsInUse[i].topic == selectedTopic.topic) { // fixme topic이 아무것도 없다가 생겼을 경우

							initTopicClientData();

							selectedTopic = topicsInUse[i];
							selectedClients = selectedTopic.clients;

							topicMsgSize.push(selectedTopic.accumulatedMsgSize);

							break;
						}
					}
				}
				
				// 파이 차트 데이터 갱신
				for (var i = 0; i < selectedClients.length; i++) {
					selectedClientsName.push(selectedClients[i].name);
					selectedClientsMsgSize
							.push(selectedClients[i].accumulatedMsgSize);
					selectedClientsMsgPublishCount
							.push(selectedClients[i].msgPublishCount);
				}

				// 새로 갱신된 데이터 저장
				for (var i = 0; i < components.length; i++) {
					if (components[i].topic == selectedTopic.topic) {
						selectedComponent = components[i];
						selectedComponentCount = [selectedComponent.stroke, selectedComponent.rect, selectedComponent.oval, selectedComponent.text, selectedComponent.image, selectedComponent.erase];
						break;
					}
				}
				
			}
			
			updateCharts();
			updateTopicTable();
			updatePlatformLabels();
			
			updateTerminatedTopicTable();
			updateAverageLabels();
			
			updateTotalLabels();
			updateComponentLabels();
		}

	}

	// 사용하는 차트 생성과 차트를 배열에 삽입
	function initializeChart() {
		console.log("chart initialize");

		msgSizeChart = new Chart(document.getElementById("msgSizeChart"), {
			type : 'line',
			data : {
				labels : labels,
				datasets : [ {
					label : '전체 회의방 메시지 사이즈',
					data : msgSize,
					backgroundColor : 'rgb(0,0,0,0)',
					borderColor : 'rgb(22,160,232)',
					borderWidth : 2,
					lineTension : 0,
					pointRadius : 0
				} ]
			},

			options : {
				responsive : true,
				animation : {
					duration : 1000,
					easing : 'linear'
				},
				legend : false,
				scales : {
					xAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : false
						},
						scaleLabel : {
							display : true,
							labelString : '초(s)'
						}
					} ],
					yAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : true
						},
						ticks : {
							beginAtZero : true,
							maxTicksLimit : 5
						},
						scaleLabel : {
							display : true,
							labelString : '바이트(byte)'
						}
					} ]
				},
				tooltips : {
					mode : 'nearest',
					titleFontSize : 20,
					backgroundColor : 'rgba(255, 255, 255, 0.8)',
					titleFontColor : 'rgb(102, 102, 102)',
					bodyFontColor : 'rgb(102, 102, 102)'
				},
				layout : {
					padding : {
						left : -5,
						right : -5,
						top : -5,
						bottom : 0
					}
				}
			}
		});
		connectionAndSenderChart = new Chart(document
				.getElementById("connectionAndSenderChart"), {
			type : 'line',
			data : {
				labels : labels,
				datasets : [ {
					label : '참가자 수',
					data : connections,
					backgroundColor : 'rgb(242,93,93,0.8)',
					borderColor : 'rgb(242,93,93, 0.8)',
					pointRadius : 5,
					pointHoverRadius : 10,
					showLine : false
				}, {
					label : '메시지 송신자 수',
					data : senders,
					backgroundColor : 'rgb(255,203,102, 0.8)',
					borderColor : 'rgb(255,203,102, 0.8)',
					pointRadius : 5,
					pointHoverRadius : 10,
					showLine : false
				} ]
			},
			options : {
				responsive : true,
				animation : {
					duration : 1000,
					easing : 'linear'
				},
				legend : {
					display : true,
					labels : {
						fontColor : 'rgb(102, 102, 102)'
					}
				},
				scales : {
					xAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : false
						},
						scaleLabel : {
							display : true,
							labelString : '초(s)'
						}
					} ],
					yAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : true
						},
						ticks : {
							beginAtZero : true,
							maxTicksLimit : 5
						},
						scaleLabel : {
							display : true,
							labelString : '참가자 수 & 메시지 송신자 수'
						}
					} ]
				},
				tooltips : {
					titleFontSize : 20,
					backgroundColor : 'rgba(255, 255, 255, 0.8)',
					titleFontColor : 'rgb(102, 102, 102)',
					bodyFontColor : 'rgb(102, 102, 102)'
				},
				layout : {
					padding : {
						left : -5,
						right : -5,
						top : -5,
						bottom : 0
					}
				}
			}
		});
		msgPublishCountChart = new Chart(document
				.getElementById("msgPublishCountChart"), {
			type : 'line',
			data : {
				labels : labels,
				datasets : [ {
					data : msgPublishCount,
					steppedLine : true,
					backgroundColor : 'rgb(22,160,232, 0.1)',
					borderColor : 'rgb(22,160,232)',
					borderWidth : 2,
					lineTension : 0.25,
					pointRadius : 0
				} ]
			},
			options : {
				responsive : true,
				animation : {
					duration : 500,
					easing : 'linear'
				},
				legend : false,

				scales : {
					xAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : false
						},
						scaleLabel : {
							display : true,
							labelString : '초(s)'
						}
					} ],
					yAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : true
						},
						ticks : {
							beginAtZero : true,
							maxTicksLimit : 5
						},
						scaleLabel : {
							display : true,
							labelString : '전송 횟수'
						}
					} ]
				},
				layout : {
					padding : {
						left : -5,
						right : -5,
						top : -5,
						bottom : 0
					}
				}
			}
		});

		componentChart = new Chart(document.getElementById("componentChart"), {
			type : 'bar',
			data : {
				labels : [ '자유곡선', '사각형', '타원', '텍스트', '이미지', '지우기' ],
				datasets : [ {
					data : selectedComponentCount,
					backgroundColor : [ 'rgb(241,178,235)', 'rgb(164,160,252)',
							'rgb(255,203,101)', 'rgb(22,160,232)',
							'rgb(242,93,93)' ]
				} ]
			},
			options : {
				responsive : true,
				animation : {
					duration : 1000,
					easing : 'linear'
				},
				legend : false,
				scales : {
					xAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : false
						},
						scaleLabel : {
							display : true,
							labelString : '컴포넌트 종류'
						}
					} ],
					yAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : true
						},
						ticks : {
							beginAtZero : true,
							maxTicksLimit : 5
						},
						scaleLabel : {
							display : true,
							labelString : '개수, 횟수'
						}
					} ]
				}
			}
		});

		clientMsgSizeChart = new Chart(document
				.getElementById("clientMsgSizeChart"), {
			type : 'pie',
			data : {
				datasets : [ {
					data : selectedClientsMsgSize,
					backgroundColor : [ 'rgb(95,227,161)', 'rgb(22,160,232)',
							'rgb(241,178,235)', 'rgb(255,203,101)',
							'rgb(255,203,102)' ]
				} ],
				labels : selectedClientsName
			},
			options : {
				responsive : true,
				animation : {
					duration : 1000,
					easing : 'linear'
				},
			}
		});

		clientMsgPublishCountChart = new Chart(document
				.getElementById("clientMsgPublishCountChart"), {
			type : 'doughnut',
			data : {
				datasets : [ {
					data : selectedClientsMsgPublishCount,
					backgroundColor : [ 'rgb(95,227,161)', 'rgb(22,160,232)',
							'rgb(241,178,235)', 'rgb(255,203,101)',
							'rgb(255,203,102)' ]
				} ],
				labels : selectedClientsName
			},
			options : {
				responsive : true,
				animation : {
					duration : 0,
					easing : 'linear'
				}
			}
		});

		topicMsgSizeChart = new Chart(document
				.getElementById("topicMsgSizeChart"), {
			type : 'line',
			data : {
				labels : labels,
				datasets : [ {
					data : topicMsgSize,
					backgroundColor : 'rgb(0,0,0,0)',
					borderColor : 'rgb(255,99,132)',
					borderWidth : 2,
					lineTension : 0,
					pointRadius : 0
				} ]
			},
			options : {
				responsive : true,
				animation : {
					duration : 1000,
					easing : 'linear'
				},
				legend : false,
				scales : {
					xAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : false
						},
						scaleLabel : {
							display : true,
							labelString : '초(s)'
						}
					} ],
					yAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : true
						},

						ticks : {
							beginAtZero : true,
							maxTicksLimit : 5
						},
						scaleLabel : {
							display : true,
							labelString : '바이트(byte)'
						}
					} ]
				},
				layout : {
					padding : {
						left : -5,
						right : -5,
						top : -5,
						bottom : 0
					}
				}
			}
		});

		
		componentAvgChart = new Chart(document.getElementById("componentAvgChart"), {
			type : 'bar',
			data : {
				labels : [ '자유곡선', '사각형', '타원', '텍스트', '이미지', '지우기' ],
				datasets : [ {
					data : [ componentAvgMap.stroke, componentAvgMap.rect, componentAvgMap.oval, 
							componentAvgMap.text, componentAvgMap.image, componentAvgMap.erase ],
					backgroundColor : [ 'rgb(241,178,235)', 'rgb(164,160,252)',
							'rgb(255,203,101)', 'rgb(22,160,232)',
							'rgb(242,93,93)' ]
				} ]
			},
			options : {
				responsive : true,
				animation : {
					duration : 1000,
					easing : 'linear'
				},
				legend : false,
				scales : {
					xAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : false
						},
						scaleLabel : {
							display : true,
							labelString : '컴포넌트 종류'
						}
					} ],
					yAxes : [ {
						gridLines : {
							display : true,
							drawBorder : true,
							drawOnChartArea : true
						},
						ticks : {
							beginAtZero : true,
							maxTicksLimit : 5
						},
						scaleLabel : {
							display : true,
							labelString : '개수, 횟수'
						}
					} ]
				}
			}
		});
		
	}

	function updateCharts() {
		console.log("update charts");

		msgSizeChart.update();
		connectionAndSenderChart.update();
		msgPublishCountChart.update();

		componentChart.data.datasets[0].data = selectedComponentCount;
		componentChart.update();

		clientMsgPublishCountChart.data.datasets[0].data = selectedClientsMsgPublishCount;
		clientMsgPublishCountChart.data.labels = selectedClientsName;
		clientMsgPublishCountChart.update();

		topicMsgSizeChart.data.datasets[0].data = topicMsgSize;
		topicMsgSizeChart.update();

		clientMsgSizeChart.data.datasets[0].data = selectedClientsMsgSize;
		clientMsgSizeChart.data.labels = selectedClientsName;
		clientMsgSizeChart.update();
		
		/* 누적 사용 현황 (컴포넌트) 업데이트 */
		componentAvgChart.data.datasets[0].data = [componentAvgMap.strokeAvg, componentAvgMap.rectAvg, componentAvgMap.ovalAvg, componentAvgMap.textAvg, componentAvgMap.imageAvg, componentAvgMap.eraseAvg ];
		componentAvgChart.update();

	}

	function updateTopicTable() {
		console.log("update topic table");

		var topicsInUseTable = document.getElementById('topicsInUseTable');
		var topicsInUseTableBody = document.getElementById('topicsInUseTableBody');

		topicsInUseTableBody.innerHTML = "";

		var rows = '';

		for (var i = 0; i < topicsInUse.length; i++) {
			rows += '<tr>';
			rows += '<th scope="row">' + (i + 1) + '</th>';
			rows += '<td>' + topicsInUse[i].topic + '</td>';
			rows += '<td>' + topicsInUse[i].startDate + '</td>';
			rows += '<td>' + topicsInUse[i].participants + '</td>';
			rows += '<td>' + durations[i] + '</td>';
			rows += '</tr>';
		}

		topicsInUseTableBody.innerHTML = rows;

		/* 테이블 행 이벤트 리스너 */
		var rows = document.getElementsByTagName('tr');
		for (var i = 0; i < rows.length; i++) {
			rows[i].addEventListener('click', function() {
				var cell = this.getElementsByTagName('td')[0];

				if (selectedTopic.topic == cell.innerHTML) {
					return;
				}

				for (var i = 0; i < topicsInUse.length; i++) {
					if (topicsInUse[i].topic == cell.innerHTML) {
						
						selectedTopic = topicsInUse[i]; // 선택된 토픽 저장
						topicMsgSize = [];
						selectedComponentCount = [];
						
						initTopicClientData();
						
						updateCharts();
						break;
					}
				}
			});
		}
	}
	
	function updateTerminatedTopicTable() {
		console.log("update terminated topic table");
		
		var terminatedTopicsTable = document.getElementById('terminatedTopicsTable');
		var terminatedTopicsTableBody = document.getElementById('terminatedTopicsTableBody');

		terminatedTopicsTableBody.innerHTML = "";

		var rows = '';

		for (var i = 0; i < terminatedTopics.length; i++) {
			rows += '<tr>';
			rows += '<th scope="row">' + (i + 1) + '</th>';
			rows += '<td>' + terminatedTopics[i].topic.split("(")[0] + '</td>';
			rows += '<td>' + terminatedTopics[i].startDate + '</td>';
			rows += '<td>' + calcUseTime(terminatedTopics[i].startDate, terminatedTopics[i].topic.substring(terminatedTopics[i].topic.indexOf("(")).replace("(","").replace(")","")) + '</td>';
			console.log(terminatedTopics[i].topic.substring(terminatedTopics[i].topic.indexOf("(")));
			rows += '<td>' + bytesToSize(terminatedTopics[i].accumulatedMsgSize) + '</td>';
			rows += '<td>' + terminatedTopics[i].msgPublishCount + '</td>';
			rows += '<td>' + terminatedTopics[i].participants + '</td>';
			rows += '</tr>';
		}

		terminatedTopicsTableBody.innerHTML = rows;
	}

	
	
	function updatePlatformLabels() {
		console.log("update platform amount");

		document.getElementById('androidLabel').innerHTML = Android;
		document.getElementById('iOSLabel').innerHTML = iOS;
	}
	
	function updateAverageLabels() {
		console.log("update average label");
		
		document.getElementById('msgSizeAvgLabel').innerHTML = bytesToSize(msgAvgMap.msgSizeAvg);
		document.getElementById('msgPublishCountAvgLabel').innerHTML = msgAvgMap.msgPublishCountAvg;
		document.getElementById('participantAvgLabel').innerHTML = msgAvgMap.participantAvg;
	}
	
 	function updateTotalLabels() {
 		console.log("update total label");
 		
 		document.getElementById('msgSizeTotalLabel').innerHTML = bytesToSize(msgTotalMap.msgSizeTotal);
 		document.getElementById('msgPublishCountTotalLabel').innerHTML = msgTotalMap.msgPublishCountTotal;
 		document.getElementById('participantTotalLabel').innerHTML = msgTotalMap.participantTotal;
 	}
 	
 	function updateComponentLabels() {
 		console.log("update component label");
 		
 		document.getElementById('strokeTotal').innerHTML = componentTotalMap.strokeTotal;
 		document.getElementById('rectTotal').innerHTML = componentTotalMap.rectTotal;
 		document.getElementById('ovalTotal').innerHTML = componentTotalMap.ovalTotal;
 		document.getElementById('textTotal').innerHTML = componentTotalMap.textTotal;
 		document.getElementById('imageTotal').innerHTML = componentTotalMap.imageTotal;
 		document.getElementById('eraseTotal').innerHTML = componentTotalMap.eraseTotal;

 	}

	function shiftArrays() {

		console.log("-------------------- length --------------------");
		console.log("msgSize = " + msgSize.length + ", topicMsgSize = "
				+ topicMsgSize.length + ", labels = " + labels.length);

		if (msgSize.length > labels.length) {
			console.log("advance func shift (total data)");

			msgSize.shift();
			connections.shift();
			senders.shift();
			msgPublishCount.shift();
		}

		if (topicMsgSize.length == labels.length) {
			console.log("advance func shift (topicMsgSize)");

			topicMsgSize.shift();
		}
	}

	function startTimer() {
		setInterval(printDuration, 1000);
	}
	
	function printDuration() {

		// 현재 사용중인 토픽이 없거나(토픽 배열이 빈 상태), 테이블 업데이트가 이루어지지 않은 경우(행과 열이 생성되지 않은 상태)
		if (document.getElementById('topicsInUseTable').rows.length - 1 != topicsInUse.length) {
			for (var i = 0; i < topicsInUse.length; i++) {
				durations[i] = '0:0:0';
			}
			return;
		}

		durations = [];
		for (var i = 0; i < topicsInUse.length; i++) {

			// var diff = Math.abs(new Date() - new Date(topics[i].startDate.replace(/-/g, '/')));

			var duration = calcDuration(topicsInUse[i].startDate)

			durations.push(duration); // function updateTopicTable() 에서 반영하기 위해
			document.getElementById('topicsInUseTable').rows[i + 1].cells[4].innerHTML = duration;
		}

	}
	
	function calcDuration(startDate) {
		var diff = Math.abs(new Date() - new Date(startDate.replace(/-/g, '/')));
		
		return msToTime(diff);
	}
	
	function calcUseTime(startDate, finishDate) {
		var diff = Math.abs(new Date(finishDate.replace(/-/g, '/')) - new Date(startDate.replace(/-/g, '/')));
		
		return msToTime(diff);
	}

	function msToTime(s) {
		var ms = s % 1000;
		s = (s - ms) / 1000;
		var secs = s % 60;
		s = (s - secs) / 60;
		var mins = s % 60;
		var hrs = (s - mins) / 60;

		return hrs + ':' + mins + ':' + secs;
	}
	
	function bytesToSize(bytes) {
		var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
		if (bytes == 0) return '0 Byte';
		var i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
		return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
	}
	
</script>
