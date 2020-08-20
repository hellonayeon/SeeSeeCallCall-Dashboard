<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


	<title>Line Chart</title>
	
	<script src="<c:url value="/resources/js/Chart.js/Chart.min.js"/>"></script>
	<script src="<c:url value="/resources/js/Chart.js/samples/utils.js"/>"></script>
	<script src="<c:url value="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.15.1/moment.min.js"/>"></script>
	<script src="<c:url value="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"/>"></script>
	
	<style>
	canvas{
		-moz-user-select: none;
		-webkit-user-select: none;
		-ms-user-select: none;
	}
	</style>

<div class="container-wrapper"> <!-- top margin 80px -->
	<div class="container-fluid">	
		<div class="row">
			<div class="col-4">
				<canvas id="msgSizeChart"></canvas>
			</div>
			<div class="col-4">
				<canvas id="connectionChart"></canvas>
			</div>
			<div class="col-4">
				<canvas id="msgSendingCountChart"></canvas>
			</div>
		</div>
	
	</div>
</div>

<div class="container-wrapper"> <!-- top margin 80px -->
	<div class="container-fluid">	
		<div class="row">
		
			<div class="col-8">
				<table id="topicTable" class="table table-hover">
				  <thead>
				    <tr>
				      <th scope="col">#</th>
				      <th scope="col">Topic</th>
				      <th scope="col">Start Time</th>
				    </tr>
				  </thead>
				  <tbody>
				    <tr>
				      <th scope="row">1</th>
				      <td>Mark</td>
				      <td>Otto</td>
				    </tr>
				    <tr>
				      <th scope="row">2</th>
				      <td>Jacob</td>
				      <td>Thornton</td>
				    </tr>
				    <tr>
				      <th scope="row">3</th>
				      <td colspan="2">Larry the Bird</td>
				    </tr>
				  </tbody>
				</table>
			</div>
			
			<div class="col-4">
				<canvas id="platformRatioChart"></canvas>
			</div>
			
		</div>
	</div>
</div>
	
		
	<div>
		
	</div>
	
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
		var msgSendingCount = [];
		var topics = [];
		
		var Android; // number of
		var iOS;
		
		var platform = [];
		
		/* 차트 */
		var msgSizeChart;
		var connectionChart;
		var msgSendingCountChart;
		var platformChart;

		addEmptyValues(labels, 5);

		function getData() {
			var sse = new EventSource('http://localhost:8080/Dashboard/update');
			sse.onmessage = function(evt) {
				console.log("getData func");
				
				var obj = JSON.parse(evt.data);
				console.log(obj);
				
				// 서버로부터 받은 데이터 저장
				msgSize.push(obj.realtime.accumulated_msg_size);
				connections.push(obj.realtime.number_of_connections);
				msgSendingCount.push(obj.realtime.number_of_msgs);
				
				topics.push(obj.topics);
				
				Android = parseInt(obj.platformMap.Android);
				iOS = parseInt(obj.platformMap.iOS);
				
				platform = [];
				platform.push(Android);
				platform.push(iOS);
				
				console.log(msgSize);
				console.log(connections);
				console.log(msgSendingCount);
				
				console.log(Android);
				console.log(iOS);
				
				updateCharts();
				
			}
			labels.pop();

			labels.push(moment(new Date()).format('YYYY MM DD HH:mm:ss'));
		}

		// chart 배열 초기화
		function initialize() {
			console.log("chart initialize");

			msgSizeChart = new Chart(document.getElementById("msgSizeChart"), {
				type : 'line',
				data : {
					labels : labels,
					datasets : [ {
						data : msgSize,
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
								max : 100000
							}
						} ]
					}
				}
			});
			
			connectionChart = new Chart(document.getElementById("connectionChart"), {
				type : 'line',
				data : {
					labels : labels,
					datasets : [ {
						data : msgSize,
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
								max : 100000
							}
						} ]
					}
				}
			});
			
			msgSendingCountChart = new Chart(document.getElementById("msgSendingCountChart"), {
				type : 'line',
				data : {
					labels : labels,
					datasets : [ {
						data : msgSendingCount,
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
								max : 5000
							}
						} ]
					}
				}
			});
			
			platformChart = new Chart(document.getElementById("platformRatioChart"), {
				type: 'doughnut',
				data: {
					datasets: [{
						data: [ Android, iOS ],
						backgroundColor: [
							window.chartColors.green,
							window.chartColors.blue
						]
					}],
					labels: [
						'Android',
						'iOS'
					]
				},
				options: {
					responsive: true
				}
			});
			
			charts.push(msgSizeChart);
			charts.push(connectionChart);
			charts.push(msgSendingCountChart);
			charts.push(platformChart);
			
			/*
			charts.push(new Chart(document.getElementById("msgSizeChart"), {
				type : 'line',
				data : {
					labels : labels,
					datasets : [ {
						data : msgSize,
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
								max : 100000
							}
						} ]
					}
				}
			}),
			new Chart(document.getElementById("connectionChart"), {
				type : 'line',
				data : {
					labels : labels,
					datasets : [ {
						data : connections,
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
								max : 100
							}
						} ]
					}
				}
			}),
			new Chart(document.getElementById("msgSendingCountChart"), {
				type : 'line',
				data : {
					labels : labels,
					datasets : [ {
						data : msgSendingCount,
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
								max : 5000
							}
						} ]
					}
				}
			}),
			new Chart(document.getElementById("platformRatioChart"), {
				type: 'doughnut',
				data: {
					datasets: [{
						data: [ Android, iOS ],
						backgroundColor: [
							window.chartColors.green,
							window.chartColors.blue
						]
					}],
					labels: [
						'Android',
						'iOS'
					]
				},
				options: {
					responsive: true
				}
			})
			);
			*/
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
			connectionChart.update();
			msgSendingCountChart.update();
			
			platformChart.data.datasets[0].data = [ Android, iOS ];
			platformChart.update();
			
		}
		
		function updateTopicTable() {
			
		}

		function advance() {
			console.log("advance func");

			getData();
			
			//updateCharts();
			//updateTopicTable();
			
			if (msgSize.length > labels.length) {
				console.log("advance func shift");
				
				msgSize.shift();
				connections.shift();
				msgSendingCount.shift();

				updateCharts();
			}

			setTimeout(function() {
				requestAnimationFrame(advance);
			}, 1000);
		}
		
		window.onload = function() {
			console.log("window.onload");
			initialize();
			advance();

		};
	</script>
