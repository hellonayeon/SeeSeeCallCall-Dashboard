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
		
		<div class="row">
			<div class="col">
				<canvas id="canvas"></canvas>
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
		
		/* 모니터링 데이터 (메시지량, 커넥션 수, 메시지 전송 횟수) */
		var msgSize = [];
		var connections = [];
		var msgSendingCount = [];

		addEmptyValues(labels, 5);

		function getData() {
			var sse = new EventSource('http://localhost:8080/Dashboard/update');
			sse.onmessage = function(evt) {
				var obj = JSON.parse(evt.data);
				console.log(obj);
				
				data.push(obj.data);
				msgSize.push(obj.accumulated_msg_size);
				
				console.log(msgSize);
				
				console.log(obj.accumulated_msg_size);
				
			}
			labels.pop();

			labels.push(moment(new Date()).format('YYYY MM DD HH:mm:ss'));
		}

		function initialize() {
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
			new Chart(document.getElementById("msgSendingCountChart"), {
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
			new Chart(document.getElementById("canvas"), {
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
			})
			);
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
			charts.forEach(function(chart) {
				chart.update();
			});
		}

		function advance() {
			if (data[0] !== null) {
				updateCharts();

			}

			getData();
			updateCharts();
			if (msgSize.length > labels.length) {
				data.shift();
				connectionData.shift();
				messageData.shift();
				msgSize.shift();
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
