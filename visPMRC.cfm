<!doctype html>
<cfajaxproxy cfc="visPMRC" jsclassname="TDF">
<cfajaximport>

<cfsetting showdebugoutput="no">
<cfset datasource = 'teradata_prod'>
<html>
<head>
<meta charset="utf-8">
<title>Priority Mail Root Cause [DEV]</title>
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

.scrollup {
	background: silver;
	//border: 2px groove black;
	border-radius: 5px;
    box-shadow: 0px 0px 1px #21435F;
	cursor:pointer;
}

.scrollupArrow {
	margin: auto;
	transform:translateY(70%);
	width: 0; 
	height: 0; 
	border-left: 5px solid transparent;
	border-right: 5px solid transparent;

	border-bottom: 5px solid black;
}

.scrolldownArrow {
	margin: auto;
	transform:translateY(80%);
	width: 0; 
	height: 0; 
	border-left: 5px solid transparent;
	border-right: 5px solid transparent;

	border-top: 5px solid black;
}

.scrolldown {
	background: silver;
	//border: 2px groove black;
	border-radius: 5px;
    box-shadow: 0px 0px 1px #21435F;
	cursor:pointer;
}

.scrolltrack {
	background: #21435F;
	//border: 2px groove black;
	border-radius: 5px;
    box-shadow: 0px 0px 1px #21435F;
}

.scrollDragBar {
	background: silver;
	//border: 2px groove black;
	border-radius: 5px;
	cursor:pointer;
	-moz-box-shadow: 0px 0px 6px -1px black;
	-webkit-box-shadow: 0px 0px 6px -1px black;
	box-shadow: 0px 0px 6px -1px black;
	background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, silver), color-stop(1, #bab1ba));
	background:-moz-linear-gradient(top, silver 5%, #bab1ba 100%);
	background:-webkit-linear-gradient(top, silver 5%, #bab1ba 100%);
	background:-o-linear-gradient(top, silver 5%, #bab1ba 100%);
	background:-ms-linear-gradient(top, silver 5%, #bab1ba 100%);
	background:linear-gradient(to bottom, silver 5%, #bab1ba 100%);
	filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='silver', endColorstr='#bab1ba',GradientType=0);
	background-color:silver;
	//-moz-border-radius:15px;
	//-webkit-border-radius:15px;
	//border-radius:15px;
	//border:1px solid #d6bcd6;
	cursor:pointer;
}
.scrollDragBar:hover {
	background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #bab1ba), color-stop(1, #ededed));
	background:-moz-linear-gradient(top, #bab1ba 5%, #ededed 100%);
	background:-webkit-linear-gradient(top, #bab1ba 5%, #ededed 100%);
	background:-o-linear-gradient(top, #bab1ba 5%, #ededed 100%);
	background:-ms-linear-gradient(top, #bab1ba 5%, #ededed 100%);
	background:linear-gradient(to bottom, #bab1ba 5%, #ededed 100%);
	filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#bab1ba', endColorstr='#ededed',GradientType=0);
	background-color:#bab1ba;
}
.bottomAxis text {
	transform: rotate(45deg);
	text-anchor: start;
}
.topAxis text {
	transform: rotate(45deg);
	text-anchor: end;
}
.leftAxis text {
	text-anchor: end;
}
.rightAxis text {
	text-anchor: start;
}

.brush rect.extent {
  fill: steelblue;
  fill-opacity: .125;
}

.brush .resize path {
  fill: #eee;
  stroke: #777;
}

.labelTip {		
    text-align: left;
    padding: 5px;				
    font-size: 14px;
	text-variant: small-caps;
	font-family: times, Times New Roman;
    //background: black;
	color:white;
    border: 0px;		
    border-radius: 8px;			
    pointer-events: none;
}

.tooltip {
	position: absolute;			
    text-align: left;			
   // width: 60px;					
    //height: 28px;					
    padding: 5px;				
    font-size: 14px;
	text-variant: small-caps;
	font-family: times, Times New Roman;
    background: black;
	color:white;
    border: 0px;		
    border-radius: 8px;			
    pointer-events: none;	
	
   // position: relative;
    //display: inline-block;
   // border-bottom: 1px dotted black; /* If you want dots under the hoverable text */
}

/* Tooltip text */
.tooltip .tooltiptext {
    visibility: hidden;
    width: 120px;
    background-color: black;
    color: #fff;
    text-align: center;
    padding: 5px 0;
    border-radius: 6px;
 
    /* Position the tooltip text - see examples below! */
    position: absolute;
    z-index: 1;
}

/* Show the tooltip text when you mouse over the tooltip container */
.tooltip:hover .tooltiptext {
    visibility: visible;
}


.imgbtn {
	opacity:0.5;
    padding: 0px;
    margin: 0px 0px;
    border: 1px solid #d4d4d4;
    text-align: center;
    color: #3F3F3F;
    background-color: #f8f8f8;
    background: -webkit-linear-gradient(#f8f8f8, #ececec);
    background: -moz-linear-gradient(#f8f8f8, #ececec);
    background: -ms-linear-gradient(#f8f8f8, #ececec);
    background: -o-linear-gradient(#f8f8f8, #ececec);
    background: linear-gradient(#f8f8f8, #ececec);
    border-radius: 5px;
    -webkit-box-shadow: 0 0 3px #cFcFcF;
    -moz-box-shadow: 0 0 3px #cFcFcF;
    box-shadow: 0 0 3px #cFcFcF;
}

.imgbtn:hover {
	opacity:0.8;
	cursor:pointer;
    border-color: #3072b3;
    border-bottom-color: #2a65a0;
    color: #FFFFFF;
    background-color: #3c8dde;
    background: -webkit-linear-gradient(#599bdc, #3072b3);
    background: -moz-linear-gradient(#599bdc, #3072b3);
    background: -o-linear-gradient(#599bdc, #3072b3);
    background: linear-gradient(#599bdc, #3072b3);
    -webkit-box-shadow: 0 0 5px #cFcFcF;
    -moz-box-shadow: 0 0 5px #cFcFcF;
    box-shadow: 0 0 5px #cFcFcF;
}

.imgbtn:active {
    border-color: #2a65a0;
    border-bottom-color: #3884cd;
    background-color: #3072b3;
    background: -webkit-linear-gradient(#3072b3, #599bdc);
    background: -moz-linear-gradient(#3072b3, #599bdc);
    background: -ms-linear-gradient(#3072b3, #599bdc);
    background: -o-linear-gradient(#3072b3, #599bdc);
    background: linear-gradient(#3072b3, #599bdc);
}
.imgbtn:disabled {
	opacity:0.1;
	cursor:none;
    color: #AFAFAF;
    border-color: #f8f8f8;
    background-color: transparent;
    background: -webkit-repeating-llinear-gradient(45deg,#efefef, #e7e7e7 2%,#efefef 4%);
    background: -moz-repeating-llinear-gradient(45deg,#efefef, #e7e7e7 2%,#efefef 4%);
    background: -ms-repeating-llinear-gradient(45deg,#efefef, #e7e7e7 2%,#efefef 4%);
    background: -o-repeating-llinear-gradient(45deg,#efefef, #e7e7e7 2%,#efefef 4%);
    background: repeating-linear-gradient(45deg,#efefef, #e7e7e7 2%,#efefef 4%);
    -webkit-box-shadow: 0px 0px 0px #000000;
    -moz-box-shadow: 0px 0px 0px #000000;
    box-shadow: 0px 0px 0px #000000;
}

.popup {
    -webkit-box-shadow: 3px 3px 6px #000000,-3px -3px 16px #f3f3f3;
    -moz-box-shadow: 3px 3px 6px #000000,-3px -3px 16px #f3f3f3;
    box-shadow: 3px 3px 6px #000000,-3px -3px 16px #f3f3f3;
	background:#f3f3f3;
}

.ghost {
	opacity:0.02;
}

.svgTool:hover {
	opacity:1;
    -webkit-box-shadow: 3px 3px 6px #000000,-3px -3px 16px #f3f3f3;
    -moz-box-shadow: 3px 3px 6px #000000,-3px -3px 16px #f3f3f3;
    box-shadow: 3px 3px 6px #000000,-3px -3px 16px #f3f3f3;
}

/*
.chartShelf {
	/*margin:5px;
	width:100%;
	opacity:0.25;* 
	-webkit-box-shadow: 0px 3px 6px -2px #21435F;
    -moz-box-shadow: 0px 3px 6px -2px #21435F;
    box-shadow: 0px 3px 6px -2px #21435F;
	border-bottom: 3px ridge #21435F;
}*/
.switch {
  position: relative;
  display: inline-block;
  top:4px;
  width: 30px;
  height: 16px;
}

/* Hide default HTML checkbox */
.switch input {display:none;}

/* The slider */
.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 12px;
  width: 12px;
  left: 4px;
  bottom: 2px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before {
  -webkit-transform: translateX(13px);
  -ms-transform: translateX(13px);
  transform: translateX(13px);
}

/* Rounded sliders */
.slider.round {
  border-radius: 16px;
}

.slider.round:before {
  border-radius: 50%;
}
</style>
<script>

	var initLoader = loader({width: 480, height: 150, container: "#mainDiv", id: "initLoader",msg:"Loading . . . "});
	var myLoader = loader({width: 480, height: 150, container: "#loaderDiv", id: "loader",msg:"Retrieving . . . "});

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
	
	function area_data_err(res)
	{
		d3.select('#loader').remove();
		alert(res);
	}

	function updateGraphs(val,id)
	{
		val = "'"+val+"'";
		var chk = false;
		var n=d3.select('#'+id).node();
		/*chartHistory[ReqId+1].selparam = (function(a,b){return function(){
			if(a.value=='')
			{
				a.value=val;
				return;
			}
			var chk = false;
			var arg = a.value.split(',');
			var hold=[];
			arg.forEach(function(d,i){
				if(d == b)
					chk=true;
				else
					hold.push(d);
			})
			if(!chk)
				hold.push(b);
			a.value = hold.toString();
		}})(n,val)*/
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
			d3.select('#RAll').style('color','silver');
		else
			d3.select('#RAll').style('color','blue');
		
		cfrm_sub();
	}
	
	//318 164 //720
	function dragChart(eve,divChart)
	{
		eve.sourceEvent.preventDefault();
		divChart
		.style('min-width','350px')
		.style('min-height','25px')
		//.style('background','')
		var charts = d3.selectAll("[id^='chart-']");
		var ownInd=0;
		charts[0].forEach(function(d,i){
			if(divChart.attr('id')==d3.select(d).attr('id'))
				ownInd=i;
		})
		charts[0].splice(ownInd,1);
		var rowSize = d3.select('#cpr').node().value;
		var tp = eve.sourceEvent.pageY - 78;
		var lt = eve.sourceEvent.pageX - 18;
		var ix = Math.floor((lt-164)/380);
		if(ix<0)
			ix=0;
		if(ix >= rowSize)
			ix= rowSize-1;
		var hgh = 402;
		if(d3.select('#clpseCht').node().checked)
			hgh=65;
		var iy = Math.floor((tp-318)/hgh);//402
		if(iy<0)
			iy=0;
		var index = iy*rowSize+ix;
		if(index >charts[0].length)
			index=charts[0].length;
		
		charts[0].splice(index,0,divChart.node());
		divChart.select('#orderer').style('position','absolute').style('top',tp+'px').style('left',lt+'px');
		
		if(window.innerHeight-(tp-window.pageYOffset) < 50)
			window.scrollBy(0, 3); 
		if(tp-window.pageYOffset < 50)
			window.scrollBy(0, -3); 
		
		var divWidth = 380*(rowSize/1)
		var cSpace = d3.select('#chrtSpace');
		d3.selectAll("#chrtSpace > div").remove();
		cSpace.selectAll('br').remove();
		var targetDiv;
		charts[0].forEach(function(d,i){
			if(i%rowSize==0)
			{
				cSpace.append('div');
				targetDiv = cSpace.append('div')
				.style('width',divWidth+'px')
				.style('text-align','left')
				.style('margin',' 0 auto')
				.style('height',function(){if(d3.select('#clpseCht').node().checked)return '65px';return '';})
				.style('min-height','20px')
				/*.style('border-left','10px solid #21435F')
				.style('border-bottom-left-radius','25px')
				.style('border-top-left-radius','25px')
				.on('mouseover',function(){if(d3.event.target != this){d3.select(this).style('border-left','10px solid #21435F');return;};d3.select(this).style('border-left','10px solid #C3C3F7')})
				.on('click',function(){
					if(d3.event.target != this)
						return;
					if(d3.select(this).style('height') != d3.select(this).style('min-height'))
					{
						var lbl=d3.select(this).append('label').attr('id','tempLbl').attr('class','labelTip');
						d3.select(this).selectAll('div').select('.y.label').style('border',function(){if(lbl.text() == '')lbl.text(d3.select(this).text());else lbl.text(lbl.text()+', '+d3.select(this).text());});
						d3.select(this).style('background','#21435F').style('margin',' 2px auto').selectAll('div').style('display','none');
					}else{
						d3.select(this).select('#tempLbl').remove();
						d3.select(this).style('background','').style('margin',' 0 auto').selectAll('div').style('display','inline-block')
					}
				})
				.on('mouseout',function(){d3.select(this).style('border-left','10px solid #21435F')})*/
				//.attr('class','chartShelf')
			}
			targetDiv.node().appendChild(d);
		})
	}
	
	
	var loadCnt=0;
	var c0070="#d73027";
	var c7080="#fc8d59";
	var c8090="#fee090";
	var c9095="#91bfdb";
	var c9510="#4575b4";
	
	function streamLineChart(res,paramId,contId,chartId,cTitle,loaderId,range,sortBy)
	{	
		if(!sortBy)
			sortBy=2;
		var w = 350;
		var h = 350;
		var padding = 50;
		var maxRows=11;
		
		var cScale = d3.scale.linear().domain([0,0.7,1]).range(["#700","#C00","#0C0"]);	
		var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);	

		var perF = d3.format('.1%');
		var sigF = d3.format('.3g');
		var comF = d3.format(',');
		var siF = d3.format('.3s');
		
		var high = d3.max(res,function(d){return d[2];});
		var low = 0;//d3.min(res,function(d){return d[2];});
		var diff=high-low;
		var len = res.length;
		var selParam = d3.select('#'+paramId).node().value;
		
		if(sortBy)
		{
			if(sortBy >=0)
			{
				if(sortBy == 1)
					res.sort(function (a,b) {return d3.descending(a[sortBy], b[sortBy]);})
				else
					res.sort(function(a, b){if(a[sortBy] == b[sortBy])return d3.descending(a[1], b[1]);return a[sortBy] - b[sortBy]})
			}
			else
			{
				var hold=(sortBy+1)*-1;
				if(hold == 1)
					res.sort(function (a,b) {return d3.ascending(a[hold], b[hold]);})
				else
					res.sort(function(a, b){if(a[hold] == b[hold])return d3.ascending(a[1], b[1]);return b[hold] - a[hold]})
			}
		}
		
		if(loadCnt > 0 && selParam != '')
		{
			res.forEach( function(d,i) {if(selParam.search("'"+d[0]+"'")>=0){range = len-i-1;}})
		}
		if(!range || len <= maxRows)
			range=0;
		else if(len - range < maxRows)
		{
			range = len-maxRows;
		}
		else if(len - range >= len)
		{
			range = 0;
		}
		loadCnt--;
		if(loadCnt <=0)
			d3.select('#'+loaderId).remove();
		
		yScale = d3.scale.ordinal().rangeBands([h - padding, padding]);

		xScale = d3.scale.linear()
			 .domain([0,1])
			 .range([padding, w - padding]);
			 
		xScale2 = d3.scale.linear()
			 .domain([low,high])
			 .range([padding, w - padding]);
		
		
		var order = [];
		var holdData = res.slice(0);
		res = res.slice(Math.max(res.length-maxRows-range,0),res.length-range);
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

		var rdiv = (h-(padding*2))/((res.length<maxRows)?res.length:maxRows)/2;
		var rw = (h-(padding*2)-rdiv*2)/((res.length<maxRows)?res.length:maxRows);//210
		if(rw==0)
		{
			rw=rdiv;
		}
		var zoomed;
		
		var zoom = d3.behavior.zoom()
		.scaleExtent([1, 10]).on("zoom."+paramId, null);
		
		zoomed=(function(AR,pID,cID,chID,title,LID,rng,zm,sb){return function zoomed() {
			if(loadCnt > 0 || !d3.event.sourceEvent)
				return;
			var len = AR.length;
			if(d3.event.sourceEvent.wheelDelta)
			{
				if(d3.event.sourceEvent.wheelDelta < 0)
				{
					rng+=1;
					if(len-rng < maxRows)
						rng = len-maxRows;
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
				if(d3.event.translate[1] > 0)
				{
					rng+=d3.event.translate[1]*((len-maxRows)/(h - padding * 2-15));//1;
					if(len-rng < maxRows)
						rng = len-maxRows;
					zm.translate([0, 0]);
				}
				if(d3.event.translate[1] < 0)
				{
					rng+=d3.event.translate[1]*((len-maxRows)/(h - padding * 2-15));
					if(rng<0)
						rng=0;
					zm.translate([0, 0]);
				}
			}
			streamLineChart(AR,pID,cID,chID,title,LID,rng,sb);
			
		}})(holdData,paramId,contId,chartId,cTitle,loaderId,range,zoom,sortBy)
		
		zoom.on("zoom."+paramId, zoomed);
		
		var scheck = (d3.select('#'+chartId).node() != null);
		if(scheck)
		{
			var tooldiv = d3.select("#"+chartId+'div');
			
			svg = d3.select('#'+chartId)
			container=svg.select("#mainContainer");
			svg.select('.x.axis').call(xAxis);
			svg.select('.x2.axis').call(xAxis2);
			svg.select("#loadShield")
			.style("fill",'none');
			svg.select('g')
				.call(zoom);
				
			svg.select('#magnifier')
			.on('click',(function(AR,pID,cID,chID,title,LID,rng,sb){
				return function doSe(){
					if(loadCnt > 0)
						return;
					d3.select('#searchBlockParent').style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px').style('left',window.innerWidth/3+'px')//.attr('draggable','true')
					d3.select('#searchBlockMove')
					.on('mousedown',function(){d3.select('#searchBlockParent').call(d3.behavior.drag().on("drag", move));})
					.on('mouseup',function(){d3.select('#searchBlockParent').call(d3.behavior.drag().on("drag", null));d3.select('#searchBlockParent').on('mousedown.drag',null)})
					//d3.select('#searchBlock').style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px');
					d3.select('#commitSearch').on('click',function(){					
						d3.select("#searchBlockParent").style("display","none");
						var targetSearch=d3.select('#searchTarget').node().value.toUpperCase();
						var len = AR.length;
						AR.forEach(function(d,i){
							if(d[1].search(targetSearch)>=0)
								rng=len-i-1;
						})
						streamLineChart(AR,pID,cID,chID,title,LID,rng,sb);
					})
					
				}
			})(holdData,paramId,contId,chartId,cTitle,loaderId,range,sortBy)
			)
			
			svg.select('#sorter')
			.on('click',(function(AR,pID,cID,chID,title,LID,rng,sb){
				return function reSort(){
					if(loadCnt > 0)
						return;
					d3.select('#sortBlockParent').style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px').style('left',window.innerWidth/3+'px')//.attr('draggable','true')
					d3.select('#sortBlockMove')
					.on('mousedown',function(){d3.select('#sortBlockParent').call(d3.behavior.drag().on("drag", move));})
					.on('mouseup',function(){d3.select('#sortBlockParent').call(d3.behavior.drag().on("drag", null));d3.select('#sortBlockParent').on('mousedown.drag',null)})
					var ssb = d3.select('#sortBlock');//.style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px');
					var sssb = d3.select('#sortslct');
					sssb.node().value=sb;
					ssb.on('change',function(){var sbnew =sssb.node().value/1;d3.select('#sortBlockParent').style('display','none');streamLineChart(AR,pID,cID,chID,title,LID,rng,sbnew);})
				}
			})(holdData,paramId,contId,chartId,cTitle,loaderId,range,sortBy)
			)
			.on('mouseout',function(d,i){d3.select(this).style('cursor','').select('path').attr('fill',function(){if(sortBy == 2)return 'silver'; return 'lightblue';});})
			
			svg.select('#sorter path')
			.attr('fill',function(){if(sortBy == 2)return 'silver'; return 'lightblue';})
			
			svg.select('#totable')
			.on('click',(function(AR,pID,cID,chID,title){
				return function shwTbl(){
					dragenabled=false;
					//d3.select(window).on('mousemove',function(){if(!dragenabled)return;d3.select('#tblBlockParent').style('top',d3.event.y+window.pageYOffset-70+'px').style('left',d3.event.x-20+'px')})
					d3.select('#tblBlockParent').style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px').style('left',window.innerWidth/3+'px')//.attr('draggable','true')
					d3.select('#tblBlockMove')
					.on('mousedown',function(){d3.select('#tblBlockParent').call(d3.behavior.drag().on("drag", move));})
					.on('mouseup',function(){d3.select('#tblBlockParent').call(d3.behavior.drag().on("drag", null));d3.select('#tblBlockParent').on('mousedown.drag',null)})
					var perF = d3.format('.2%');
					var comF = d3.format(',');
					var TblProps =
					{
						'maxRows':20,
						'headers':['ID','Name','Failed Pieces','Percent','Total'],
						'headerWidths':function(d,i){var hold = ['103px','262px','85px','102px','88px']; return hold[i];},
						'cellFormat':function(d,i){ if(i==2 || i==4)return comF(d);if(i==3)return perF(d);return d;},
						'tableAttr':{
							'id':'mainTable',
							'class':'pbTable'
						},
						'tableStyle':{
							'background':'#f3f3f3'
						},			
						'rowStyle':{
							'background':'#f3f3f3'
						},
						'rowAttr':{
						},
						'cellStyle':{
							'white-space': 'nowrap',
							'overflow': 'hidden',
							'text-overflow': 'ellipsis',
							'text-align':function(d,i){ if(i==1)return 'left';return 'center';},
							'outline':function(d,i) {if(i != 3) return; return '1px dashed  '+cScale2(Math.floor(d*100)/100);},
							'border':function(d,i) {if(i != 3) return; return '1px solid black';},
							'color':function(d,i) {if(i != 3) return; return cScale2(Math.floor(d*100)/100);},
							'background':function(d,i) {if(i != 3) return; return '#333';}
						},
						'cellAttr':{
							'title':function(d){return d;}
						}
					}
					createScrollTable('tblBlock','TableDiv', holdData.slice(0).reverse(),TblProps);
				}
			})(holdData,paramId,contId,chartId,cTitle)
			)
			
			
			if(len>maxRows){
				scrolly=(function(AR,pID,cID,chID,title,LID,rng,sb){return function() {
					if(loadCnt > 0)
						return;
					var len = AR.length;
					var hr = 15;
					rng+=d3.event.dy*((len-maxRows)/(h - padding * 2-hr));
					if(len-rng < maxRows)
						rng = len-maxRows;
					if(rng<0)
						rng=0;
					streamLineChart(AR,pID,cID,chID,title,LID,rng,sb);
				}})(holdData,paramId,contId,chartId,cTitle,loaderId,range,sortBy)
				
				var scrDrag=d3.behavior.drag()
				.on("drag",scrolly);
				
				var hr = 15;
				var hx = (h - padding * 2-hr)*(range/(len-maxRows));
				d3.select('#'+contId).select("#scroll-rect").style('display','')
					.attr("transform","translate("+ (w-padding+3)+","+(padding+hx)+") scale("+(9/32)+","+(15/32)+")")
					//.attr("y", padding+hx)
					.call(scrDrag);
				d3.select('#'+contId).select("#scroll-track").style('display','');
			}else
			{
				d3.select('#'+contId).select("#scroll-rect").style('display','none');
				d3.select('#'+contId).select("#scroll-track").style('display','none');
			}
		}
		else
		{
			//Create SVG element
			svg=d3.select('#'+contId)
				//.attr('draggable','true')
				.append("svg")
				.attr("width", w)
				.attr("height", h)
				.style("margin", '15px')
				.attr("id", chartId)
			  .append("g")
				//.attr("transform", "matrix(0.05,0,0,0.05,0,0)")
				//.style('-ms-transform-origin','center center')
				//.style('transform-origin','center center')
				.call(zoom);//.call(dragForm);	
			
			var defs=svg.append("defs");
			
			defs.append("svg:clipPath")
				.attr("id","clip")
				.append("svg:rect")
				.attr("id","clip-rect")
				.style("fill", "black")
				.attr("x", padding)
				.attr("y", padding)
				.attr("width", w - padding * 2)
				.attr("height", h - padding * 2);
			
			var lg=defs.append('linearGradient')
			.attr("id","shadeV")
			.attr('x1','0%')
			.attr('x2','0%')
			.attr('y1','0%')
			.attr('y2','100%');
			
			lg.append('stop').attr('offset','0%').style('stop-color','#DDD').style('stop-opacity',1)
			lg.append('stop').attr('offset','100%').style('stop-color','#CCC').style('stop-opacity',1)
			
			var lgg=defs.append('linearGradient')
			.attr("id","shadeGV")
			.attr('x1','0%')
			.attr('x2','0%')
			.attr('y1','0%')
			.attr('y2','100%');
			
			lgg.append('stop').attr('offset','0%').style('stop-color','#ADA').style('stop-opacity',1)
			lgg.append('stop').attr('offset','100%').style('stop-color','#7C7').style('stop-opacity',1)
		
			var lg2=defs.append('linearGradient')
			.attr("id","shadeIV")
			.attr('x1','0%')
			.attr('x2','0%')
			.attr('y1','0%')
			.attr('y2','100%');
			
			lg2.append('stop').attr('offset','0%').style('stop-color','#AAA').style('stop-opacity',1)
			lg2.append('stop').attr('offset','100%').style('stop-color','#777').style('stop-opacity',1)
			
			
			var ord=d3.select('#'+contId)
				//.attr('draggable','true')
				.append("div")
				.style("width", w+'px')
				.style("height", '50px')
				//.style("margin", '15px')
				.attr("id", 'orderer')
				.style('border','solid silver 1px')
				.style('border-radius','25px')
				.style('background','#21435F')
				.style('color','#F3F3F3');
				
			var ordhndl = ord.append('div')
				.style("width", '40px')
				.style("height", '40px')
				.style('background','silver')
				.style('margin','5px')
				.style('vertical-align','middle')
				.style('display','inline-block')
				.style('cursor','pointer')
				.style('border-radius','20px')
				//.style('border','solid silver 1px')
				.call(d3.behavior.drag().on("drag", function(){dragChart(d3.event,d3.select('#'+contId));}).on("dragend", function(){d3.select('#'+contId).style('min-width','').style('min-height','').select('#orderer').style('position','').style('top','').style('left','')}))
				.on('mouseover',function(){d3.select(this).style('background','blue')})
				.on('mouseout',function(){d3.select(this).style('background','silver')});
				
			var ordlbl = ord.append('div')
				.style('font-weight','bold')
				.style('font-variant','small-caps')
				.style('margin','15px 0')
				.style('vertical-align','middle')
				.style('display','inline-block')
				.text(cTitle);
				
			ord.style('display','none');
				
			/** /svg.append("rect")
				.attr("width", 20)
				.attr("height", 20)
				.attr('id','dragTab')
				.attr("x", 0)
				.attr("y", 0)
				//.attr("rx", 20)
				//.attr("ry", 20)
				.style("fill", "gray")
				.style("cursor", "pointer")
				.attr("opacity", 0.5)
				.call(d3.behavior.drag().on("drag", function(){dragChart(d3.event,d3.select('#'+contId));}).on("dragend", function(){/*d3.select('#chrtSpace').selectAll('div').style('height','');* /d3.select('#'+contId).style('min-width','').style('min-height','').select('svg').style('position','').style('top','').style('left','')}))
				.on('mouseover',function(){d3.select(this).style('fill','blue')})
				.on('mouseout',function(){d3.select(this).style('fill','gray')});/**/
			
			svg.append("circle")
				.attr("cx", 20)
				.attr("cy", 20)
				.attr("r", 20)
				//.attr("ry", 20)
				.style("fill", "#F3F3F3");
				
			svg.append("rect")
				.attr("width", w)
				.attr("height", h)
				.attr('id','bg')
				.attr("x", 0)
				.attr("y", 0)
				.attr("rx", 20)
				.attr("ry", 20)
				.style("fill", "white")
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
			
			var tooldiv = d3.select("body").append("div")
			.attr('id',chartId+'div')
			.attr("class", "tooltip")				
			.style("opacity", 0)
			.style("z-index",4);
			
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
				.attr("y", padding/2+3)
				.text("Performance ").style('font-size','10px')
				.append("tspan").attr('display','block')
				.attr("id","gphName");
				
			svg.append("text")
			.attr("class", "y label")
			.attr("x", padding-10)
			.attr("y", padding/3)
			.text(cTitle).style('font-weight','bold')
			.attr('fill','#000');
				
			svg.append("g").attr('id','magnifier').attr('class','svgTool')
			.on('click',(function(AR,pID,cID,chID,title,LID,rng,sb){
				return function doSe(){
					if(loadCnt > 0)
						return;
					d3.select('#searchBlockParent').style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px').style('left',window.innerWidth/3+'px')//.attr('draggable','true')
					d3.select('#searchBlockMove')
					.on('mousedown',function(){d3.select('#searchBlockParent').call(d3.behavior.drag().on("drag", move));})
					.on('mouseup',function(){d3.select('#searchBlockParent').call(d3.behavior.drag().on("drag", null));d3.select('#searchBlockParent').on('mousedown.drag',null)})
					d3.select('#commitSearch').on('click',function(){					
						d3.select("#searchBlockParent").style("display","none");
						var targetSearch=d3.select('#searchTarget').node().value.toUpperCase();
						var len = AR.length;
						AR.forEach(function(d,i){
							if(d[1].search(targetSearch)>=0)
								rng=len-i-1;
						})
						streamLineChart(AR,pID,cID,chID,title,LID,rng,sb);
					})
					
				}
			})(holdData,paramId,contId,chartId,cTitle,loaderId,range,sortBy)
			)
			.on('mouseover',function(){d3.select(this).style('cursor','pointer').select('path').attr('stroke','blue');})
			.on('mouseout',function(d,i){d3.select(this).style('cursor','').select('path').attr('stroke','silver');})
			.attr('transform','translate('+(w-padding-18)+' '+(7)+')')
			.append("path")
			.attr('d',"M0 16 L16 16 L10 10 a4.5,4.5 0 1 0 -1,1 L10 10")
			.attr('stroke','silver')
			.attr('stroke-width','2px')
			.attr('fill','transparent')
			.attr('stroke-dasharray','75,16')
			.attr('stroke-dashoffset','75')
			.attr('stroke-linejoin','round')
			.attr('transition','stroke-dasharray .6s cubic-bezier(0,.5,.5,1), stroke-dashoffset .6s cubic-bezier(0,.5,.5,1)')
			
			var sortie=svg.append("g").attr('id','sorter').attr('class','svgTool')
			.on('click',(function(AR,pID,cID,chID,title,LID,rng,sb){
				return function reSort(){
					if(loadCnt > 0)
						return;
					d3.select('#sortBlockParent').style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px').style('left',window.innerWidth/3+'px')//.attr('draggable','true')
					d3.select('#sortBlockMove')
					.on('mousedown',function(){d3.select('#sortBlockParent').call(d3.behavior.drag().on("drag", move));})
					.on('mouseup',function(){d3.select('#sortBlockParent').call(d3.behavior.drag().on("drag", null));d3.select('#sortBlockParent').on('mousedown.drag',null)})
					var ssb = d3.select('#sortBlock');//.style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px');
					var sssb = d3.select('#sortslct');
					sssb.node().value=sb;
					ssb.on('change',function(){var sbnew =sssb.node().value/1;d3.select('#sortBlockParent').style('display','none');streamLineChart(AR,pID,cID,chID,title,LID,rng,sbnew);})
				}
			})(holdData,paramId,contId,chartId,cTitle,loaderId,range,sortBy)
			)
			.on('mouseover',function(){d3.select(this).style('cursor','pointer').select('path').attr('fill','blue');})
			.on('mouseout',function(d,i){d3.select(this).style('cursor','').select('path').attr('fill','silver');})
			//arbar .attr('transform','translate('+(w-padding-36)+' '+(7)+') scale(0.40,0.40)')
			.attr('transform','translate('+(w-padding-36)+' '+(5)+') scale(0.20,0.20)');
			
			sortie.append("rect")
				.attr("width", 100)
				.attr("height", 100)
				.attr("x", 0)
				.attr("y", 0)
				.attr("rx", 20)
				.attr("ry", 20)
				.style("fill", "white")
				.attr("opacity", 0.2);
				
			sortie.append("path")
			//arrow w/ bars.attr('d',"M13.771,37.26l2.189-0.008l-4.826,7.494l-4.871-7.465l2.221-0.007l0.052-32.02l5.291,0.008L13.771,37.26z M16.853,5.313 v5.288h26.885V5.313H16.853z M16.853,18.9h20.711v-5.287H16.853V18.9z M16.853,27.203h12.342v-5.29H16.853V27.203z M16.853,35.502 h6.834v-5.289h-6.834V35.502z")
			.attr('d',"M81.755,62.641L64.598,84.959c-0.172,0.224-0.44,0.355-0.723,0.355c-0.281,0-0.549-0.132-0.721-0.355L45.997,62.641 c-0.127-0.164-0.189-0.36-0.189-0.555c0-0.19,0.06-0.385,0.183-0.549c0.248-0.325,0.682-0.447,1.063-0.298l11.36,4.488v-47.57 c0-0.503,0.409-0.909,0.911-0.909h9.105c0.502,0,0.91,0.406,0.91,0.909v47.57L80.7,61.239c0.381-0.149,0.815-0.027,1.061,0.298 C82.008,61.865,82.006,62.315,81.755,62.641z M54.01,38.463c0.123-0.164,0.183-0.358,0.183-0.549c0-0.194-0.063-0.391-0.189-0.555 L36.846,15.041c-0.172-0.224-0.44-0.355-0.721-0.355c-0.283,0-0.55,0.132-0.723,0.355L18.245,37.359 c-0.251,0.325-0.252,0.775-0.005,1.104c0.246,0.325,0.68,0.447,1.061,0.298l11.361-4.488v47.57c0,0.503,0.407,0.909,0.91,0.909 h9.105c0.502,0,0.911-0.406,0.911-0.909v-47.57l11.36,4.488C53.328,38.91,53.762,38.788,54.01,38.463z")
			//.attr('stroke','white')
			//.attr('stroke-opacity',0.85)
			//.attr('stroke-width','2px')
			.attr('fill','silver')
			//.attr('stroke-dasharray','75,16')
			//.attr('stroke-dashoffset','75')
			//.attr('stroke-linejoin','round')
			//.attr('transition','stroke-dasharray .6s cubic-bezier(0,.5,.5,1), stroke-dashoffset .6s cubic-bezier(0,.5,.5,1)')
			
			var totbl=svg.append("g").attr('id','totable').attr('class','svgTool')
			.on('click',(function(AR,pID,cID,chID,title){
				return function shwTbl(){
					dragenabled=false;
					//d3.select(window).on('mousemove',function(){if(!dragenabled)return;d3.select('#tblBlockParent').style('top',d3.event.y+window.pageYOffset-70+'px').style('left',d3.event.x-20+'px')})
					d3.select('#tblBlockParent').style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px').style('left',window.innerWidth/3+'px')//.attr('draggable','true')
					d3.select('#tblBlockMove')
					.on('mousedown',function(){d3.select('#tblBlockParent').call(d3.behavior.drag().on("drag", move));})
					.on('mouseup',function(){d3.select('#tblBlockParent').call(d3.behavior.drag().on("drag", null));d3.select('#tblBlockParent').on('mousedown.drag',null)})
					var perF = d3.format('.2%');
					var comF = d3.format(',');
					var TblProps =
					{
						'maxRows':20,
						'headers':['ID','Name','Failed Pieces','Percent','Total'],
						'headerWidths':function(d,i){var hold = ['103px','262px','85px','102px','88px']; return hold[i];},
						'cellFormat':function(d,i){ if(i==2 || i==4)return comF(d);if(i==3)return perF(d);return d;},
						'tableAttr':{
							'id':'mainTable',
							'class':'pbTable'
						},
						'tableStyle':{
							'background':'#f3f3f3'
						},			
						'rowStyle':{
							'background':'#f3f3f3'
						},
						'rowAttr':{
						},
						'cellStyle':{
							'white-space': 'nowrap',
							'overflow': 'hidden',
							'text-overflow': 'ellipsis',
							'text-align':function(d,i){ if(i==1)return 'left';return 'center';},
							'outline':function(d,i) {if(i != 3) return; return '1px dashed  '+cScale2(Math.floor(d*100)/100);},
							'border':function(d,i) {if(i != 3) return; return '1px solid black';},
							'color':function(d,i) {if(i != 3) return; return cScale2(Math.floor(d*100)/100);},
							'background':function(d,i) {if(i != 3) return; return '#333';}
						},
						'cellAttr':{
							'title':function(d){return d;}
						}
					}
					createScrollTable('tblBlock','TableDiv', holdData.slice(0).reverse(),TblProps);
				}
			})(holdData,paramId,contId,chartId,cTitle)
			)
			.on('mouseover',function(){d3.select(this).style('cursor','pointer').select('path').attr('fill','blue');})
			.on('mouseout',function(d,i){d3.select(this).style('cursor','').select('path').attr('fill','silver');})
			//arbar .attr('transform','translate('+(w-padding-36)+' '+(7)+') scale(0.40,0.40)')
			.attr('transform','translate('+(w-padding-54)+' '+(5)+') scale(0.20,0.20)');
			
			totbl.append("rect")
				.attr("width", 100)
				.attr("height", 100)
				.attr("x", 0)
				.attr("y", 0)
				.attr("rx", 20)
				.attr("ry", 20)
				.style("fill", "white")
				.attr("opacity", 0.2);
			
			totbl.append("path")
			.attr('d',"M86.904,14.373H13.096c-1.644,0-2.98,1.338-2.98,2.98v65.293c0,1.009,0.507,1.899,1.277,2.439v0.47h1.069 c0.205,0.044,0.416,0.071,0.634,0.071h73.809c0.218,0,0.429-0.027,0.633-0.071h0.147V85.51c1.264-0.346,2.2-1.492,2.2-2.863V17.354 C89.885,15.711,88.548,14.373,86.904,14.373z M87.33,17.354v8.588H67.672v-9.014h19.232C87.139,16.928,87.33,17.119,87.33,17.354z M87.125,83H67.672v-8.09H87.33v7.736C87.33,82.798,87.245,82.926,87.125,83z M12.67,82.646V74.91h9.226V83h-9.021 C12.755,82.926,12.67,82.798,12.67,82.646z M43.399,52.555v8.857H24.45v-8.857H43.399z M24.45,50v-9.581h18.949V50H24.45z M43.399,63.967v8.389H24.45v-8.389H43.399z M43.399,74.91V83H24.45v-8.09H43.399z M45.954,74.91h19.163V83H45.954V74.91z M45.954,72.355v-8.389h19.163v8.389H45.954z M45.954,61.412v-8.857h19.163v8.857H45.954z M45.954,50v-9.581h19.163V50H45.954z M45.954,37.864v-9.368h19.163v9.368H45.954z M45.954,25.941v-9.014h19.163v9.014H45.954z M43.399,25.941H24.45v-9.014h18.949 V25.941z M43.399,28.496v9.368H24.45v-9.368H43.399z M21.896,37.864H12.67v-9.368h9.226V37.864z M21.896,40.419V50H12.67v-9.581 H21.896z M21.896,52.555v8.857H12.67v-8.857H21.896z M21.896,63.967v8.389H12.67v-8.389H21.896z M67.672,72.355v-8.389H87.33v8.389 H67.672z M67.672,61.412v-8.857H87.33v8.857H67.672z M67.672,50v-9.581H87.33V50H67.672z M67.672,37.864v-9.368H87.33v9.368H67.672z ")
			//.attr('stroke','white')
			//.attr('stroke-opacity',0.85)
			//.attr('stroke-width','2px')
			.attr('fill','silver')
			
			var expand=svg.append("g").attr('id','expand')
			.on('click',(function(tsvg,h2){ return function(){
				var scl = (window.innerHeight/h2*0.8);
				if(tsvg.style('position')=='static')
				{
					tsvg.style('z-index',3).style('position','absolute').style('top',window.innerHeight/4+window.pageYOffset+'px').style('left',window.innerWidth/2.5+'px').style('transform','scale(1,1)');
					tsvg.transition().style('transform','scale('+scl+','+scl+')').select('#bg').style('opacity',0.99);
					tsvg.selectAll('.svgTool').classed('ghost',true);
					tsvg.select('#expand').style('opacity',0.15);
				}
				else
				{
					tsvg.transition().style('transform','scale(1,1)');
					tsvg.style('z-index','').style('position','').style('top','').style('left','').style('transform','').select('#bg').style('opacity',0.2);
					tsvg.selectAll('.svgTool').classed('ghost',false);
					tsvg.select('#expand').style('opacity','');
				}
			}})(d3.select(svg.node().parentNode),h))
			.on('mouseover',function(){d3.select(this).style('cursor','pointer').select('path').attr('fill','blue');})
			.on('mouseout',function(d,i){d3.select(this).style('cursor','').select('path').attr('fill','silver');})
			//arbar .attr('transform','translate('+(w-padding-36)+' '+(7)+') scale(0.40,0.40)')
			.attr('transform','translate('+(padding/3+5)+' '+(-3)+') scale(0.03,0.03)');
			
			expand.append("rect")
				.attr("width", 670)
				.attr("height", 670)
				.attr("x", 0)
				.attr("y", 0)
				.attr("rx", 130)
				.attr("ry", 130)
				.style("fill", "white")
				.attr("opacity", 0.2);
			
			expand.append("path")
			.attr('d',"M432.105,419.906l53.787-53.191v255.199c0,7.57-2.688,13.945-8.066,19.125s-11.654,7.77-18.826,7.77H73.512 c-7.172,0-13.447-2.59-18.826-7.77s-8.068-11.555-8.068-19.125V256.149c0-7.57,2.689-13.945,8.068-19.125s11.654-7.77,18.826-7.77 h273.128l-53.791,53.789H100.405V595.02h331.701V419.906z M353.812,167.098l48.408,46.617L240.258,375.68l97.418,97.417 l161.965-161.965l50.203,51.398l15.539-219.34L353.812,167.098z")
			//.attr('stroke','white')
			//.attr('stroke-opacity',0.85)
			//.attr('stroke-width','2px')
			.attr('fill','silver')
			
			
			svg.append("rect")
				.style("fill", "black")
				.style("opacity",0.75)
				.attr('id','scroll-track')
				.attr("x", w-padding+7)
				.attr("y", padding)
				.attr("width", 1)
				.attr("height", h-padding*2)
		
			scrolly=(function(AR,pID,cID,chID,title,LID,rng,sb){return function() {
					if(loadCnt > 0)
						return;
					var len = AR.length;
					var hr = 15;
					rng+=d3.event.dy*((len-maxRows)/(h - padding * 2-hr));
					if(len-rng < maxRows)
						rng = len-maxRows;
					if(rng<0)
						rng=0;
					streamLineChart(AR,pID,cID,chID,title,LID,rng,sb);
				}})(holdData,paramId,contId,chartId,cTitle,loaderId,range,sortBy)
				
				var scrDrag=d3.behavior.drag()
				.on("drag",scrolly);
				
				var hr = (h - padding * 2)/(len-maxRows);
				var sr = d3.select('#'+contId)
					.select("svg").append("g")
					.attr("id","scroll-rect")
					.attr('draggable','true')
					.style("fill", "black")					
					.style("opacity", "0.75")
					.attr("transform","translate("+ (w-padding+3)+","+padding+") scale("+(9/32)+","+(15/32)+")")
					.attr("width", 15)
					//.attr("rx", 2)
					//.attr("ry", 2)
					.attr("height", (hr<15)?15:hr)
					//.call(scrDrag)	;
					sr.append('rect')
					.style("fill", "#777")					
					.style("opacity", "0.75")
					.attr("width", 32)
					.attr("height", 32)
					.attr("rx", 5)
					.attr("ry", 5)
					.attr("x", 4)
					.attr("y", 4);
					sr.append('rect')
					.style("fill", "url(#shadeV)")	
					.attr("stroke", "url(#shadeIV)")
					.attr('stroke-width',1.5)
					.style("opacity", "0.95")
					.attr("width", 32)
					.attr("height", 32)
					.attr("rx", 5)
					.attr("ry", 5)
					.attr("x", 0)
					.attr("y", 0)
					.on("mouseover",function(){d3.select(this).transition()
						.style("fill", "url(#shadeGV)")
						//.attr("x", w-padding)
						//.attr("width", 9)
					})
					.on("mouseout",function(){d3.select(this).transition()
						.style("fill", "url(#shadeV)")
						//.attr("x", w-padding)
						//.attr("width", 5)
					});
					/*sr.append('path')
					.attr('d',"M22,14H10c-1.105,0-2,0.895-2,2s0.895,2,2,2h12c1.105,0,2-0.895,2-2 S23.105,14,22,14z M22,21H10c-1.105,0-2,0.895-2,2s0.895,2,2,2h12c1.105,0,2-0.895,2-2S23.105,21,22,21z M22,7H10 C8.895,7,8,7.895,8,9s0.895,2,2,2h12c1.105,0,2-0.895,2-2S23.105,7,22,7z M29,0H3C1.343,0,0,1.343,0,3v26c0,1.657,1.343,3,3,3h26 c1.657,0,3-1.343,3-3V3C32,1.343,30.657,0,29,0z M28,27c0,0.552-0.448,1-1,1H5c-0.552,0-1-0.448-1-1V5c0-0.552,0.448-1,1-1h22 c0.552,0,1,0.448,1,1V27z")
					.attr('stroke-width',1.5)
					.attr('stroke-opacity',0.85)
					.attr("stroke","white");
					sr.append('rect')
					.style("fill", "none")
					.attr("stroke","black")	
					//.style("opacity", "0.75")
					.attr('stroke-width',2.5)
					.attr("width", 33)
					.attr("height", 33)
					.attr("rx", 5)
					.attr("ry", 5)
					.attr("x", -0.5)
					.attr("y", -0.5);*/
				
			
			if(len<=maxRows){
				d3.select('#'+contId).select("#scroll-rect").style('display','none');
				d3.select('#'+contId).select("#scroll-track").style('display','none');
			}
			//svg.transition().attr("transform", "matrix(1.15,0,0,1.15,0,0)")
			//.transition().attr("transform", "matrix(1,0,0,1,0,0)")
			var avgPoint=Math.floor(d3.mean(res,function(d) { return +d[2]}));
			var midPoint=Math.floor(d3.median(res,function(d) { return +d[2]}));
			var varPoint=Math.floor(d3.variance(res,function(d) { return +d[2]}));
			var devPoint=Math.floor(d3.deviation(res,function(d) { return +d[2]}));
			
			
			/*container.append("rect")
				.style("fill", "blue")
				.style("opacity",0.75)
				.attr('id','avgStat')
				.attr("x", xScale2(avgPoint))
				.attr("y", padding)
				.attr("width", 1)
				.attr("height", h-padding*2)
			   .on('mouseover',function(d,i){
					d3.select(this).style('cursor','pointer');
					tooldiv.transition()		
					.duration(200)		
					.style("opacity", 1);
					tooldiv.html( 'Average Failed Pcs: '+comF(avgPoint) + "<br/>"  + 'Median Failed Pcs: '+comF(midPoint) + "<br/>"  + 'Deviation Failed Pcs: '+comF(devPoint))	
					.style("left", (d3.event.pageX) + "px")		
					.style("top", (d3.event.pageY +20) + "px");	
			   })
			   .on('mouseout',function(d,i){
					d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');
					tooldiv.transition()		
					.duration(500)		
					.style("opacity", 0);
				})
			
			container.append("rect")
				.style("fill", "cyan")
				.style("opacity",0.75)
				.attr('id','midStat')
				.attr("x", xScale2(midPoint))
				.attr("y", padding)
				.attr("width", 1)
				.attr("height", h-padding*2)
			   .on('mouseover',function(d,i){
					d3.select(this).style('cursor','pointer');
					tooldiv.transition()		
					.duration(200)		
					.style("opacity", 1);
					tooldiv.html( 'Average Failed Pcs: '+comF(avgPoint) + "<br/>"  + 'Median Failed Pcs: '+comF(midPoint) + "<br/>"  + 'Deviation Failed Pcs: '+comF(devPoint))	
					.style("left", (d3.event.pageX) + "px")		
					.style("top", (d3.event.pageY +20) + "px");	
			   })
			   .on('mouseout',function(d,i){
					d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');
					tooldiv.transition()		
					.duration(500)		
					.style("opacity", 0);
				})*/
		}
		
		if(holdData.length <= maxRows)
			svg.select('#magnifier').style('display','none');
		else
			svg.select('#magnifier').style('display','');
		
		//var rdiv = (h-(padding*2))/((res.length<maxRows)?res.length:maxRows)/2;
		//var rw = 210/((res.length<maxRows)?res.length:maxRows);
		var timing;
		
		
		
		var fdb=container
			   .selectAll(".failDropBars")
			   .data(res);
			   
		fdb.enter()
			   .append("rect")
				.attr("class", function(d,i) { return "failDropBars r"+i;})
			   .attr("x", function(d,i) { return xScale2(d[2])+0.5;})
			   .attr("y", function(d) { return yScale(d[1])+rdiv-rw/2+2;})
			   .attr("width", 1)
			   .attr("height",function(d) { return Math.abs(h-padding-yScale(d[1])+rdiv-rw/2+2);} )
			   .style("fill",  'silver')
			   .attr("opacity", 0.25);
			   
		fdb.transition().duration(500).attr("class", function(d,i) { return "failDropBars r"+i;})
			   .attr("x", function(d,i) { return xScale2(d[2])+0.5;})
			   .attr("y", function(d) { return yScale(d[1])+rdiv-rw/2+2;})
			   .attr("width", 1)
			   .attr("height",function(d) { return Math.abs(h-padding-yScale(d[1])+rdiv-rw/2+2);} )
			   .style("fill",  'silver')
			   .attr("opacity", 0.25);
			   
		//fdb.transition();

		fdb.exit().transition().remove();
		var fpie=container
			   .selectAll(".failPie")
			   .data(res);
			   
		var tle=fpie.enter()
			   .append("rect")
				.attr("class", "failPie")
			   .attr("x", function(d,i) { return xScale2(low);})
			   .attr("y", function(d) { return yScale(d[1])+rdiv-rw/2+2;})
			   .attr("width", function(d) {return Math.abs(xScale2(d[2])-xScale2(low));})
			   .attr("height", rw-4)
			   .style("fill", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';})
			   .on('mouseover',function(d,i){
					d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');
					tooldiv.transition()		
					.duration(200)		
					.style("opacity", 1);		
					tooldiv.html( 'Failed Pieces: '+comF(d[2]) + "<br/>"  + 'Total Pieces: '+comF(d[4]) + "<br/>"  +'Percent: '+perF(d[3]))	
					.style("left", (d3.event.pageX) + "px")		
					.style("top", (d3.event.pageY +20) + "px");	
			   })
			   .on('click',function(d){if(timing){clearTimeout(timing); timing=null;return;}var sel=this.parentNode.parentNode.parentNode; timing=setTimeout(function(){timing=null; var nme = d3.select(sel).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d[1],ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(d[0],paramId)}, 600);})//id
			   .on('dblclick',function(d,i){dbC(d,i,paramId); })
			   .on('mouseout',function(d,i){
					d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');
					tooldiv.transition()		
					.duration(500)		
					.style("opacity", 0);
				})
			   //.append('title');
			   
		/*tle.append("tspan").attr('display','block').text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nPercent: '+perF(d[3]);})	*/
		
		fpie.transition().duration(500).attr("x", function(d,i) { return xScale2(low);})
			   .attr("y", function(d) { return yScale(d[1])+rdiv-rw/2+2;})
			   .attr("width", function(d) {return Math.abs(xScale2(d[2])-xScale2(low));})
			   .attr("height", rw-4)
			   .style("fill", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';});
			   
		tle=fpie.on('mouseover',function(d,i){
					d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');
					tooldiv.transition()		
					.duration(200)		
					.style("opacity", .9);		
					tooldiv.html( 'Failed Pieces: '+comF(d[2]) + "<br/>"  + 'Total Pieces: '+comF(d[4]) + "<br/>"  +'Percent: '+perF(d[3]))	
					.style("left", (d3.event.pageX) + "px")		
					.style("top", (d3.event.pageY +20) + "px");	
			   })
			   .on('click',function(d){if(timing){clearTimeout(timing); timing=null;return;}var sel=this.parentNode.parentNode.parentNode; timing=setTimeout(function(){timing=null; var nme = d3.select(sel).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d[1],ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(d[0],paramId)}, 600);})//id
			   .on('dblclick',function(d,i){dbC(d,i,paramId); })
			   .on('mouseout',function(d,i){
					d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');
					tooldiv.transition()		
					.duration(500)		
					.style("opacity", 0);
				})
			   //.select('title');
		
		/*tle.selectAll('tspan').remove();	
		tle.append("tspan").attr('display','block').text(function(d) {return '\nFailed Pieces: '+comF(d[2]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nPercent: '+perF(d[3]);})	*/
			   
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
			.style("fill",'none');*/

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
			   .style("fill", 'silver')
			   .attr("opacity", 0.25);
		
		pdb.transition().duration(500).attr("class", function(d,i) { return "perDropBars c"+i;})
			   .attr("x", function(d,i) {	return xScale(d[3])-0.5;})
			   .attr("y", padding)
			   .attr("width", 1)
			   .attr("height",function(d) { return Math.abs(yScale(d[1])+rdiv-padding);})
			   .style("fill", 'silver')
			   .attr("opacity", 0.25);
			   
		//pdb.transition();

		pdb.exit().transition().remove();
		
		var fpc=container
			   .selectAll(".failPer")
			   .data(res);
			   
		tle=fpc.enter()
			   .append("circle")
				.attr("class", "failPer")
			   .attr("cx", function(d,i) {	return xScale(d[3]);})
			   .attr("cy", function(d) { return yScale(d[1])+rdiv;})
			   .attr("r", 5)
			   .attr("stroke", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale(d[3]);return 'white'; })
			   .attr("stroke-width", 2)
			   .style("fill", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';})
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',1).attr('stroke','cyan');
					tooldiv.transition()		
					.duration(200)		
					.style("opacity", 1);		
					tooldiv.html( 'Failed Pieces: '+comF(d[2]) + "<br/>"  + 'Total Pieces: '+comF(d[4]) + "<br/>"  +'Percent: '+perF(d[3]))	
					.style("left", (d3.event.pageX) + "px")		
					.style("top", (d3.event.pageY +20) + "px");	})
			   .on('click',function(d){if(timing){clearTimeout(timing); timing=null;return;}var sel=this.parentNode.parentNode.parentNode; timing=setTimeout(function(){timing=null; var nme = d3.select(sel).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d[1],ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(d[0],paramId)}, 600);})//id
			   .on('dblclick',function(d,i){dbC(d,i,paramId); })
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',0.25).attr('stroke','');
					tooldiv.transition()		
					.duration(500)		
					.style("opacity", 0);})
			   /*.append('title');

		tle.append("tspan").attr('display','block').text(function(d) {return 'Percent: '+perF(d[3]);})	
		tle.append("tspan").attr('display','block').text(function(d) {return '\nFailed Pieces: '+comF(d[2]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})	*/
		
		fpc.transition().duration(500).attr("class", "failPer")
			   .attr("cx", function(d,i) {	return xScale(d[3]);})
			   .attr("cy", function(d) { return yScale(d[1])+rdiv;})
			   .attr("r", 5)
			   .attr("stroke", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale(d[3]);return 'white'; })
			   .attr("stroke-width", 2)
			   .style("fill", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';});
			   
		tle=fpc.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',1).attr('stroke','cyan');
					tooldiv.transition()		
					.duration(200)		
					.style("opacity", 1);		
					tooldiv.html( 'Failed Pieces: '+comF(d[2]) + "<br/>"  + 'Total Pieces: '+comF(d[4]) + "<br/>"  +'Percent: '+perF(d[3]))	
					.style("left", (d3.event.pageX) + "px")		
					.style("top", (d3.event.pageY +20) + "px");	})
			   .on('click',function(d){if(timing){clearTimeout(timing); timing=null;return;}var sel=this.parentNode.parentNode.parentNode; timing=setTimeout(function(){timing=null; var nme = d3.select(sel).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d[1],ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(d[0],paramId)}, 600);})//id
			   .on('dblclick',function(d,i){dbC(d,i,paramId); })
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',0.25).attr('stroke','');
					tooldiv.transition()		
					.duration(500)		
					.style("opacity", 0);})
			  /* .select('title');
		
		
		tle.selectAll('tspan').remove();
		tle.append("tspan").attr('display','block').text(function(d) {return 'Percent: '+perF(d[3]);})	
		tle.append("tspan").attr('display','block').text(function(d) {return '\nFailed Pieces: '+comF(d[2]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})	*/
			   
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
			tle=svg.append("g")
				.attr("class", "y axis")
				.attr("transform", "translate(" + padding + ",0)")
				.call(yAxis)
				.selectAll('text').attr('fill','#darkblue').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold')
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');
					tooldiv.transition()		
					.duration(200)		
					.style("opacity", 1);		
					tooldiv.html( 'Failed Pieces: '+comF(res[i][2]) + "<br/>"  + 'Total Pieces: '+comF(res[i][4]) + "<br/>"  +'Percent: '+perF(res[i][3]))	
					.style("left", (d3.event.pageX) + "px")		
					.style("top", (d3.event.pageY +20) + "px");	})
				.on('click',function(d,i){if(timing){clearTimeout(timing); timing=null;return;}var sel=this.parentNode.parentNode.parentNode; timing=setTimeout(function(){timing=null; var nme = d3.select(sel).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d[1],ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(res[i][0],paramId)}, 600);})//id
			   .on('dblclick',function(d,i){dbC(res[i],i,paramId); })
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');
					tooldiv.transition()		
					.duration(500)		
					.style("opacity", 0);})
			/*   .append('title');
			
			
			tle.append("tspan").attr('display','block').text(function(d,i) {return 'Failed Pieces: '+comF(res[i][2]);})
			tle.append("tspan").attr('display','block').text(function(d,i) {return '\nTotal Pieces: '+comF(res[i][4]);})
			tle.append("tspan").attr('display','block').text(function(d,i) {return '\nPercent: '+perF(res[i][3]);})		*/
			   
			   svg.append("text")
			.attr("class", "y label")
			.attr("x", w-padding)
			.attr("y", padding/3)
			.text('Reset').style('font-weight','bold').style('font-size','10px').style('text-decoration','underline').style('cursor','pointer').style('font-variant','small-caps').style('font-family','times, Times New Roman')
			.attr('fill',function(){if(selParam == '')return 'silver';return 'blue'})
			.attr('id','resetLink').attr('class','svgTool')
			.on('click',function(){var nme = d3.select(this.parentNode.parentNode.parentNode).select('.y').text();chartHistory.length=ReqId+1;chartHistory[ReqId+1]={};var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1;ht.options[ReqId+1]=new Option("Reset "+nme,ReqId+1);ht.selectedIndex=ReqId+1;d3.select('#'+paramId).node().value='';cfrm_sub();});
		}
		else
		{
			var Ytext=svg.select('.y.axis').call(yAxis).selectAll('text');
			Ytext.selectAll('title').remove();
			tle=Ytext.attr('fill','#darkblue').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold')
				   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');
					tooldiv.transition()		
					.duration(200)		
					.style("opacity", 1);		
					tooldiv.html( 'Failed Pieces: '+comF(res[i][2]) + "<br/>"  + 'Total Pieces: '+comF(res[i][4]) + "<br/>"  +'Percent: '+perF(res[i][3]))	
					.style("left", (d3.event.pageX) + "px")		
					.style("top", (d3.event.pageY +20) + "px");	})
				.on('click',function(d,i){if(timing){clearTimeout(timing); timing=null;return;}var sel=this.parentNode.parentNode.parentNode; timing=setTimeout(function(){timing=null; var nme = d3.select(sel).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d[1],ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(res[i][0],paramId)}, 600);})//id
			   .on('dblclick',function(d,i){dbC(res[i],i,paramId); })
				   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');
					tooldiv.transition()		
					.duration(500)		
					.style("opacity", 0);})
			/*	   .append('title');
			
			tle.selectAll('tspan').remove();
			tle.append("tspan").attr('display','block').text(function(d,i) {return 'Failed Pieces: '+comF(res[i][2]);})
			tle.append("tspan").attr('display','block').text(function(d,i) {return '\nTotal Pieces: '+comF(res[i][4]);})	
			tle.append("tspan").attr('display','block').text(function(d,i) {return '\nPercent: '+perF(res[i][3]);})	
			*/
			svg.select('#resetLink').transition().attr('fill',function(){if(selParam == '')return 'silver';return 'blue'})
			
		}
		container.select("#loadShield").remove();
				
		var ldShd=container
			.append("rect")
			.attr("id","loadShield")
			.attr("opacity",0.75)
			.style("fill",'none')
			.attr("width", w)
			.attr("height",h);
	
	}
	var dragenabled=false;
	function move(){
		//this.parentNode.parentNode.appendChild(this.parentNode);
		var dragTarget = d3.select(this);
		dragTarget.style({
			left: d3.event.dx + parseInt(dragTarget.style("left")) + "px",
			top: d3.event.dy + parseInt(dragTarget.style("top")) + "px"
		});
	}
	
	function dbC(d,i,paramId)
	{
		//alert(d);
	}
	
	function resizePath(d) {
        var e = +(d == "e"),
			x = e ? 1 : -1,
			y = 350 / 3;
        return "M" + (.5 * x) + "," + y
            + "A6,6 0 0 " + e + " " + (6.5 * x) + "," + (y + 6)
            + "V" + (2 * y - 6)
            + "A6,6 0 0 " + e + " " + (.5 * x) + "," + (2 * y)
            + "Z"
            + "M" + (2.5 * x) + "," + (y + 8)
            + "V" + (2 * y - 8)
            + "M" + (4.5 * x) + "," + (y + 8)
            + "V" + (2 * y - 8);
    }
    
	function OArea_Chart(res)
	{	
		var resId = res.pop()[0];
			res.shift();
			chartHistory[resId].OArea_Chart=(function(data){
				return function(){
					streamLineChart(data,'selOArea','chart-OArea','svgOArea','Origin Area','loader');
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selOArea','chart-OArea','svgOArea','Origin Area','loader');
	}

	function DArea_Chart(res)
	{	
		var resId = res.pop()[0];
			res.shift();
			chartHistory[resId].DArea_Chart=(function(data){
				return function(){
					streamLineChart(data,'selDArea','chart-DArea','svgDArea','Dest. Area','loader');
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selDArea','chart-DArea','svgDArea','Dest. Area','loader');
	}
	
	function ODistrict_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].ODistrict_Chart=(function(data){
				return function(){
					streamLineChart(data,'selODistrict','chart-ODistrict','svgODistrict','District','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selODistrict','chart-ODistrict','svgODistrict','Origin District','loader');		
	}
	
	function DDistrict_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].DDistrict_Chart=(function(data){
				return function(){
					streamLineChart(data,'selDDistrict','chart-DDistrict','svgDDistrict','District','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selDDistrict','chart-DDistrict','svgDDistrict','Dest. District','loader');		
	}
	
	function OFacility_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].OFacility_Chart=(function(data){
				return function(){
					streamLineChart(data,'selOFacility','chart-OFacility','svgOFacility','Origin Facility','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selOFacility','chart-OFacility','svgOFacility','Origin Facility','loader');		
	}
	
	function DFacility_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].DFacility_Chart=(function(data){
				return function(){
					streamLineChart(data,'selDFacility','chart-DFacility','svgDFacility','Dest. Facility','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selDFacility','chart-DFacility','svgDFacility','Dest. Facility','loader');		
	}
	
	function RootFacility_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].RootFacility_Chart=(function(data){
				return function(){
					streamLineChart(data,'selRootPlant','chart-RFacility','svgRFacility','Root Cause Facility','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selRootPlant','chart-RFacility','svgRFacility','Root Cause Facility','loader');		
	}
	
	function SST_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].SST_Chart=(function(data){
				return function(){
					streamLineChart(data,'selTransp','chart-SST','svgSST','Transport','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selTransp','chart-SST','svgSST','Transport','loader');		
	}
	
	function Mode_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].Mode_Chart=(function(data){
				return function(){
					streamLineChart(data,'selMode','chart-Mode','svgMode','Svc. Std.','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selMode','chart-Mode','svgMode','Svc. Std.','loader');		
	}
	
	function SSC_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].SSC_Chart=(function(data){
				return function(){
					streamLineChart(data,'selSSC','chart-SSC','svgSSC','Sales Src. Code','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selSSC','chart-SSC','svgSSC','Sales Src. Code','loader');		
	}
	
	function Shape_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].Shape_Chart=(function(data){
				return function(){
					streamLineChart(data,'selShape','chart-Shape','svgShape','Shape','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selShape','chart-Shape','svgShape','Shape','loader');		
	}
	
	function RCT_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].RCT_Chart=(function(data){
				return function(){
					streamLineChart(data,'selRootType','chart-RCT','svgRCT','Root Cause Type','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selRootType','chart-RCT','svgRCT','Root Cause Type','loader');		
	}
	
	function Root_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].Root_Chart=(function(data){
				return function(){
					streamLineChart(data,'selRoot','chart-Root','svgRoot','Root Cause','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selRoot','chart-Root','svgRoot','Root Cause','loader');		
	}
	
	function STC_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].STC_Chart=(function(data){
				return function(){
					streamLineChart(data,'selSTC','chart-STC','svgSTC','Start the Clock','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selSTC','chart-STC','svgSTC','Start the Clock','loader');		
	}
	
	function StopTC_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].StopTC_Chart=(function(data){
				return function(){
					streamLineChart(data,'selStopTC','chart-StopTC','svgStopTC','Stop the Clock','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selStopTC','chart-StopTC','svgStopTC','Stop the Clock','loader');		
	}
	
	function ProductCode_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].ProductCode_Chart=(function(data){
				return function(){
					streamLineChart(data,'selProCode','chart-ProCode','svgProCode','Product Code','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selProCode','chart-ProCode','svgProCode','Product Code','loader');		
	}

	function cfrm()
	{
	document.getElementById("subtn").style.border = 'Red 4px solid';
	}	

	var doInit;
	function init()
	{
		doInit=true;
		
		var e=new TDF();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(area_data_err);
		e.getDates('<cfoutput>#datasource#</cfoutput>','');
		
	}

	ReqId=-1;
	chartHistory=[];
	
	function doHistory(dir,sel)
	{
		if(dir+ReqId < 0 || dir+ReqId >= chartHistory.length)
			return;
		if(dir==0)
		{
			ReqId=sel/1;
			for (var key in chartHistory[ReqId]) {
			  if (chartHistory[ReqId].hasOwnProperty(key)) {
					chartHistory[ReqId][key]();
			  }
			}
			return;
		}
		ReqId+=dir;
		d3.select('#histTrack').node().selectedIndex=ReqId;
		for (var key in chartHistory[ReqId]) {
		  if (chartHistory[ReqId].hasOwnProperty(key)) {
		//	if(key=='selparam' && dir < 0)
		//		chartHistory[ReqId+1][key]();
		//	else
				chartHistory[ReqId][key]();
		  }
		}
	}
	
	function cfrm_sub()
	{
		myLoader();
		d3.selectAll("#loadShield")
			.style("fill",'gray');
		listSelections();
		document.getElementById("subtn").style.border = 'none';
		var sd = document.getElementById('selDate');
		var sdend=0;
		if(document.getElementById("Weekly").checked)
			sdend=6;
		sd=sd.value;
		var dateVari = new Date(sd);
	
		var soa = document.getElementById("selOArea").value;
		var sda = document.getElementById("selDArea").value;
		var sod = document.getElementById("selODistrict").value;
		var sdd = document.getElementById("selDDistrict").value;
		var sof = document.getElementById("selOFacility").value;
		var sdf = document.getElementById("selDFacility").value;
		var srp = document.getElementById("selRootPlant").value;
		var ssst = document.getElementById("selTransp").value;
		var sm = document.getElementById("selMode").value;
		var sssc = document.getElementById("selSSC").value;
		var ss = document.getElementById("selShape").value;
		var srt = document.getElementById("selRootType").value;
		var sr = document.getElementById("selRoot").value;
		var stc = document.getElementById("selSTC").value;
		var stpc = document.getElementById("selStopTC").value;
		var spc = document.getElementById("selProCode").value;
		
		ReqId++;
		var vahold = d3.select('#filtDiv').selectAll('[type=hidden]')[0];
		var vhold=[];		
		vahold.forEach(function(d){
			vhold.push(d.value);
		})
		chartHistory[ReqId].selparam = (function(a,b){return function(){
			loadCnt=14;
			d3.select('#filtDiv').selectAll('[type=hidden]').attr('value',function(d,i){return a[i];})
			var sda=d3.select('#selDate').node();
			sda.value=b;
			filterArgs[4]=sda.options[sda.selectedIndex].text;
			listSelections();		
		}})(vhold,d3.select('#selDate').node().value)
		loadCnt=16;
		var e=new TDF();
		e.setCallbackHandler(Display_Overalls);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,srp,ssst,sm,sssc,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(OArea_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByOAreaData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,sda,sdd,sdf,srp,ssst,sm,sssc,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(DArea_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDAreaData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sod,sof,srp,ssst,sm,sssc,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(ODistrict_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByODistData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sdd,sdf,srp,ssst,sm,sssc,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(DDistrict_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDDistData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sof,srp,ssst,sm,sssc,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(OFacility_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByOFacilityData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sdf,srp,ssst,sm,sssc,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(DFacility_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDFacilityData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,srp,ssst,sm,sssc,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(RootFacility_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByRootFacilityData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,ssst,sm,sssc,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(SST_Chart);	
		e.setErrorHandler(area_data_err);
		e.getBySSTData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,srp,sm,sssc,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(Mode_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByModeData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,srp,ssst,sssc,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(SSC_Chart);	
		e.setErrorHandler(area_data_err);
		e.getBySSCData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,srp,ssst,sm,ss,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(Shape_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByShapeData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,srp,ssst,sm,sssc,srt,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(RCT_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByRCTData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,srp,ssst,sm,sssc,ss,sr,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(Root_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByRootData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,srp,ssst,sm,sssc,ss,srt,stc,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(STC_Chart);	
		e.setErrorHandler(area_data_err);
		e.getBySTCData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,srp,ssst,sm,sssc,ss,srt,sr,stpc,spc);
		var e=new TDF();
		e.setCallbackHandler(StopTC_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByStopTCData(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,srp,ssst,sm,sssc,ss,srt,sr,stc,spc);
		var e=new TDF();
		e.setCallbackHandler(ProductCode_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByProductCode(ReqId,'<cfoutput>#datasource#</cfoutput>',sd,sdend,soa,sda,sod,sdd,sof,sdf,srp,ssst,sm,sssc,ss,srt,sr,stc,stpc,spc);
	
	}
	var trackTimer;
	var Trend_Data=[];
	function Gather_Trend_Data(res)
	{
		var resId = res.pop()[0];
		res.shift();
		Trend_Data[resId].push(res.shift());
		chartHistory[resId].Trend_Graph=(function(data){
			return function(){
				if(Trend_Data[resId].length == 8)
				{
					Trend_Data[ReqId].sort(function(a, b){return new Date(a[5])-new Date(b[5])});
					Load_Trend_Graph(Trend_Data[ReqId]);
				}
			}
		})(res)
		if(ReqId != resId)
			return;
		if(Trend_Data[resId].length == 8)
		{
			Trend_Data[resId].sort(function(a, b){return new Date(a[5])-new Date(b[5])});
			Load_Trend_Graph(Trend_Data[resId]);
		}
	}
	
	function Load_Trend_Graph(res)
	{	
		var w = 500;
		var h = 120;
		var padding = 40;

		var rdiv = (w-(padding*2))/(8)/2;
		var rw = 210/8;
		
		dataset=res;
		var high =d3.max(dataset, function(d) { return d[2]; });
		//Create scale functions
		xScale = d3.time.scale()
							 .domain([d3.min(dataset, function(d) { return new Date(d[5]); }), new d3.max(dataset, function(d) { return new Date(d[5]); })])
							 .range([padding+rw/2-2, w - padding-rw/2+2]);

		yScale = d3.scale.linear()
							 .domain([0, high])
							 .range([h - padding, padding/2.5]);
		
		yScale2 = d3.scale.linear()
							 .domain([0, 1])
							 .range([h - padding, padding/2.5]);

		var formatAsPercentage = d3.format("%");
		var formatAsInt = d3.format("d");		
		var siF = d3.format('.3s');
		var comF = d3.format(',');

					 
		var	cScale = d3.scale.linear().domain([0,0.7,1]).range(["#700","#C00","#0C0"]);	
		
		var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);		

		//Define X axis
		var xAxis = d3.svg.axis()
						  .scale(xScale)
						  .orient("bottom")
						  //.innerTickSize(-h+padding*2)
						  //.ticks(5)
						  .ticks(d3.time.saturday, 1)
						  .tickFormat(d3.time.format('WK %m/%d'));

		//Define Y axis
		var yAxis = d3.svg.axis()
						  .scale(yScale)
						  .orient("left")
						  //.innerTickSize(-w+padding*3)
						  .ticks(5)
						  .tickFormat(siF);
						  
		var yAxis2 = d3.svg.axis()
						  .scale(yScale2)
						  .orient("right")
						  //.innerTickSize(-w+padding*3)
						  .ticks(5)
						  .tickFormat(formatAsPercentage);
		
		var line = d3.svg.line()
		.interpolate("cardinal")
		.x(function(d) { return xScale(new Date(d[5])); })
		.y(function(d) { return yScale(d[2]); });
		
		var line2 = d3.svg.line()
		.interpolate("cardinal")
		.x(function(d) { return xScale(new Date(d[5])); })
		.y(function(d) { return yScale2(d[3]); });
		//Create SVG element
		var svg = d3.select('#trend-Graph').select('#mainSvg');
		
		if(svg.node())
		{
			container=svg.select("#mainContainer");
			svg.select('.x.axis').call(xAxis).selectAll('text')
				.attr("y", 0)
				.attr("x", 9)
				.attr("dy", ".35em")
				.attr("transform", "rotate(45)")
				.style("text-anchor", "start").style('font-size','8px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold');
			svg.select('.y.axis').call(yAxis).selectAll('text').style('font-size','8px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold');
			svg.select('.y2.axis').call(yAxis2).selectAll('text').style('font-size','8px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold');
			
			var fpie=container
				   .selectAll(".failPie")
				   .data(dataset);
				   
			fpie.enter()
				   .append("rect")
					.attr("class", "failPie")
				   .attr("x", function(d,i) { return xScale(new Date(d[5]))-rw/2+2;})
				   .attr("y", function(d) { return yScale(d[2]);})
				   .attr("height",  function(d) {return Math.abs(yScale(d[2])-yScale(0));})
				   .attr("width",rw-4)
				   .style("fill", function(d) {return cScale2(Math.floor(d[3]*100)/100);}) .append('title')
				   .text(function(d) {return 'Failed Pieces: '+comF(d[2]);})

			fpie.transition().duration(500).attr("x", function(d,i) { return xScale(new Date(d[5]))-rw/2+2;})
				   .attr("y", function(d) { return yScale(d[2]);})
				   .attr("height",  function(d) {return Math.abs(yScale(d[2])-yScale(0));})
				   .attr("width",rw-4)
				   .style("fill", function(d) {return cScale2(Math.floor(d[3]*100)/100);})
				   .select('title').text(function(d) {return 'Failed Pieces: '+comF(d[2]);});

			fpie.exit().transition().remove();
			
			
			var lt2 = container.select(".lineTrend2 path")
			.datum(dataset);
			
			lt2.transition().duration(500).attr("class", "lineV")
			.attr("d",  line2)
			.attr('stroke', 'url(#temperature-gradient)')
			.attr('stroke-width', 2)
			.attr('fill', 'none');
		}
		else if(!svg.node())
		{
			svg=d3.select('#trend-Graph')
				.append("svg")
				.attr("width", w)
				.attr("height", h)
				.attr("id", 'mainSvg');
		

			svg.append("rect")
				.attr("width", w)
				.attr("height", h)
				.attr("x", 0)
				.attr("y", 0)
				.attr("rx", 20)
				.attr("ry", 20)
				.style("fill", "white")
				.attr("opacity", 0.2);

			/*	svg.append("text")
				.attr("class", "x label")
				.attr("text-anchor", "end")
				.attr("x", w/2)
				.attr("y", h - padding/3)
				.text("Week");
				
			svg.append("text")
			.attr("class", "y label")
			.attr("text-anchor", "middle")
			.attr("x", -h/2)
			.attr("y", padding/4)
			.attr("transform", "rotate(-90)")
			.text("Failures");
				
			svg.append("text")
			.attr("class", "y label")
			.attr("text-anchor", "middle")
			.attr("x", -h/2)
			.attr("y", w-padding/4)
			.attr("transform", "rotate(-90)")
			.text("Performance");
			*/
			svg.append("text")
			.attr("class", "y label")
			.attr("x", padding-10)
			.attr("y", padding/3)
			.text('8wk Overall Trend').style('font-size','12px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold')
			.attr('fill','#000');

			svg.append("linearGradient")
				.attr("id", "temperature-gradient")
				.attr("gradientUnits", "userSpaceOnUse")
				.attr("x1", 0).attr("y1", yScale2(0))
				.attr("x2", 0).attr("y2", yScale2(1))
				.selectAll("stop")
				.data([
					{offset: "0%", color: c0070},
					{offset: "69%", color: c0070},
					{offset: "70%", color: c7080},
					{offset: "79%", color: c7080},
					{offset: "80%", color: c8090},
					{offset: "89%", color: c8090},
					{offset: "90%", color:c9095},
					{offset: "94%", color: c9095},
					{offset: "95%", color: c9510},
					{offset: "100%", color: c9510}
				])
				.enter().append("stop")
				.attr("offset", function(d) { return d.offset; })
				.attr("stop-color", function(d) { return d.color; });

			var container = svg.append('g').attr('id','mainContainer');
			var fpie=container
				   .selectAll(".failPie")
				   .data(dataset);
				   
			fpie.enter()
				   .append("rect")
					.attr("class", "failPie")
				   .attr("x", function(d,i) { return xScale(new Date(d[5]))-rw/2+2;})
				   .attr("y", function(d) { return yScale(d[2]);})
				   .attr("height",  function(d) {return Math.abs(yScale(d[2])-yScale(0));})
				   .attr("width",rw-4)
				   .style("fill", function(d) {return cScale2(Math.floor(d[3]*100)/100);}) .append('title')
				   .text(function(d) {return 'Failed Pieces: '+comF(d[2]);})

			/*	fpie.transition().duration(500).attr("x", function(d,i) { return xScale(new Date(d[5]))+rdiv-rw/2+2;})
				   .attr("y", function(d) { return yScale(d[1])+rdiv-rw/2+2;})
				   .attr("width", function(d) {return Math.abs(xScale2(d[2])-xScale2(low));})
				   .attr("height", rw-4)
				   .style("fill", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';});
				   
			fpie.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
				   .on('click',function(d){updateGraphs(d[0],paramId)})//id
				   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
				   .select('title')
				   .text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
				   
			//fpie.transition();

			fpie.exit().transition().remove();*/

			container.append("g")
			.attr("class", "lineTrend2")
			.append("path")
			.datum(dataset)
			.attr("class", "lineV")
			.attr("d",  line2)
			.attr('stroke', 'url(#temperature-gradient)')
			.attr('stroke-width', 2)
			.attr('fill', 'none');

			/*svg.append("g")
			.attr("class", "lineTrend")
			.append("path")
			.datum(dataset)
			.attr("class", "lineV")
			.attr("d",  line)
			.attr('stroke', 'black')
			.attr('stroke-width', 2)
			.attr('fill', 'none');*/

			//Create X axis
			svg.append("g")
				.attr("class", "x axis")
				.attr("transform", "translate(0," + (h - padding) + ")")
				.call(xAxis).selectAll('text')
				.attr("y", 0)
				.attr("x", 9)
				.attr("dy", ".35em")
				.attr("transform", "rotate(45)")
				.style("text-anchor", "start").style('font-size','8px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold');

			//Create Y axis
			svg.append("g")
				.attr("class", "y axis")
				.attr("transform", "translate(" + padding + ",0)")
				.call(yAxis)
				.selectAll('text').style('font-size','8px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold');

			//Create Y axis
			svg.append("g")
				.attr("class", "y2 axis")
				.attr("transform", "translate(" + (w-padding) + ",0)")
				.call(yAxis2)
				.selectAll('text').style('font-size','8px').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold');

		}
		
		svg.select("#loadShield").remove();
				
		var ldShd=svg
			.append("rect")
			.attr("id","loadShield")
			.attr("opacity",0.75)
			.style("fill",'none')
			.attr("width", w)
			.attr("height",h);
	}	
	
	function makeDate(dt)
	{
		var m = dt.getMonth()+1;
		var d = dt.getDate();
		var y = dt.getFullYear();
		
		return (m+'/'+d+'/'+y);
	}
	
	function getTimeRemaining(endtime){
	  var t = Date.parse(new Date()) - Date.parse(endtime);
	  var seconds = Math.floor( (t/1000) % 60 );
	  var minutes = Math.floor( (t/1000/60) % 60 );
	  var hours = Math.floor( (t/(1000*60*60)) % 24 );
	  var days = Math.floor( t/(1000*60*60*24) );
	  return {
		'total': t,
		'days': days,
		'hours': hours,
		'minutes': minutes,
		'seconds': seconds
	  };
	}
	
	function Display_Overalls(res)
	{
		var resId = res.pop()[0];
			res.shift();
			chartHistory[resId].Display_Overalls=(function(data){
				return function(){
					var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);		
					var toColor = cScale2(data[0][3]);
					
					var perF = d3.format('.2%');
					var sigF = d3.format('.3g');
					var comF = d3.format(',');
					
					d3.select('#OverallScore').data(data).style('background',toColor).text(function(d){return perF(d[3])});
					d3.select('#OverallFail').data(data).style('background',toColor).text(function(d){return comF(d[2])});
					d3.select('#OverallPieces').data(data).style('background',toColor).text(function(d){return comF(d[4])});
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);		
		var toColor = cScale2(res[0][3]);
		
		var perF = d3.format('.2%');
		var sigF = d3.format('.3g');
		var comF = d3.format(',');
		
		d3.select('#OverallScore').data(res).style('background',toColor).text(function(d){return perF(d[3])});
		d3.select('#OverallFail').data(res).style('background',toColor).text(function(d){return comF(d[2])});
		d3.select('#OverallPieces').data(res).style('background',toColor).text(function(d){return comF(d[4])});
	}
	
	function listSelections()
	{		
		//var filterHds = ['Entry: ','Area: ','District: ','Range: ','Date: ','Level: ','Rollup: ','Class: ','Std.: ','Shape: ']
		//var filterArgs = ['Destination','National','','Week','04/23/2016','Originating From View','Area','Standard','DSCF 3-4','Letters']
		d3.select('#flist').style('display','');
		d3.select('#flist').selectAll('span').remove();
		var hold =[];hold.push(filterHds[4]);//hold.push(filterHds[5]);
		var hold2 =[];hold2.push(filterArgs[4]);//hold2.push(filterArgs[5]);
		d3.select('#flist').selectAll('span').data(hold).enter().append('span').attr('class','smallFnt').text(function(d,i){return d+': '+hold2[i];});
		
	}

	function load_Dates(res)
	{
		//res.shift();
		var sel = document.getElementById('selDate');
		sel.options.length=0;
		res.forEach(function(d,i){
			sel.options[sel.options.length]= 	new Option(d,d);
		});
		var dt = new Date(sel.options[0].text);
		var dow = dt.getDay();
		if(dow == 0)
		{
			filterArgs[4]=sel.options[1].text;
			sel.selectedIndex=1;
		}
		else
			filterArgs[4]=sel.options[0].text;
	
		if(doInit)
		{
			doInit=false;
			chartHistory[0]={};
			document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';cfrm_sub();			
		}
		else
			cfrm();
	}

	function scrollTimeOut(t,res,range,mod,check,container,tableDivID,TblProps)
	{
		d3.select(t).on('mouseup',function(){
			check[0]=false;
		})
		d3.select(t).on('mouseout',function(){
			check[0]=false;
		})
		range+=mod;
		makeTable(res.slice(0),range,container,tableDivID,TblProps);
		if(check[0]==true)
			setTimeout(function(){scrollTimeOut(t,res,range,mod,check,container,tableDivID,TblProps);},3);
	}

	function createScrollTable(containerID,tableDivID, res,TblProps)
	{
		var scrollWidth=18;
		var btnHeight = 18;
		var borderSize = 2;
		var borderColor='black';
		
		var mainDiv=d3.select('#'+containerID);
		if(!mainDiv.select('#sbmain').node())
		{
			mainDiv.append('div')
			.attr('id',tableDivID)
			.attr('tabindex',0)
			.style('display','inline-block')
			
			var sbm=mainDiv.append('div')
			.attr('id','sbmain')
			.style('float','right')
			.style('width',scrollWidth+'px')
			.style('background','silver')	
		
			var sbup=sbm.append('div')
			.attr('id','sbup')
			.attr('class','scrollup')
			.style('height',(btnHeight-borderSize*2)+'px')
			.style('border',borderSize+'px groove black')
			
			sbup.append('div')
			.attr('id','scrollupArrow')
			.attr('class','scrollupArrow')
		
			var sbtrack=sbm.append('div')
			.attr('id','sbtrack')
			.attr('class','scrolltrack')
			.style('border',borderSize+'px groove black')
			
			var sbdragBar=sbtrack.append('div')
			.attr('id','sbdragBar')
			.attr('class','scrollDragBar')
			.attr('draggable',true)
			.attr('tabindex',0)
			.style('border',borderSize+'px groove black')
			.style('position','relative')
			.style('left','-2px')
			.style('top','29px')
			.style('width',(scrollWidth-borderSize*2)+'px')
			.style('position','relative')
		
			var sbdown=sbm.append('div')
			.attr('id','sbdown')
			.attr('class','scrolldown')
			.style('height',(btnHeight-borderSize*2)+'px')
			.style('border',borderSize+'px groove black')
			
			sbdown.append('div')
			.attr('id','scrolldownArrow')
			.attr('class','scrolldownArrow')
		}
		
		TblProps.scrollWidth = scrollWidth;
		TblProps.borderSize = borderSize;
		TblProps.btnHeight = btnHeight;
		if(!TblProps.maxRows)
			TblProps.maxRows=20;
		if(!TblProps.tableAttr)
			TblProps.tableAttr={};
		if(!TblProps.tableAttr.id)
			TblProps.tableAttr.id='mainTable';
		
		if(res.length <= TblProps.maxRows)
			mainDiv.select('#sbmain').style('display','none')
		else
			mainDiv.select('#sbmain').style('display','')
		
		makeTable(res,0,mainDiv,tableDivID,TblProps)		
	}
	
	function makeTable(res,range,container,tableDivID,TblProps)
	{
		var len=res.length;
		if(!range || len <= TblProps.maxRows)
			range=0;
		else if(len - range < TblProps.maxRows)
		{
			range = len-TblProps.maxRows;
		}
		else if(len - range >= len)
		{
			range = 0;
		}
		range = Math.floor(range);
	
		var holdData = res.slice(0);		
		var homediv = container.select('#'+tableDivID);
		var sbm = container.select('#sbmain');
		var sbup = sbm.select('#sbup');
		var sbdown = sbm.select('#sbdown');
		var sbt = sbm.select('#sbtrack');
		var sbdb = sbt.select('#sbdragBar');
		
		var doDrag = d3.behavior.drag().on('drag.foo',function(){
			//d3.event.preventDefault();			
			var delta = d3.event.dy/sbt.node().clientHeight;
			range+=delta*(holdData.length-TblProps.maxRows);
			if(delta != 0)
				makeTable(holdData.slice(0),range,container,tableDivID,TblProps);
		})
		
		scheck=homediv.select('#'+TblProps.tableAttr.id).node();
		if(!scheck)
		{
			var scrPlace = range/(len-TblProps.maxRows);
			var homeTBL =homediv.append('table');

			for(var key in TblProps.tableAttr){
				hold=TblProps.tableAttr[key];
				homeTBL.attr(key,hold)
			}
			
			for(var key in TblProps.tableStyle){
				hold=TblProps.tableStyle[key];
				homeTBL.style(key,hold)
			}
			
			homeTBL.on('wheel',function(){
				d3.event.preventDefault();
				var delta = d3.event.deltaY;
				if(delta < 0)
					makeTable(holdData,range-1,container,tableDivID,TblProps);
				else if(delta > 0)
					makeTable(holdData,range+1,container,tableDivID,TblProps);
			})
			
			homediv.on('keydown',function(){
				d3.event.preventDefault();
				if(d3.event.keyCode==33 || d3.event.keyCode==38)
					makeTable(holdData,range-1,container,tableDivID,TblProps);
				else if(d3.event.keyCode==34 || d3.event.keyCode==40)
					makeTable(holdData,range+1,container,tableDivID,TblProps);
			})
			
			sbdb.call(doDrag);
			
			sbup.on('mousedown',function(){
				check=[];
				check.push(true);
				scrollTimeOut(this,holdData,range,-3,check,container,tableDivID,TblProps);
			});
			
			sbdown.on('mousedown',function(){
				check=[];
				check.push(true);
				scrollTimeOut(this,holdData,range,3,check,container,tableDivID,TblProps);
			});
			
			var thead = homeTBL.append('thead');
			
			res = res.slice(Math.max(0,range),range+TblProps.maxRows);
			
			thead.append('tr')
			.selectAll('th').data(TblProps.headers).enter()
			.append('th')
			.style('width',TblProps.headerWidths)
			.text(function(d){return d;});

			var tbody = homeTBL.append('tbody');
			
			var trs= tbody.selectAll('tr').data(res).enter()
			.append('tr')
			
			for(var key in TblProps.rowStyle){
				hold=TblProps.rowStyle[key];
				trs.style(key,hold)
			}
			
			for(var key in TblProps.rowAttr){
				hold=TblProps.rowAttr[key];
				trs.attr(key,hold)
			}
			
			var tds =trs.selectAll('td').data(function(d){return d}).enter()
			.append('td')
			
			for(var key in TblProps.cellStyle){
				hold=TblProps.cellStyle[key];
				tds.style(key,hold)
			}
			
			for(var key in TblProps.cellAttr){
				hold=TblProps.cellAttr[key];
				tds.attr(key,hold)
			}
			
			tds.text(TblProps.cellFormat);
		}
		else
		{
			var scrPlace = range/(len-TblProps.maxRows);
			res = res.slice(Math.max(0,range),range+TblProps.maxRows);
			
			var homeTBL = homediv.select('#'+TblProps.tableAttr.id);
			homeTBL.on('wheel',function(){
				d3.event.preventDefault();
				var delta = d3.event.deltaY;
				if(delta < 0)
					makeTable(holdData.slice(0),range-1,container,tableDivID,TblProps);
				else if(delta > 0)
					makeTable(holdData.slice(0),range+1,container,tableDivID,TblProps);
			})
			
			homediv.on('keydown',function(){
				d3.event.preventDefault();
				if(d3.event.keyCode==33 || d3.event.keyCode==38)
					makeTable(holdData,range-1,container,tableDivID,TblProps);
				else if(d3.event.keyCode==34 || d3.event.keyCode==40)
					makeTable(holdData,range+1,container,tableDivID,TblProps);
			})
			
			sbdb.call(doDrag);
			
			sbup.on('mousedown',function(){
				check=[];
				check.push(true);
				scrollTimeOut(this,holdData,range,-3,check,container,tableDivID,TblProps);
			});
			
			sbdown.on('mousedown',function(){
				check=[];
				check.push(true);
				scrollTimeOut(this,holdData,range,3,check,container,tableDivID,TblProps);
			});			
			
			var tbody = homeTBL.select('tbody');
			var trs = tbody.selectAll('tr').data(res);
			
			trs.enter()
			.append('tr');
			
			for(var key in TblProps.rowStyle){
				hold=TblProps.rowStyle[key];
				trs.style(key,hold)
			}
			
			for(var key in TblProps.rowAttr){
				hold=TblProps.rowAttr[key];
				trs.attr(key,hold)
			}
			
			var tds=trs.selectAll('td').data(function(d){return d});
			tds.enter()
			.append('td')
			.text(TblProps.cellFormat);
			
			tds.text(TblProps.cellFormat);
			
			for(var key in TblProps.cellStyle){
				hold=TblProps.cellStyle[key];
				tds.style(key,hold)
			}
			
			for(var key in TblProps.cellAttr){
				hold=TblProps.cellAttr[key];
				tds.attr(key,hold)
			}
			
			tds.exit().transition().remove();
			
			trs.exit().transition().remove();
		}
		var cntAbort = 100;
		while(container.style('min-width') != (homediv.node().clientWidth+TblProps.scrollWidth+'px') && cntAbort>0)
		{
			container.style('min-width',homediv.node().clientWidth+TblProps.scrollWidth+'px');
			cntAbort--;
		}
		sbm.style('height',homediv.node().clientHeight-(TblProps.borderSize*2)+'px');
		sbt.style('height',sbm.node().clientHeight-(TblProps.btnHeight*2)+'px');
		sbdb.style('height',sbt.node().clientHeight/len+'px');
		if(sbdb.node().clientHeight < TblProps.btnHeight)
			sbdb.style('height',TblProps.btnHeight+'px')
		sbdb.style('top',(sbt.node().clientHeight-sbdb.node().clientHeight)*scrPlace-(TblProps.borderSize)+'px');
		
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
		d3.select('#RAll').style('color','silver');
		d3.select('#filtDiv').selectAll('[type=hidden]').attr('value','');
		chartHistory.length=ReqId+1;
		chartHistory[ReqId+1]={};
		var ht=d3.select('#histTrack').node();
		ht.options.length=ReqId+1;
		ht.options[ReqId+1]=new Option("Reset All",ReqId+1);
		ht.selectedIndex=ReqId+1;
		cfrm_sub();
	}
	
	function moveCharts(rowSize)
	{
		var charts = d3.selectAll("[id^='chart-']")[0];
		var divWidth = 380*(rowSize/1)
		var cSpace = d3.select('#chrtSpace');
		var collapse = d3.select('#clpseCht').node().checked;
		if(collapse)
		{
			 d3.selectAll("[id^='chart-']").select('svg').style('display','none');
			 d3.selectAll("[id^='chart-']").select('#orderer').style('display','');
		}
		else
		{
			 d3.selectAll("[id^='chart-']").select('svg').style('display','');
			 d3.selectAll("[id^='chart-']").select('#orderer').style('display','none');
		}
		d3.selectAll("#chrtSpace > div").remove();
		cSpace.selectAll('br').remove();
		var targetDiv;
		charts.forEach(function(d,i){
			if(i%rowSize==0)
			{
				cSpace.append('div');
				targetDiv = cSpace.append('div')
				.style('width',divWidth+'px')
				.style('text-align','left')
				.style('margin',' 0 auto')
				.style('min-height','20px')
				.style('height',function(){if(d3.select('#clpseCht').node().checked)return '65px';return '';})
				/*.style('border-left','10px solid #21435F')
				.style('border-bottom-left-radius','25px')
				.style('border-top-left-radius','25px')
				.on('mouseover',function(){if(d3.event.target != this){d3.select(this).style('border-left','10px solid #21435F');return;};d3.select(this).style('border-left','10px solid #C3C3F7')})
				.on('click',function(){
					if(d3.event.target != this)
						return;
					if(d3.select(this).style('height') != d3.select(this).style('min-height'))
					{
						var lbl=d3.select(this).append('label').attr('id','tempLbl').attr('class','labelTip');
						d3.select(this).selectAll('div').select('.y.label').style('border',function(){if(lbl.text() == '')lbl.text(d3.select(this).text());else lbl.text(lbl.text()+', '+d3.select(this).text());});
						d3.select(this).style('background','#21435F').style('margin',' 2px auto').selectAll('div').style('display','none');
					}else{
						d3.select(this).select('#tempLbl').remove();
						d3.select(this).style('background','').style('margin',' 0 auto').selectAll('div').style('display','inline-block')
					}
				})
				.on('mouseout',function(){d3.select(this).style('border-left','10px solid #21435F')})*/
				//.attr('class','chartShelf')
			}
			targetDiv.node().appendChild(d);
		})
	}
	function HCLpicker(eve,sColor,t)
	{
		d3.select("#hclCont").style("display","").style("top",eve.y+"px").style("left",eve.x+"px");
		var white = d3.rgb("white"),
		black = d3.rgb("black"),
		width = d3.select("canvas").property("width");
		height = d3.select("canvas").property("height");

		var channels = {
		  h: {scale: d3.scale.linear().domain([0, 360]).range([0, height]), y: height / 2},
		  c: {scale: d3.scale.linear().domain([0, 100]).range([0, height]), y: height / 2},
		  l: {scale: d3.scale.linear().domain([0, 150]).range([0, height]), y: height / 2}
		};
		var hold=d3.hcl(sColor);
		channels.h.y=channels.h.scale(hold.h);
		channels.c.y=channels.c.scale(hold.c);
		channels.l.y=channels.l.scale(hold.l);
		var channel = d3.selectAll(".channel")
			.data(d3.entries(channels));
			
		d3.select('#chooseColor').on('click',function(){
			var HCLcolor = d3.select('#hcl').node().style.background;
			t.value = HCLcolor;
			t.style.background=HCLcolor;			
			t.parentNode.style.background=HCLcolor;
			d3.select('#clrVal').attr('value',HCLcolor);
			if(t.name == 'c0070')
				c0070=HCLcolor;
			else if(t.name == 'c7080')
				c7080=HCLcolor;
			else if(t.name == 'c8090')
				c8090=HCLcolor;
			else if(t.name == 'c9095')
				c9095=HCLcolor;
			else if(t.name == 'c9510')
				c9510=HCLcolor;
			d3.select("#hclCont").style("display","none");
			var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);	
			d3.selectAll(".failPie")
			.style("fill", function(d) {
				if(d3.select(this).node().style.fill!='#c0c0c0')
					return cScale2(Math.floor(d[3]*100)/100);
				return '#c0c0c0';
			})
			d3.selectAll(".failPer")
			.style("fill", function(d) {
				if(d3.select(this).node().style.fill!='#c0c0c0')
					return cScale2(Math.floor(d[3]*100)/100);
				return '#c0c0c0';
			})
			d3.selectAll(".ovAll")
			.style("background", function(d) {
				return cScale2(Math.floor(d[3]*100)/100);
			})
			d3.select("#temperature-gradient")
				.selectAll("stop")
				.data([
					{offset: "0%", color: c0070},
					{offset: "69%", color: c0070},
					{offset: "70%", color: c7080},
					{offset: "79%", color: c7080},
					{offset: "80%", color: c8090},
					{offset: "89%", color: c8090},
					{offset: "90%", color:c9095},
					{offset: "94%", color: c9095},
					{offset: "95%", color: c9510},
					{offset: "100%", color: c9510}
				])
				.attr("offset", function(d) { return d.offset; })
				.attr("stop-color", function(d) { return d.color; });
		})

		d3.select('#resetColor').on('click',function(){
			if(t.name == 'c0070')
				HCLcolor = c0070="#d73027";
			else if(t.name == 'c7080')
				HCLcolor = c7080="#fc8d59";
			else if(t.name == 'c8090')
				HCLcolor = c8090="#fee090";
			else if(t.name == 'c9095')
				HCLcolor = c9095="#91bfdb";
			else if(t.name == 'c9510')
				HCLcolor = c9510="#4575b4";
			t.value = HCLcolor;
			t.style.background=HCLcolor;			
			t.parentNode.style.background=HCLcolor;
			d3.select("#hclCont").style("display","none");
			var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);	
			d3.selectAll(".failPie")
			.style("fill", function(d) {
				if(d3.select(this).node().style.fill!='#c0c0c0')
					return cScale2(Math.floor(d[3]*100)/100);
				return '#c0c0c0';
			})
			d3.selectAll(".failPer")
			.style("fill", function(d) {
				if(d3.select(this).node().style.fill!='#c0c0c0')
					return cScale2(Math.floor(d[3]*100)/100);
				return '#c0c0c0';
			})
			d3.selectAll(".ovAll")
			.style("background", function(d) {
				return cScale2(Math.floor(d[3]*100)/100);
			})
			d3.select("#temperature-gradient")
				.selectAll("stop")
				.data([
					{offset: "0%", color: c0070},
					{offset: "69%", color: c0070},
					{offset: "70%", color: c7080},
					{offset: "79%", color: c7080},
					{offset: "80%", color: c8090},
					{offset: "89%", color: c8090},
					{offset: "90%", color:c9095},
					{offset: "94%", color: c9095},
					{offset: "95%", color: c9510},
					{offset: "100%", color: c9510}
				])
				.attr("offset", function(d) { return d.offset; })
				.attr("stop-color", function(d) { return d.color; });
		})
		
		var canvas = channel.select("canvas")
			.call(d3.behavior.drag().on("drag", dragged))
			.each(render);

		function dragged(d) {
		  d.value.y = Math.max(0, Math.min(this.height - 1, d3.mouse(this)[1]));
		  canvas.each(render);
		}

		function render(d) {
		  var height = this.height,
			  context = this.getContext("2d"),
			  image = context.createImageData(1, height),
			  i = -1;

		  var current = d3.hcl(
			channels.h.scale.invert(channels.h.y),
			channels.c.scale.invert(channels.c.y),
			channels.l.scale.invert(channels.l.y)
		  );

		  for (var y = 0, v, c; y < height; ++y) {
			if (y === Math.floor((d.value.y<0)?d.value.y+height:d.value.y)) {
			  current[d.key] = d.value.scale.invert(y);
			  d3.select('#hcl').style('background',d3.rgb(current).toString());
			  d3.select('#clrVal').attr('value',d3.select('#hcl').node().style.background);
			  c = white;
			} else if (y === Math.floor(d.value.y) - 1) {
			  c = black;
			} else {
			  current[d.key] = d.value.scale.invert(y);
			  c = d3.rgb(current);
			}
			image.data[++i] = c.r;
			image.data[++i] = c.g;
			image.data[++i] = c.b;
			image.data[++i] = 255;
		  }

		  context.putImageData(image, 0, 0);
		}
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
<div id="wrapper" class="" style='min-width:75%;'>
      
      <!-- Sidebar -->
            <!-- Sidebar -->
      <div id="sidebar-wrapper">
      <ul id="sidebar_menu" class="sidebar-nav">
           <li class="sidebar-brand"><a id="menu-toggle" href="#" >Menu</a></li>
      </ul>
        <ul class="sidebar-nav" id="sidebar">     
          <li><a>Link1</a></li>
          <li><a>link2</a></li>
        </ul>
      </div>
          
      <!-- Page content -->
      <div id="page-content-wrapper">
<br>
<fieldset class="fset" style="border: solid 1px blue;padding: 5px 5px"><legend>Filters</legend>
<div id='filtDiv'>
	<fieldset class="" style='display:none;' ><legend>Report For:</legend>
		<input type='hidden' id="selOArea" name='selOArea' value=''>
		<input type='hidden' id="selDArea" name='selDArea' value=''>
		<input type='hidden' id="selODistrict" name='selODistrict' value=''>
		<input type='hidden' id="selDDistrict" name='selDDistrict' value=''>
		<input type='hidden' id="selOFacility" name='selOFacility' value=''>
		<input type='hidden' id="selDFacility" name='selDFacility' value=''>
		<input type='hidden' id="selRootPlant" name='selRootPlant' value=''>
		<input type='hidden' id="selTransp" name='selTransp' value=''>
		<input type='hidden' id="selMode" name='selMode' value=''>
		<input type='hidden' id="selSSC" name='selSSC' value=''>
		<input type='hidden' id="selShape" name='selShape' value=''>
		<input type='hidden' id="selRootType" name='selRootType' value=''>
		<input type='hidden' id="selRoot" name='selRoot' value=''>
		<input type='hidden' id="selSTC" name='selSTC' value=''>
		<input type='hidden' id="selStopTC" name='selStopTC' value=''>
		<input type='hidden' id="selProCode" name='selProCode' value=''>
	</fieldset>
	<fieldset class="fset"><legend>Date By:</legend>
		&nbsp;&nbsp;&nbsp;&nbsp;Starting:
		<select class ="slct" name = "selDate" id = "selDate" onchange = "filterArgs[4]=this.options[this.selectedIndex].text;cfrm();">
		</select>
		<input class ="slct" id="daily" type = "radio" value = "Daily" name='DRANGE' onclick="var e=new TDF();e.setCallbackHandler(load_Dates);e.setErrorHandler(area_data_err);e.getDates('<cfoutput>#datasource#</cfoutput>','');" checked>Daily
		<input class ="slct" id="Weekly" type = "radio" value = "Weekly" name='DRANGE' onclick="var e=new TDF();e.setCallbackHandler(load_Dates);e.setErrorHandler(area_data_err);e.getDates('<cfoutput>#datasource#</cfoutput>','WK');">Weekly
	</fieldset>
	
	<fieldset class="fset"><legend></legend>
		<input class ="slct" id="subtn" type = "button" value = "Submit Request" onClick="chartHistory.length=ReqId+1;chartHistory[ReqId+1]={};var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1;ht.options[ReqId+1]=new Option(d3.select('#selDate').node().value,ReqId+1);ht.selectedIndex=ReqId+1;document.getElementById('chRow').style.display='inline-block';document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';cfrm_sub();">        
	</fieldset>
	<fieldset class="fset"><legend></legend>
		<input class ="slct" id="hideFilt" type = "button" value = "Hide" onClick="document.getElementById('chRow').style.display='inline-block';document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';d3.select('#flist').style('display','');">        
	</fieldset>
</div>
	<fieldset class="fset" id="sFilt" style='display:none'><legend></legend>
		<input class ="slctSmall" type = "button" value = "Show Filters" onClick="document.getElementById('chRow').style.display='none';document.getElementById('filtDiv').style.display='';d3.select('#flist').style('display','none');document.getElementById('sFilt').style.display='none';">
		<div id='flist' style='float:right'></div>
	</fieldset>
</fieldset>
<div id='chRow' style="display:inline-block;margin:5px;">
<input class ="slctSmall" type='button' value='Undo' onclick='doHistory(-1);'>
<select class ="slctSmall" id='histTrack' style='width:100px;' onchange = "doHistory(0,this.options[this.selectedIndex].value);">
		<option value = 0>Default</option> 
</select>
<input class ="slctSmall" type='button' value='Redo' onclick='doHistory(1);'>
<select class ="slctSmall" id='cpr' onchange = "moveCharts(this.options[this.selectedIndex].value);">
		<option value = 1>1 Chart Per Row</option>
		<option value = 2>2 Charts Per Row</option> 
		<option value = 3 selected>3 Charts Per Row</option> 
		<option value = 4>4 Charts Per Row</option> 
		<option value = 5>5 Charts Per Row</option> 
		<option value = 6>6 Charts Per Row</option> 
		<option value = 7>7 Charts Per Row</option> 
</select>
Reorder:<label class="switch">
  <input id='clpseCht' type="checkbox" onchange = "moveCharts(d3.select('#cpr').node().value);">
  <div class="slider round"></div>
</label>
<input class ="slctSmall" type='button' value='Report Notes' onclick='window.open("Package Performance Processing Visualization.docx")'>
</div>
<div id="trend-Graph" style="float:right;text-align:center; min-width:20%;"></div>
<h2>Package Performance Processing [DEV]</h2><iframe id="txtArea1" style="display:none"></iframe>
<div id ="loaderDiv" style="z-index: 3;"></div>
<div id='hclCont' style='text-align:center;position:absolute;display:none;border:3px groove black; background:silver;box-shadow:0px 0px 5px silver; width: 170px; padding:10px;'>
<div class="channel" id="h" style='display:inline-block;min-height:90px;'>
  <canvas width="1" height="90" style='border:1px solid black;width:20px;height:90px;'></canvas>
  <svg width="20" height="90"><g class="axis" transform="translate(30,.5)"></g></svg>
</div>
<div class="channel" id="c" style='display:inline-block;min-height:90px;'>
  <canvas width="1" height="90" style='border:1px solid black;width:20px;height:90px;'></canvas>
  <svg width="20" height="90"><g class="axis" transform="translate(30,.5)"></g></svg>
</div>
<div class="channel" id="l" style='display:inline-block;min-height:90px;'>
  <canvas width="1" height="90" style='border:1px solid black;width:20px;height:90px;'></canvas>
  <svg width="20" height="90"><g class="axis" transform="translate(30,.5)"></g></svg>
</div><br><br>
<div class="channel" id="hcl" style='border:1px solid black;display:inline-block;width:20px;height:20px;'>
</div>
<input type='button' class = 'cbtn' id='chooseColor' value="Choose">
<input type='button' class = 'cbtn' onclick='d3.select("#hclCont").style("display","none");' value="Cancel">
<input type='button' class = 'cbtn' id='resetColor' value="Reset">
</div>
<div style='min-width:1260px;text-align:left;margin:0 0 0 10%;'>
<div style="margin:15px 50px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: times, Times New Roman;vertical-align:top;"><legend style='font-weight:bold;font-size: 24px;'>Overall Score</legend><div class='ovAll' id="OverallScore" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div style="margin:15px 50px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: times, Times New Roman;vertical-align:top;"><legend style='font-weight:bold;font-size: 24px;'>Overall Failed Pieces</legend><div class='ovAll' id="OverallFail" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div style="margin:15px 50px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: times, Times New Roman;vertical-align:top;"><legend style='font-weight:bold;font-size: 24px;'>Overall Pieces</legend><div class='ovAll' id="OverallPieces" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div id="color-key" style='text-align: left;margin:15px 50px;display:inline-block;vertical-align:top;'>
	<strong title='Click colors to change them'>Color Key </strong>
	<div style="height:24px;">
		<div style=";line-height: 90%;display:inline-block;height:20px;width:20px;border:1px black solid;background:#4575b4">
			<input type='button' name='c9510' onclick=' HCLpicker(event,this.value,this);' value="#4575b4" style="line-height: 0%;color:transparent; background:#4575b4;opacity:1; border:none;padding:0px;margin:0px;height:20px;width:20px;">
		</div><span>Score 95&ndash;100%</span>
	</div>
	<div style="height:24px;">
		<div style=";line-height: 90%;display:inline-block;height:20px;width:20px;border:1px black solid;background:#91bfdb">
			<input type='button' name='c9095' onclick=' HCLpicker(event,this.value,this);' value="#91bfdb" style="line-height: 0%;color:transparent; background:#91bfdb;opacity:1; border:none;padding:0px;margin:0px;height:20px;width:20px;">
			</div><span>Score 90&ndash;95%</span>
	</div>
	<div style="height:24px;">
		<div style=";line-height: 90%;display:inline-block;height:20px;width:20px;border:1px black solid;background:#fee090">
			<input type='button' name='c8090' onclick=' HCLpicker(event,this.value,this);' value="#fee090" style="line-height: 0%;color:transparent; background:#fee090;opacity:1; border:none;padding:0px;margin:0px;height:20px;width:20px;">
		</div><span>Score 80&ndash;90%</span>
	</div>
	<div style="height:24px;">
		<div style=";line-height: 90%;display:inline-block;height:20px;width:20px;border:1px black solid;background:#fc8d59">
			<input type='button' name='c7080' onclick=' HCLpicker(event,this.value,this);' value="#fc8d59" style="line-height: 0%;color:transparent; background:#fc8d59;opacity:1; border:none;padding:0px;margin:0px;height:20px;width:20px;">
		</div><span>Score 70&ndash;80%</span>
	</div>
	<div style="height:24px;">
		<div style=";line-height: 90%;display:inline-block;height:20px;width:20px;border:1px black solid;background:#d73027">
			<input type='button' name='c0070' onclick=' HCLpicker(event,this.value,this);' value="#d73027" style="line-height: 0%;color:transparent; background:#d73027;opacity:1; border:none;padding:0px;margin:0px;height:20px;width:20px;">
		</div><span>Score 0&ndash;70%</span>
	</div>
</div>
<input type='button' id="RAll" style="font-size: 10px;border:none;text-decoration:underline;padding:10px 0px;background:transparent;color:silver;height:40px;width:80px;cursor:pointer;" value='Reset All' onClick='resetAll();'/>
</div>
<div id='searchBlockParent' class='popup' style='z-index:4;display: none;position: absolute; top:50%; left:50%; text-align:center;margin: 0 auto;'>
<div id='searchBlockMove' style='border:gray outset 3px;min-height:18px;min-width:97%;background:#21435F;'><img src ='images/close_icon.png' class = 'imgbtn' style="float:right" onMouseDown="d3.select('#searchBlockParent').style('display','none');event.stopPropagation();"/></div>
<div id='searchBlock' style='padding: 25px;border: solid 2px blue;background:#f3f3f3;text-align:center;margin: 0 auto;'>
Search by Name:
<input id='searchTarget' type='text' onkeyup='if (event.keyCode == 13) {d3.select("#commitSearch").node().click();}'/> <input type='button' id='commitSearch' value='submit' onClick='d3.select("#searchBlockParent").style("display","none");')/>
</div></div>
<div id='sortBlockParent' class='popup' style='z-index:4;display: none;position: absolute; top:50%; left:50%; text-align:center;margin: 0 auto;'>
<div id='sortBlockMove' style='border:gray outset 3px;min-height:18px;min-width:97%;background:#21435F;'><img src ='images/close_icon.png' class = 'imgbtn' style="float:right" onMouseDown="d3.select('#sortBlockParent').style('display','none');event.stopPropagation();"/></div>
<div id='sortBlock' style='padding: 25px;border: solid 2px blue;background:#f3f3f3;text-align:center;margin: 0 auto;'>
Sort by:<select id='sortslct' class ="slctSmall">
		<option value = 2>Failed Pieces desc</option>
		<option value = 3>Percent desc</option> 
		<option value = -2>Alphabetical desc</option> 
		<option value = -3>Failed Pieces</option> 
		<option value = -4>Percent</option> 
		<option value = 1>Alphabetical</option>
		</select>
</div></div>
<div id='tblBlockParent' class='popup' style='z-index:4;display: none;position: absolute; top:50%; left:50%; text-align:center;margin: 0 auto;'>
<div id='tblBlockMove' style='border:gray outset 3px;min-height:18px;min-width:97%;background:#21435F;'>
<img src ='images/close_icon.png' class = 'imgbtn' style="float:right;" onMouseDown="d3.select('#tblBlockParent').call(d3.behavior.drag().on('drag', null));d3.select('#tblBlockParent').on('mousedown.drag',null);d3.select('#tblBlockParent').style('display','none');event.stopPropagation();"/>
</div>
<div id='tblBlock' style='padding: 3px;border: solid 2px blue;background:#f3f3f3;'></div>
</div>
<div id='chrtSpace' style='margin:0 0 0 10%;text-align:left;min-width:1260px;'>
<div style='min-width:99%;text-align:left;margin: 0 auto;'>
<div id="chart-OArea" style="display:inline-block;background:#f3f3f3;"></div>
<div id="chart-ODistrict" style="display:inline-block;background:#f3f3f3;"></div>
<div id="chart-OFacility" style="display:inline-block;background:#f3f3f3;"></div>
</div>
<br>
<div style='min-width:99%;text-align:left;margin: 0 auto;'>
<div id="chart-DArea" style="display:inline-block;background:#f3f3f3;"></div>
<div id="chart-DDistrict" style="display:inline-block;background:#f3f3f3;"></div>
<div id="chart-DFacility" style="display:inline-block;background:#f3f3f3;"></div>
</div>
<br>
<div style='min-width:99%;text-align:left;margin: 0 auto;'>
<div id="chart-RFacility" style="display:inline-block;background:#f3f3f3;"></div>
<div id="chart-SST" style="display:inline-block;background:#f3f3f3;"></div>
<div id="chart-Mode" style="display:inline-block;background:#f3f3f3;"></div>
</div>
<br>
<div style='min-width:99%;text-align:left;margin: 0 auto;'>
<div id="chart-SSC" style="display:inline-block;background:#f3f3f3;"></div>
<div id="chart-Shape" style="display:inline-block;background:#f3f3f3;"></div>
<div id="chart-RCT" style="display:inline-block;background:#f3f3f3;"></div>
</div>
<br>
<div style='min-width:99%;text-align:left;margin: 0 auto;'>
<div id="chart-Root" style="display:inline-block;background:#f3f3f3;"></div>
<div id="chart-STC" style="display:inline-block;background:#f3f3f3;"></div>
<div id="chart-StopTC" style="display:inline-block;background:#f3f3f3;"></div>
</div>
<br>
<div style='min-width:99%;text-align:left;margin: 0 auto;'>
<div id="chart-ProCode" style="display:inline-block;background:#f3f3f3;"></div>
</div>
</div>
<input class ="hyperFont" type = "button" id='eOut' value = "Excel" onClick="excel_out();" style='display:none;margin:0px 0px 0px 30px;'>
<div id='scrollTableCont' style='position:absolute; top:20%; left:20%; margin:0 auto; '>
</div>
<div id ="mainDiv" ></div>
</div>
</body>
</html>