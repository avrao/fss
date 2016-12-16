<!doctype html>
<cfset opsvisdata = 'iv_spduser'>
<cfajaxproxy cfc="vis104" jsclassname="TDF">
<cfajaximport>

<cfsetting showdebugoutput="no">

<html>
<head>
<meta charset="utf-8">
<title>Performance By Day of Week</title>
<link rel="stylesheet" type="text/css" href="styles/CommonStyleSheet.css">
<link rel="stylesheet" type="text/css" href="styles/d3styles.css">
<script language="javascript" src="jscripts/Lance.js"></script>
<script src='jscripts/d3.min.js'></script>
<script src='jscripts/crossfilter.min.js'></script>
<script src='jscripts/dc.min.js'></script>
<style>
body {
	background-color:#f3f3f3;
}

.slct {
    font-size:16px;
  line-height: 1.3333333;
    padding: 10px 16px;
    margin: 0px 3px;
    -webkit-border-radius:6px;
    -moz-border-radius:6px;
    border-radius:6px;
    -webkit-box-shadow: 0 3px 5px #cFcFcF;
    -moz-box-shadow: 0 3px 5px #cFcFcF;
    box-shadow: 0 3px 5px #cFcFcF;
   background-image: linear-gradient(to bottom, #ffffff, #C0C0C0);
   background-image: -ms-linear-gradient(top, #ffffff 0%, #C0C0C0 100%);   
    /*border:solid  gray 1px;*/
	
	/*background-color: buttonface;*/
    box-sizing: border-box;

    border: 2px outset buttonface;
}

.slctSmall {
    font-size:12px;
  line-height: 1.3333333;
    padding: 5px 8px;
    margin: 0px 3px;
    -webkit-border-radius:6px;
    -moz-border-radius:6px;
    border-radius:6px;
    -webkit-box-shadow: 0 3px 5px #cFcFcF;
    -moz-box-shadow: 0 3px 5px #cFcFcF;
    box-shadow: 0 3px 5px #cFcFcF;
   background-image: linear-gradient(to bottom, #ffffff, #C0C0C0);
   background-image: -ms-linear-gradient(top, #ffffff 0%, #C0C0C0 100%);   
    /*border:solid  gray 1px;*/
	
	/*background-color: buttonface;*/
    box-sizing: border-box;

    border: 2px outset buttonface;
}

.fset
{
	display:inline-block;
	border:none;
	padding:0px;
	margin:0px;	
	font-size:20px;	
	
}

.smallFnt {
	font-size:12px;
	line-height: 1.3333333;
	padding: 5px 8px;
	margin: 0px 3px;
	border: solid 1px gray;
}

.hyperFont {
	font-size:12px;
	color:blue;
	text-decoration: underline;
	text-variant: small-caps;
	font-family: times, Times New Roman;
	cursor: pointer;
	background: transparent;
	-webkit-border-radius:6px;
	-moz-border-radius:6px;
	border-radius:6px;
}

#wrapper 
{
    padding-left: 0px;
    position: absolute;	
    transition: all .8s ease 0s;
    height: 90%
}

#sidebar-wrapper 
{
    margin-left: -150px;
    left: 0px;
    width: 150px;
    background: #21435F;
    position: absolute;
    height: 100%;
    z-index: 10000;
    transition: all .4s ease 0s;
}

.sidebar-nav {
    display: block;
    float: left;
    width: 150px;
    list-style: none;
    margin: 0;
    padding: 0;
}

#page-content-wrapper 
{
    padding-left: 20px;
    margin-left: 0;
    width: 100%;
    height: auto;
}

#wrapper.active 
{
    padding-left: 150px;
}

#wrapper.active #sidebar-wrapper 
{
    left: 150px;
}

#page-content-wrapper 
{
  width: 100%;
}

#sidebar_menu li a, .sidebar-nav li a 
{
    color: #999;
    display: block;
    float: left;
    text-decoration: none;
    width: 150px;
    background: #21435F;
    border-top: 1px solid #373737;
    border-bottom: 1px solid #1A1A1A;
    -webkit-transition: background .5s;
    -moz-transition: background .5s;
    -o-transition: background .5s;
   -ms-transition: background .5s;
    transition: background .5s;
}

.sidebar_name {
    padding-top: 25px;
    color: #fff;
    opacity: .7;
}

.sidebar-nav li {
  line-height: 40px;
  text-indent: 20px;
}

.sidebar-nav li a {
  color: #999999;
  display: block;
  text-decoration: none;
}

.sidebar-nav li a:hover {
  color: #fff;
  background: rgba(255,255,255,0.2);
  text-decoration: none;
}

.sidebar-nav li a:active,.sidebar-nav li a:focus {
  text-decoration: none;
}

.sidebar-nav > .sidebar-brand {
  height: 65px;
  line-height: 60px;
  font-size: 18px;
}

.sidebar-nav > .sidebar-brand a {
  color: #999999;
}

.sidebar-nav > .sidebar-brand a:hover {
  color: #fff;
  background: none;
}

#main_icon
{
    float:right;
   padding-right: 65px;
   padding-top:20px;
}

.sub_icon
{
    float:right;
   padding-right: 65px;
   padding-top:10px;
}

.content-header {
  height: 65px;
  line-height: 65px;
}

.content-header h1 {
  margin: 0;
  margin-left: 20px;
  line-height: 65px;
  display: inline-block;
}

@media (max-width:767px) {
    #wrapper 
	{
		padding-left: 0px;
		transition: all .4s ease 0s;
	}

	#sidebar-wrapper 
	{
		left: 0px;
	}

	#wrapper.active 
	{
		padding-left: 150px;
	}

	#wrapper.active #sidebar-wrapper 
	{
		left: 150px;
		width: 150px;
		transition: all .4s ease 0s;
	}
}

</style>

<script>

	var initLoader = loader({width: 480, height: 150, container: "#mainDiv", id: "initLoader",msg:"Loading . . . "});
	var myLoader = loader({width: 480, height: 150, container: "#loaderDiv", id: "loader",msg:"Retrieving . . . "});
	
	var AreaLoader = loader2({width: 175, height: 175, container: "#chart-Area", id: "AreaLoader",msg:""});
	var DistrictLoader = loader2({width: 175, height: 175, container: "#chart-District", id: "DistrictLoader",msg:""});
	var FacilityLoader = loader2({width: 175, height: 175, container: "#chart-Facility", id: "FacilityLoader",msg:""});
	var EntryLoader = loader2({width: 175, height: 175, container: "#chart-EOD", id: "EODLoader",msg:""});
	var DOWLoader = loader2({width: 175, height: 175, container: "#chart-DOW", id: "DOWLoader",msg:""});
	var ClassLoader = loader2({width: 175, height: 175, container: "#chart-Class", id: "ClassLoader",msg:""});
	var ShapeLoader = loader2({width: 175, height: 175, container: "#chart-Shape", id: "ShapeLoader",msg:""});

	var filterHds = ['Entry: ','Area: ','District: ','Range: ','Date: ','Level: ','Rollup: ','Class: ','Std.: ','Shape: '];
	var filterArgs = ['Destination','National','','Week','04/23/2016','Originating From View','Area','Standard','DSCF 3-4','Letters'];
	
	function loader(config) {
	  return function() {
		d3.select('#'+config.id).remove();
		var radius = Math.min(config.width, config.height) / 2;
		var tau = 2 * Math.PI;

		var arc = d3.svg.arc()
				.innerRadius(radius*0.79)
				.outerRadius(radius*0.9)
				.startAngle(0);
		var arc2 = d3.svg.arc()
				.innerRadius(radius*0.59)
				.outerRadius(radius*0.8)
				.startAngle(0);
		var arc3 = d3.svg.arc()
				.innerRadius(radius*0.39)
				.outerRadius(radius*0.6)
				.startAngle(0);

		var svg = d3.select(config.container).append("svg")
			.attr("id", config.id)
			.attr("width", config.width)
			.attr("height", config.height)
			.style('position','absolute')
			.style('z-index',3)
			.style('left','50%')
			.style('transform','translate(-50%, 0)')
		  .append("g")
			.attr("transform", "translate(" + config.width / 2 + "," + config.height / 2 + ")")

		var background = svg.append("path")
				.datum({endAngle: 0.80*tau})
				.style("fill", "#21435F")
				.attr("d", arc)
				.attr("opacity", 0.75+0.25*(1-Math.random()))
				.call(spin, 1600)
				
		var background2 = svg.append("path")
				.datum({endAngle: 0.80*tau})
				.style("fill", "#21435F")
				.attr("d", arc2)
				.attr("opacity", 0.75+0.25*(1-Math.random()))
				.call(spinRev, 1500)
		
		var background3 = svg.append("path")
				.datum({endAngle: 0.80*tau})
				.style("fill", "#21435F")
				.attr("d", arc3)
				.attr("opacity", 0.75+0.25*(1-Math.random()))
				.call(spin, 1400)
				
		svg.append('rect').attr('x',-5).attr('y',-18).attr('width',200).attr('height',30).attr('fill','#000').attr('opacity',0.5);
		svg.append('text').text(config.msg).attr('fill','#FFF').style('font-size','18px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold').attr('textLength',180);
				
		function spin(selection, duration) {
			selection.transition()
				.ease("linear")
				.duration(duration)
				.attrTween("transform", function() {
					return d3.interpolateString("rotate(0)", "rotate(360)");
				});

			setTimeout(function() { spin(selection, Math.min(Math.max(duration*(Math.random()+0.51),500),2500)); }, duration);
		}
		
		function spinRev(selection, duration) {
			selection.transition()
				.ease("linear")
				.duration(duration)
				.attrTween("transform", function() {
					return d3.interpolateString("rotate(360)", "rotate(0)");
				});

			setTimeout(function() { spinRev(selection, duration); }, duration);
		}

		function transitionFunction(path) {
			path.transition()
				.duration(7500)
				.attrTween("stroke-dasharray", tweenDash)
				.each("end", function() { d3.select(this).call(transition); });
		}

	  };
	}
	
	function loader2(config) {
	  return function() {
		d3.select('#'+config.id).remove();
		var radius = Math.min(config.width, config.height) / 2;
		var tau = 2 * Math.PI;

		var arc = d3.svg.arc()
				.innerRadius(radius*0.79)
				.outerRadius(radius*0.9)
				.startAngle(0);
		var arc2 = d3.svg.arc()
				.innerRadius(radius*0.59)
				.outerRadius(radius*0.8)
				.startAngle(0);
		var arc3 = d3.svg.arc()
				.innerRadius(radius*0.39)
				.outerRadius(radius*0.6)
				.startAngle(0);

		var svg = d3.select(config.container).append("svg")
			.attr("id", config.id)
			.attr("width", config.width)
			.attr("height", config.height)
			.style('position','relative')
			.style('z-index',3)
			.style('left','175px')
			.style('top','-300px')
			//.style('transform','translate(-50%, 0)')
		  .append("g")
			.attr("transform", "translate(" + config.width / 2 + "," + config.height / 2 + ")")

		var background = svg.append("path")
				.datum({endAngle: 0.80*tau})
				.style("fill", "#21435F")
				.attr("d", arc)
				.attr("opacity", 0.75+0.25*(1-Math.random()))
				.call(spin, 1600)
				
		var background2 = svg.append("path")
				.datum({endAngle: 0.80*tau})
				.style("fill", "#21435F")
				.attr("d", arc2)
				.attr("opacity", 0.75+0.25*(1-Math.random()))
				.call(spinRev, 1500)
		
		var background3 = svg.append("path")
				.datum({endAngle: 0.80*tau})
				.style("fill", "#21435F")
				.attr("d", arc3)
				.attr("opacity", 0.75+0.25*(1-Math.random()))
				.call(spin, 1400)
				
		svg.append('rect').attr('x',-5).attr('y',-18).attr('width',200).attr('height',30).attr('fill','#000').attr('opacity',0.5);
		svg.append('text').text(config.msg).attr('fill','#FFF').style('font-size','18px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold').attr('textLength',180);
				
		function spin(selection, duration) {
			selection.transition()
				.ease("linear")
				.duration(duration)
				.attrTween("transform", function() {
					return d3.interpolateString("rotate(0)", "rotate(360)");
				});

			setTimeout(function() { spin(selection, Math.min(Math.max(duration*(Math.random()+0.51),500),2500)); }, duration);
		}
		
		function spinRev(selection, duration) {
			selection.transition()
				.ease("linear")
				.duration(duration)
				.attrTween("transform", function() {
					return d3.interpolateString("rotate(360)", "rotate(0)");
				});

			setTimeout(function() { spinRev(selection, duration); }, duration);
		}

		function transitionFunction(path) {
			path.transition()
				.duration(7500)
				.attrTween("stroke-dasharray", tweenDash)
				.each("end", function() { d3.select(this).call(transition); });
		}

	  };
	}

	function area_data_err(res)
	{
		d3.select('#loader').remove();
		alert(res);
	}

	var yAxis2,yAxisTot,yAxisCall;
	function BarChart(res)
	{	
		d3.select('#loader').remove();
		d3.select('#mainSvg').remove();
		
		var dataGroup = d3.nest()
		.key(function(d){ return (d.FAC_NAME)?d.FAC_NAME:(d.DISTRICT_NAME)?d.DISTRICT_NAME:d.AREA_NAME;})
		.rollup(function(d) { return [(d3.sum(d,function(d2){return d2.TP_SAT;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_SAT;})/d3.sum(d,function(d2){return d2.TP_SAT;}),
		(d3.sum(d,function(d2){return d2.TP_SUN;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_SUN;})/d3.sum(d,function(d2){return d2.TP_SUN;}),
		(d3.sum(d,function(d2){return d2.TP_MON;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_MON;})/d3.sum(d,function(d2){return d2.TP_MON;}),
		(d3.sum(d,function(d2){return d2.TP_TUE;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_TUE;})/d3.sum(d,function(d2){return d2.TP_TUE;}),
		(d3.sum(d,function(d2){return d2.TP_WED;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_WED;})/d3.sum(d,function(d2){return d2.TP_WED;}),
		(d3.sum(d,function(d2){return d2.TP_THU;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_THU;})/d3.sum(d,function(d2){return d2.TP_THU;}),
		(d3.sum(d,function(d2){return d2.TP_FRI;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_FRI;})/d3.sum(d,function(d2){return d2.TP_FRI;})]; })
		.entries(res);
		
		var dataGroup2 = d3.nest()
		.key(function(d){ return (d.FAC_NAME)?d.FAC_NAME:(d.DISTRICT_NAME)?d.DISTRICT_NAME:d.AREA_NAME;})
		.rollup(function(d) { return [
		[d3.sum(d,function(d2){return d2.TP_SAT;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_SUN;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_MON;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_TUE;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_WED;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_THU;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_FRI;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})]]; })
		.entries(res);
		
		var dataGroup3 = d3.nest()
		.key(function(d){ return (d.FAC_NAME)?d.FAC_NAME:(d.DISTRICT_NAME)?d.DISTRICT_NAME:d.AREA_NAME;})
		.rollup(function(d) { return [
		[d3.sum(d,function(d2){return d2.FP_SAT;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_SUN;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_MON;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_TUE;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_WED;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_THU;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_FRI;}),d3.min(d,function(d2){ return (d2.FAC_NAME)?d2.FAC_NAME:(d2.DISTRICT_NAME)?d2.DISTRICT_NAME:d2.AREA_NAME;})]]; })
		.entries(res);
		
		var w = 600;
		var h = 300;
		var padding = 60;

		var high = d3.max(dataGroup2,function(d){if(d.key =='Overall Totals' || d.key=='')return 0; return  d3.max(d.values,function(d2){return d2[0];});});
		var low = d3.min(dataGroup3,function(d){if(d.key =='Overall Totals' || d.key=='')return high;return  d3.min(d.values,function(d2){return d2[0];});});
		
		var high2 = d3.max(dataGroup2,function(d){if(d.key =='Overall Totals' || d.key=='')return  d3.max(d.values,function(d2){return d2[0];}); return 0;});
		var low2 = d3.min(dataGroup3,function(d){if(d.key =='Overall Totals' || d.key=='')return d3.min(d.values,function(d2){return d2[0];});return high2;});
		
		//Create scale functions
		xScale = d3.scale.ordinal().rangeBands([padding, w-padding]);

		yScale = d3.scale.linear()
			 .domain([0,1])
			 .range([h - padding, padding]);
			 
		yScale2 = d3.scale.linear()
			 .domain([low,high])
			 .range([h - padding, padding]);
			 
		yScaleTot = d3.scale.linear()
			 .domain([low2,high2])
			 .range([h - padding, padding]);
							 
		var	cScale = d3.scale.linear().domain([0,1]).range(["#0C0","#0C0"]);	
		var	cScale2 = d3.scale.linear().domain([low,high]).range(["#00C","#00C"]);	
		var	cScale3 = d3.scale.linear().domain([low,high]).range(["#C00","#C00"]);	


		var perF = d3.format('.1%');
		var sigF = d3.format('.3g');
		var comF = d3.format(',');
		var siF = d3.format('.3s');
		  
		var order = ['Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday','Friday'];
		xScale.domain(order);
		  
		var formatAsPercentage = d3.format("%");

		//Define X axis
		var xAxis = d3.svg.axis()
						  .scale(xScale)
						  .orient("bottom")
						  //.ticks(5)
						  //.tickValues(function(d) {return d[0]; })
						  //.tickFormat( d3.format("d"));
						  //.tickFormat(formatAsPercentage);

		//Define Y axis
		var yAxis = d3.svg.axis()
						  .scale(yScale)
						  .orient("left")
						  //.innerTickSize(-(w-padding*2))
						  .ticks(10)
						  .tickFormat(formatAsPercentage);
						  
		yAxis2 = d3.svg.axis()
						  .scale(yScale2)
						  .orient("right")
						  //.innerTickSize(-(w-padding*2))
						  .ticks(10)
						  .tickFormat(siF);
						  
		yAxisTot = d3.svg.axis()
						  .scale(yScaleTot)
						  .orient("right")
						  //.innerTickSize(-(w-padding*2))
						  .ticks(10)
						  .tickFormat(siF);

		
		//Create SVG element
		svg=d3.select('#mainDiv')
			.append("svg")
			.attr("width", w)
			.attr("height", h)
			.style("margin", '0px 0px 0px 30px')
			.attr("id", 'mainSvg');	
		
		svg.append("defs").append("svg:clipPath")
			.attr("id","clip")
			.append("svg:rect")
			.attr("id","clip-rect")
			.attr("fill", "black")
			.attr("x", padding)
			.attr("y", padding)
			.attr("width", w - padding * 2)
			.attr("height", h - padding * 2);
	
		svg.append("rect")
			.attr("width", w)
			.attr("height", h)
			.attr("x", 0)
			.attr("y", 0)
			.attr("rx", 20)
			.attr("ry", 20)
			.attr("fill", "white")

			//Create X axis
			svg.append("g")
				.attr("class", "x axis")
				.attr("transform", "translate(0," + (h - padding) + ")")
				.call(xAxis);

			//Create Y axis
			svg.append("g")
				.attr("class", "y axis")
				.attr("transform", "translate(" + padding + ",0)")
				.call(yAxis);
			
			
			yAxisCall=svg.append("g")
				.attr("class", "y axis")
				.attr("transform", "translate(" + (w-padding) + ",0)");
				
			yAxisCall.call(yAxis2);
				
		container=svg.append("g")
			.attr("clip-path",  "url(#clip)")
			.attr("id",  "mainContainer");
		
		
		svg.append("text")
			.attr("class", "x label")
			.attr("text-anchor", "middle")
			.attr("x", w/2)
			.attr("y", h - 12)
			.text('Week');
			
		svg.append("text")
			.attr("class", "gTitle")
			.attr("text-anchor", "middle")
			.attr("x", w/2)
			.attr("y", padding-16)
			.text("Performance ")
			.append("tspan")
			.attr("id","gphName");
			
		svg.append("text")
		.attr("class", "y label")
		.attr("text-anchor", "middle")
		.attr("x", -h/2)
		.attr("y", padding/3.5)
		.attr("transform", "rotate(-90)")
		.text("% On Time")
		.attr('fill','#000');
		
		svg.append("text")
		.attr("class", "y label")
		.attr("text-anchor", "middle")
		.attr("x", -h/2)
		.attr("y", w-(padding/6))
		.attr("transform", "rotate(-90)")
		.text("Pieces")
		.attr('id','hTxt')
		.attr('fill','#000');
		
		var rdiv = (w-(padding*2))/(7)/2;
		var rw = 210/7;
		
		container.selectAll(".contP")
			   .data(dataGroup2)
			   .enter()
			   .append("g")
			   .attr("class", function(d) {return d.key.replace(/[\/& ]/g,"_");})
			   .attr("opacity", function(d,i) {return (i==0)?1:0;})
			   .style("display", function(d,i) {return (i==0)?'':'none';})
			   .selectAll(".failP")
			   .data(function(d){ return d.values})
			   .enter()
			   .append("rect")
				.attr("class", "failP")
			   .attr("x", function(d,i) {	return xScale(order[i])+rdiv-rw/2;})
			   .attr("y", function(d) {if(d[1]=='Overall Totals')return yScaleTot(d[0]);return yScale2(d[0]);})
			   .attr("width", rw)
			   .attr("height", function(d) {if(d[1]=='Overall Totals')return Math.abs(yScaleTot(d[0])-yScaleTot(low2));return Math.abs(yScale2(d[0])-yScale2(low));})
			   .attr("fill", function(d) {return cScale2(d[0]);})
			   .append('title')
			   .text(function(d) {return 'Total Pieces: '+comF(d[0]);})
		
		
		container.selectAll(".contP2")
			   .data(dataGroup3)
			   .enter()
			   .append("g")
			   .attr("class", function(d) {return d.key.replace(/[\/& ]/g,"_");})
			   .attr("opacity", function(d,i) {return (i==0)?1:0;})
			   .style("display", function(d,i) {return (i==0)?'':'none';})
			   .selectAll(".failP")
			   .data(function(d){ return d.values})
			   .enter()
			   .append("rect")
				.attr("class", "failP")
			   .attr("x", function(d,i) {	return xScale(order[i])+rdiv-rw/2;})
			   .attr("y", function(d) {if(d[1]=='Overall Totals')return yScaleTot(d[0]);return yScale2(d[0]);})
			   .attr("width", rw)
			   .attr("height", function(d) {if(d[1]=='Overall Totals')return Math.abs(yScaleTot(d[0])-yScaleTot(low2));return Math.abs(yScale2(d[0])-yScale2(low));})
			   .attr("fill", function(d) {return cScale3(d[0]);})
			   .append('title')
			   .text(function(d) {return 'Failed Pieces: '+comF(d[0]);})
		
		var line = d3.svg.line()
		.interpolate("cardinal")
		.x(function(d,i) { return xScale(order[i])+rdiv; })
		.y(function(d) { return yScale(d); });
		
		container.selectAll(".area")
			.data(dataGroup)
			.enter().append("g")
			.attr("class", function(d) {return d.key.replace(/[\/& ]/g,"_");})
			.attr("opacity", function(d,i) {return (i==0)?1:0;})
			.append("path")
			.attr("class", "lineV")
			.attr("d", function(d) { return line(d.values);})
			.attr('stroke', '#0B0')
			.attr('stroke-width', 2)
			.attr('fill', 'none');

		container.selectAll(".pCont")
			   .data(dataGroup)
			   .enter()
			   .append("g")
			   .attr("class", function(d) {return d.key.replace(/[\/& ]/g,"_");})
			   .attr("opacity", function(d,i) {return (i==0)?1:0;})
			   .selectAll(".pFail")
			   .data(function(d){ return d.values})
			   .enter()
			   .append("circle")
				.attr("class", "pFail")
			   .attr("cx", function(d,i) {	return xScale(order[i])+rdiv;})
			   .attr("cy", function(d) {return yScale(d)})
			   .attr("r", 3)
			   .attr("fill", function(d) {return cScale(d);})
			   .append('title')
			   .text(function(d) {return 'On Time: '+perF(d);})

		var legend=svg.append("g")
				.attr("class", "Legend")
				.attr("transform", "translate(" + (w - padding) + ","+padding+")");

		legend.append('text')
			   .attr("x", 5)
			   .attr("y", 5)
			   .text("")
			   .style("font-size", 8)

	}
	
	function updateGraphs(val,id)
	{
		//if(val =='Others')
		//	return;
		val = "'"+val+"'";
		var chk = false;
		var n=d3.select('#'+id).node();
		if(n.value=='')
		{
			n.value=val;
			d3.select('#RAll').style('color','blue');
			cfrm_sub();
			return;
		}
		var arg = n.value.split(',');
		var hold=[];
		arg.forEach(function(d,i){
			if(d == val)
				chk=true;
			else
				hold.push(d);
		})
		if(!chk)
			hold.push(val);
		n.value = hold.toString();
		if(n.value=='')	
			d3.select('#RAll').style('color','white');
		else
			d3.select('#RAll').style('color','blue');
		
		cfrm_sub();
	}
	
	var loadCnt=8;
	
	function streamLineChart(res,paramId,contId,chartId,cTitle,loaderId,range)
	{	
		if(!range || res.length <= 11)
			range=0;
		else if(res.length - range < 11)
		{
			range = res.length-11;
		}
		else if(res.length - range >= res.length)
		{
			range = 0;
		}
		var selParam = d3.select('#'+paramId).node().value;
		loadCnt--;
		if(loadCnt <=0)
			d3.select('#'+loaderId).remove();
		//d3.select('#'+chartId).remove();
		
		
		var w = 350;
		var h = 350;
		var padding = 50;
		
		var high = d3.max(res,function(d){return d[2];});
		var low = 0;//d3.min(res,function(d){return d[2];});
		var diff=high-low;
		
		var mult=res.length/11;
		//Create scale functions
		yScale = d3.scale.ordinal().rangeBands([h - padding, padding]);

		xScale = d3.scale.linear()
			 .domain([0,1])
			 .range([padding, w - padding]);
			 
		xScale2 = d3.scale.linear()
			 .domain([low,high])
			 .range([padding, w - padding]);
							 
		var	cScale = d3.scale.linear().domain([0,0.7,1]).range(["#700","#C00","#0C0"]);	
		var	cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range(["#d73027","#d73027","#fc8d59","#fc8d59","#fee090","#fee090","#91bfdb","#91bfdb","#4575b4","#4575b4"]);	

		var perF = d3.format('.1%');
		var sigF = d3.format('.3g');
		var comF = d3.format(',');
		var siF = d3.format('.3s');
		  
		var order = [];
		var holdData = res.slice(0);
		res = res.slice(Math.max(res.length-11-range,0),res.length-range);
		res.forEach(function(d,i){order.push(d[1])});
		yScale.domain(order);
		
		var formatAsPercentage = d3.format("%");

		//Define X axis
		var yAxis = d3.svg.axis()
						  .scale(yScale)
						  .orient("right")
						  //.ticks(5)
						  //.tickValues(function(d) {return d[0]; })
						  //.tickFormat( d3.format("d"));
						  //.tickFormat(formatAsPercentage);

		//Define Y axis
		var xAxis = d3.svg.axis()
						  .scale(xScale)
						  .orient("top")
						  //.innerTickSize(-(w-padding*2))
						  .ticks(5)
						  .tickFormat(formatAsPercentage);
						  
		xAxis2 = d3.svg.axis()
						  .scale(xScale2)
						  .orient("bottom")
						  //.innerTickSize(-(w-padding*2))
						  .ticks(5)
						  .tickFormat(siF);

		var rdiv = (h-(padding*2))/((res.length<11)?res.length:11)/2;
		var rw = 210/((res.length<11)?res.length:11);
		
		var zoomed;
		
		var zoom = d3.behavior.zoom()
		.scaleExtent([1, 10]).on("zoom."+paramId, null);
		
		zoomed=(function(AR,pID,cID,chID,title,LID,rng,zm){return function zoomed() {
			if(loadCnt > 0)
				return;
			var len = AR.length;
			if(d3.event.sourceEvent.wheelDelta)
			{
				if(d3.event.sourceEvent.wheelDelta < 0)
				{
					rng+=1;
					if(len-rng < 11)
						rng = len-11;
					//zm.translate([0, 0]);
				}
				if(d3.event.sourceEvent.wheelDelta > 0)
				{
					rng-=1;
					if(rng<0)
						rng=0;
					zm.translate([0, 0]);
				}
			}
			else{
				if(d3.event.translate[1] < 0)
				{
					rng+=1;
					if(len-rng < 11)
						rng = len-11;
					//zm.translate([0, 0]);
				}
				if(d3.event.translate[1] > 0)
				{
					rng-=1;
					if(rng<0)
						rng=0;
					zm.translate([0, 0]);
				}
			}
			streamLineChart(AR,pID,cID,chID,title,LID,rng);
			
		}})(holdData,paramId,contId,chartId,cTitle,loaderId,range,zoom)
		
		zoom.on("zoom."+paramId, zoomed);
		
		var scheck = (d3.select('#'+chartId).node() != null);
		if(scheck)
		{
			svg = d3.select('#'+chartId)
			container=svg.select("#mainContainer");
			svg.select('.x.axis').call(xAxis);
			svg.select('.x2.axis').call(xAxis2);
			svg.select("#loadShield")
			.attr("fill",'none');
			svg.select('g')
				.call(zoom);
		}
		else
		{
			//Create SVG element
			svg=d3.select('#'+contId)
				.append("svg")
				.attr("width", w)
				.attr("height", h)
				.style("margin", '0px 0px 30px 30px')
				.attr("id", chartId)
			  .append("g")
				.attr("transform", "translate(" + 0 + "," + 0 + ")")
				.call(zoom);	
			
			svg.append("defs").append("svg:clipPath")
				.attr("id","clip")
				.append("svg:rect")
				.attr("id","clip-rect")
				.attr("fill", "black")
				.attr("x", padding)
				.attr("y", padding)
				.attr("width", w - padding * 2)
				.attr("height", h - padding * 2);
		
			svg.append("rect")
				.attr("width", w)
				.attr("height", h)
				.attr("x", 0)
				.attr("y", 0)
				.attr("rx", 20)
				.attr("ry", 20)
				.attr("fill", "white")
				.attr("opacity", 0.2);

				//Create X axis
				svg.append("g")
					.attr("class", "x axis")
					.attr("transform", "translate(0," + (padding) + ")")
					.call(xAxis);

				//Create X axis
				svg.append("g")
					.attr("class", "x2 axis")
					.attr("transform", "translate(0," + (h-padding) + ")")
					.call(xAxis2);
					
								
			container=svg.append("g")
				.attr("clip-path",  "url(#clip)")
				.attr("id",  "mainContainer");
			
			
			svg.append("text")
				.attr("class", "x label")
				.attr("text-anchor", "middle")
				.attr("x", w/2)
				.attr("y", h - 12)
				.text('Failed Pcs.').style('font-size','10px');
				
			svg.append("text")
				.attr("class", "gTitle")
				.attr("text-anchor", "middle")
				.attr("x", w/2)
				.attr("y", padding/2)
				.text("Performance ").style('font-size','10px')
				.append("tspan")
				.attr("id","gphName");
				
			svg.append("text")
			.attr("class", "y label")
			.attr("x", padding-10)
			.attr("y", padding/3)
			.text(cTitle).style('font-weight','bold')
			.attr('fill','#000');
		}
		
		//var rdiv = (h-(padding*2))/((res.length<11)?res.length:11)/2;
		//var rw = 210/((res.length<11)?res.length:11);
		
		var fdb=container
			   .selectAll(".failDropBars")
			   .data(res);
			   
		fdb.enter()
			   .append("rect")
				.attr("class", function(d,i) { return "failDropBars r"+i;})
			   .attr("x", function(d,i) { return xScale2(d[2]);})
			   .attr("y", function(d) { return yScale(d[1])+rdiv-rw/2+2;})
			   .attr("width", 1)
			   .attr("height",function(d) { return Math.abs(h-padding-yScale(d[1])+rdiv-rw/2+2);} )
			   .attr("fill",  'silver')
			   .attr("opacity", 0.25);
			   
		fdb.transition().duration(500).attr("class", function(d,i) { return "failDropBars r"+i;})
			   .attr("x", function(d,i) { return xScale2(d[2]);})
			   .attr("y", function(d) { return yScale(d[1])+rdiv-rw/2+2;})
			   .attr("width", 1)
			   .attr("height",function(d) { return Math.abs(h-padding-yScale(d[1])+rdiv-rw/2+2);} )
			   .attr("fill",  'silver')
			   .attr("opacity", 0.25);
			   
		//fdb.transition();

		fdb.exit().transition().remove();
		
		var fpie=container
			   .selectAll(".failPie")
			   .data(res);
			   
		fpie.enter()
			   .append("rect")
				.attr("class", "failPie")
			   .attr("x", function(d,i) { return xScale2(low);})
			   .attr("y", function(d) { return yScale(d[1])+rdiv-rw/2+2;})
			   .attr("width", function(d) {return Math.abs(xScale2(d[2])-xScale2(low));})
			   .attr("height", rw-4)
			   .attr("fill", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale2(d[3]);return 'silver';})
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
			   .append('title')
			   .text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
		
		fpie.transition().duration(500).attr("x", function(d,i) { return xScale2(low);})
			   .attr("y", function(d) { return yScale(d[1])+rdiv-rw/2+2;})
			   .attr("width", function(d) {return Math.abs(xScale2(d[2])-xScale2(low));})
			   .attr("height", rw-4)
			   .attr("fill", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale2(d[3]);return 'silver';});
			   
		fpie.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
			   .select('title')
			   .text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
			   
		//fpie.transition();

		fpie.exit().transition().remove();
		
		/*var line = d3.svg.line()
		.interpolate("cardinal")
		.x(function(d,i) { return xScale(d[3]); })
		.y(function(d) { return yScale(d[1])+rdiv; });
		
		container.append("g")
			.attr("class", "aline")
			.attr("opacity", '0.5')
			.append("path")
			.attr("class", "lineV")
			.attr("d", function(d) { return line(res);})
			.attr('stroke', '#0B0')
			.attr('stroke-width', 2)
			.attr("fill",'none');*/

		var pdb=container
			   .selectAll(".perDropBars")
			   .data(res);
			   
		pdb.enter()
			   .append("rect")
				.attr("class", function(d,i) { return "perDropBars c"+i;})
			   .attr("x", function(d,i) {	return xScale(d[3])-0.5;})
			   .attr("y", padding)
			   .attr("width", 1)
			   .attr("height",function(d) { return Math.abs(yScale(d[1])+rdiv-padding);})
			   .attr("fill", 'silver')
			   .attr("opacity", 0.25);
		
		pdb.transition().duration(500).attr("class", function(d,i) { return "perDropBars c"+i;})
			   .attr("x", function(d,i) {	return xScale(d[3])-0.5;})
			   .attr("y", padding)
			   .attr("width", 1)
			   .attr("height",function(d) { return Math.abs(yScale(d[1])+rdiv-padding);})
			   .attr("fill", 'silver')
			   .attr("opacity", 0.25);
			   
		//pdb.transition();

		pdb.exit().transition().remove();
		
		var fpc=container
			   .selectAll(".failPer")
			   .data(res);
			   
		fpc.enter()
			   .append("circle")
				.attr("class", "failPer")
			   .attr("cx", function(d,i) {	return xScale(d[3]);})
			   .attr("cy", function(d) { return yScale(d[1])+rdiv;})
			   .attr("r", 5)
			   .attr("stroke", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale(d[3]);return 'white'; })
			   .attr("stroke-width", 2)
			   .attr("fill", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale2(d[3]);return 'silver';})
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',0.25).attr('stroke','');})
			   .append('title')
			   .text(function(d) {return 'Percent: '+perF(d[3])+'\nTotal Pieces: '+comF(d[4]);})
		
		fpc.transition().duration(500).attr("class", "failPer")
			   .attr("cx", function(d,i) {	return xScale(d[3]);})
			   .attr("cy", function(d) { return yScale(d[1])+rdiv;})
			   .attr("r", 5)
			   .attr("stroke", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale(d[3]);return 'white'; })
			   .attr("stroke-width", 2)
			   .attr("fill", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale2(d[3]);return 'silver';});
			   
		fpc.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',0.25).attr('stroke','');})
			   .select('title')
			   .text(function(d) {return 'Percent: '+perF(d[3])+'\nTotal Pieces: '+comF(d[4]);})
			   
		//fpc.transition();

		fpc.exit().transition().remove();
		
		if(!scheck)
		{
			var legend=svg.append("g")
					.attr("class", "Legend")
					.attr("transform", "translate(" + (w - padding) + ","+padding+")");

			legend.append('text')
				   .attr("x", 5)
				   .attr("y", 5)
				   .text("")
				   .style("font-size", 8)

			
			//Create Y axis
			svg.append("g")
				.attr("class", "y axis")
				.attr("transform", "translate(" + padding + ",0)")
				.call(yAxis)
				.selectAll('text').attr('fill','#darkblue').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold')
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d,i){updateGraphs(res[i][0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
			   .append('title')
			   .text(function(d,i) {return 'Failed Pieces: '+comF(res[i][2]);});
			   
			   svg.append("text")
			.attr("class", "y label")
			.attr("x", w-padding)
			.attr("y", padding/3)
			.text('Reset').style('font-weight','bold').style('font-size','10px').style('text-decoration','underline').style('cursor','pointer').style('font-variant','small-caps').style('font-family','times, Times New Roman')
			.attr('fill',function(){if(selParam == '')return 'silver';return 'blue'})
			.attr('id','resetLink')
			.on('click',function(){d3.select('#'+paramId).node().value='';cfrm_sub();});
			
		}
		else
		{
			var Ytext=svg.select('.y.axis').call(yAxis).selectAll('text');
			Ytext.selectAll('title').remove();
			Ytext.attr('fill','#darkblue').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold')
				   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
				   .on('click',function(d,i){updateGraphs(res[i][0],paramId)})//id
				   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
				   .append('title')
				   .text(function(d,i) {return 'Failed Pieces: '+comF(res[i][2]);});
			
			svg.select('#resetLink').transition().attr('fill',function(){if(selParam == '')return 'silver';return 'blue'})
			
		}
		container.select("#loadShield").remove();
				
		var ldShd=container
			.append("rect")
			.attr("id","loadShield")
			.attr("opacity",0.75)
			.attr("fill",'none')
			.attr("width", w)
			.attr("height",h);
			/*ldShd.call((function(AShield) {return function() {
				var radius = Math.min(w/2, h/2) / 2;
				var tau = 2 * Math.PI;

				var arc = d3.svg.arc()
						.innerRadius(radius*0.79)
						.outerRadius(radius*0.9)
						.startAngle(0);
				var arc2 = d3.svg.arc()
						.innerRadius(radius*0.59)
						.outerRadius(radius*0.8)
						.startAngle(0);
				var arc3 = d3.svg.arc()
						.innerRadius(radius*0.39)
						.outerRadius(radius*0.6)
						.startAngle(0);

				var svg = AShield.attr("transform", "translate(" + w / 2 + "," + h / 2 + ")");

				var background = svg.append("path")
						.datum({endAngle: 0.80*tau})
						.style("fill", "#21435F")
						.attr("d", arc)
						.attr("opacity", 0.75+0.25*(1-Math.random()))
						.call(spin, 1600)
						
				var background2 = svg.append("path")
						.datum({endAngle: 0.80*tau})
						.style("fill", "#21435F")
						.attr("d", arc2)
						.attr("opacity", 0.75+0.25*(1-Math.random()))
						.call(spinRev, 1500)
				
				var background3 = svg.append("path")
						.datum({endAngle: 0.80*tau})
						.style("fill", "#21435F")
						.attr("d", arc3)
						.attr("opacity", 0.75+0.25*(1-Math.random()))
						.call(spin, 1400)
						
				svg.append('rect').attr('x',-5).attr('y',-18).attr('width',100).attr('height',30).attr('fill','#000').attr('opacity',0.5);
				svg.append('text').text('Loading...').attr('fill','#FFF').style('font-size','18px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold').attr('textLength',80);
						
				function spin(selection, duration) {
					selection.transition()
						.ease("linear")
						.duration(duration)
						.attrTween("transform", function() {
							return d3.interpolateString("rotate(0)", "rotate(360)");
						});

					setTimeout(function() { spin(selection, Math.min(Math.max(duration*(Math.random()+0.51),500),2500)); }, duration);
				}
				
				function spinRev(selection, duration) {
					selection.transition()
						.ease("linear")
						.duration(duration)
						.attrTween("transform", function() {
							return d3.interpolateString("rotate(360)", "rotate(0)");
						});

					setTimeout(function() { spinRev(selection, duration); }, duration);
				}

				function transitionFunction(path) {
					path.transition()
						.duration(7500)
						.attrTween("stroke-dasharray", tweenDash)
						.each("end", function() { d3.select(this).call(transition); });
				}

			  };})(ldShd));
			*/
	
	}
	
	function Area_Chart(res)
	{	
		if(ReqId != res.pop()[0])
			return;
		res.shift();
		streamLineChart(res,'selArea','chart-Area','svgArea','Area','loader');
	}
	
	
	function District_Chart(res)
	{	
		if(ReqId != res.pop()[0])
			return;
		res.shift();
		/*var hold=[];
		var len = res.length;
		for(var i=0; i<10 && i<len; i++)
		{
			hold.push(res.shift());
		}
		if(res.length > 0)
			hold.push(['Others','Others',Math.floor(d3.mean(res,function(d){return d[2]})),d3.mean(res,function(d){return d[3]}),Math.floor(d3.mean(res,function(d){return d[4]}))]);
		*/
		res=res.reverse();
		
		streamLineChart(res,'selDistrict','chart-District','svgDistrict','District','loader');		
	}

	function Facility_Chart(res)
	{	
		if(ReqId != res.pop()[0])
			return;
		res.shift();
		var hold=res;/*[];
		var len = res.length;
		for(var i=0; i<10 && i<len; i++)
		{
			hold.push(res.shift());
		}
		if(res.length > 0)
			hold.push(['Others','Others',Math.floor(d3.mean(res,function(d){return d[2]})),d3.mean(res,function(d){return d[3]}),Math.floor(d3.mean(res,function(d){return d[4]}))]);
		*/
		res=hold.reverse();
		
		streamLineChart(res,'selFacility','chart-Facility','svgFacility','Facility','loader');		
	}

	function DOW_Chart(res)
	{	
		if(ReqId != res.pop()[0])
			return;
		res.shift();
		/*var hold=[];
		var len = res.length;
		for(var i=0; i<10 && i<len; i++)
		{
			hold.push(res.shift());
		}
		if(res.length > 0)
			hold.push(['Others','Others',Math.floor(d3.mean(res,function(d){return d[2]})),d3.mean(res,function(d){return d[3]}),Math.floor(d3.mean(res,function(d){return d[4]}))]);
		*/
		res=res.reverse();
		
		streamLineChart(res,'selDOW','chart-DOW','svgDOW','Day Of Week','loader');		
	}
	
	function Class_Chart(res)
	{	
		if(ReqId != res.pop()[0])
			return;
		res.shift();
		/*var hold=[];
		var len = res.length;
		for(var i=0; i<10 && i<len; i++)
		{
			hold.push(res.shift());
		}
		if(res.length > 0)
			hold.push(['Others','Others',Math.floor(d3.mean(res,function(d){return d[2]})),d3.mean(res,function(d){return d[3]}),Math.floor(d3.mean(res,function(d){return d[4]}))]);
		*/
		res=res.reverse();
		
		streamLineChart(res,'selClass','chart-Class','svgClass','Mail Class','loader');		
	}
	
	function Cat_Chart(res)
	{	
		if(ReqId != res.pop()[0])
			return;
		res.shift();
		/*var hold=[];
		var len = res.length;
		for(var i=0; i<10 && i<len; i++)
		{
			hold.push(res.shift());
		}
		if(res.length > 0)
			hold.push(['Others','Others',Math.floor(d3.mean(res,function(d){return d[2]})),d3.mean(res,function(d){return d[3]}),Math.floor(d3.mean(res,function(d){return d[4]}))]);
		*/
		res=res.reverse();
		
		streamLineChart(res,'selCategory','chart-Shape','svgShape','Mail Shape','loader');		
	}
	
	function EOD_Chart(res)
	{	
		if(ReqId != res.pop()[0])
			return;
		res.shift();
		/*var hold=[];
		var len = res.length;
		for(var i=0; i<10 && i<len; i++)
		{
			hold.push(res.shift());
		}
		if(res.length > 0)
			hold.push(['Others','Others',Math.floor(d3.mean(res,function(d){return d[2]})),d3.mean(res,function(d){return d[3]}),Math.floor(d3.mean(res,function(d){return d[4]}))]);
		*/
		res=res.reverse();
		
		streamLineChart(res,'selEod','chart-EOD','svgEOD','Entry','loader');		
	}
	
	function SVCSTD_Chart(res)
	{	
		if(ReqId != res.pop()[0])
			return;
		res.shift();
		/*var hold=[];
		var len = res.length;
		for(var i=0; i<10 && i<len; i++)
		{
			hold.push(res.shift());
		}
		if(res.length > 0)
			hold.push(['Others','Others',Math.floor(d3.mean(res,function(d){return d[2]})),d3.mean(res,function(d){return d[3]}),Math.floor(d3.mean(res,function(d){return d[4]}))]);
		*/
		res=res.reverse();
		
		streamLineChart(res,'selHybStd','chart-SVCSTD','svgSVCSTD','Svc. Std.','loader');		
	}
	
	function date_ret(res)
	{

      var sel=document.getElementById('selDate')
	  sel.length=0;
	  for (var i=0;i<res.length;i++)
	  {
       var opt = document.createElement('option');
       opt.value = res[i];
       opt.innerHTML = res[i];
    	sel.appendChild(opt);
	  }
	  sel.disabled=false;
	}

	function date_err(res)
	{
		alert(res);
	}


	function get_val(v)
	{
	 var sel=document.getElementById(v);
	 return sel.options[sel.selectedIndex].value; 
	}

	function cfrm()
	{
	document.getElementById("subtn").style.border = 'Red 4px solid';
	}	

	function load_shape(c)
		{
		  var cl = [];
		  cl[1] = [1,'Letters','1,3','Letters/Cards',2,'Flats',3,'Cards'];
		  cl[2] = [2,'Flats'];  
		  cl[3] = [1,'Letters',2,'Flats'];	  
		  var curshape = get_val('selCategory');
		  var sel=document.getElementById('selCategory')
		  sel.length=0;
		  for (var i=0;i<cl[c].length;i+=2)
		  {
		   if (i==0)
		   {
			 var opt = document.createElement('option');
			 opt.value = '';
			 opt.innerHTML = 'All Shapes';
			  sel.appendChild(opt);
		   }
		   
		   var opt = document.createElement('option');
		   opt.value = cl[c][i];
		   opt.innerHTML = cl[c][i+1];
			sel.appendChild(opt);
		   if (opt.value == curshape)
			sel.selectedIndex = sel.length-1; 
			
		  }
				  
		  sel.disabled=false;
			
		}

	var doInit;
	function init()
	{
		doInit=true;
		/*myLoader();
		var e=new TDF();
		e.setCallbackHandler(makeTable);	
		e.setErrorHandler(area_data_err);
		e.getMainData('<cfoutput>#opsvisdata#</cfoutput>','1','O','N',"04/09/2016","04/16/2016","All","All","3","1","","","","","Y","","34",'');*/
		
		var e=new TDF();
		e.setCallbackHandler(load_Area_Dist);	
		e.setErrorHandler(area_data_err);
		e.getAreaDistData('<cfoutput>#opsvisdata#</cfoutput>');
		
		var e=new TDF();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(area_data_err);
		e.getDates('<cfoutput>#opsvisdata#</cfoutput>','');
		
		get_std();
	}

	function chg_DateRng(n)
	{
		var e=new TDF();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(area_data_err);
		e.getDates('<cfoutput>#opsvisdata#</cfoutput>',n);
	}

	ReqId=0;
	function cfrm_sub()
	{
		myLoader();
		d3.selectAll("#loadShield")
			.attr("fill",'gray');
		/*AreaLoader();
		DistrictLoader();
		FacilityLoader();
		EntryLoader();
		DOWLoader();
		ClassLoader();
		ShapeLoader();*/
		listSelections();
		document.getElementById("subtn").style.border = 'none';
		//document.getElementById('selArea').selectedOptions[0].text
		var srlupv = document.getElementById('rlupv').value;
		var sdir = document.getElementById('selDir').value;
		var seod = document.getElementById('selEod').value;
		var sDOW = document.getElementById('selDOW').value;
		var sd = document.getElementById('selDate');
		var sdend='';
		if(sd.selectedIndex >0)
		{
			sdend=sd.options[sd.selectedIndex-1].value;
		}
		sd=sd.value;
		var sarea = document.getElementById('selArea').value;
		var sdist = document.getElementById('selDistrict').value;
		var sfac = document.getElementById('selFacility').value;
		var sclass = document.getElementById('selClass').value;
		var scat = document.getElementById('selCategory').value;
		var sfss = document.getElementById('selFSS').value;
		var smode = '';
		var sair = '';
		var spol = document.getElementById('selPOL').value;
		var shyb = document.getElementById('selHybStd').value;
			
		if(sclass==1)
		{
			smode = document.getElementById('selMode').value;
			sair = document.getElementById('selAir').value;
		}
		
		ReqId++;
		loadCnt=8;
		var e=new TDF();
		e.setCallbackHandler(Display_Overalls);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"","","","Y",spol,shyb,'',sDOW,sfac);
		var e=new TDF();
		e.setCallbackHandler(Area_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByAreaData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"","","","Y",spol,shyb,'',sDOW);
		var e=new TDF();
		e.setCallbackHandler(District_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDistData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"","","","Y",spol,shyb,'',sDOW);
		var e=new TDF();
		e.setCallbackHandler(Facility_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByFacilityData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"","","","Y",spol,shyb,'',sDOW);
		var e=new TDF();
		e.setCallbackHandler(DOW_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDayData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"","","","Y",spol,shyb,'',sDOW,sfac);
		var e=new TDF();
		e.setCallbackHandler(Class_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByClassData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"","","","Y",spol,shyb,'',sDOW,sfac);
		var e=new TDF();
		e.setCallbackHandler(Cat_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByCatData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"","","","Y",spol,shyb,'',sDOW,sfac);
		var e=new TDF();
		e.setCallbackHandler(EOD_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByEODData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"","","","Y",spol,shyb,'',sDOW,sfac);
		var e=new TDF();
		e.setCallbackHandler(SVCSTD_Chart);	
		e.setErrorHandler(area_data_err);
		e.getBySvcStdData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"","","","Y",spol,shyb,'',sDOW,sfac);
		
	}
	function Display_Overalls(res)
	{
		if(ReqId != res.pop()[0])
			return;
		res.shift();
		var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range(["#d73027","#d73027","#fc8d59","#fc8d59","#fee090","#fee090","#91bfdb","#91bfdb","#4575b4","#4575b4"]);	
		var toColor = cScale2(res[0][3]);
		
		var perF = d3.format('.1%');
		var sigF = d3.format('.3g');
		var comF = d3.format(',');
		
		d3.select('#OverallScore').style('background',toColor).text(perF(res[0][3]));
		d3.select('#OverallFail').style('background',toColor).text(comF(res[0][2]));
		d3.select('#OverallPieces').style('background',toColor).text(comF(res[0][4]));
	}
	
	function listSelections()
	{		
		//var filterHds = ['Entry: ','Area: ','District: ','Range: ','Date: ','Level: ','Rollup: ','Class: ','Std.: ','Shape: ']
		//var filterArgs = ['Destination','National','','Week','04/23/2016','Originating From View','Area','Standard','DSCF 3-4','Letters']
		d3.select('#flist').style('display','');
		d3.select('#flist').selectAll('span').remove();
		var hold =[];hold.push(filterHds[4]);hold.push(filterHds[5]);
		var hold2 =[];hold2.push(filterArgs[4]);hold2.push(filterArgs[5]);
		d3.select('#flist').selectAll('span').data(hold).enter().append('span').attr('class','smallFnt').text(function(d,i){return d+': '+hold2[i];});
		
	}

	function load_std(res)
	{
		var sel=document.getElementById('selHybStds')
		sel.length=0;
		res.forEach(function(d,i){
			sel.options[sel.options.length]= 	new Option(d[1],d[0]);
		});
		if(document.getElementById('selClasses').value==3)
			sel.selectedIndex=1;
		filterArgs[8]=res[sel.selectedIndex][1];
		cfrm();
	}

	function std_err(res)
	{
		alert(res);
	}

	function get_std()
	{
		var seod = document.getElementById('selEod').value;
		var sclass = document.getElementById('selClasses').value;

		var e=new TDF();
		e.setCallbackHandler(load_std);	
		e.setErrorHandler(std_err);
		e.getHybStd('<cfoutput>#opsvisdata#</cfoutput>',sclass,seod);
	}

	function chg_area(t)
	{
		d3.select('#selArea').node().value=t.value;
		load_district();
		cfrm();
	}

	function chg_district()
	{
		cfrm();
	}

	function chg_date()
	{
		cfrm();
	}

	function cat_sel(n)
	{
		var sc = document.getElementById('selCategory');
		if(sc.value=='')
		{
			sc.value=n;
			return;
		}
		var scAr = sc.value.split(',');
		var chk = false;
		var hold = [];
		scAr.forEach(function(d,i){		
			if(d==n)
				chk=true;
			else
				hold.push(d);
		});
		if(!chk)
			hold.push(n);
		sc.value=hold.toString();
		
	}
	
	function cat_filt(n)
	{
		if(filterArgs[9]=='')
		{
			filterArgs[9]=n;
			return;
		}
		var scAr = filterArgs[9].split(',');
		var chk = false;
		var hold = [];
		scAr.forEach(function(d,i){		
			if(d==n)
				chk=true;
			else
				hold.push(d);
		});
		if(!chk)
			hold.push(n);
		filterArgs[9]=hold.toString();
		
	}

	function load_Dates(res)
	{
		res.shift();
		var sel = document.getElementById('selDate');
		sel.options.length=0;
		res.forEach(function(d,i){
			sel.options[sel.options.length]= 	new Option(d,d);
		});
	
		if(doInit)
		{
			doInit=false;
			filterArgs[4]=sel.options[0].text;
			document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';cfrm_sub();			
		}
	}

	var ADHier;
	function load_Area_Dist(res)
	{
		ADHier=d3.nest()
		.key(function(d){return d[1]})
		.key(function(d){return d[3]})
		.entries(res);
		ADHier.forEach(function(d,i){
			d.values.sort(function(a,b){return d3.ascending(a.values[0][2],b.values[0][2])});
		});
		load_area();
	}

	function load_area()
	{
		var sel = document.getElementById('selAreas');
		sel.options.length=1;
		ADHier.forEach(function(d,i){
			sel.options[sel.options.length]= 	new Option(d.values[0].values[0][0],d.key);
		});
	}

	function load_district()
	{
		var sa = document.getElementById('selAreas').value;
		var sel = document.getElementById('selDistricts');
		sel.options.length=1;
		if(sa == '' || sa == 'HQ')
			return;
		ADHier.forEach(function(d,i){
			if(d.key==sa)
			{
				d.values.forEach(function(d2,i){
					sel.options[sel.options.length]= 	new Option(d2.values[0][2],d2.key);
				});
				return;
			}
		});
	}

	function DS(fac,zip3)
	{
		//var spol = document.getElementById('selPOL').value;
	//var srlupv = document.getElementById('rlupv').value;
		var smode = '';
		var sair = '';
		var sclass = document.getElementById('selClass').value;
			
		if(sclass==1)
		{
			smode = document.getElementById('selMode').value;
			sair = document.getElementById('selAir').value;
		}
		var rng = 'WEEK'
		
		if(document.getElementById('rngMON').checked)
			rng = 'MON';
		else if(document.getElementById('rngQTR').checked)
			rng = 'QTR';
		var sd = document.getElementById('selDate');
		var sdend='';
		if(sd.selectedIndex >0)
		{
			sdend=sd.options[sd.selectedIndex-1].value;
		}
		sd=sd.value;
		var sarea = document.getElementById('selArea').value;
		var sdist = document.getElementById('selDistrict').value;
		var sdir = document.getElementById('selDir').value;
		var seod = document.getElementById('selEod').value;
		var scat = document.getElementById('selCategory').value;
		var sfss = document.getElementById('selFSS').value;
		var shyb = document.getElementById('selHybStd').value;
/*		
	window.open('DowDsFacD3.cfm?WKN='+sd+'&BG_DATE=' +sd+"&ED_DATE="+sdend+"&RPT_RANGE="+rng+"&SELAREA="+sarea+"&SELDISTRICT="+sdist
	+"&SELCATEGORY="+scat+"&SELCLASS="+sclass+"&SELDIR="+sdir
	+"&SELEOD="+seod+"&SELFACILITY="+fac+"&SELFSS="+sfss
	+"&SELHYBSTD="+shyb+"&selAir="+sair+"&selMode="+smode
	+"&SELORG3="+zip3
		,'_DowFac ');
		*/
		var lnkForm = d3.select("body")
		.append("form")
		.attr("method","post")
		.attr("target","_DowFac")
		.attr("action","DowDsFacD3.cfm")
		.attr("name","link_form")
		
		lnkForm.append("input").attr("type","hidden").attr("name","SELAREA").attr("value",sarea);
		lnkForm.append("input").attr("type","hidden").attr("name","SELDISTRICT").attr("value",sdist);
		lnkForm.append("input").attr("type","hidden").attr("name","SELFACILITY").attr("value",fac);
		lnkForm.append("input").attr("type","hidden").attr("name","WKN").attr("value",sd);
		lnkForm.append("input").attr("type","hidden").attr("name","RPT_RANGE").attr("value",rng);
		lnkForm.append("input").attr("type","hidden").attr("name","selDir").attr("value",sdir);
		lnkForm.append("input").attr("type","hidden").attr("name","selEOD").attr("value",seod);
		lnkForm.append("input").attr("type","hidden").attr("name","bg_date").attr("value",sd);
		lnkForm.append("input").attr("type","hidden").attr("name","ed_date").attr("value",sdend);
		lnkForm.append("input").attr("type","hidden").attr("name","selClass").attr("value",sclass);
		lnkForm.append("input").attr("type","hidden").attr("name","selCategory").attr("value",scat);
		lnkForm.append("input").attr("type","hidden").attr("name","selFSS").attr("value",sfss);
		lnkForm.append("input").attr("type","hidden").attr("name","selMode").attr("value",smode);
		lnkForm.append("input").attr("type","hidden").attr("name","selAir").attr("value",sair);
		lnkForm.append("input").attr("type","hidden").attr("name","selOrg3").attr("value",zip3);
		//lnkForm.append("input").attr("type","hidden").attr("name","selCntrLvl").attr("value","");
		//lnkForm.append("input").attr("type","hidden").attr("name","rdCert").attr("value","Y");
		//lnkForm.append("input").attr("type","hidden").attr("name","chkPol").attr("value",spol);
		lnkForm.append("input").attr("type","hidden").attr("name","selHybStd").attr("value",shyb);
		//lnkForm.append("input").attr("type","hidden").attr("name","selOrgFac").attr("value",params[0]);
		//lnkForm.append("input").attr("type","hidden").attr("name","selDOW").attr("value",sDOW);
		//lnkForm.append("input").attr("type","hidden").attr("name","selvariance").attr("value","");
		//lnkForm.append("input").attr("type","hidden").attr("name","fp_chk").attr("value","");
		//lnkForm.append("input").attr("type","hidden").attr("name","selMailer").attr("value",params[13]);
		//lnkForm.append("input").attr("type","hidden").attr("name","selDest3").attr("value",params[15]);
		//lnkForm.append("input").attr("type","hidden").attr("name","selPhysCntr").attr("value",params[16]);
		//lnkForm.append("input").attr("type","hidden").attr("name","selDestFac").attr("value",params[17]);
		//lnkForm.append("input").attr("type","hidden").attr("name","selImbZip3").attr("value",params[18]);
		
		document.link_form.submit();
		
		lnkForm.remove();
	}

	function go_mlr(fac,dow)
	{
		var smode = '';
		var sair = '';
		var sclass = document.getElementById('selClass').value;
			
		if(sclass==1)
		{
			smode = document.getElementById('selMode').value;
			sair = document.getElementById('selAir').value;
		}
		var rng = 'WEEK'
		
		if(document.getElementById('rngMON').checked)
			rng = 'MON';
		else if(document.getElementById('rngQTR').checked)
			rng = 'QTR';
		var sd = document.getElementById('selDate');
		var sdend='';
		if(sd.selectedIndex >0)
		{
			sdend=sd.options[sd.selectedIndex-1].value;
		}
		sd=sd.value;
		var sarea = document.getElementById('selArea').value;
		var sdist = document.getElementById('selDistrict').value;
		var sdir = document.getElementById('selDir').value;
		var seod = document.getElementById('selEod').value;
		var scat = document.getElementById('selCategory').value;
		var sfss = document.getElementById('selFSS').value;
		var shyb = document.getElementById('selHybStd').value;
		
	/*	window.open('TrendDayMailersD3.cfm?WKN='+sd+'&BG_DATE=' +sd+"&ED_DATE="+sdend+"&RPT_RANGE="+rng+"&SELAREA="+sarea+"&SELDISTRICT="+sdist
		+"&SELCATEGORY="+scat+"&SELCLASS="+sclass+"&SELDIR="+sdir
		+"&SELEOD="+seod+"&SELFACILITY="+fac+"&SELFSS="+sfss
		+"&SELHYBSTD="+shyb+"&selAir="+sair+"&selMode="+smode
		+"&selDOW="+dow
		,'_TMailers ');
		
		*/
		var lnkForm = d3.select("body")
		.append("form")
		.attr("method","post")
		.attr("target","_TMailers")
		.attr("action","TrendDayMailersD3.cfm")
		.attr("name","link_form")
		
		lnkForm.append("input").attr("type","hidden").attr("name","SELAREA").attr("value",sarea);
		lnkForm.append("input").attr("type","hidden").attr("name","SELDISTRICT").attr("value",sdist);
		lnkForm.append("input").attr("type","hidden").attr("name","SELFACILITY").attr("value",fac);
		lnkForm.append("input").attr("type","hidden").attr("name","WKN").attr("value",sd);
		lnkForm.append("input").attr("type","hidden").attr("name","RPT_RANGE").attr("value",rng);
		lnkForm.append("input").attr("type","hidden").attr("name","selDir").attr("value",sdir);
		lnkForm.append("input").attr("type","hidden").attr("name","selEOD").attr("value",seod);
		lnkForm.append("input").attr("type","hidden").attr("name","bg_date").attr("value",sd);
		lnkForm.append("input").attr("type","hidden").attr("name","ed_date").attr("value",sdend);
		lnkForm.append("input").attr("type","hidden").attr("name","selClass").attr("value",sclass);
		lnkForm.append("input").attr("type","hidden").attr("name","selCategory").attr("value",scat);
		lnkForm.append("input").attr("type","hidden").attr("name","selFSS").attr("value",sfss);
		lnkForm.append("input").attr("type","hidden").attr("name","selMode").attr("value",smode);
		lnkForm.append("input").attr("type","hidden").attr("name","selAir").attr("value",sair);
		//lnkForm.append("input").attr("type","hidden").attr("name","selOrg3").attr("value",zip3);
		//lnkForm.append("input").attr("type","hidden").attr("name","selCntrLvl").attr("value","");
		//lnkForm.append("input").attr("type","hidden").attr("name","rdCert").attr("value","Y");
		//lnkForm.append("input").attr("type","hidden").attr("name","chkPol").attr("value",spol);
		lnkForm.append("input").attr("type","hidden").attr("name","selHybStd").attr("value",shyb);
		//lnkForm.append("input").attr("type","hidden").attr("name","selOrgFac").attr("value",params[0]);
		lnkForm.append("input").attr("type","hidden").attr("name","selDOW").attr("value",dow);
		//lnkForm.append("input").attr("type","hidden").attr("name","selvariance").attr("value","");
		//lnkForm.append("input").attr("type","hidden").attr("name","fp_chk").attr("value","");
		//lnkForm.append("input").attr("type","hidden").attr("name","selMailer").attr("value",params[13]);
		//lnkForm.append("input").attr("type","hidden").attr("name","selDest3").attr("value",params[15]);
		//lnkForm.append("input").attr("type","hidden").attr("name","selPhysCntr").attr("value",params[16]);
		//lnkForm.append("input").attr("type","hidden").attr("name","selDestFac").attr("value",params[17]);
		//lnkForm.append("input").attr("type","hidden").attr("name","selImbZip3").attr("value",params[18]);
		
		document.link_form.submit();
		
		lnkForm.remove();

	}

	function makeTable(res)
	{
		d3.select('#eOut').style('display','');
		var perF = d3.format('.2%');
		var sigF = d3.format('.3g');
		var siF = d3.format('.3s');
		var comF = d3.format(',');
		
		d3.select('#loader').remove();
		var homediv = d3.select('#tableDiv');
		homediv.select('#STQdiv').remove();

		var homeTBL =homediv.append('table')
		.attr('class','pbTable')
		//.style('margin','0px 0px 0px 100px')	  
		.attr('id','mainTable');
		var thead = homeTBL.append('thead');
		
		var srlupv = document.getElementById('rlupv').value;
		var h1row = res.shift();
		var data=[];
		res.forEach(function(d,i){
			data[i]={};
			h1row.forEach(function(d2,i2){
				data[i][d2]=d[i2];	
			});
		});
		var len=data.length;
		data[len]={};
		h1row.forEach(function(d2,i2){
			if(d2 == 'AREA_NAME' || d2 == 'DISTRICT_NAME' || d2 == 'DISTRICT_ID' || d2 == 'DISTRICT_ID' || d2 == 'FAC_NAME' || d2 == 'FAC_KEY' || d2 == 'ORGN_FAC_ZIP_3')
				data[len][d2]='Overall Totals';
			else if(d2.slice(0,3)== 'PER')
			{
				var day=d2.slice(3,d2.length);
				var tots = d3.sum(data,function(d,i){return d['TP'+day]});
				data[len][d2]=(tots>0)?(1-d3.sum(data,function(d,i){return d['FP'+day];})/tots):0;	
			}
			else if(d2.slice(0,3)== 'HYB')
			{
				data[len][d2]=d3.max(data,function(d,i){return d[d2];});	
			}
			else
				data[len][d2]=d3.sum(data,function(d,i){return d[d2]});
		});

		BarChart(data);
		
		res=[];totalNames=[];
		
		var count=0;
		data.forEach(function(d,i){
			res[i]=[];
			count=0;
			if(srlupv==1)
			{
				res[i][count++]=d[h1row[0]];
				res[i][count++]=[d.FP_SAT,d.TP_SAT];
				res[i][count++]=d.PER_SAT;
				res[i][count++]=[d.FP_SUN,d.TP_SUN];
				res[i][count++]=d.PER_SUN;
				res[i][count++]=[d.FP_MON,d.TP_MON];
				res[i][count++]=d.PER_MON;
				res[i][count++]=[d.FP_TUE,d.TP_TUE];
				res[i][count++]=d.PER_TUE;
				res[i][count++]=[d.FP_WED,d.TP_WED];
				res[i][count++]=d.PER_WED;
				res[i][count++]=[d.FP_THU,d.TP_THU];
				res[i][count++]=d.PER_THU;
				res[i][count++]=[d.FP_FRI,d.TP_FRI];
				res[i][count++]=d.PER_FRI;
			}
			else if(srlupv==2)
			{
				res[i][count++]=d[h1row[2]];
				res[i][count++]=(d[h1row[0]]=='Overall Totals')?'':d[h1row[0]];
				
				res[i][count++]=[d.FP_SAT,d.TP_SAT];
				res[i][count++]=d.PER_SAT;
				res[i][count++]=[d.FP_SUN,d.TP_SUN];
				res[i][count++]=d.PER_SUN;
				res[i][count++]=[d.FP_MON,d.TP_MON];
				res[i][count++]=d.PER_MON;
				res[i][count++]=[d.FP_TUE,d.TP_TUE];
				res[i][count++]=d.PER_TUE;
				res[i][count++]=[d.FP_WED,d.TP_WED];
				res[i][count++]=d.PER_WED;
				res[i][count++]=[d.FP_THU,d.TP_THU];
				res[i][count++]=d.PER_THU;
				res[i][count++]=[d.FP_FRI,d.TP_FRI];
				res[i][count++]=d.PER_FRI;
			}
			else
			{
				if(d.ORGN_FAC_ZIP_3)
					res[i][count++]=[d[h1row[4]],d.FAC_KEY,d.ORGN_FAC_ZIP_3];
				else
					res[i][count++]=d[h1row[4]];
				res[i][count++]=(d[h1row[2]]=='Overall Totals')?'':d[h1row[2]];
				
				res[i][count++]=(d[h1row[2]]=='Overall Totals')?[d.FP_SAT,d.TP_SAT]:[d.FP_SAT,d.TP_SAT,d.FAC_KEY,7];
				res[i][count++]=d.PER_SAT;
				res[i][count++]=(d[h1row[2]]=='Overall Totals')?[d.FP_SUN,d.TP_SUN]:[d.FP_SUN,d.TP_SUN,d.FAC_KEY,1];
				res[i][count++]=d.PER_SUN;
				res[i][count++]=(d[h1row[2]]=='Overall Totals')?[d.FP_MON,d.TP_MON]:[d.FP_MON,d.TP_MON,d.FAC_KEY,2];
				res[i][count++]=d.PER_MON;
				res[i][count++]=(d[h1row[2]]=='Overall Totals')?[d.FP_TUE,d.TP_TUE]:[d.FP_TUE,d.TP_TUE,d.FAC_KEY,3];
				res[i][count++]=d.PER_TUE;
				res[i][count++]=(d[h1row[2]]=='Overall Totals')?[d.FP_WED,d.TP_WED]:[d.FP_WED,d.TP_WED,d.FAC_KEY,4];
				res[i][count++]=d.PER_WED;
				res[i][count++]=(d[h1row[2]]=='Overall Totals')?[d.FP_THU,d.TP_THU]:[d.FP_THU,d.TP_THU,d.FAC_KEY,5];
				res[i][count++]=d.PER_THU;
				res[i][count++]=(d[h1row[2]]=='Overall Totals')?[d.FP_FRI,d.TP_FRI]:[d.FP_FRI,d.TP_FRI,d.FAC_KEY,6];
				res[i][count++]=d.PER_FRI;
			}
			res[i][count++]=[d.FP_TOT,d.TP_TOT];
			res[i][count++]=d.PER_TOT;
			
		});
		
		if(srlupv==1)
		{
			h1row=['Area','Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Total'];
			thead.append('tr')
			.selectAll('th').data(h1row).enter()
			.append('th')
			.style('padding','3px')
			.attr('colSpan',function(d,i){if(i==0) return 1;return 2;})
			.attr('rowSpan',function(d,i){if(i==0) return 2;return 1;})
			.text(function(d){return d;});
		}
		else if(srlupv==2)
		{
			h1row=['District','Area','Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Total'];
			thead.append('tr')
			.selectAll('th').data(h1row).enter()
			.append('th')
			.style('padding','3px')
			.attr('colSpan',function(d,i){if(i<=1) return 1;return 2;})
			.attr('rowSpan',function(d,i){if(i<=1) return 2;return 1;})
			.text(function(d){return d;});
		}
		else
		{
			h1row=['Facility','District','Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Total'];
			thead.append('tr')
			.selectAll('th').data(h1row).enter()
			.append('th')
			.style('padding','3px')
			.attr('colSpan',function(d,i){if(i<=1) return 1;return 2;})
			.attr('rowSpan',function(d,i){if(i<=1) return 2;return 1;})
			.text(function(d){return d;});
		}
		
		h2row=['Failed','%','Failed','%','Failed','%','Failed','%','Failed','%','Failed','%','Failed','%','Failed','%'];
		
		thead.append('tr')
		.selectAll('th').data(h2row).enter()
		.append('th')
		.style('padding','3px')
		.text(function(d){return d;});

		var tbody = homeTBL.append('tbody')
		.selectAll('.trb').data(res).enter()
		.append('tr')
		.on('mouseover',function(d,i){
			d3.select('#mainContainer').selectAll('g').attr('opacity',0)
			   .style("display", 'none');
			var hold;
			if(d[0].length==3)
				hold=d[0][0];
			else
				hold=d[0];
			
			if(hold == 'Overall Totals')
				yAxisCall.call(yAxisTot);
			else
				yAxisCall.call(yAxis2);
			
			d3.select('#gphName').text('for '+hold);
			d3.selectAll('.'+hold.replace(/[\/& ]/g,"_")).attr('opacity',1)
			   .style("display", '');
		})
		.selectAll('td').data(function(d){return d}).enter()
		.append('td')
		.style('padding','3px')
		.style('text-align',function(d,i) {return (i<=((srlupv==1)?0:1)) ? 'Left' : 'Center'})
		.style('text-decoration',function(d,i){if((d.length == 3 || d.length == 4) && d[0]!='Overall Totals')return 'underline';})
		.style('color',function(d,i){if((d.length == 3 || d.length == 4) && d[0]!='Overall Totals')return 'blue';})
		.style('cursor',function(d,i){if((d.length == 3 || d.length == 4) && d[0]!='Overall Totals')return 'pointer';})
		.attr('title',function(d,i){if(d.length == 2 || d.length == 4)return 'Failed Pieces: '+comF(d[0])+'\nTotal Pieces: '+comF(d[1]);})
		.text(function(d,i){if(d.length == 3)return d[0];if(d.length == 2 || d.length == 4){if(d[0]>0&&d[0]<1)return perF(d[0]);if(d[0]>100)return siF(d[0]);return d[0];}else{if(d>0&&d<1)return perF(d);if(d>100)return siF(d);return d;}})
		.on('click',function(d,i){if(d.length == 3 && d[0]!='Overall Totals')DS(d[1],d[2]);if(d.length == 4)go_mlr(d[2],d[3])});
		
		scrTblQuick('mainTable',300);
		d3.select('#STQdiv').style('margin','');
	}

	function excel_out()
	{
		var ua = window.navigator.userAgent;
		var msie = ua.indexOf("MSIE "); 

		if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
		{
			txtArea1.document.open("txt/html","replace");
			txtArea1.document.write(d3.select('#tableDiv').node().innerHTML);
			txtArea1.document.close();
			txtArea1.focus(); 
			sa=txtArea1.document.execCommand("SaveAs",true,"Performance.xls");
		}  
		else  
			window.open('data:application/vnd.ms-excel;filename=Performance.xls;base64,'+window.btoa(d3.select('#tableDiv').node().innerHTML));
	}
	
	function toggle()
	{
	 var t = document.getElementById('wrapper');
	 if (t.className == 'active')
	 t.className = ''
	 else
	 t.className = 'active';
	}
	
	function resetAll()
	{
		d3.select('#RAll').style('color','white');
		d3.select('#filtDiv').selectAll('[type=hidden]').attr('value','');
		cfrm_sub();
	}
</script>
</head>

<body onload="init()" style="margin:0px;">
<div id="banner" style="margin:0px auto; background: #21435F; height:60px; color:#FFFFFF">
<input type='button' value='|||' onclick="toggle()" class='pbnobtn' style='margin:5px 15px;width:40px;height:40px;font-size:20px;float:left;transform: rotate(90deg);'>
<h1  style="margin:5px 20px;font-size:45px;float:left;"> IV</h1>
<div style='padding:10px 25px 5px 0px;'>
<span style=" font-size:20px;"> Informed Visibility </span><br>
<span  style="font-size:15px;"> The single source for all your mail visibility needs </span>
</div><br>
</div>
<div id="wrapper" class="">
      
      <!-- Sidebar -->
            <!-- Sidebar -->
      <div id="sidebar-wrapper">
      <ul id="sidebar_menu" class="sidebar-nav">
           <li class="sidebar-brand"><a id="menu-toggle" href="#" >Menu</a></li>
      </ul>
        <ul class="sidebar-nav" id="sidebar">     
          <li><a>Link1</span></a></li>
          <li><a>link2</a></li>
        </ul>
      </div>
          
      <!-- Page content -->
      <div id="page-content-wrapper">
<br>
<fieldset class="fset" style="border: solid 1px blue;padding: 5px 5px"><legend>Filters</legend>
<div id='filtDiv'>
	<fieldset class="" style='display:none;' ><legend>Entry Type:</legend>
		<select class ="slct" id = "selEods" name = "selEods" onChange="filterArgs[0]=this.options[this.selectedIndex].text;get_std();" >
		<option value="Y">Origin</option>
		<option value='N' selected>Destination</option>   
		</select>
	</fieldset>
	<fieldset class="" style='display:none;' ><legend>Report For:</legend>
		<select class ="slct" name="selAreas" id="selAreas" style='display:none;' onChange="filterArgs[1]=this.options[this.selectedIndex].text;chg_area(this)">
			<option value = 'All'>NATIONAL</option> 
		</select>
		<input type='hidden' id='selArea' name='selArea' value=''>
		<select class ="slct" name="selDistricts" id="selDistricts" style='display:none;' onChange="filterArgs[2]=this.options[this.selectedIndex].text;chg_district()">
			<option value = 'All'>All Districts</option> 
		</select>
		<input type='hidden' id='selDistrict' name='selDistrict' value=''>
		<input type='hidden' id='selFacility' name='selFacility' value=''>
		<input type='hidden' id='selDOW' name='selDOW' value=''>
		<input type='hidden' id='selClass' name='selClass' value=''>
		<input type='hidden' id='selEod' name='selEod' value=''>
		<input type='hidden' id='selHybStd' name='selHybStd' value=''>
		&nbsp;Rollup:
		<input class ="slct" type = "Radio" name  = "rlup" id  = "rlup" style='display:none;' onclick = "filterArgs[6]='Area';document.getElementById('rlupv').value=1;cfrm();" checked>Area
		<input class ="slct" type = "Radio" name  = "rlup" id  = "rlup" style='display:none;' onclick = "filterArgs[6]='District';document.getElementById('rlupv').value=2;cfrm();" >District
		<input class ="slct" type = "Radio" name  = "rlup" id  = "rlup" style='display:none;' onclick = "filterArgs[6]='Facility';document.getElementById('rlupv').value=3;cfrm();" >Facility&nbsp;
	</fieldset>
	<!---<br>
	<br>--->
	<fieldset class="fset"><legend>Date By:</legend>
		<!---<input class ="slct" type = "Radio" name  = "rng" id  = "rngWK" style='display:none;' onclick = "filterArgs[3]='Week';chg_DateRng('WEEK');cfrm();" checked>Week
		<input class ="slct" type = "Radio" name  = "rng" id  = "rngMON" style='display:none;' onclick = "filterArgs[3]='Month';chg_DateRng('MON');cfrm();" >Month
		<input class ="slct" type = "Radio" name  = "rng" id  = "rngQTR" style='display:none;' onclick = "filterArgs[3]='QTR';chg_DateRng('QTR');cfrm();" >QTR--->
		&nbsp;&nbsp;&nbsp;&nbsp;Starting:
		<select class ="slct" name = "selDate" id = "selDate" onchange = "filterArgs[4]=this.options[this.selectedIndex].text;cfrm();">
		</select>
	</fieldset>
	<fieldset class="fset"><legend>Level :</legend>
		<select class ="slct" name="selDir" id="selDir" onchange = "filterArgs[5]=this.options[this.selectedIndex].text;cfrm();">
		<option value = 'O'>Originating From View</option> 
		<option value = 'D'>Destinating to View</option> 
		</select> 
		<input type = "hidden" name = "rlupv"  id = "rlupv"value = '1'>
	</fieldset>
	<!---<br>
	<br>--->
	<fieldset class="" style='display:none;' ><legend>Mail Class</legend>
		<select class ="slct" name="selClasses" id ="selClasses" onchange="filterArgs[7]=this.options[this.selectedIndex].text;(this.value==1)?document.getElementById('selEod').value='Y':'';document.getElementById('airField').style.display=((this.value==1)?'':'none');get_std();cfrm()">               
		<option value="1" >First</option>
		<option value="2">Periodicals</option>
		<option value="3" selected>Standard</option>           
		</select>
	</fieldset>
	<fieldset class="" style='display:none;' ><legend>Service Standard</legend>
	<select class ="slct" name="selHybStds" id ="selHybStds"  onChange="filterArgs[8]=this.options[this.selectedIndex].text;cfrm()" >                  
	</select>
	</fieldset>
	<fieldset class="" id='airField' style='display:none'><legend><label for="selAir">Surface / Air:</label></legend>		
		<select class ="slct" name="selAir" id="selAir" onChange="cfrm();">
		<option value="">Combined</option>
		<option value="Y" >Air Only</option>
		<option value="N" >Surface Only</option>
		</select>
		<label for="selMode">Mode:</label>
		<select class ="slct" name="selMode" id="selMode" onChange="cfrm();">
		<option value="Y" >Matrix</option>
		<option value="N" >Measured</option>
		</select>
	</fieldset>
	<fieldset class="" style='display:none;' ><legend></legend>
		<!--<input class ="slct" type = "checkbox" name  = "cat1" id  = "cat1" onclick = "cfrm();cat_sel(1);cat_filt('Letters');">Letters
		<input class ="slct" type = "checkbox" name  = "cat2" id  = "cat2" onclick = "cfrm();cat_sel(3);cat_filt('Cards');" >Cards
		<input class ="slct" type = "checkbox" name  = "cat3" id  = "cat3" onclick = "cfrm();cat_sel(2);cat_filt('Flats');" >Flats--->
		<input class ="slct" type = "checkbox" name  = "selFSSck" id  = "selFSSck" onclick = "cfrm();document.getElementById('selFSS').value=((this.checked)?'Y':'');cat_filt('FSS');" >FSS Only
		<input class ="slct" type = "checkbox" name  = "chkpol" id  = "chkpol" onclick = "cfrm();document.getElementById('selPOL').value=((this.checked)?'Y':'');cat_filt('Political');" >Politcal Mailings Only
		<input type = "hidden" name = "selCategory" id = "selCategory" value = ''>
		<input type = "hidden" name = "selFSS" id = "selFSS" value = ''>
		<input type = "hidden" name = "selPOL" id = "selPOL" value = ''>
		<input type = "hidden" name = "selCntrLvl" id = "selCntrLvl" value = ''>
		<input type = "hidden" name = "rdCert" id = "rdCert" value = ''>
	</fieldset>
	<!---<br>
	<br>--->
	<fieldset class="fset"><legend></legend>
		<input class ="slct" id="subtn" type = "button" value = "Submit Request" onClick="document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';cfrm_sub();">        
	</fieldset>
	<fieldset class="fset"><legend></legend>
		<input class ="slct" id="hideFilt" type = "button" value = "Hide" onClick="document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';d3.select('#flist').style('display','');">        
	</fieldset>
	<!--- <fieldset class="fset"><legend>Facility</legend>  <select name="selFacility" id= "selFacility" style="min-width:200px"  class="slct"></select>   </fieldset>  --->    
</div>
	<fieldset class="fset" id="sFilt" style='display:none'><legend></legend>
		<input class ="slctSmall" type = "button" value = "Show Filters" onClick="document.getElementById('filtDiv').style.display='';d3.select('#flist').style('display','none');document.getElementById('sFilt').style.display='none';">
		<div id='flist' style='float:right'></div>
	</fieldset>
</fieldset>
<h2>Performance By Week</h2><iframe id="txtArea1" style="display:none"></iframe>
<div id ="loaderDiv" style="z-index: 3;"></div>


<div style='margin:0px 150px 300px 150px;'>
<div style="margin:50px;float:left;max-width:380px;text-align:center;text-variant: small-caps;font-family: times, Times New Roman;"><legend style='font-weight:bold;font-size: 24px;'>Overall Score</legend><div id="OverallScore" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div style="margin:50px;float:left;max-width:380px;text-align:center;text-variant: small-caps;font-family: times, Times New Roman;"><legend style='font-weight:bold;font-size: 24px;'>Overall Failed Pieces</legend><div id="OverallFail" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div style="margin:50px;float:left;max-width:380px;text-align:center;text-variant: small-caps;font-family: times, Times New Roman;"><legend style='font-weight:bold;font-size: 24px;'>Overall Pieces</legend><div id="OverallPieces" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div id="color-key" style='margin:50px;float:left;'>
	<strong>Color Key</strong>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;background-color:#4575b4"></div><span>Score 95&ndash;100%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;background-color:#91bfdb"></div><span>Score 90&ndash;95%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;background-color:#fee090"></div><span>Score 80&ndash;90%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;background-color:#fc8d59"></div><span>Score 70&ndash;80%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;background-color:#d73027"></div><span>Score 0&ndash;70%</span>
	</div>
</div>
<input type='button' id="RAll" style="font-size: 10px;border:none;text-decoration:underline;padding:10px 0px;background:transparent;color:white;height:40px;width:80px;cursor:pointer;" value='Reset All' onClick='resetAll();'/>
</div>
<div style=''>
<div id="chart-EOD" style="float:left;max-width:380px;"></div>
<div id="chart-DOW" style="float:left;max-width:380px;"></div>
<div id="chart-Class" style="float:left;max-width:380px;"></div>
<div id="chart-Shape" style="float:left;max-width:380px;"></div>
</div>
<div style=''>
<div id="chart-Area" style="float:left;max-width:380px;"></div>
<div id="chart-District" style="float:left;max-width:380px;"></div>
<div id="chart-Facility" style="float:left;max-width:380px;"></div>
<div id="chart-SVCSTD" style="float:left;max-width:380px;"></div>
<div id="chart-Entry" style="float:left;max-width:380px;"></div>
<div id="chart-Level" style="float:left;max-width:380px;"></div>
</div>
<input class ="hyperFont" type = "button" id='eOut' value = "Excel" onClick="excel_out();" style='display:none;margin:0px 0px 0px 30px;'>
<div id ="tableDiv" style='margin:0px 0px 10px 30px'></div>
<div id ="mainDiv" ></div>
</div>
</body>
</html>