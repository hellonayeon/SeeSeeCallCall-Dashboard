<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<title>Line Chart</title>

<script src="<c:url value="/resources/js/Chart.js/Chart.min.js"/>"></script>
<script src="<c:url value="/resources/js/Chart.js/samples/utils.js"/>"></script>
<script
	src="<c:url value="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.15.1/moment.min.js"/>"></script>
<script
	src="<c:url value="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"/>"></script>

<style>
canvas {
	-moz-user-select: none;
	-webkit-user-select: none;
	-ms-user-select: none;
}
#table-wrapper          { overflow-y: auto; height: 200px; }
#table-wrapper thead th { position: sticky; top: 0; }

/* Just common table stuff. Really. */
table  { border-collapse: collapse; width: 100%; }
th, td { padding: 8px 16px; }

.rounded-background {
	background: white;
	border-radius: 5px;
}


.total-amount-area {
	
}

.total-amount-title {
	

}


</style>

<div class="container-wrapper">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<p class="total-amount-title">Message Size</p>
					<p class="" id="msgSizeLabel">0</p>
				</div>
			</div>
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<p class="total-amount-title">Message Publish Count</p>
					<p class="" id="msgPublishCountLabel">0</p>
				</div>
			</div>
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<p class="total-amount-title">Connections</p>
					<p class="" id="connectionsLabel">0</p>
					<p class="total-amount-title">Senders</p>
					<p class="" id="sendersLabel">0</p>
				</div>
			</div>
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<p class="total-amount-title">Android</p>
					<p class="" id="androidLabel">0</p>
					<p class="total-amount-title">iOS</p>
					<p class="" id="iOSLabel">0</p>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="container-wrapper">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
				<div class="col-md-12 rounded-background" id="table-wrapper">
					<table id="topicTable" class="table table-hover">
					<thead>
						<tr>
							<th scope="col">#</th>
							<th scope="col">Topic</th>
							<th scope="col">Participants</th>
							<th scope="col">Start Date</th>
							<th scope="col">Duration</th>
						</tr>
					</thead>
					<tbody id="topicTableBody">
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
				<div class="col-md-12 rounded-background total-data-area">
					<canvas id="componentChart"></canvas>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="container-wrapper">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<canvas id="clientMsgSizeChart"></canvas>
				</div>
			</div>
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<canvas id="clientMsgPublishCountChart"></canvas>
				</div>
			</div>
			<div class="col-md-6">
				<div class="col-md-12 rounded-background total-data-area">
					<canvas id="topicMsgSizeChart"></canvas>
				</div>
			</div>
		</div>
	</div>
</div>


<div></div>

<script>
	var labels = [];
	var data = [];
	var connectionData = [];
	var messageData = [];
	var charts = [];
	var speed = 250;

	var msgSize;
	var connections;
	var msgPublishCount;
	var senders;
	
	var topics = [];
	
	var components = [];
	var stroke;
	var rect;
	var oval;
	var text;
	
	var curTopic;
	var curComponent;
	
	var curClients = [];
	var curClientsName = [];
	var curClientsMsgSize = [];
	var curClientsMsgPublishCount = [];
	
	var topicMsgSize = [];

	var Android; // number of
	var iOS;

	
	/* 차트 */
	var msgSizeChart;
	var connectionAndSenderChart;
	var msgPublishCountChart;
	var platformRatioChart;
	
	var componentChart;
	var topicMsgSizeChart;
	var clientMsgSizeChart;
	var clientMsgPublishCountChart;

	addEmptyValues(labels, 5);

	window.onload = function() {
		console.log("window.onload");

		initializeData();
		initializeChart();

		advance();

	};
	
	function initTopicData() {
		curClients = [];
		
		curClientsName = [];
		curClientsMsgSize = [];
		curClientsMsgPublishCount = [];		
	}

	// 차트 초기 데이터 세팅
	function initializeData() {
		console.log("initialize data func");
		
		msgSize = JSON.parse('${msgSize}');
		console.log(msgSize);

		connections = JSON.parse('${connections}');
		console.log(connections);

		msgPublishCount = JSON.parse('${msgPublishCount}');
		console.log(msgPublishCount);

		senders = JSON.parse('${senders}');
		console.log(senders);

		topics = JSON.parse('${topics}');
		console.log(topics);
		
		components = JSON.parse('${components}');
		console.log(components);
				
		
		if(topics[0] !== null) {
			console.log("topic is not null");
			
			initTopicData();
			
			curTopic = topics[0];
			curClients = curTopic.clients;
			
			topicMsgSize.push(curTopic.accumulatedMsgSize);
			
			for(var i=0; i<curClients.length; i++) {
				curClientsName.push(curClients[i].name);
				curClientsMsgSize.push(curClients[i].accumulatedMsgSize);
				curClientsMsgPublishCount.push(curClients[i].msgPublishCount);
			}
			
			
			console.log(curTopic);
			for(var i=0; i<components.length; i++) {
				console.log(components[i].topic.topic + " " + curTopic.topic);
				if(components[i].topic.topic == curTopic.topic) {
					curComponent = components[i];
					break;
				}
			}
		}
		console.log(curComponent);
		
		stroke = curComponent.stroke;
		rect = curComponent.rect;
		oval = curComponent.oval;
		text = curComponent.text;

		Android = parseInt(JSON.parse('${Android}'));
		iOS = parseInt(JSON.parse('${iOS}'));
	}

	// 사용하는 차트 생성과 차트를 배열에 삽입
	function initializeChart() {
		console.log("chart initialize");

		componentChart = new Chart(document.getElementById("componentChart"), {
			type : 'bar',
			data : {
				labels : ['Stroke', 'Rect', 'Oval', 'Text'],
				datasets : [ {
					data : [stroke, rect, text, oval],
					fillColor : 'rgb(255,0,0,0)',
					strokeColor : 'rgb(255,99,132)',
				} ]
			},
			options : {
				responsive : true,
				title : {
					display : true,
					fontSize : 15,
					text : 'Number of Components'
				},
				animation : {
					duration : 0,
					easing : 'linear'
				},
				legend : false,
				scales : {
					yAxes : [ {
						ticks : {
							min : 0,
							max : 50
						}
					} ]
				}
			}
		});
		
		clientMsgSizeChart = new Chart(document.getElementById("clientMsgSizeChart"), {
			type: 'doughnut',
			data: {
				datasets: [{
					data: curClientsMsgSize,
					backgroundColor: [
						window.chartColors.green,
						window.chartColors.blue
					]
				}],
				labels: curClientsName
			},
			options: {
				responsive: true,
				title : {
					display : true,
					fontSize : 15,
					text : 'Client Msg Size'
				},
				animation : {
					duration : 0,
					easing : 'linear'
				}
			}
		});
		
		clientMsgPublishCountChart = new Chart(document.getElementById("clientMsgPublishCountChart"), {
			type: 'doughnut',
			data: {
				datasets: [{
					data: curClientsMsgPublishCount,
					backgroundColor: [
						window.chartColors.green,
						window.chartColors.blue
					]
				}],
				labels: curClientsName
			},
			options: {
				responsive: true,
				title : {
					display : true,
					fontSize : 15,
					text : 'Client Msg Publish Count'
				},
				animation : {
					duration : 0,
					easing : 'linear'
				}
			}
		});
		
		topicMsgSizeChart = new Chart(document.getElementById("topicMsgSizeChart"), {
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
				title : {
					display : true,
					fontSize : 15,
					text : 'Topic' + "\'" + curTopic.topic + "\'" + ' Publish Message Size'
				},
				animation : {
					duration : 0,
					easing : 'linear'
				},
				legend : false,
				scales : {
					yAxes : [ {
						ticks : {
							min : 0,
							max : 100000
						}
					} ]
				}
			}
		});

	}

	function addEmptyValues(arr, n) {
		for (var i = 60; i >= 0; i -= n) {
			arr.push(i);
			data.push(null);
			messageData.push(null);
			connectionData.push(null);

		}

	}

	function updateCharts() {
		console.log("update charts");

		/* msgSizeChart.update();
		connectionAndSenderChart.update();
		msgPublishCountChart.update();

		platformRatioChart.data.datasets[0].data = [ Android, iOS ];
		platformRatioChart.update(); */
		
		componentChart.data.datasets[0].data = [stroke, rect, oval, text];
		componentChart.update();
		
		clientMsgSizeChart.data.datasets[0].data = curClientsMsgSize;
		clientMsgSizeChart.data.labels = curClientsName;
		clientMsgSizeChart.update();
		
		clientMsgPublishCountChart.data.datasets[0].data = curClientsMsgPublishCount;
		clientMsgPublishCountChart.data.labels = curClientsName;
		clientMsgPublishCountChart.update();
		
		topicMsgSizeChart.data.datasets[0].data = topicMsgSize;
		topicMsgSizeChart.update();

	}

	function updateTopicTable() {
		console.log("update topic topic table");

		var topicTable = document.getElementById('topicTable');
		var topicTableBody = document.getElementById('topicTableBody');
		var row, cell1, cell2, cell3;

		topicTableBody.innerHTML = "";

		var rows = '';

		for (var i = 0; i < topics.length; i++) {
			rows += '<tr>';
			rows += '<th scope="row">' + (i + 1) + '</th>';
			rows += '<td>' + topics[i].topic + '</td>';
			rows += '<td>' + topics[i].participants + '</td>';
			rows += '<td>' + topics[i].startDate + '</td>';
			rows += '<td>' + topics[i].startDate + '</td>';
			rows += '</tr>';
		}

		topicTableBody.innerHTML = rows;
		
		var rows = document.getElementsByTagName('tr');
		for (var i=0; i < rows.length; i++) {
			rows[i].addEventListener('click', function(){
				var cell = this.getElementsByTagName('td')[0];
				
				if(curTopic.topic == cell.innerHTML) {
					return;
				}
				
				for(var i=0; i<topics.length; i++) {
					if(topics[i].topic == cell.innerHTML) {
						curTopic = topics[i];
						topicMsgSize = [];
						break;
					}
				}				
			});
		}

	}
	
	function updateTotalAmountLabel() {
		console.log("update total amount");
		
		var msgSizeLabel = document.getElementById('msgSizeLabel');
		msgSizeLabel.innerHTML = msgSize;
		
		var msgPublishCountLabel = document.getElementById('msgPublishCountLabel');
		msgPublishCountLabel.innerHTML = msgPublishCount;
		
		var connectionsLabel = document.getElementById('connectionsLabel');
		connectionsLabel.innerHTML = connections;
		
		var sendersLabel = document.getElementById('sendersLabel');
		sendersLabel.innerHTML = senders;
		
		var androidLabel = document.getElementById('androidLabel');
		androidLabel.innerHTML = Android;
		
		var iOSLabel = document.getElementById('iOSLabel');
		iOSLabel.innerHTML = iOS;
		
	}

	function advance() {
		console.log("advance func");

		getData();

		if (topicMsgSize.length > labels.length) {
			console.log("advance func shift");

			topicMsgSize.shift();

			updateCharts();
		}
 		
		setTimeout(function() {
			requestAnimationFrame(advance);
		}, 1000);
	}

	function getData() {
		var sse = new EventSource('http://localhost:8080/Dashboard/update');
		sse.onmessage = function(evt) {
			console.log("getData func");

			var obj = JSON.parse(evt.data);
			console.log(obj);

			/* // 서버로부터 받은 데이터 저장
			msgSize.push(obj.realtime.accumulatedMsgSize);
			connections.push(obj.realtime.numberOfConnections);
			msgPublishCount.push(obj.realtime.msgPublishCount);
			senders.push(obj.realtime.numberOfSenders); */

			msgSize = obj.realtime.accumulatedMsgSize;
			connections = obj.realtime.numberOfConnections;
			msgPublishCount = obj.realtime.msgPublishCount;
			senders = obj.realtime.numberOfSenders;

			topics = obj.topics;
			components = obj.components;

			Android = parseInt(obj.platformMap.Android);
			iOS = parseInt(obj.platformMap.iOS);
			
			
/* 			if(topics[0] !== null) {
				console.log("topic is not null");
				
				initTopicData();
				
				curTopic = topics[0];
				curClients = topics[0].clients;
				
				for(var i=0; i<curClients.length; i++) {
					curClientsName.push(curClients[i].name);
					curClientsMsgSize.push(curClients[i].accumulatedMsgSize);
					curClientsMsgPublishCount.push(curClients[i].msgPublishCount);
				}
				
				console.log(curTopic);
				for(var i=0; i<components.length; i++) {
					console.log(components[i].topic.topic + " " + curTopic.topic);
					if(components[i].topic.topic == curTopic.topic) {
						curComponent = components[i];
						break;
					}
				}
			} */
			
			for (var i=0; i<topics.length; i++) {
				if(topics[i].topic == curTopic.topic) {
					
					initTopicData();
					
					curTopic = topics[i];
					curClients = curTopic.clients;
					
					topicMsgSize.push(curTopic.accumulatedMsgSize);
					console.log(topicMsgSize);
					
					for(var i=0; i<curClients.length; i++) {
						curClientsName.push(curClients[i].name);
						curClientsMsgSize.push(curClients[i].accumulatedMsgSize);
						curClientsMsgPublishCount.push(curClients[i].msgPublishCount);
					}
					
					console.log(curTopic);
					for(var i=0; i<components.length; i++) {
						console.log(components[i].topic.topic + " " + curTopic.topic);
						if(components[i].topic.topic == curTopic.topic) {
							curComponent = components[i];
							break;
						}
					}
					
					break;
				}
			}
						
			stroke = curComponent.stroke;
			rect = curComponent.rect;
			oval = curComponent.oval;
			text = curComponent.text;

			updateCharts();
			updateTopicTable();
			updateTotalAmountLabel();

		}
		labels.pop();

		labels.push(moment(new Date()).format('HH:mm:ss'));
	}
</script>
