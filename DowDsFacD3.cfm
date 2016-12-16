<!doctype html>
<cfajaxproxy cfc="DowDsFacD3" jsclassname="DDF">
<cfajaximport>

<cfsetting showdebugoutput="no">

<cfparam name="chkpol" default="">
<cfparam name="selDOW" default="7">
<cfparam name="selEod" default="Y">
<cfparam name="selDir" default="O">
<cfparam name="selHybStd" default="11">
<cfparam name="selClass" default="1">
<cfparam name="selCategory" default="1,3">
<cfparam name="selArea" default="All">
<cfparam name="selDistrict" default="All">
<cfparam name="selFacility" default="37571">
<cfparam name="selFSS" default="">
<cfparam name="selAir" default="">
<cfparam name="selMode" default="Y">
<cfparam name="rpt_range" default="WEEK">
<cfparam name="WKN" default="">
<cfparam name="BG_DATE" default="">
<cfparam name="ED_DATE" default="">

<html>
<head>
<meta charset="utf-8">
<title>Day of the Week Facilities</title>
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
	<cfoutput>
	var params=['#selFacility#','#selDOW#','#selEod#','#selDir#','#selHybStd#','#selClass#','#selCategory#','#selFSS#','#selAir#','#selMode#','#rpt_range#','#BG_DATE#','#chkpol#']
	</cfoutput>
	var initLoader = loader({width: 480, height: 150, container: "#mainDiv", id: "initLoader",msg:"Loading . . . "});
	var myLoader = loader({width: 480, height: 150, container: "#loaderDiv", id: "loader",msg:"Loading . . . "});

	var filterHds = ['Entry :','DOW :','Range :','Date :','Level :','Class :','Std. :','Shape :'];
	var filterArgs = ['Destination','Saturday','Week','04/23/2016','Originating From View','Standard','DSCF 3-4','Letters'];
	
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

	function data_err(res)
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
		.key(function(d){ return d.FAC_KEY+''+d.DESTN_FAC_ZIP_3;})
		.rollup(function(d) { return [(d3.sum(d,function(d2){return d2.TP_SAT;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_SAT;})/d3.sum(d,function(d2){return d2.TP_SAT;}),
		(d3.sum(d,function(d2){return d2.TP_SUN;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_SUN;})/d3.sum(d,function(d2){return d2.TP_SUN;}),
		(d3.sum(d,function(d2){return d2.TP_MON;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_MON;})/d3.sum(d,function(d2){return d2.TP_MON;}),
		(d3.sum(d,function(d2){return d2.TP_TUE;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_TUE;})/d3.sum(d,function(d2){return d2.TP_TUE;}),
		(d3.sum(d,function(d2){return d2.TP_WED;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_WED;})/d3.sum(d,function(d2){return d2.TP_WED;}),
		(d3.sum(d,function(d2){return d2.TP_THU;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_THU;})/d3.sum(d,function(d2){return d2.TP_THU;}),
		(d3.sum(d,function(d2){return d2.TP_FRI;})<=0)?0:1-d3.sum(d,function(d2){return d2.FP_FRI;})/d3.sum(d,function(d2){return d2.TP_FRI;})]; })
		.entries(res);
		
		var dataGroup2 = d3.nest()
		.key(function(d){ return d.FAC_KEY+''+d.DESTN_FAC_ZIP_3;})
		.rollup(function(d) { return [
		[d3.sum(d,function(d2){return d2.TP_SAT;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_SUN;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_MON;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_TUE;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_WED;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_THU;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.TP_FRI;}),d3.min(d,function(d2){ return d.FAC_NAME;})]]; })
		.entries(res);
		
		var dataGroup3 = d3.nest()
		.key(function(d){ return d.FAC_KEY+''+d.DESTN_FAC_ZIP_3;})
		.rollup(function(d) { return [
		[d3.sum(d,function(d2){return d2.FP_SAT;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_SUN;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_MON;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_TUE;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_WED;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_THU;}),d3.min(d,function(d2){ return d.FAC_NAME;})],
		[d3.sum(d,function(d2){return d2.FP_FRI;}),d3.min(d,function(d2){ return d.FAC_NAME;})]]; })
		.entries(res);
		
		var w = 600;
		var h = 300;
		var padding = 60;

		var high = d3.max(dataGroup2,function(d){if(d.key =='Overall Totals' || d.key=='')return 0; return  d3.max(d.values,function(d2){return d2[0];});});
		var low = d3.min(dataGroup3,function(d){if(d.key =='Overall Totals' || d.key=='')return high;return  d3.min(d.values,function(d2){return d2[0];});});
		
		//var high2 = d3.max(dataGroup2,function(d){if(d.key =='Overall Totals' || d.key=='')return  d3.max(d.values,function(d2){return d2[0];}); return 0;});
		//var low2 = d3.min(dataGroup3,function(d){if(d.key =='Overall Totals' || d.key=='')return d3.min(d.values,function(d2){return d2[0];});return high2;});
		
		//Create scale functions
		xScale = d3.scale.ordinal().rangeBands([padding, w-padding]);

		yScale = d3.scale.linear()
			 .domain([0,1])
			 .range([h - padding, padding]);
			 
		yScale2 = d3.scale.linear()
			 .domain([low,high])
			 .range([h - padding, padding]);
			 
		/*yScaleTot = d3.scale.linear()
			 .domain([low2,high2])
			 .range([h - padding, padding]);*/
							 
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
						  
	/*	yAxisTot = d3.svg.axis()
						  .scale(yScaleTot)
						  .orient("right")
						  //.innerTickSize(-(w-padding*2))
						  .ticks(10)
						  .tickFormat(siF);
*/
		
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
			   .attr("class", function(d) {return 'F'+d.key.replace(/[\/& ]/g,"_");})
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
			   .attr("class", function(d) {return 'F'+d.key.replace(/[\/& ]/g,"_");})
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
			.attr("class", function(d) {return 'F'+d.key.replace(/[\/& ]/g,"_");})
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
			   .attr("class", function(d) {return 'F'+d.key.replace(/[\/& ]/g,"_");})
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
	
	function get_val(v)
	{
	 var sel=document.getElementById(v);
	 return sel.options[sel.selectedIndex].value; 
	}

	function cfrm()
	{
	document.getElementById("subtn").style.border = 'Red 4px solid';
	}	

	function init()
	{
		/*myLoader();
		var e=new DDF();
		e.setCallbackHandler(makeTable);	
		e.setErrorHandler(data_err);
		e.getMainData('<cfoutput>#opsvisdata#</cfoutput>','1','O','N',"04/09/2016","04/16/2016","All","All","3","1","","","","","Y","","34",'');*/
		
		/*var e=new DDF();
		e.setCallbackHandler(load_Area_Dist);	
		e.setErrorHandler(data_err);
		e.getAreaDistData('<cfoutput>#opsvisdata#</cfoutput>');*/
		
		if(params[10]=='MON')
		{
			d3.select('#rngMON').attr('checked',true);filterArgs[2]='Month';
		}
		else if(params[10]=='QTR')
		{
			d3.select('#rngQTR').attr('checked',true);filterArgs[2]='QTR';
		}
		if(params[6].search("1")>=0)
		{
			d3.select('#cat1').attr('checked',true);
		}else		
			cat_filt('Letters');
			
		if(params[6].search("3")>=0)
		{
			d3.select('#cat2').attr('checked',true);
			cat_filt('Cards');
		}
		if(params[6].search("2")>=0)
		{
			d3.select('#cat3').attr('checked',true);
			cat_filt('Flats');
		}
		
		d3.select('#selDOW').node().value=params[1];
		d3.select('#selEod').node().value=params[2];
		d3.select('#selDir').node().value=params[3];
		d3.select('#selClass').node().value=params[5];
		d3.select('#selCategory').node().value=params[6];
		(params[7]!='')?d3.select('#selFSSck').attr('checked',true):'';
		d3.select('#selFSS').node().value=params[7];
		d3.select('#selAir').node().value=params[8];
		d3.select('#selMode').node().value=params[9];
		(params[12]!='')?d3.select('#chkpol').attr('checked',true):'';
		d3.select('#selPOL').node().value=params[12];
		
		var e=new DDF();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(data_err);
		e.getDates('<cfoutput>#opsvisdata#</cfoutput>',params[10]);
		
		get_std();
		var e=new DDF();
		e.setCallbackHandler(makeTable);	
		e.setErrorHandler(data_err);
		<cfoutput>e.getMainData('#opsvisdata#','#selDir#','#selEod#','#BG_DATE#','#ED_DATE#','#selClass#','#selCategory#','#selFSS#','#selMode#','#selAir#',"","Y",'#chkpol#','#selHybStd#','','#selFacility#','#selDOW#','','0');</cfoutput>
		document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';
		myLoader();
		listSelections();
		document.getElementById("subtn").style.border = 'none';
	}

	function chg_DateRng(n)
	{
		var e=new DDF();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(data_err);
		e.getDates('<cfoutput>#opsvisdata#</cfoutput>',n);
	}

	function cfrm_sub()
	{
		myLoader();
		listSelections();
		document.getElementById("subtn").style.border = 'none';
		//document.getElementById('selArea').selectedOptions[0].text
		//var srlupv = document.getElementById('rlupv').value;
		var sdir = document.getElementById('selDir').value;
		var seod = document.getElementById('selEod').value;
		var sd = document.getElementById('selDate');
		var sdend='';
		if(sd.selectedIndex >0)
		{
			sdend=sd.options[sd.selectedIndex-1].value;
		}
		sd=sd.value;
		//var sarea = document.getElementById('selArea').value;
		//var sdist = document.getElementById('selDistrict').value;
		var sclass = document.getElementById('selClass').value;
		var scat = document.getElementById('selCategory').value;
		var sfss = document.getElementById('selFSS').value;
		var smode = '';
		var sair = '';
		var spol = document.getElementById('selPOL').value;
		var shyb = document.getElementById('selHybStd').value;
		var lvl = document.getElementById('selLvl').value;
		var selDest = document.getElementById('selDestFac').value;
			
		if(sclass==1)
		{
			smode = document.getElementById('selMode').value;
			sair = document.getElementById('selAir').value;
		}
		
		var sDOW = document.getElementById('selDOW').value;
		var e=new DDF();
		e.setCallbackHandler(makeTable);	
		e.setErrorHandler(data_err);
		e.getMainData('<cfoutput>#opsvisdata#</cfoutput>',sdir,seod,sd,sdend,sclass,scat,sfss,smode,sair,"","Y",spol,shyb,'',params[0],sDOW,selDest,lvl);
	}
	
	function listSelections()
	{		
		//var filterHds = ['Entry: ','Area: ','District: ','Range: ','Date: ','Level: ','Rollup: ','Class: ','Std.: ','Shape: ']
		//var filterArgs = ['Destination','National','','Week','04/23/2016','Originating From View','Area','Standard','DSCF 3-4','Letters']
		d3.select('#flist').style('display','');
		d3.select('#flist').selectAll('span').remove();
		d3.select('#flist').selectAll('span').data(filterHds).enter().append('span').attr('class','smallFnt').text(function(d,i){return d+' : '+filterArgs[i];});
		
	}

	function load_std(res)
	{
		var sel=document.getElementById('selHybStd')
		sel.length=0;
		res.forEach(function(d,i){			
			sel.options[sel.options.length]= 	new Option(d[1],d[0]);
			if(params[4]==d[0])
				sel.selectedIndex = i;
		});
		if(document.getElementById('selClass').value==3)
			sel.selectedIndex=1;
		filterArgs[6]=res[sel.selectedIndex][1];
		cfrm();
	}

	function std_err(res)
	{
		alert(res);
	}

	function get_std()
	{
		var seod = document.getElementById('selEod').value;
		var sclass = document.getElementById('selClass').value;

		var e=new DDF();
		e.setCallbackHandler(load_std);	
		e.setErrorHandler(std_err);
		e.getHybStd('<cfoutput>#opsvisdata#</cfoutput>',sclass,seod);
	}

	function chg_area()
	{
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
		if(filterArgs[7]=='')
		{
			filterArgs[7]=n;
			return;
		}
		var scAr = filterArgs[7].split(',');
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
		filterArgs[7]=hold.toString();
		
	}

	function load_Dates(res)
	{
		var sel = document.getElementById('selDate');
		sel.options.length=0;
		res.forEach(function(d,i){
			sel.options[sel.options.length]= 	new Option(d,d);
			if(params[11]==d)
				sel.selectedIndex = i;
		});
		filterArgs[3] = sel.options[sel.selectedIndex].value;
		listSelections();
	}

	/*
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
		var sel = document.getElementById('selArea');
		sel.options.length=1;
		ADHier.forEach(function(d,i){
			sel.options[sel.options.length]= 	new Option(d.values[0].values[0][0],d.key);
		});
	}

	function load_district()
	{
		var sa = document.getElementById('selArea').value;
		var sel = document.getElementById('selDistrict');
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
		
	window.open('DOW_DS_FAC.cfm?WKN='+sd+'&BG_DATE=' +sd+"&ED_DATE="+sdend+"&RPT_RANGE="+rng+"&SELAREA="+sarea+"&SELDISTRICT="+sdist
	+"&SELCATEGORY="+scat+"&SELCLASS="+sclass+"&SELDIR="+sdir
	+"&SELEOD="+seod+"&SELFACILITY="+fac+"&SELFSS="+sfss
	+"&SELHYBSTD="+shyb+"&selAir="+sair+"&selMode="+smode
	+"&SELORG3="+zip3
		,'_self ');
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
		
		window.open('Trend_Day_mailers.cfm?WKN='+sd+'&BG_DATE=' +sd+"&ED_DATE="+sdend+"&RPT_RANGE="+rng+"&SELAREA="+sarea+"&SELDISTRICT="+sdist
		+"&SELCATEGORY="+scat+"&SELCLASS="+sclass+"&SELDIR="+sdir
		+"&SELEOD="+seod+"&SELFACILITY="+fac+"&SELFSS="+sfss
		+"&SELHYBSTD="+shyb+"&selAir="+sair+"&selMode="+smode
		+"&selDOW="+dow
		,'_self ');

	}
*/

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
		
		BarChart(data);
		var lvl = document.getElementById('selLvl').value;
		res=[];totalNames=[];
		
		var count=0;
		var count=0;
		data.forEach(function(d,i){
			res[i]=[];
			count=0;
			var N = [((d.IMB_DLVRY_ZIP_3)?d.IMB_DLVRY_ZIP_3:''),d.DESTN_FAC_ZIP_3,d.FAC_KEY];
			res[i][count++]=[(lvl==0)?d.FAC_NAME:d.FAC_NAME+'-'+d.IMB_DLVRY_ZIP_3,d.FAC_KEY+''+d.DESTN_FAC_ZIP_3,N];
			res[i][count++]=[d.FP_SAT,d.TP_SAT,N];
			res[i][count++]=d.PER_SAT;
			res[i][count++]=[d.FP_SUN,d.TP_SUN,N];
			res[i][count++]=d.PER_SUN;
			res[i][count++]=[d.FP_MON,d.TP_MON,N];
			res[i][count++]=d.PER_MON;
			res[i][count++]=[d.FP_TUE,d.TP_TUE,N];
			res[i][count++]=d.PER_TUE;
			res[i][count++]=[d.FP_WED,d.TP_WED,N];
			res[i][count++]=d.PER_WED;
			res[i][count++]=[d.FP_THU,d.TP_THU,N];
			res[i][count++]=d.PER_THU;
			res[i][count++]=[d.FP_FRI,d.TP_FRI,N];
			res[i][count++]=d.PER_FRI;			
			res[i][count++]=[d.FP_TOT,d.TP_TOT,N];
			res[i][count++]=d.PER_TOT;
			
		});
		
		
		h1row=['Down Stream Facility','Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Total'];
		thead.append('tr')
		.selectAll('th').data(h1row).enter()
		.append('th')
		.style('padding','3px')
		.attr('colSpan',function(d,i){if(i==0) return 1;return 2;})
		.attr('rowSpan',function(d,i){if(i==0) return 2;return 1;})
		.text(function(d){return d;});
		
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
			var hold;
			hold='F'+d[0][1];			
			d3.select('#gphName').text('for '+d[0][0]);
			d3.select('#mainContainer').selectAll('g').attr('opacity',0)
			   .style("display", 'none');
			d3.selectAll('.'+hold.replace(/[\/& ]/g,"_"))
			   .style("display", '').transition().attr('opacity',1);
		})
		.selectAll('td').data(function(d){return d}).enter()
		.append('td')
		.style('padding','3px')
		.style('text-decoration',function(d,i){if((i==0 && lvl==0) || (i>0 && d.length == 3 && i < 15))return 'underline';})
		.style('color',function(d,i){if((i==0 && lvl==0) || (i>0 && d.length == 3 && i < 15))return 'blue';})
		.style('cursor',function(d,i){if((i==0 && lvl==0) || (i>0 && d.length == 3 && i < 15))return 'pointer';})
		.on('click',function(d,i){
			if(d.length == 3 && i < 15){if(i>0)Diag_Report_Lnk(d[2],i); if(i==0 && lvl==0)diag_lnk(d[2],i);}
		})
		.attr('title',function(d,i){if(d.length == 3)return 'Failed Pieces: '+comF(d[0])+'\nTotal Pieces: '+comF(d[1]);})
		.style('text-align',function(d,i) {return (i==0) ? 'Left' : 'Center'})
		.text(function(d,i){if(d.length == 3){if(d[0]>0&&d[0]<1)return perF(d[0]);if(d[0]>100)return siF(d[0]);return d[0];}else{if(d>0&&d<1)return perF(d);if(d>100)return siF(d);return d;}});
		
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
	
	function diag_lnk(N,place)
	{
		document.getElementById('selLvl').value=1;
		document.getElementById('selDestFac').value=N[2];
		cfrm_sub();
	}
	
	function Diag_Report_Lnk(N,place)
	{
		if(place > 1)
			place=(place-1)/2;
		if(place == 1)
			place = 7;
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
		var sarea = '';//document.getElementById('selArea').value;
		var sdist = '';//document.getElementById('selDistrict').value;
		var sdir = document.getElementById('selDir').value;
		var seod = document.getElementById('selEod').value;
		var scat = document.getElementById('selCategory').value;
		var sfss = document.getElementById('selFSS').value;
		var shyb = document.getElementById('selHybStd').value;
		var sDOW = document.getElementById('selDOW').value;

		/*window.open('DiagReportD3.cfm?WKN='+sd+'&BG_DATE=' +sd+"&ED_DATE="+sdend+"&RPT_RANGE="+rng+"&SELAREA="+sarea+"&SELDISTRICT="+sdist
		+"&SELCATEGORY="+scat+"&SELCLASS="+sclass+"&SELDIR="+sdir
		+"&SELEOD="+seod+"&SELFACILITY="+params[0]+"&SELFSS="+sfss
		+"&SELHYBSTD="+shyb+"&selAir="+sair+"&selMode="+smode
		+"&selDow="+sDOW+"&selMailer="+"&selImbZip3="+N[0]
		+'&selOrg3='+'&selDest3='+N[1]+'&selPhysCntr='+''+'&selDestFac='+N[2]
		,'_DiagRep ');
		*/
		
		var lnkForm = d3.select("body")
		.append("form")
		.attr("method","post")
		.attr("target","_DiagRep")
		.attr("action","DiagReportD3.cfm")
		.attr("name","link_form")
		
		lnkForm.append("input").attr("type","hidden").attr("name","SELAREA").attr("value",sarea);
		lnkForm.append("input").attr("type","hidden").attr("name","SELDISTRICT").attr("value",sdist);
		lnkForm.append("input").attr("type","hidden").attr("name","SELFACILITY").attr("value",params[0]);
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
		lnkForm.append("input").attr("type","hidden").attr("name","selMailer").attr("value",params[13]);
		lnkForm.append("input").attr("type","hidden").attr("name","selHybStd").attr("value",shyb);
		lnkForm.append("input").attr("type","hidden").attr("name","selDOW").attr("value",sDOW);
		lnkForm.append("input").attr("type","hidden").attr("name","selOrg3").attr("value",'');
		//lnkForm.append("input").attr("type","hidden").attr("name","selCntrLvl").attr("value","");
		//lnkForm.append("input").attr("type","hidden").attr("name","rdCert").attr("value","Y");
		//lnkForm.append("input").attr("type","hidden").attr("name","chkPol").attr("value",spol);
		//lnkForm.append("input").attr("type","hidden").attr("name","selOrgFac").attr("value",params[0]);
		//lnkForm.append("input").attr("type","hidden").attr("name","selvariance").attr("value","");
		//lnkForm.append("input").attr("type","hidden").attr("name","fp_chk").attr("value","");
		lnkForm.append("input").attr("type","hidden").attr("name","selDest3").attr("value",N[1]);
		lnkForm.append("input").attr("type","hidden").attr("name","selPhysCntr").attr("value",'');
		lnkForm.append("input").attr("type","hidden").attr("name","selDestFac").attr("value",N[2]);
		lnkForm.append("input").attr("type","hidden").attr("name","selImbZip3").attr("value",N[0]);
		
		document.link_form.submit();
		
		lnkForm.remove();
	}
	
<!---
	function fp(fd,d,bg,ed,fz,imb)
	{
		//alert(d+' '+fd+' '+bg+' '+ed);
		var dt = new Date(bg);
		var et = new Date(ed);

		if (imb)
			document.rpt_form.selImbZip3.value = imb;
		else 
			document.rpt_form.selImbZip3.value = '';
		document.rpt_form.selDestFac.value = fd; 
		document.rpt_form.selDest3.value = fz; 
		if ((et-dt)/(1000*60*60*24) < 7)  
		{
			if (d != 7) 
				dt = new  Date(dt.getFullYear(),dt.getMonth(),dt.getDate()+d);
			dt = (dt.getMonth()+1)+'/'+dt.getDate()+'/'+dt.getFullYear();
			document.rpt_form.selDate.value = dt;
			document.rpt_form.action = 'diag_Frame.cfm';
			document.rpt_form.target = 'DOW_Diagnostic';
			document.rpt_form.method = 'Post';
			document.rpt_form.submit()
			document.rpt_form.action = <cfoutput>'#fa#'</cfoutput>;
			document.rpt_form.target = '';
		}
		if ((et-dt)/(1000*60*60*24) > 6)  
		{
			window.open('','DAY_STC','height=300,width=400,menubar=no,toolbar=no,top=50,left=50,resizable=yes,scrollbars=yes');
			document.rpt_form.selDay.value = d;
			document.rpt_form.action = 'DOW_RNG.cfm';
			document.rpt_form.target = 'DAY_STC';
			document.rpt_form.method = 'Post';
			document.rpt_form.submit()
			document.rpt_form.action = <cfoutput>'#fa#'</cfoutput>;
			document.rpt_form.target = '';
			//document.rpt_form.selDestFac.value = '';
		}

	}
--->
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
	<fieldset class="fset"><legend>Entry Type:</legend>
		<select class ="slct" id = "selEod" name = "selEod" onChange="filterArgs[0]=this.options[this.selectedIndex].text;get_std();" >
		<option value="Y">Origin</option>
		<option value='N' selected>Destination</option>   
		</select>
	</fieldset>
	<fieldset class="fset"><legend>Report For:</legend>
		<select class ="slct" name="selDOW" id="selDOW" onChange="filterArgs[1]=this.options[this.selectedIndex].text;">
			<option value = '7'>Saturday</option> 
			<option value = '1'>Sunday</option> 
			<option value = '2'>Monday</option> 
			<option value = '3'>Tuesday</option> 
			<option value = '4'>Wednesday</option> 
			<option value = '5'>Thursday</option> 
			<option value = '6'>Friday</option> 
		</select>
	</fieldset>
	<br>
	<br>
	<fieldset class="fset"><legend>Date By:</legend>
		<input class ="slct" type = "Radio" name  = "rng" id  = "rngWK" onclick = "filterArgs[2]='Week';chg_DateRng('WEEK');cfrm();" checked>Week
		<input class ="slct" type = "Radio" name  = "rng" id  = "rngMON" onclick = "filterArgs[2]='Month';chg_DateRng('MON');cfrm();" >Month
		<input class ="slct" type = "Radio" name  = "rng" id  = "rngQTR" onclick = "filterArgs[2]='QTR';chg_DateRng('QTR');cfrm();" >QTR
		&nbsp;&nbsp;&nbsp;&nbsp;Starting:
		<select class ="slct" name = "selDate" id = "selDate" onchange = "filterArgs[3]=this.options[this.selectedIndex].text;cfrm();">
		</select>
	</fieldset>
	<fieldset class="fset"><legend>Level :</legend>
		<select class ="slct" name="selDir" id="selDir" onchange = "filterArgs[4]=this.options[this.selectedIndex].text;cfrm();">
		<option value = 'O'>Originating From View</option> 
		<option value = 'D'>Destinating to View</option> 
		</select> 
		<input type = "hidden" name = "rlupv"  id = "rlupv"value = '1'>
	</fieldset>
	<br>
	<br>
	<fieldset class="fset"><legend>Mail Class</legend>
		<select class ="slct" name="selClass" id ="selClass" onchange="filterArgs[5]=this.options[this.selectedIndex].text;(this.value==1)?document.getElementById('selEod').value='Y':'';document.getElementById('airField').style.display=((this.value==1)?'':'none');get_std();cfrm()">               
		<option value="1" >First</option>
		<option value="2">Periodicals</option>
		<option value="3" selected>Standard</option>           
		</select>
	</fieldset>
	<fieldset class="fset"><legend>Service Standard</legend>
	<select class ="slct" name="selHybStd" id ="selHybStd"  onChange="filterArgs[6]=this.options[this.selectedIndex].text;cfrm()" >                  
	</select>
	</fieldset>
	<fieldset class="fset" id='airField' style='display:none'><legend><label for="selAir">Surface / Air:</label></legend>		
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
	<fieldset class="fset"><legend>Shape</legend>
		<input class ="slct" type = "checkbox" name  = "cat1" id  = "cat1" onclick = "cfrm();cat_sel(1);cat_filt('Letters');" checked>Letters
		<input class ="slct" type = "checkbox" name  = "cat2" id  = "cat2" onclick = "cfrm();cat_sel(3);cat_filt('Cards');" >Cards
		<input class ="slct" type = "checkbox" name  = "cat3" id  = "cat3" onclick = "cfrm();cat_sel(2);cat_filt('Flats');" >Flats
		<input class ="slct" type = "checkbox" name  = "selFSSck" id  = "selFSSck" onclick = "cfrm();document.getElementById('selFSS').value=((this.checked)?'Y':'');cat_filt('FSS');" >FSS Only
		<input class ="slct" type = "checkbox" name  = "chkpol" id  = "chkpol" onclick = "cfrm();document.getElementById('selPOL').value=((this.checked)?'Y':'');cat_filt('Political');" >Politcal Mailings Only
		<input type = "hidden" name = "selCategory" id = "selCategory" value = '1'>
		<input type = "hidden" name = "selFSS" id = "selFSS" value = ''>
		<input type = "hidden" name = "selPOL" id = "selPOL" value = ''>
		<input type = "hidden" name = "selCntrLvl" id = "selCntrLvl" value = ''>
		<input type = "hidden" name = "rdCert" id = "rdCert" value = ''>
		<input type = "hidden" name = "selLvl" id = "selLvl" value = '0'>
		<input type = "hidden" name = "selDestFac" id = "selDestFac" value = ''>
	</fieldset>
	<br>
	<br>
	<fieldset class="fset"><legend></legend>
		<input class ="slct" id="subtn" type = "button" value = "Submit Request" onClick="document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';cfrm_sub();">        
	</fieldset>
	<!--- <fieldset class="fset"><legend>Facility</legend>  <select name="selFacility" id= "selFacility" style="min-width:200px"  class="slct"></select>   </fieldset>  --->    
</div>
	<fieldset class="fset" id="sFilt" style='display:none'><legend></legend>
		<input class ="slctSmall" type = "button" value = "Show Filters" onClick="document.getElementById('filtDiv').style.display='';d3.select('#flist').style('display','none');document.getElementById('sFilt').style.display='none';">
		<div id='flist' style='float:right'></div>
	</fieldset>
</fieldset>
<h2>Performance by Start the Clock Day of the Week</h2><iframe id="txtArea1" style="display:none"></iframe>
<div id ="loaderDiv" style="z-index: 3;"></div>
<input class ="hyperFont" type = "button" id='eOut' value = "Excel" onClick="excel_out();" style='display:none;margin:0px 0px 0px 30px;'>
<div id ="tableDiv" style='margin:0px 0px 10px 30px'></div>
<div id ="mainDiv" ></div>
</div>
</body>
</html>