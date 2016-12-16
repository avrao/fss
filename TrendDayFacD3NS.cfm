<!doctype html>
<cfajaxproxy cfc="TrendDayFacD3NS" jsclassname="TDF">
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

	function updateGraphs(val,id)
	{
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
			d3.select('#RAll').style('color','silver');
		else
			d3.select('#RAll').style('color','blue');
		
		cfrm_sub();
	}
	
	var loadCnt=8;
	var c0070="#d73027";
	var c7080="#fc8d59";
	var c8090="#fee090";
	var c9095="#91bfdb";
	var c9510="#4575b4";
	
	function streamLineChart(res,paramId,contId,chartId,cTitle,loaderId,range)
	{	
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

		var yAxis = d3.svg.axis()
						  .scale(yScale)
						  .orient("right")

		var xAxis = d3.svg.axis()
						  .scale(xScale)
						  .orient("top")
						  .ticks(5)
						  .tickFormat(formatAsPercentage);
						  
		xAxis2 = d3.svg.axis()
						  .scale(xScale2)
						  .orient("bottom")
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
		
		zoomed=(function(AR,pID,cID,chID,title,LID,rng,zm){return function zoomed() {
			if(loadCnt > 0)
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
			.style("fill",'none');
			svg.select('g')
				.call(zoom);
				
			svg.select('#magnifier')
			.on('click',(function(AR,pID,cID,chID,title,LID,rng){
				return function doSe(){
					d3.select('#searchBlock').style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px');
					d3.select('#commitSearch').on('click',function(){					
						d3.select("#searchBlock").style("display","none");
						var targetSearch=d3.select('#searchTarget').node().value.toUpperCase();
						var len = AR.length;
						AR.forEach(function(d,i){
							if(d[1].search(targetSearch)>=0)
								rng=len-i-1;
						})
						streamLineChart(AR,pID,cID,chID,title,LID,rng);
					})
					
				}
			})(holdData,paramId,contId,chartId,cTitle,loaderId,range)
			)
			
			if(len>maxRows){
				scrolly=(function(AR,pID,cID,chID,title,LID,rng){return function() {
					if(loadCnt > 0)
						return;
					var len = AR.length;
					var hr = 15;
					rng+=d3.event.dy*((len-maxRows)/(h - padding * 2-hr));
					if(len-rng < maxRows)
						rng = len-maxRows;
					if(rng<0)
						rng=0;
					streamLineChart(AR,pID,cID,chID,title,LID,rng);
				}})(holdData,paramId,contId,chartId,cTitle,loaderId,range)
				
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
				.append("svg")
				.attr("width", w)
				.attr("height", h)
				.style("margin", '0px 0px 30px 30px')
				.attr("id", chartId)
				.attr('draggable','true')
			  .append("g")
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
			
			svg.append("rect")
				.attr("width", w)
				.attr("height", h)
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
				.append("tspan").attr('display','block')
				.attr("id","gphName");
				
			svg.append("text")
			.attr("class", "y label")
			.attr("x", padding-10)
			.attr("y", padding/3)
			.text(cTitle).style('font-weight','bold')
			.attr('fill','#000');
				
			svg.append("g").attr('id','magnifier')
			.on('click',(function(AR,pID,cID,chID,title,LID,rng){
				return function doSe(){
					d3.select('#searchBlock').style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px');
					d3.select('#commitSearch').on('click',function(){					
						d3.select("#searchBlock").style("display","none");
						var targetSearch=d3.select('#searchTarget').node().value.toUpperCase();
						var len = AR.length;
						AR.forEach(function(d,i){
							if(d[1].search(targetSearch)>=0)
								rng=len-i-1;
						})
						streamLineChart(AR,pID,cID,chID,title,LID,rng);
					})
					
				}
			})(holdData,paramId,contId,chartId,cTitle,loaderId,range)
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
			
				svg.append("rect")
					.style("fill", "black")
					.style("opacity",0.75)
					.attr('id','scroll-track')
					.attr("x", w-padding+7)
					.attr("y", padding)
					.attr("width", 1)
					.attr("height", h-padding*2)
			
				scrolly=(function(AR,pID,cID,chID,title,LID,rng){return function() {
					if(loadCnt > 0)
						return;
					var len = AR.length;
					var hr = 15;
					rng+=d3.event.dy*((len-maxRows)/(h - padding * 2-hr));
					if(len-rng < maxRows)
						rng = len-maxRows;
					if(rng<0)
						rng=0;
					streamLineChart(AR,pID,cID,chID,title,LID,rng);
				}})(holdData,paramId,contId,chartId,cTitle,loaderId,range)
				
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
					.call(scrDrag)	;
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
					})
					.on("mouseout",function(){d3.select(this).transition()
						.style("fill", "url(#shadeV)")
					});
				
			
			if(len<=maxRows){
				d3.select('#'+contId).select("#scroll-rect").style('display','none');
				d3.select('#'+contId).select("#scroll-track").style('display','none');
			}

		}
		
		if(holdData.length <= maxRows)
			svg.select('#magnifier').style('display','none');
		else
			svg.select('#magnifier').style('display','');
			
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
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){ var nme = d3.select(this.parentNode.parentNode.parentNode).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d[1],ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
			   .append('title');
			   
		tle.append("tspan").attr('display','block').text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nPercent: '+perF(d[3]);})	
		
		fpie.transition().duration(500).attr("x", function(d,i) { return xScale2(low);})
			   .attr("y", function(d) { return yScale(d[1])+rdiv-rw/2+2;})
			   .attr("width", function(d) {return Math.abs(xScale2(d[2])-xScale2(low));})
			   .attr("height", rw-4)
			   .style("fill", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';});
			   
		tle=fpie.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){var nme = d3.select(this.parentNode.parentNode.parentNode).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d[1],ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
			   .select('title');
		
		tle.selectAll('tspan').remove();	
		tle.append("tspan").attr('display','block').text(function(d) {return '\nFailed Pieces: '+comF(d[2]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nPercent: '+perF(d[3]);})	
		
		fpie.exit().transition().remove();
		
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
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){var nme = d3.select(this.parentNode.parentNode.parentNode).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d[1],ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',0.25).attr('stroke','');})
			   .append('title');

		tle.append("tspan").attr('display','block').text(function(d) {return 'Percent: '+perF(d[3]);})	
		tle.append("tspan").attr('display','block').text(function(d) {return '\nFailed Pieces: '+comF(d[2]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})	
		
		fpc.transition().duration(500).attr("class", "failPer")
			   .attr("cx", function(d,i) {	return xScale(d[3]);})
			   .attr("cy", function(d) { return yScale(d[1])+rdiv;})
			   .attr("r", 5)
			   .attr("stroke", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale(d[3]);return 'white'; })
			   .attr("stroke-width", 2)
			   .style("fill", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';});
			   
		tle=fpc.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){var nme = d3.select(this.parentNode.parentNode.parentNode).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d[1],ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',0.25).attr('stroke','');})
			   .select('title');
		
		
		tle.selectAll('tspan').remove();
		tle.append("tspan").attr('display','block').text(function(d) {return 'Percent: '+perF(d[3]);})	
		tle.append("tspan").attr('display','block').text(function(d) {return '\nFailed Pieces: '+comF(d[2]);})
		tle.append("tspan").attr('display','block').text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})	
		
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
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d,i){var nme = d3.select(this.parentNode.parentNode.parentNode).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d,ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(res[i][0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
			   .append('title');
			
			
			tle.append("tspan").attr('display','block').text(function(d,i) {return 'Failed Pieces: '+comF(res[i][2]);})
			tle.append("tspan").attr('display','block').text(function(d,i) {return '\nTotal Pieces: '+comF(res[i][4]);})
			tle.append("tspan").attr('display','block').text(function(d,i) {return '\nPercent: '+perF(res[i][3]);})		
			   
			   svg.append("text")
			.attr("class", "y label")
			.attr("x", w-padding)
			.attr("y", padding/3)
			.text('Reset').style('font-weight','bold').style('font-size','10px').style('text-decoration','underline').style('cursor','pointer').style('font-variant','small-caps').style('font-family','times, Times New Roman')
			.attr('fill',function(){if(selParam == '')return 'silver';return 'blue'})
			.attr('id','resetLink')
			.on('click',function(){var nme = d3.select(this.parentNode.parentNode.parentNode).select('.y').text();chartHistory.length=ReqId+1;chartHistory[ReqId+1]={};var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1;ht.options[ReqId+1]=new Option("Reset "+nme,ReqId+1);ht.selectedIndex=ReqId+1;d3.select('#'+paramId).node().value='';cfrm_sub();});
		}
		else
		{
			var Ytext=svg.select('.y.axis').call(yAxis).selectAll('text');
			Ytext.selectAll('title').remove();
			tle=Ytext.attr('fill','#darkblue').style('font-family','times, Times New Roman').style('font-variant','small-caps').style('font-weight','bold')
				   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
				   .on('click',function(d,i){var nme = d3.select(this.parentNode.parentNode.parentNode).select('.y').text(); chartHistory.length=ReqId+1; chartHistory[ReqId+1]={}; var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1; ht.options[ReqId+1]=new Option(nme+'-'+d,ReqId+1); ht.selectedIndex=ReqId+1;updateGraphs(res[i][0],paramId)})//id
				   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
				   .append('title');
			
			tle.selectAll('tspan').remove();
			tle.append("tspan").attr('display','block').text(function(d,i) {return 'Failed Pieces: '+comF(res[i][2]);})
			tle.append("tspan").attr('display','block').text(function(d,i) {return '\nTotal Pieces: '+comF(res[i][4]);})	
			tle.append("tspan").attr('display','block').text(function(d,i) {return '\nPercent: '+perF(res[i][3]);})	
			
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
    
	
	function Chart_Maker(Container,svgWidth,svgHeight,svgID)
	{
		var w = svgWidth | 350;
		var h = svgHeight | 350;
		var padding = 50;
		var brush = d3.svg.brush();
		brush.x(d3.scale.linear().domain([0,1]).range([padding, w - padding]));
		//brush.y(d3.scale.linear().domain([0,1]).range([h-padding, padding]));
		var svg,mc,ChartMaker;
		var zoomed,range,maxRows;
		var brushed=false,brushDirty = true;
		var dispatch,linkState;
		
		/*
		var gBrush = g.append("g").attr("class", "brush").call(brush);
          gBrush.selectAll("rect").attr("height", height);
          gBrush.selectAll(".resize").append("path").attr("d", resizePath);
		  
		brush.on("brushstart.chart", function() {
		  var div = d3.select(this.parentNode.parentNode.parentNode);
		  div.select(".title a").style("display", null);
		});

		brush.on("brush.chart", function() {
		  var g = d3.select(this.parentNode),
			  extent = brush.extent();
		  if (round) g.select(".brush")
			  .call(brush.extent(extent = extent.map(round)))
			.selectAll(".resize")
			  .style("display", null);
		  g.select("#clip-" + id + " rect")
			  .attr("x", x(extent[0]))
			  .attr("width", x(extent[1]) - x(extent[0]));
		  dimension.filterRange(extent);
		});

		brush.on("brushend.chart", function() {
		  if (brush.empty()) {
			var div = d3.select(this.parentNode.parentNode.parentNode);
			div.select(".title a").style("display", "none");
			div.select("#clip-" + id + " rect").attr("x", null).attr("width", "100%");
			//dimension.filterAll();
		  }
		});
		*/
		
	
		ChartMaker={
			components:[],			
			axis:function(){},
			linkTo:function(dispatcher){
				linkState=dispatcher[1];
				dispatch = dispatcher[0];
			},
			createLink:function(linkName){
				linkState=linkName;
				dispatch = d3.dispatch(linkName);
			},
			linkFrom:function(){
				return [dispatch,linkState];
			},
			update:function(res){
				if(!svg){
					svg=d3.select('#'+Container)
						.append("svg")
						.attr("width", w)
						.attr("height", h)
						.style("margin", '0px 0px 30px 30px')
						.attr("id", svgID)
						.attr('draggable','true')
						.append("g");

					svg.append("defs").append("svg:clipPath")
						.attr("id","clip")
						.append("svg:rect")
						.attr("id","clip-rect")
						.style("fill", "black")
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
						.style("fill", "white")
						.attr("opacity", 0.2);
						
					mc=svg.append("g")
						.attr("clip-path",  "url(#clip)")
						.attr("id",  "mainContainer");
						
					if(brushed){
						
					/*	mc.append("clipPath")
							.attr("id", "clip-" + svgID)
							.append("rect")
							.attr("width", w)
							.attr("height", w);
					*/
						var gBrush = svg.append("g").attr("class", "brush").call(brush);
						  gBrush.selectAll("rect").attr("height", h-padding*2).attr("y", padding);
						  gBrush.selectAll(".resize").append("path").attr("d", resizePath);
						
						if (brushDirty) {
						  brushDirty = false;
						  svg.selectAll(".brush").call(brush);
						/*/  if (brush.empty()) {
							mc.selectAll("#clip-" + svgID + " rect")
								.attr("x", 0)
								.attr("width", w);
						/*  } else {
							var extent = brush.extent();
							mc.selectAll("#clip-" + svgID + " rect")
								.attr("x", xScale(extent[0]))
								.attr("width", xScale(extent[1]) - xScale(extent[0]));
						  }*/
						}
						
						brush.on("brushstart.chart", function() {
						});

						brush.on("brush.chart", (function(A){return function() {
							xScale = d3.scale.linear().domain([0,1]).range([padding, w - padding]);
							var extent = brush.extent();
							dispatch[linkState](A,extent,this.parentNode.parentNode);
							/*if (round) mc.select(".brush")
								.call(brush.extent(extent = extent.map(round)))
								.selectAll(".resize")
								.style("display", null);* /
							mc.select("#clip-" + svgID + " rect")
								.attr("x", xScale(extent[0]))
								.attr("width", xScale(extent[1]) - xScale(extent[0]));/**/
							//dimension.filterRange(extent);
						}})(res.slice(0)));

						brush.on("brushend.chart", function() {
						  if (brush.empty()) {
							//var div = d3.select(this.parentNode.parentNode.parentNode);
							//div.select(".title a").style("display", "none");
							//mc.select("#clip-" + svgID + " rect").attr("x", null).attr("width", "100%");
							//dimension.filterAll();
						  }
						});
					}
				}
				if(dispatch)
				{
					dispatch.on(linkState+'.'+svgID,ChartMaker.LinkUpdate)
				}
				if(maxRows){
					len=res.length;
					if(!range || range > len)
						range=len;
					else if(range < maxRows)
					{
						range = maxRows;
					}
					var zoom = d3.behavior.zoom()
					.scaleExtent([1, 1]).on("zoom."+svgID, null);
					zoomed=(function(AR,zm){return function() {
						var len = AR.length;
						if(d3.event.sourceEvent.wheelDelta)
						{
							if(d3.event.sourceEvent.wheelDelta < 0)
							{
								range-=1;
								if(range<0)
									range=0;
								//zm.translate([0, 0]);
							}
							if(d3.event.sourceEvent.wheelDelta > 0)
							{
								range+=1;
								if(range > len)
									range = len;
								zm.translate([0, 0]);
							}
							ChartMaker.update(AR);
						}
					/*	else{
							if(d3.event.translate[1] < 0)
							{
								range+=1;
								if(range >= len)
									range = len-1;
								//zm.translate([0, 0]);
							}
							if(d3.event.translate[1] > 0)
							{
								range-=1;
								if(range<0)
									range=0;
								zm.translate([0, 0]);
							}
						}*/
						
					}})(res.slice(0),zoom)
					
					res = res.slice(Math.max(0,range-maxRows),Math.min(range,res.length));
					zoom.on("zoom."+svgID, zoomed);
					svg.call(zoom);
				}
				for(initi=0;initi<ChartMaker.components.length;initi++)
					ChartMaker.components[initi].update(res);
				ChartMaker.axis(res);
			},
			LinkUpdate:function(res,Ranges,source){
				if(svg.node().parentNode == source)
					return;
				var HoldData = res.slice(0);
				res = res.slice(Math.max(0,Ranges[0]*res.length),Math.min(Ranges[1]*res.length,res.length));
				if(maxRows){
					len=res.length;
					if(!range || range > len)
						range=len;
					else if(range < maxRows)
					{
						range = maxRows;
					}
					var zoom = d3.behavior.zoom()
					.scaleExtent([1, 1]).on("zoom."+svgID, null);
					zoomed=(function(AR,zm){return function() {
						var len = AR.length;
						if(d3.event.sourceEvent.wheelDelta)
						{
							if(d3.event.sourceEvent.wheelDelta < 0)
							{
								range-=1;
								if(range<0)
									range=0;
								//zm.translate([0, 0]);
							}
							if(d3.event.sourceEvent.wheelDelta > 0)
							{
								range+=1;
								if(range > len)
									range = len;
								zm.translate([0, 0]);
							}
						}
						else{
							if(d3.event.translate[1] < 0)
							{
								range+=1;
								if(range >= len)
									range = len-1;
								//zm.translate([0, 0]);
							}
							if(d3.event.translate[1] > 0)
							{
								range-=1;
								if(range<0)
									range=0;
								zm.translate([0, 0]);
							}
						}
						ChartMaker.LinkUpdate(AR,Ranges);
						
					}})(HoldData.slice(0),zoom)
					
					res = res.slice(Math.max(0,range-maxRows),Math.min(range,res.length));
					zoom.on("zoom."+svgID, zoomed);
					svg.call(zoom);
				}
				for(initi=0;initi<ChartMaker.components.length;initi++)
					ChartMaker.components[initi].update(res);
				ChartMaker.axis(res);
			},
			enableBrush:function(){
				brushed=true;
			},
			enableScroll:function(NumOfRows){
				maxRows=(NumOfRows) ? Math.max(NumOfRows,1):10;
			},
			defineAxis:function(isOrdinals,indexes,axes){
				var tAxis = d3.svg.axis()
					.orient("top");
				var rAxis = d3.svg.axis()
					.orient("right")
				var bAxis= d3.svg.axis()
					.orient("bottom")
				var lAxis= d3.svg.axis()
					.orient("left");
				var scales=[];
				var order = [];
				
				hold=function(res){
					for(i = 0; i < 4; i++)
					{
						if(axes[i])
							axes[i]=d3.format(axes[i]);
						if(indexes[i])
						{
							var rng =(i%2==0) ? [padding, w - padding]:[h - padding, padding];
							if(isOrdinals[i])
							{
								order = [];
								res.forEach(function(d,ii){order.push(d[indexes[i]])});
								scales[i]=d3.scale.ordinal().rangeBands(rng).domain(order);
							}
							else {
								var high = d3.max(res,function(d){return d[indexes[i]];});
								var low = 0;
								scales[i]= d3.scale.linear().domain([low,high]).range(rng);
							}
						}
					}
					if(indexes[0])
					{
						tAxis.scale(scales[0]);
						 if(axes[0])
						  tAxis.tickFormat(axes[0]);
						 
						if(!svg.select('.topAxis').node())
							svg.append("g").attr("class", "topAxis axis").attr("transform", "translate(0," + padding + ")").call(tAxis).selectAll('text').style('text-anchor','');//.selectAll('text').style('transform',function(d){return 'scale('+padding/(d.length*10)+',1)';});
						else
							svg.select('.topAxis').call(tAxis).selectAll('text').style('text-anchor','');//.selectAll('text').style('transform',function(d){return 'scale('+padding/(d.length*10)+',1)';});
					}
					if(indexes[1])
					{
						rAxis.scale(scales[1]);
						 if(axes[1])
						  rAxis.tickFormat(axes[1]);
						 
						if(!svg.select('.rightAxis').node())
							svg.append("g").attr("class", "rightAxis axis").attr("transform", "translate("+(w-padding)+",0)").call(rAxis).selectAll('text').style('text-anchor','');//.selectAll('text').style('transform',function(d){return 'scale('+padding/(d.length*10)+',1)';});
						else
							svg.select('.rightAxis').call(rAxis).selectAll('text').style('text-anchor','');//.selectAll('text').style('transform',function(d){return 'scale('+padding/(d.length*10)+',1)';});
					}
					if(indexes[2])
					{
						bAxis.scale(scales[2]);
						 if(axes[2])
						  bAxis.tickFormat(axes[2]);
						 
						if(!svg.select('.bottomAxis').node())
							svg.append("g").attr("class", "bottomAxis axis").attr("transform", "translate(0," + (h-padding) + ")").call(bAxis).selectAll('text').style('text-anchor','');//.selectAll('text').style('transform',function(d){return 'scale('+padding/(d.length*10)+',1)';});
						else
							svg.select('.bottomAxis').call(bAxis).selectAll('text').style('text-anchor','');//.selectAll('text').style('transform',function(d){return 'scale('+padding/(d.length*10)+',1)';});
					}
					if(indexes[3])
					{
						lAxis.scale(scales[3]);
						 if(axes[3])
						  lAxis.tickFormat(axes[3]);
						 
						if(!svg.select('.leftAxis').node())
							svg.append("g").attr("class", "leftAxis axis").attr("transform", "translate("+(padding)+",0)").call(lAxis).selectAll('text').style('text-anchor','');//.selectAll('text').style('transform',function(d){return 'scale('+padding/(d.length*10)+',1)';});
						else
							svg.select('.leftAxis').call(lAxis).selectAll('text').style('text-anchor','');//.selectAll('text').style('transform',function(d){return 'scale('+padding/(d.length*10)+',1)';});
					}
				}
				ChartMaker.axis=hold;
			},
			addBarChart:function(barClass,isHoriz,isOrdinal,barValueIdx,barIndexIdx,cStops,cColors){
				var xScale,yScale,cScale,barChartEvents,rects,rectDomains,customScales;				
				barChartEvents=[],barChartFunctions={};
				if(!cColors)
				{
					cColors=['#00E','#00F'];
				}
				if(!cStops)
				{
					cStops=[];
					var frac = 1/(cColors.length-1);
					for(i=0; i< cColors.length; i++)
					{
						cStops[i]=i+i*frac;
					}
				}
				var low = 0;
				var cScale = d3.scale.linear().domain(cStops).range(cColors);	
				hold ={ 
					update:function(res){
						//var cScale = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);		
						rects=mc
							   .selectAll("."+barClass)
							   .data(res);
						var high = d3.max(res,function(d){return d[barValueIdx];});
						if(!maxRows)
							maxRows = res.length;
						if(isOrdinal)
						{
							if(isHoriz)
							{
								var order = [];
								res.forEach(function(d,i){order.push(d[barIndexIdx])});
								yScale = d3.scale.ordinal().rangeBands([h - padding, padding]);
								if(customScales)
									xScale = d3.scale.linear().domain(rectDomains[0]).range([padding, w - padding]);
								else
									xScale = d3.scale.linear().domain([low,high]).range([padding, w - padding]);
								yScale.domain(order);

							}
							else
							{						
								var order = [];
								res.forEach(function(d,i){order.push(d[barIndexIdx])});
								xScale = d3.scale.ordinal().rangeBands([w - padding, padding]);
								if(customScales)
									yScale = d3.scale.linear().domain(rectDomains[1]).range([ h - padding, padding]);
								else			 
									yScale = d3.scale.linear().domain([low,high]).range([ h - padding, padding]);
								xScale.domain(order);
							}							
						}
						else if(customScales)
						{
							xScale = d3.scale.linear().domain(rectDomains[0]).range([padding, w - padding]);
							yScale = d3.scale.linear().domain(rectDomains[1]).range([ h - padding, padding]);
						}
						else
						{
							var high2 = d3.max(res,function(d){return d[barIndexIdx];});
							if(isHoriz)
							{
								yScale = d3.scale.linear().domain([low,high2]).range([h - padding, padding]);					 
								xScale = d3.scale.linear().domain([low,high]).range([padding, w - padding]);
							}
							else
							{
								yScale = d3.scale.linear().domain([low,high]).range([h - padding, padding]);					 
								xScale = d3.scale.linear().domain([low,high2]).range([padding, w - padding]);
							}				
						}
						
						if(isHoriz)
						{
							var rdiv = (h-(padding*2))/((res.length<maxRows)?res.length:maxRows)/2;
							var rw = (h-(padding*2)-rdiv*2)/((res.length<maxRows)?res.length:maxRows);//210
							if(rw==0)
							{
								rw=rdiv;
							}
							rects.enter()
								.append("rect")
								.attr("class", barClass)
								.attr("x", function(d,i) { return xScale(low);})
								.attr("y", function(d) { return yScale(d[barIndexIdx])+rdiv-rw/2+2;})
								.attr("width", function(d) {return Math.abs(xScale(d[barValueIdx])-xScale(low));})
								.attr("height", (rw<=4)?rw:rw-4)
								.style("fill",  function(d) {return cScale(d[barValueIdx]);});
								   
							rects.transition().duration(500)
								.attr("x", function(d,i) { return xScale(low);})
								.attr("y", function(d) { return yScale(d[barIndexIdx])+rdiv-rw/2+2;})
								.attr("width", function(d) {return Math.abs(xScale(d[barValueIdx])-xScale(low));})
								.attr("height", (rw<=4)?rw:rw-4)
								.style("fill",  function(d) {return cScale(d[barValueIdx]);});
							
							barChartEvents.forEach(function(d){
								rects.on(d[0],d[1]);
							})
							
							rects.exit().transition().remove();
						}
						else
						{
							var rdiv = (w-(padding*2))/((res.length<maxRows)?res.length:maxRows)/2;
							var rw = (w-(padding*2)-rdiv*2)/((res.length<maxRows)?res.length:maxRows);//210
							if(rw==0)
							{
								rw=rdiv;
							}
							rects.enter()
								.append("rect")
								.attr("class", barClass)
								.attr("x", function(d) { return xScale(d[barIndexIdx])+rdiv-rw/2+2;})
								.attr("y", function(d,i) { return Math.abs(yScale(d[barValueIdx]));})
								.attr("height", function(d) {return h-padding-Math.abs(yScale(d[barValueIdx]));})
								.attr("width", (rw<=4)?rw:rw-4)
								.style("fill",  function(d) {return cScale(d[barValueIdx]);});
								   
							rects.transition().duration(500)
								.attr("x", function(d) { return xScale(d[barIndexIdx])+rdiv-rw/2+2;})
								.attr("y", function(d,i) { return Math.abs(yScale(d[barValueIdx]));})
								.attr("height", function(d) {return h-padding-Math.abs(yScale(d[barValueIdx]));})
								.attr("width", (rw<=4)?rw:rw-4)
								.style("fill",  function(d) {return cScale(d[barValueIdx]);});
							
							barChartEvents.forEach(function(d){
								rects.on(d[0]+'.'+barClass,d[1]);
							})
							
							rects.exit().transition().remove();
						}
					}
				}
				ChartMaker.components.push(hold);
				barChartFunctions={
					addEvent:function(eventType,eventCall){
						barChartEvents.push([eventType,eventCall]);
						return barChartFunctions;
					},
					customizeDomain:function(xDomain,yDomain)
					{
						rectDomains=[xDomain,yDomain];
						customScales=true;
						return barChartFunctions;
					}
				}
				return barChartFunctions;
			},
			addScatterChart:function(pointClass,isHoriz,isOrdinal,pointValueIdx,pointIndexIdx,cStops,cColors){
				var xScale,yScale,cScale,pointChartEvents,circles,circleDomains,customScales;				
				pointChartEvents=[],pointChartFunctions={};
				if(!cColors)
				{
					cColors=['#F00','#FF0','#0F0'];
				}
				if(!cStops)
				{
					cStops=[];
					var frac = 1/(cColors.length-1);
					for(i=0; i< cColors.length; i++)
					{
						cStops[i]=i+i*frac;
					}
				}
				var low = 0;
				var cScale = d3.scale.linear().domain(cStops).range(cColors);	
				hold ={ 
					update:function(res){
						//var cScale = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);		
						circles=mc
							   .selectAll("."+pointClass)
							   .data(res);
						var high = d3.max(res,function(d){return d[pointValueIdx];});
						var rdiv = rw = 0;
						if(!maxRows)
							maxRows = res.length;
						if(isOrdinal)
						{
							if(isHoriz)
							{
								rdiv = (h-(padding*2))/((res.length<maxRows)?res.length:maxRows)/2;
								rw = (h-(padding*2)-rdiv*2)/((res.length<maxRows)?res.length:maxRows);//210
								if(rw==0)
								{
									rw=rdiv;
								}
								var order = [];
								res.forEach(function(d,i){order.push(d[pointIndexIdx])});
								yScale = d3.scale.ordinal().rangeBands([h - padding, padding]);
								if(customScales)
									xScale = d3.scale.linear().domain(circleDomains[0]).range([padding, w - padding]);
								else
									xScale = d3.scale.linear().domain([low,high]).range([padding, w - padding]);
								yScale.domain(order);

							}
							else
							{
								rdiv = (w-(padding*2))/((res.length<maxRows)?res.length:maxRows)/2;
								rw = (w-(padding*2)-rdiv*2)/((res.length<maxRows)?res.length:maxRows);//210
								if(rw==0)
								{
									rw=rdiv;
								}
								var order = [];
								res.forEach(function(d,i){order.push(d[pointIndexIdx])});
								xScale = d3.scale.ordinal().rangeBands([w - padding, padding]);
								if(customScales)
									yScale = d3.scale.linear().domain(circleDomains[1]).range([ h - padding, padding]);
								else			 
									yScale = d3.scale.linear().domain([low,high]).range([ h - padding, padding]);
								xScale.domain(order);
							}							
						}
						else if(customScales)
						{
							xScale = d3.scale.linear().domain(circleDomains[0]).range([padding, w - padding]);
							yScale = d3.scale.linear().domain(circleDomains[1]).range([ h - padding, padding]);
						}
						else
						{
							var high2 = d3.max(res,function(d){return d[pointIndexIdx];});
							if(isHoriz)
							{
								yScale = d3.scale.linear().domain([low,high2]).range([h - padding, padding]);					 
								xScale = d3.scale.linear().domain([low,high]).range([padding, w - padding]);
							}
							else
							{
								yScale = d3.scale.linear().domain([low,high]).range([h - padding, padding]);					 
								xScale = d3.scale.linear().domain([low,high2]).range([padding, w - padding]);
							}				
						}						
						
						if(isHoriz)
						{
							circles.enter()
								.append("circle")
								.attr("class", pointClass)
								.attr("cx", function(d,i) { return xScale(d[pointValueIdx]);})
								.attr("cy", function(d) { return yScale(d[pointIndexIdx])+rdiv;})
								.attr("r", 4)
								.style("fill",  function(d) {return cScale(d[pointValueIdx]);});
								   
							circles.transition().duration(500)
								.attr("cx", function(d,i) { return xScale(d[pointValueIdx]);})
								.attr("cy", function(d) { return yScale(d[pointIndexIdx])+rdiv;})
								.attr("r", 4)
								.style("fill",  function(d) {return cScale(d[pointValueIdx]);});
							
							pointChartEvents.forEach(function(d){
								circles.on(d[0],d[1]);
							})
							
							circles.exit().transition().remove();
						}
						else
						{
							circles.enter()
								.append("circle")
								.attr("class", pointClass)
								.attr("cx", function(d) { return xScale(d[pointIndexIdx])+rdiv;})
								.attr("cy", function(d,i) { return yScale(d[pointValueIdx]);})
								.attr("r", 4)
								.style("fill",  function(d) {return cScale(d[pointValueIdx]);});
								   
							circles.transition().duration(500)
								.attr("cx", function(d) { return xScale(d[pointIndexIdx])+rdiv;})
								.attr("cy", function(d,i) { return yScale(d[pointValueIdx]);})
								.attr("r", 4)
								.style("fill",  function(d) {return cScale(d[pointValueIdx]);});
							
							pointChartEvents.forEach(function(d){
								circles.on(d[0]+'.'+pointClass,d[1]);
							})
							
							circles.exit().transition().remove();
						}
					}
				}
				ChartMaker.components.push(hold);
				pointChartFunctions={
					addEvent:function(eventType,eventCall){
						pointChartEvents.push([eventType,eventCall]);
						return pointChartFunctions;
					},
					customizeDomain:function(xDomain,yDomain)
					{
						circleDomains=[xDomain,yDomain];
						customScales=true;
						return pointChartFunctions;
					}
				}
				return pointChartFunctions;
			},
			addLineChart:function(lineClass,isHoriz,isOrdinal,lineValueIdx,lineIndexIdx,cStops,cColors){
				var xScale,yScale,cScale,lineChartEvents,lines,lineDomains,customScales;				
				lineChartEvents=[],lineChartFunctions={};
				if(!cColors)
				{
					cColors=['#F00','#FF0','#0F0'];
				}
				if(!cStops)
				{
					cStops=[];
					var frac = 1/(cColors.length-1);
					for(i=0; i< cColors.length; i++)
					{
						cStops[i]=i+i*frac;
					}
				}
				var low = 0;
				var cScale = d3.scale.linear().domain(cStops).range(cColors);	
				hold ={ 
					update:function(res){
						
						var lines = mc.select('.path-'+lineClass);
						if(!lines.node())
						{
							lines=mc.append("g")
								.append("path")
								.attr("class", 'path-'+lineClass)
								.datum(res)
						}else
						{
							lines = lines.datum(res);
						}
						var high = d3.max(res,function(d){return d[lineValueIdx];});
						if(isOrdinal)
						{
							if(isHoriz)
							{
								var order = [];
								res.forEach(function(d,i){order.push(d[lineIndexIdx])});
								yScale = d3.scale.ordinal().rangeBands([h - padding, padding]);
								if(customScales)
									xScale = d3.scale.linear().domain(lineDomains[0]).range([padding, w - padding]);
								else
									xScale = d3.scale.linear().domain([low,high]).range([padding, w - padding]);
								yScale.domain(order);

							}
							else
							{						
								var order = [];
								res.forEach(function(d,i){order.push(d[lineIndexIdx])});
								xScale = d3.scale.ordinal().rangeBands([w - padding, padding]);
								if(customScales)
									yScale = d3.scale.linear().domain(lineDomains[1]).range([ h - padding, padding]);
								else			 
									yScale = d3.scale.linear().domain([low,high]).range([ h - padding, padding]);
								xScale.domain(order);
							}							
						}
						else if(customScales)
						{
							xScale = d3.scale.linear().domain(lineDomains[0]).range([padding, w - padding]);
							yScale = d3.scale.linear().domain(lineDomains[1]).range([ h - padding, padding]);
						}
						else
						{
							var high2 = d3.max(res,function(d){return d[lineIndexIdx];});
							if(isHoriz)
							{
								yScale = d3.scale.linear().domain([low,high2]).range([h - padding, padding]);					 
								xScale = d3.scale.linear().domain([low,high]).range([padding, w - padding]);
							}
							else
							{
								yScale = d3.scale.linear().domain([low,high]).range([h - padding, padding]);					 
								xScale = d3.scale.linear().domain([low,high2]).range([padding, w - padding]);
							}				
						}
						
						if(isHoriz)
						{
							var line = d3.svg.line()
							.interpolate("cardinal")
							.x(function(d) { return xScale(d[lineValueIdx]); })
							.y(function(d) { return yScale(d[lineIndexIdx]); });
						}
						else
						{
							var line = d3.svg.line()
							.interpolate("cardinal")
							.x(function(d) { return xScale(d[lineIndexIdx]); })
							.y(function(d) { return yScale(d[lineValueIdx]); });
						}							
						
						var doc = [];
						var maxStop = d3.max(cStops,function(d){return d;});
						cStops.forEach(function(d,i){
							doc.push({offset:d/maxStop,color:cColors[i]});
						})
					
						if(!mc.select('#colors-'+lineClass).node())
						{
							mc.append("linearGradient")
							.attr("id", 'colors-'+lineClass)
							.attr("gradientUnits", "userSpaceOnUse")
							.attr("x1", 0).attr("y1", (isHoriz)?xScale(low):yScale(low))
							.attr("x2", 0).attr("y2", (isHoriz)?xScale(high):yScale(high))
							.selectAll("stop")
							.data(doc)
							.enter().append("stop")
							.attr("offset", function(d) { return d.offset; })
							.attr("stop-color", function(d) { return d.color; });
						}else
						{
							mc.select('#colors-'+lineClass)
							.attr("gradientUnits", "userSpaceOnUse")
							.attr("x1", 0).attr("y1", (isHoriz)?xScale(low):yScale(low))
							.attr("x2", 0).attr("y2", (isHoriz)?xScale(high):yScale(high))
							.selectAll("stop")
							.data(doc)
							.enter().append("stop")
							.attr("offset", function(d) { return d.offset; })
							.attr("stop-color", function(d) { return d.color; });
						}
						
						lines.transition().duration(500)
							.attr("class", 'path-'+lineClass)
							.attr("d",  line)
							.attr('stroke', 'url(#colors-'+lineClass+')')
							.attr('stroke-width', 2)
							.attr('fill', 'none')
						
						lineChartEvents.forEach(function(d){
							lines.on(d[0]+'.'+lineClass,d[1]);
						})
					
					}
				}
				ChartMaker.components.push(hold);
				lineChartFunctions={
					addEvent:function(eventType,eventCall){
						lineChartEvents.push([eventType,eventCall]);
						return lineChartFunctions;
					},
					customizeDomain:function(xDomain,yDomain)
					{
						lineDomains=[xDomain,yDomain];
						customScales=true;
						return lineChartFunctions;
					}
				}
				return lineChartFunctions;
			}
			
		
		}
		return ChartMaker;
	}
	
	
	function Area_Chart(res)
	{	
		var resId = res.pop()[0];
			res.shift();
			chartHistory[resId].Area_Chart=(function(data){
				return function(){
					streamLineChart(data,'selArea','chart-Area','svgArea','Area','loader');
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selArea','chart-Area','svgArea','Area','loader');
	}

	function District_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].District_Chart=(function(data){
				return function(){
					streamLineChart(data,'selDistrict','chart-District','svgDistrict','District','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selDistrict','chart-District','svgDistrict','District','loader');		
	}
var ch,ch2,chc,chl,chb;
	function Facility_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].Facility_Chart=(function(data){
				return function(){
					streamLineChart(data,'selFacility','chart-Facility','svgFacility','Facility','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selFacility','chart-Facility','svgFacility','Facility','loader');		
	}

	function DOW_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].DOW_Chart=(function(data){
				return function(){
					streamLineChart(data,'selDOW','chart-DOW','svgDOW','Day Of Week','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selDOW','chart-DOW','svgDOW','Day Of Week','loader');		
	}
	
	function Class_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].Class_Chart=(function(data){
				return function(){
					streamLineChart(data,'selClass','chart-Class','svgClass','Mail Class','loader');
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selClass','chart-Class','svgClass','Mail Class','loader');		
	}
	
	function Cat_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].Cat_Chart=(function(data){
				return function(){
					streamLineChart(data,'selCategory','chart-Shape','svgShape','Mail Shape','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selCategory','chart-Shape','svgShape','Mail Shape','loader');		
	}
	
	function EOD_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].EOD_Chart=(function(data){
				return function(){
					streamLineChart(data,'selEod','chart-EOD','svgEOD','Entry','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selEod','chart-EOD','svgEOD','Entry','loader');		
	}
	
	function SVCSTD_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].SVCSTD_Chart=(function(data){
				return function(){
					streamLineChart(data,'selHybStd','chart-SVCSTD','svgSVCSTD','Svc. Std.','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selHybStd','chart-SVCSTD','svgSVCSTD','Svc. Std.','loader');		
	}
	
	function MLR_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].MLR_Chart=(function(data){
				return function(){
					streamLineChart(data,'selMailer','chart-MLR','svgMLR','Mailers','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selMailer','chart-MLR','svgMLR','Mailers','loader');		
	}
	
	function DZ3_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].DZ3_Chart=(function(data){
				return function(){
					streamLineChart(data,'selDestZip3','chart-DZ3','svgDZ3','Dest Zip 3','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selDestZip3','chart-DZ3','svgDZ3','Dest Zip 3','loader');		
	}
	
	function OZ3_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].OZ3_Chart=(function(data){
				return function(){
					streamLineChart(data,'selOrgZip3','chart-OZ3','svgOZ3','Orgn Zip 3','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}	
		streamLineChart(res,'selOrgZip3','chart-OZ3','svgOZ3','Orgn Zip 3','loader');		
	}
	
	function Cntr_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].Cntr_Chart=(function(data){
				return function(){
					streamLineChart(data,'selCntrLvl','chart-Cntr','svgCntr','Cntr Lvl','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selCntrLvl','chart-Cntr','svgCntr','Cntr Lvl','loader');		
	}
	
	function FSS_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].FSS_Chart=(function(data){
				return function(){
					streamLineChart(data,'selFSS','chart-FSS','svgFSS','FSS','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		streamLineChart(res,'selFSS','chart-FSS','svgFSS','FSS','loader');		
	}
	
	function Air_Chart(res)
	{
		var resId = res.pop()[0];
			res.shift();
			res=res.reverse();	
			chartHistory[resId].Air_Chart=(function(data){
				return function(){
					streamLineChart(data,'selAir','chart-Air','svgAir','Air','loader');		
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}	
		streamLineChart(res,'selAir','chart-Air','svgAir','Air','loader');		
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

	var doInit;
	function init()
	{
		doInit=true;
		
		var e=new TDF();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(area_data_err);
		e.getDates('<cfoutput>#opsvisdata#</cfoutput>','');
		
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
		var dateVari = new Date(sd);
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
		var sMail = document.getElementById('selMailer').value;
		var sOZ3 = document.getElementById('selOrgZip3').value;
		var sDZ3 = document.getElementById('selDestZip3').value;
		var sCntr = document.getElementById('selCntrLvl').value;
			smode = document.getElementById('selMode').value;
			sair = document.getElementById('selAir').value;
		
		ReqId++;
		var vahold = d3.select('#filtDiv').selectAll('[type=hidden]')[0];
		var vhold=[];		
		vahold.forEach(function(d){
			vhold.push(d.value);
		})
		chartHistory[ReqId].selparam = (function(a,b,c){return function(){
			loadCnt=14;
			d3.select('#filtDiv').selectAll('[type=hidden]').attr('value',function(d,i){return a[i];})
			var sda=d3.select('#selDate').node();
			sda.value=b;
			filterArgs[4]=sda.options[sda.selectedIndex].text;
			var sdi = d3.select('#selDir').node();
			sdi.value=c;
			filterArgs[5]=sdi.options[sdi.selectedIndex].text;	
			listSelections();		
		}})(vhold,d3.select('#selDate').node().value,d3.select('#selDir').node().value)
		loadCnt=14;
		var e=new TDF();
		e.setCallbackHandler(Display_Overalls);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(Area_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByAreaData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(District_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDistData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(Facility_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByFacilityData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(DOW_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDayData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(Class_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByClassData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(Cat_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByCatData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(EOD_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByEODData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(SVCSTD_Chart);	
		e.setErrorHandler(area_data_err);
		e.getBySvcStdData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(MLR_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByMlrData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(DZ3_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDestZip3(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3);
		var e=new TDF();
		e.setCallbackHandler(OZ3_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByOrgZip3(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(Cntr_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByCntrData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(FSS_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByFSS(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		var e=new TDF();
		e.setCallbackHandler(Air_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByAir(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		
		Trend_Data[ReqId]=[];
		//trackTimer=new Date();
		var e=new TDF();
		e.setCallbackHandler(Gather_Trend_Data);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		
		var e=new TDF(); dateVari.setDate(dateVari.getDate()-7);
		e.setCallbackHandler(Gather_Trend_Data);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,makeDate(dateVari),sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		
		var e=new TDF(); dateVari.setDate(dateVari.getDate()-7);
		e.setCallbackHandler(Gather_Trend_Data);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,makeDate(dateVari),sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		
		var e=new TDF(); dateVari.setDate(dateVari.getDate()-7);
		e.setCallbackHandler(Gather_Trend_Data);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,makeDate(dateVari),sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		
		var e=new TDF(); dateVari.setDate(dateVari.getDate()-7);
		e.setCallbackHandler(Gather_Trend_Data);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,makeDate(dateVari),sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		
		var e=new TDF(); dateVari.setDate(dateVari.getDate()-7);
		e.setCallbackHandler(Gather_Trend_Data);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,makeDate(dateVari),sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		
		var e=new TDF(); dateVari.setDate(dateVari.getDate()-7);
		e.setCallbackHandler(Gather_Trend_Data);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,makeDate(dateVari),sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		
		var e=new TDF(); dateVari.setDate(dateVari.getDate()-7);
		e.setCallbackHandler(Gather_Trend_Data);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,makeDate(dateVari),sdend,sarea,sdist,sclass,scat,sfss,"Y",sair,sCntr,"Y",spol,shyb,'',sDOW,sfac,sMail,sOZ3,sDZ3);
		
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

			container.append("g")
			.attr("class", "lineTrend2")
			.append("path")
			.datum(dataset)
			.attr("class", "lineV")
			.attr("d",  line2)
			.attr('stroke', 'url(#temperature-gradient)')
			.attr('stroke-width', 2)
			.attr('fill', 'none');

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
					
					var perF = d3.format('.1%');
					var sigF = d3.format('.3g');
					var comF = d3.format(',');
					
					d3.select('#OverallScore').data(data).style('background',toColor).text(function(d){return perF(d[3])});
					d3.select('#OverallFail').data(data).style('background',toColor).text(function(d){return comF(d[2])}).on('click',Diag_Report_Lnk);
					d3.select('#OverallPieces').data(data).style('background',toColor).text(function(d){return comF(d[4])});
				}
			})(res)
		if(ReqId != resId)
		{
			return;
		}
		var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);		
		var toColor = cScale2(res[0][3]);
		
		var perF = d3.format('.1%');
		var sigF = d3.format('.3g');
		var comF = d3.format(',');
		
		d3.select('#OverallScore').data(res).style('background',toColor).text(function(d){return perF(d[3])});
		d3.select('#OverallFail').data(res).style('background',toColor).text(function(d){return comF(d[2])}).on('click',Diag_Report_Lnk);
		d3.select('#OverallPieces').data(res).style('background',toColor).text(function(d){return comF(d[4])});
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
			chartHistory[0]={};
			document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';cfrm_sub();			
		}
	}

	function Diag_Report_Lnk()
	{
		/*if(place > 1)
			place=(place-1)/2;
		if(place == 1)
			place = 7;*/
		//var spol = document.getElementById('selPOL').value;
		//var srlupv = document.getElementById('rlupv').value;
		var smode = '';
		var sair = '';
		var sclass = document.getElementById('selClass').value.split(",")[0].replace(/'/g, "");

		if(sclass==1)
		{
			smode = document.getElementById('selMode').value;
			sair = document.getElementById('selAir').value;
		}
		var rng = 'WEEK'

		/*if(document.getElementById('rngMON').checked)
		rng = 'MON';
		else if(document.getElementById('rngQTR').checked)
		rng = 'QTR';*/
		var sd = document.getElementById('selDate');
		var sdend='';
		if(sd.selectedIndex >0)
		{
			sdend=sd.options[sd.selectedIndex-1].value;
		}
		sd=sd.value;
		
		if(sdend=='')
		{
			var dateVari = new Date(sd);
			dateVari.setDate(dateVari.getDate()+7);
			sdend = makeDate(dateVari);
		}
		var sarea = document.getElementById('selArea').value.split(",")[0].replace(/'/g, "");
		var sdist = document.getElementById('selDistrict').value.split(",")[0].replace(/'/g, "");
		var sdir = document.getElementById('selDir').value.split(",")[0].replace(/'/g, "");
		var seod = document.getElementById('selEod').value.split(",")[0].replace(/'/g, "");
		var scat = document.getElementById('selCategory').value.split(",")[0].replace(/'/g, "");
		var sfss = document.getElementById('selFSS').value.split(",")[0].replace(/'/g, "");
		var shyb = document.getElementById('selHybStd').value.split(",")[0].replace(/'/g, "");
		var sDOW = document.getElementById('selDOW').value.split(",")[0].replace(/'/g, "");
		
		var sfac = document.getElementById('selFacility').value.split(",")[0].replace(/'/g, "");
		var sMail = document.getElementById('selMailer').value.split(",")[0].replace(/'/g, "");
		var sDZ3 = document.getElementById('selDestZip3').value.split(",")[0].replace(/'/g, "");
		var sOZ3 = document.getElementById('selOrgZip3').value.split(",")[0].replace(/'/g, "");
		//var sDOW = document.getElementById('selDOW').value;
		//var sDOW = document.getElementById('selDOW').value;
		
		var lnkForm = d3.select("body")
		.append("form")
		.attr("method","post")
		.attr("target","_DiagRep")
		.attr("action","DiagReportD3.cfm")
		.attr("name","link_form")
		
		lnkForm.append("input").attr("type","hidden").attr("name","SELAREA").attr("value",sarea);
		lnkForm.append("input").attr("type","hidden").attr("name","SELDISTRICT").attr("value",sdist);
		lnkForm.append("input").attr("type","hidden").attr("name","SELFACILITY").attr("value",sfac);
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
		lnkForm.append("input").attr("type","hidden").attr("name","selMailer").attr("value",sMail);
		lnkForm.append("input").attr("type","hidden").attr("name","selHybStd").attr("value",shyb);
		lnkForm.append("input").attr("type","hidden").attr("name","selDOW").attr("value",sDOW);
		lnkForm.append("input").attr("type","hidden").attr("name","selOrg3").attr("value",sOZ3);
		lnkForm.append("input").attr("type","hidden").attr("name","selDest3").attr("value",sDZ3);
		lnkForm.append("input").attr("type","hidden").attr("name","selPhysCntr").attr("value",'');
		lnkForm.append("input").attr("type","hidden").attr("name","selDestFac").attr("value",'');
		lnkForm.append("input").attr("type","hidden").attr("name","selDestZip3").attr("value",sDZ3);
		
		document.link_form.submit();
		
		lnkForm.remove();
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
		var divWidth = (charts[0].clientWidth+1)*(rowSize/1)
		var cSpace = d3.select('#chrtSpace');
		cSpace.selectAll('div').remove();
		cSpace.selectAll('br').remove();
		var targetDiv;
		charts.forEach(function(d,i){
			if(i%rowSize==0)
			{
				cSpace.append('br');
				targetDiv = cSpace.append('div')
				.style('width',divWidth+'px')
				.style('text-align','center')
				.style('margin',' 0 auto')
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
			if (y === Math.floor(d.value.y)) {
			  current[d.key] = d.value.scale.invert(y);
			  d3.select('#hcl').style('background',d3.rgb(current).toString());
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
	
	<fieldset class="fset"><legend>Date By:</legend>
		&nbsp;&nbsp;&nbsp;&nbsp;Starting:
		<select class ="slct" name = "selDate" id = "selDate" onchange = "filterArgs[4]=this.options[this.selectedIndex].text;cfrm();">
		</select>
		<input type='hidden' id='selArea' name='selArea' value=''>
		<input type='hidden' id='selDistrict' name='selDistrict' value=''>
		<input type='hidden' id='selFacility' name='selFacility' value=''>
		<input type='hidden' id='selDOW' name='selDOW' value=''>
		<input type='hidden' id='selClass' name='selClass' value=''>
		<input type='hidden' id='selCategory' name='selCategory' value=''>
		<input type='hidden' id='selEod' name='selEod' value=''>
		<input type='hidden' id='selPOL' name='selPOL' value=''>
		<input type='hidden' id='selHybStd' name='selHybStd' value=''>
		<input type='hidden' id='selMailer' name='selMailer' value=''>
		<input type='hidden' id='selDestZip3' name='selDestZip3' value=''>
		<input type='hidden' id='selOrgZip3' name='selOrgZip3' value=''>
		<input type='hidden' id='selCntrLvl' name='selCntrLvl' value=''>
		<input type='hidden' id='selFSS' name='selFSS' value=''>
		<input type='hidden' id='selAir' name='selAir' value=''>
		<input type='hidden' id='selMode' name='selMode' value=''>
	</fieldset>
	<fieldset class="fset"><legend>Level :</legend>
		<select class ="slct" name="selDir" id="selDir" onchange = "filterArgs[5]=this.options[this.selectedIndex].text;cfrm();">
		<option value = 'O'>Originating From View</option> 
		<option value = 'D'>Destinating to View</option> 
		</select> 
		<input type = "hidden" name = "rlupv"  id = "rlupv" value = '1'>
	</fieldset>
	
	<fieldset class="fset"><legend></legend>
		<input class ="slct" id="subtn" type = "button" value = "Submit Request" onClick="chartHistory.length=ReqId+1;chartHistory[ReqId+1]={};var ht=d3.select('#histTrack').node();ht.options.length=ReqId+1;ht.options[ReqId+1]=new Option(d3.select('#selDate').node().value+' '+d3.select('#selDir').node().options[d3.select('#selDir').node().selectedIndex].text,ReqId+1);ht.selectedIndex=ReqId+1;document.getElementById('chRow').style.display='inline-block';document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';cfrm_sub();">        
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
<select class ="slctSmall" onchange = "moveCharts(this.options[this.selectedIndex].value);">
		<option value = 1>1 Chart Per Row</option>
		<option value = 2>2 Charts Per Row</option> 
		<option value = 3 selected>3 Charts Per Row</option> 
		<option value = 4>4 Charts Per Row</option> 
		<option value = 5>5 Charts Per Row</option> 
		<option value = 6>6 Charts Per Row</option> 
		<option value = 7>7 Charts Per Row</option> 
		</select>
</div>
<div id="trend-Graph" style="float:right;text-align:center; min-width:20%;"></div>
<h2>Start the Clock Performance By Week</h2><iframe id="txtArea1" style="display:none"></iframe>
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
<div style='min-width:99%;min-height:250px;margin:0px 20%;'>
<div style="margin:50px;float:left;max-width:380px;text-align:center;text-variant: small-caps;font-family: times, Times New Roman;"><legend style='font-weight:bold;font-size: 24px;'>Overall Score</legend><div class='ovAll' id="OverallScore" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div style="margin:50px;float:left;max-width:380px;text-align:center;text-variant: small-caps;font-family: times, Times New Roman;"><legend style='font-weight:bold;font-size: 24px;'>Overall Failed Pieces</legend><div class='ovAll' id="OverallFail" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div style="margin:50px;float:left;max-width:380px;text-align:center;text-variant: small-caps;font-family: times, Times New Roman;"><legend style='font-weight:bold;font-size: 24px;'>Overall Pieces</legend><div class='ovAll' id="OverallPieces" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div id="color-key" style='margin:50px;float:left;'>
	<strong title='Click colors to change them'>Color Key </strong>
	<div style="height:24px;">
		<div style="display:inline-block;height:20px;width:20px;border:1px black solid;background:#4575b4">
			<input type='button' name='c9510' onclick=' HCLpicker(event,this.value,this);' value="#4575b4" style="color:transparent; background:#4575b4;opacity:1; border:none;padding:0px;margin:0px;height:20px;width:20px;">
		</div><span>Score 95&ndash;100%</span>
	</div>
	<div style="height:24px;">
		<div style="display:inline-block;height:20px;width:20px;border:1px black solid;background:#91bfdb">
			<input type='button' name='c9095' onclick=' HCLpicker(event,this.value,this);' value="#91bfdb" style="color:transparent; background:#91bfdb;opacity:1; border:none;padding:0px;margin:0px;height:20px;width:20px;">
			</div><span>Score 90&ndash;95%</span>
	</div>
	<div style="height:24px;">
		<div style="display:inline-block;height:20px;width:20px;border:1px black solid;background:#fee090">
			<input type='button' name='c8090' onclick=' HCLpicker(event,this.value,this);' value="#fee090" style="color:transparent; background:#fee090;opacity:1; border:none;padding:0px;margin:0px;height:20px;width:20px;">
		</div><span>Score 80&ndash;90%</span>
	</div>
	<div style="height:24px;">
		<div style="display:inline-block;height:20px;width:20px;border:1px black solid;background:#fc8d59">
			<input type='button' name='c7080' onclick=' HCLpicker(event,this.value,this);' value="#fc8d59" style="color:transparent; background:#fc8d59;opacity:1; border:none;padding:0px;margin:0px;height:20px;width:20px;">
		</div><span>Score 70&ndash;80%</span>
	</div>
	<div style="height:24px;">
		<div style="display:inline-block;height:20px;width:20px;border:1px black solid;background:#d73027">
			<input type='button' name='c0070' onclick=' HCLpicker(event,this.value,this);' value="#d73027" style="color:transparent; background:#d73027;opacity:1; border:none;padding:0px;margin:0px;height:20px;width:20px;">
		</div><span>Score 0&ndash;70%</span>
	</div>
</div>
<input type='button' id="RAll" style="font-size: 10px;border:none;text-decoration:underline;padding:10px 0px;background:transparent;color:silver;height:40px;width:80px;cursor:pointer;" value='Reset All' onClick='resetAll();'/>
</div>
<div id='searchBlock' style='padding: 25px;display: none;border: solid 2px blue;background:#f3f3f3;position: absolute; top:50%; left:50%; text-align:center;margin: 0 auto;'>
Search by Name:
<input id='searchTarget' type='text' onkeyup='if (event.keyCode == 13) {d3.select("#commitSearch").node().click();}'/> <input type='button' id='commitSearch' value='submit' onClick='d3.select("#searchBlock").style("display","none");')/>
</div>
<div id='chrtSpace'>
<div style='min-width:99%;text-align:center;margin: 0 auto;'>
<div id="chart-Area" style="display:inline-block;"></div>
<div id="chart-District" style="display:inline-block;"></div>
<div id="chart-Facility" style="display:inline-block;"></div>
</div>
<br>
<div style='min-width:99%;text-align:center;margin: 0 auto;'>
<div id="chart-EOD" style="display:inline-block;"></div>
<div id="chart-DOW" style="display:inline-block;"></div>
<div id="chart-Class" style="display:inline-block;"></div>
</div>
<br>
<div style='min-width:99%;text-align:center;margin: 0 auto;'>
<div id="chart-Shape" style="display:inline-block;"></div>
<div id="chart-SVCSTD" style="display:inline-block;"></div>
<div id="chart-MLR" style="display:inline-block;"></div>
</div>
<br>
<div style='min-width:99%;text-align:center;margin: 0 auto;'>
<div id="chart-DZ3" style="display:inline-block;"></div>
<div id="chart-OZ3" style="display:inline-block;"></div>
<div id="chart-Cntr" style="display:inline-block;"></div>
</div>
<br>
<div style='min-width:99%;text-align:center;margin: 0 auto;'>
<div id="chart-FSS" style="display:inline-block;"></div>
<div id="chart-Air" style="display:inline-block;"></div>
<div id="chart-" style="display:inline-block;"></div>
</div>
</div>
</div>
</body>
</html>