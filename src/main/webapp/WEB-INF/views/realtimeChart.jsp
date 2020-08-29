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

#table-wrapper {
	overflow-y: auto;
	height: 300px;
}

#table-wrapper thead th {
	position: sticky;
	top: 0;
}

/* Just common table stuff. Really. */
table {
	border-collapse: collapse;
	width: 100%;
}

th, td {
	padding: 8px 16px;
}

.rounded-background {
	background: white;
	border-radius: 5px;
}

.total-data-area {
	height: 100px;

}


</style>

<div class="container-wrapper">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<span class="">hello!</span>
				</div>
			</div>
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<span>halo!</span>
				</div>
			</div>
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<span>halo!</span>
				</div>
			</div>
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<span>halo!</span>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="container-wrapper">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
				<div class="col-md-12 rounded-background total-data-area">
					<span>hello!</span>
				</div>
			</div>
			<div class="col-md-6">
				<div class="col-md-12 rounded-background total-data-area">
					<span>halo!</span>
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
					<span>hello!</span>
				</div>
			</div>
			<div class="col-md-3">
				<div class="col-md-12 rounded-background total-data-area">
					<span>halo!</span>
				</div>
			</div>
			<div class="col-md-6">
				<div class="col-md-12 rounded-background total-data-area">
					<span>halo!</span>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 
<div class="container-wrapper">
	<div class="container-fluid">
		<div class="row">
			<div class="col-3">
				<canvas id="msgSizeChart"></canvas>
			</div>
			<div class="col-3">
				<canvas id="msgPublishCountChart"></canvas>
			</div>
			
		</div>

	</div>
</div>




<div class="container-wrapper">
	<div class="container-fluid"></div>
		<div class="row">
			<div class="col-4">
				<canvas id="connectionAndSenderChart"></canvas>
			</div>
			<div class="col-4">
				<canvas id="componentRatioChart"></canvas>
			</div>
			<div class="col-4">
				<canvas id="platformRatioChart"></canvas>
			</div>
			
		</div>
</div>


<div class="container-wrapper">
	<div class="container-fluid">
		<div class="row">

			<div class="col-12" id="table-wrapper">
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
	</div>
</div>
-->

<div></div>

<script>
	var labels = [];
	var data = [];
	var connectionData = [];
	var messageData = [];
	var charts = [];
	var speed = 250;

	/* 모니터링 데이터 (메시지량, 커넥션 수, 메시지 전송 횟수, 토픽, 플랫폼) */
	var msgSize = [];
	var connections = [];
	var msgPublishCount = [];
	var senders = [];
	var topics = [];

	var Android; // number of
	var iOS;

	var platform = [];

	/* 차트 */
	var msgSizeChart;
	var connectionAndSenderChart;
	var msgPublishCountChart;
	var componentRatioChart;
	var platformRatioChart;

	addEmptyValues(labels, 5);

	window.onload = function() {
		console.log("window.onload");

		initializeChartData();
		initializeChart();

		advance();

	};

	// 차트 초기 데이터 세팅
	function initializeChartData() {
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

		Android = parseInt(JSON.parse('${Android}'));
		iOS = parseInt(JSON.parse('${iOS}'));
	}

	// 사용하는 차트 생성과 차트를 배열에 삽입
	function initializeChart() {
		console.log("chart initialize");

		msgSizeChart = new Chart(document.getElementById("msgSizeChart"), {
			type : 'line',
			data : {
				labels : labels,
				datasets : [ {
					label : 'aaaaaaaaaaaaaaaaaaaaaaa',
					data : msgSize,
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
					text : 'Publish Message Size'
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

		connectionAndSenderChart = new Chart(document
				.getElementById("connectionAndSenderChart"), {
			type : 'line',
			data : {
				labels : labels,
				datasets : [ {
					label : 'Connection',
					data : connections,
					backgroundColor : 'rgb(255,99,132,0.1)',
					borderColor : 'rgb(255,99,132)',
					pointRadius : 5,
					pointHoverRadius : 10,
					showLine : false
				}, {
					label : 'Sender',
					data : senders,
					backgroundColor : 'rgb(0,255,0,0.1)',
					borderColor : 'rgb(0,255,0)',
					pointRadius : 5,
					pointHoverRadius : 10,
					showLine : false
				} ]
			},
			options : {
				responsive : true,
				animation : {
					duration : 3,
					easing : 'linear'
				},
				legend : {
					display : true,
					labels : {
						fontColor : 'rgb(255, 99, 132)'
					}
				},
				scales : {
					yAxes : [ {
						ticks : {
							min : 0,
							max : 20
						}
					} ]
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
					backgroundColor : 'rgb(255,99,132,0.1)',
					borderColor : 'rgb(255,99,132)',
					borderWidth : 2,
					lineTension : 0.25,
					pointRadius : 0
				} ]
			},
			options : {
				responsive : true,
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
		
		componentRatioChart = new Chart(
				document.getElementById("componentRatioChart"), {
					type : 'doughnut',
					data : {
						datasets : [ {
							data : [ Android, iOS ],
							backgroundColor : [ window.chartColors.green,
									window.chartColors.blue ]
						} ],
						labels : [ 'Android', 'iOS' ]
					},
					options : {
						responsive : true,
						animation : {
							duration : 0,
							easing : 'linear'
						}
					}
				});

		platformRatioChart = new Chart(
				document.getElementById("platformRatioChart"), {
					type : 'doughnut',
					data : {
						datasets : [ {
							data : [ Android, iOS ],
							backgroundColor : [ window.chartColors.green,
									window.chartColors.blue ]
						} ],
						labels : [ 'Android', 'iOS' ]
					},
					options : {
						responsive : true,
						animation : {
							duration : 0,
							easing : 'linear'
						}
					}
				});

		charts.push(msgSizeChart);
		charts.push(connectionAndSenderChart);
		charts.push(msgPublishCountChart);
		charts.push(platformRatioChart);

		updateTopicTable();
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

		msgSizeChart.update();
		connectionAndSenderChart.update();
		msgPublishCountChart.update();

		platformRatioChart.data.datasets[0].data = [ Android, iOS ];
		platformRatioChart.update();

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

	}

	function advance() {
		console.log("advance func");

		getData();

		if (msgSize.length > labels.length) {
			console.log("advance func shift");

			msgSize.shift();
			connections.shift();
			senders.shift();
			msgPublishCount.shift();

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

			// 서버로부터 받은 데이터 저장
			msgSize.push(obj.realtime.accumulatedMsgSize);
			connections.push(obj.realtime.numberOfConnections);
			msgPublishCount.push(obj.realtime.msgPublishCount);
			senders.push(obj.realtime.numberOfSenders);

			topics = obj.topics;

			Android = parseInt(obj.platformMap.Android);
			iOS = parseInt(obj.platformMap.iOS);

			platform = [];
			platform.push(Android);
			platform.push(iOS);

			console.log(msgSize);
			console.log(connections);
			console.log(msgPublishCount);

			console.log(topics);

			//console.log(Android);
			//console.log(iOS);

			updateCharts();
			updateTopicTable();

		}
		labels.pop();

		labels.push(moment(new Date()).format('HH:mm:ss'));
	}
</script>
