<!doctype html>
<cfajaxproxy cfc="DiagReportD3" jsclassname="DiRe">
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
<cfparam name="selMailer" default="">
		
<cfparam name="selOrg3" default="">
<cfparam name="selDest3" default="">
<cfparam name="selPhysCntr" default="">
<cfparam name="selDestFac" default="">
<cfparam name="selImbZip3" default="">

<html>
<head>
<meta charset="utf-8">
<title>Diagnostics</title>
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

.inputFont {
	font-size:12px;
	//color:blue;
	//text-decoration: underline;
	text-variant: small-caps;
	font-family: times, Times New Roman;
	//cursor: pointer;
	background: white;
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

.pbTable {
	font-size:12px;
}

.oddRec td{
	background: #CCC;
}

</style>

<cfquery name = "fac_lu" datasource="#opsvisdata#">
select ofczip,ofcname,pref_city
from mhts_facilities
order by ofczip
</cfquery>

<script>
	var aryfac = {};
	<cfoutput query="fac_lu">aryfac['#ofczip#'] = '#ofcname#,#pref_city#';</cfoutput>
	<cfoutput>
	var params=['#selFacility#','#selDOW#','#selEod#','#selDir#','#selHybStd#','#selClass#','#selCategory#','#selFSS#','#selAir#','#selMode#','#rpt_range#','#BG_DATE#','#chkpol#','#selMailer#','#selOrg3#','#selDest3#','#selPhysCntr#','#selDestFac#','#selImbZip3#']
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
		
		var dataGroup = res;
		
		var w = 600;
		var h = 300;
		var padding = 60;

		var high = d3.max(dataGroup,function(d){return d[5];});
		var low = d3.min(dataGroup,function(d){return d[4];});
		
		//Create scale functions
		xScale = d3.scale.ordinal().rangeBands([padding, w-padding]);

		yScale = d3.scale.linear()
			 .domain([0,1])
			 .range([h - padding, padding]);
			 
		yScale2 = d3.scale.linear()
			 .domain([low,high])
			 .range([h - padding, padding]);
							 
	/*	var	cScale = d3.scale.linear().domain([0,1]).range(["#0C0","#0C0"]);	
		var	cScale2 = d3.scale.linear().domain([low,high]).range(["#00C","#00C"]);	
		var	cScale3 = d3.scale.linear().domain([low,high]).range(["#C00","#C00"]);	*/


		var perF = d3.format('.1%');
		var sigF = d3.format('.3g');
		var comF = d3.format(',');
		var siF = d3.format('.3s');
		  
		var order = [];
		res.forEach(function(d,i){order.push(d[3]);});
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
				.call(xAxis)
				.selectAll('text')
				.attr("transform", "translate(12,3)rotate(90)")
				.style("text-anchor", "start");

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
			.text('');
			
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
		
		var rdiv = (w-(padding*2))/(res.length)/2;
		var rw = 210/res.length;
		
		container.selectAll(".rectBar")
			   .data(dataGroup)
			   .enter()
			   .append("rect")
				.attr("class", "rectBar")
			   .attr("x", function(d,i) {	return xScale(order[i])+rdiv-rw/2;})
			   .attr("y", function(d) {return yScale2(d[5]);})
			   .attr("width", rw)
			   .attr("height", function(d) {return Math.abs(yScale2(d[5])-yScale2(low));})
			   .attr("fill", '#00A')
			   .append('title')
			   .text(function(d) {return 'Total Pieces: '+comF(d[5]);})
		
		
		container.selectAll(".rectBar2")
			   .data(dataGroup)
			   .enter()
			   .append("rect")
				.attr("class", "rectBar2")
			   .attr("x", function(d,i) {	return xScale(order[i])+rdiv-rw/2;})
			   .attr("y", function(d) {return yScale2(d[4]);})
			   .attr("width", rw)
			   .attr("height", function(d) {return Math.abs(yScale2(d[4])-yScale2(low));})
			   .attr("fill",'#A00')
			   .append('title')
			   .text(function(d) {return 'Failed Pieces: '+comF(d[4]);})
		
		/*var line = d3.svg.line()
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
			.attr('fill', 'none');*/

		container.selectAll(".pCont")
			   .data(dataGroup)
			   .enter()
			   .append("circle")
				.attr("class", "pCont")
			   .attr("cx", function(d,i) {	return xScale(order[i])+rdiv;})
			   .attr("cy", function(d) {return yScale(d[6])})
			   .attr("r", 3)
			   .attr("fill", '#0C0')
			   .append('title')
			   .text(function(d) {return 'On Time: '+perF(d[6]);})

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
		var e=new DiRe();
		e.setCallbackHandler(makeTable);	
		e.setErrorHandler(data_err);
		e.getMainData('<cfoutput>#opsvisdata#</cfoutput>','1','O','N',"04/09/2016","04/16/2016","All","All","3","1","","","","","Y","","34",'');*/
		
		/*var e=new DiRe();
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
		
		var sdow=d3.select('#selDOW').node();
		filterArgs[1]=sdow.options[sdow.selectedIndex].text;
		
		var e=new DiRe();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(data_err);
		e.getDates('<cfoutput>#opsvisdata#</cfoutput>',params[10]);
		
		get_std();
		
		var e=new DiRe();
		e.setCallbackHandler(Load_Data);	
		e.setErrorHandler(data_err);
		<cfoutput>e.getMainData('#opsvisdata#','#selDir#','#selEod#','#BG_DATE#','#ED_DATE#','#selClass#','#selCategory#','#selFSS#','#selMode#','#selAir#',"","Y",'#chkpol#','#selHybStd#','','#selFacility#','#selDOW#','','','#selMailer#','#selOrg3#','#selDest3#','#selPhysCntr#','#selDestFac#','#selImbZip3#');</cfoutput>
		document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';
		myLoader();
		listSelections();
		document.getElementById("subtn").style.border = 'none';
	}

	function chg_DateRng(n)
	{
		var e=new DiRe();
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
			
		if(sclass==1)
		{
			smode = document.getElementById('selMode').value;
			sair = document.getElementById('selAir').value;
		}
		
		var sDOW = document.getElementById('selDOW').value;
		var e=new DiRe();
		e.setCallbackHandler(Load_Data);	
		e.setErrorHandler(data_err);
		e.getMainData('<cfoutput>#opsvisdata#</cfoutput>',sdir,seod,sd,sdend,sclass,scat,sfss,smode,sair,"","Y",spol,shyb,'',params[0],sDOW,'','',params[13],params[14],params[15],params[16],params[17],params[18]);
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

		var e=new DiRe();
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

	var Full_Data='';
	var recFrom=1;
	var recTo=10;
	function Load_Data(res)
	{
		d3.select('#loader').remove();
		var h1row = res.shift();
		Full_Data=[];
		res.forEach(function(d,i){
			Full_Data[i]={};
			h1row.forEach(function(d2,i2){
				Full_Data[i][d2]=d[i2];	
			});
		});
		//alert(Full_Data.length);
		splinterData(1,10);
	}
	
	function splinterData(from,to)
	{
		var lastRec = Full_Data[Full_Data.length-1].REC_NO;
		if(to>lastRec)
		{
			to=recTo=lastRec;
			from=recFrom=(to-9);
		}
		if(from<1)
		{
			from=recFrom=1;
			to=recTo=10;
		}
		var hold=[]
		Full_Data.forEach(function (d,i) {
			if(d.REC_NO >= from && d.REC_NO <= to)
				hold.push(d);
		})
		
		makeTable(hold);
	}

	function makeTable(res)
	{
		d3.select('#eOut').style('display','');
		var perF = d3.format('.1%');
		var sigF = d3.format('.3g');
		var siF = d3.format('.3s');
		var comF = d3.format(',');
		
		var homediv = d3.select('#tableDiv');
		homediv.select('#STQdiv').remove();

		var homeTBL =homediv.append('table')
		.attr('class','pbTable')
		//.style('margin','0px 0px 0px 100px')	  
		.attr('id','mainTable');
		var thead = homeTBL.append('thead');
		
		var srlupv = document.getElementById('rlupv').value;
		var h1row = res.shift();
		var data=res;
		/*res.forEach(function(d,i){
			data[i]={};
			h1row.forEach(function(d2,i2){
				data[i][d2]=d[i2];	
			});
		});*/
		
		res=[];totalNames=[];
		
		var count=0;<!---
		REC_NO,ORIGIN_FAC_ZIP3,FAC_ZIP_CODE,OP_CODE,MPE_ID,DECLARED_TRAY_CONTENT,
		SORT_PLAN,SCAN_DATETIME,IMB_CODE,SORT_ZIP,ROUTE_ID,ID_TAG,X_STC,X_IMCB_CODE,
		X_ACTUAL_ENTRY_DATETIME,X_CRITICAL_ENTRY_TIME,X_CODE_DESC,X_PLT_FACILITY_NAME,
		X_OP_DESC,X_MAILER_NAME,X_EDOC_SEQ,X_JOB_SEQ_ID,X_LOG_HU,X_PHYS_HU,X_LOG_CNTR,X_PHYS_CNTR,
		X_ML_CL_CODE,X_ML_CAT_CODE,X_SVC_STD,X_CONTR_LVL_DESC,
		X_FEDEX_AIR_SCAN_IND,
		X_THS_CLEAN_AIR_SCAN_IND,
		X_CAIR_SCAN_IND--->
		var weekday = new Array(7);
		weekday[0]=  "Sunday";
		weekday[1] = "Monday";
		weekday[2] = "Tuesday";
		weekday[3] = "Wednesday";
		weekday[4] = "Thursday";
		weekday[5] = "Friday";
		weekday[6] = "Saturday";
		var lastHr=0,lastImb='';
		data.forEach(function(d,i){
			res[i]=[];
			count=0;
			if(lastImb!=d.IMB_CODE)
			{
				lastImb=d.IMB_CODE;
				lastHr=0;
			}
			var timeHold = Math.abs(new Date(d.X_ACTUAL_ENTRY_DATETIME)- new Date(d.SCAN_DATETIME));
			timeHold=timeHold/1000/60/60;
			var dow = new Date(d.SCAN_DATETIME);
			res[i][count++]=d.REC_NO;				
			res[i][count++]=d.ORIGIN_FAC_ZIP3;
			res[i][count++]=[d.FAC_ZIP_CODE,(aryfac[d.FAC_ZIP_CODE])?aryfac[d.FAC_ZIP_CODE]:'Not in Facility Table'];
			res[i][count++]=[d.OP_CODE,d.X_OP_DESC];
			res[i][count++]=d.MPE_ID;
			res[i][count++]=d.DECLARED_TRAY_CONTENT;
			res[i][count++]=d.SORT_PLAN;
			res[i][count++]=[d.SCAN_DATETIME,d.X_IMCB_CODE,d.X_ACTUAL_ENTRY_DATETIME,d.X_CRITICAL_ENTRY_TIME,d.X_CODE_DESC,d.X_SVC_STD,d.X_CONTR_LVL_DESC,[d.IMB_CODE,d.X_JOB_SEQ_ID,d.X_EDOC_SEQ,d.X_LOG_CNTR,d.X_PHYS_CNTR,d.X_LOG_HU,d.X_PHYS_HU,d.X_ML_CL_CODE,d.X_ML_CAT_CODE,d.ORIGIN_FAC_ZIP3,params[14],params[0],d.X_SVC_STD]];
			res[i][count++]=[d.IMB_CODE,[d.FAC_ZIP_CODE,d.IMB_CODE,d.X_STC]];
			res[i][count++]=d.SORT_ZIP;
			res[i][count++]=d.ROUTE_ID;
			res[i][count++]=d.ID_TAG;
			res[i][count++]=Math.floor(timeHold-lastHr);
			res[i][count++]=Math.floor(timeHold);
			res[i][count++]=Math.floor(timeHold/24)+1;
			res[i][count++]=weekday[dow.getDay()];
			res[i][count++]=d.X_MAILER_NAME;
			lastHr=timeHold;
		});
		
		//BarChart(res);
		
		h1row=['REC NO','ORIGIN FAC ZIP3','FAC ZIP CODE','OP CODE','MPE ID','DECLARED TRAY CONTENT','SORT PLAN','SCAN DATETIME','IMb CODE','SORT ZIP','ROUTE ID','ID TAG','LAST','HOURS','DAYS','DAY','MAILER'];
		
		thead.append('tr')
		.selectAll('th').data(h1row).enter()
		.append('th')
		.style('padding','3px')
		.text(function(d){return d;});

		var tbody = homeTBL.append('tbody')
		.selectAll('.trb').data(res).enter()
		.append('tr')
		.attr('class',function(d){if(d[0] % 2 == 1)return '.oddRec';})
		.selectAll('td').data(function(d){return d}).enter()
		.append('td')
		.style('padding','3px')
		.style('text-decoration',function(d,i){if(i==2 || i==3 || i==7 || i==8)return 'underline';})
		.style('color',function(d,i){if(i==2 || i==3 || i==7 || i==8)return 'blue';})
		.style('cursor',function(d,i){if(i==7 || i==8)return 'pointer';if(i==2 || i==3)return 'help';})
		.style('text-align',function(d,i) {return 'Center'})
		.text(function(d,i){if(i==2 || i==3 || i==7 || i==8)return d[0];if(i==5)return getraydesc(d);return d;})
		.on('click', function(d,i){if(i==7)cntr_lu(d[7]);if(i==8)mhts_imb(d[1]);})
		.attr('title',function(d,i){
		if(i==7){return 'IMCB Code: '+d[1]+'\nActual Entry Time: '+d[2]+'\nCritical Entry Time: '+d[3]+'\nInduction Method: '+d[4]+'\nService Standard: '+d[5]+' Cntr LVL Code: '+d[6]+'\n* click on Scan DateTime for details';}
		if(i==2 || i==3)return d[1];if(i==8)return "Click to Link to MHTS";});
							
		scrTblQuick('mainTable',300);
		d3.select('#STQdiv').style('margin','');
		
		d3.select('#loader').remove();
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

	function fpContLnk()
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
		var sarea = '';//document.getElementById('selArea').value;
		var sdist = '';//document.getElementById('selDistrict').value;
		var sdir = document.getElementById('selDir').value;
		var seod = document.getElementById('selEod').value;
		var scat = document.getElementById('selCategory').value;
		var sfss = document.getElementById('selFSS').value;
		var shyb = document.getElementById('selHybStd').value;
		var sDOW = document.getElementById('selDOW').value;

		window.open('fp_contD3.cfm?selImb='+imb
+'&selJob='+sJob
+'&selCrid='+sCrid
+'&selContlog='+sClog
+'&selContphy='+sCphy
+'&selHUlog='+sHUlog
+'&selHUphy='+sHUphy
+'&selClass='+sclass
+'&selCategory='+scat
+'&selorg3='+N[1]
+'&seldest3='+N[2]
+'&selOrgFac='+params[0]
+'&selStd='+shyb
+'WKN='+sd+'&BG_DATE=' +sd+"&ED_DATE="+sdend+"&RPT_RANGE="+rng+"&SELAREA="+sarea+"&SELDISTRICT="+sdist
		+"&SELDIR="+sdir
		+"&SELEOD="+seod+"&SELFACILITY="+params[0]+"&SELFSS="+sfss
		+"&SELHYBSTD="+shyb+"&selAir="+sair+"&selMode="+smode
		+"&selDow="+sDOW+"&selMailer="+params[13]
		+'&selOrg3='+N[1]+'&selDest3='+N[2]+'&selPhysCntr='+''+'&selDestFac='+N[3]
		,'_fpCont ');
	}
	
	function cntr_lu(N)
	{
		var h='fp_cont.cfm?selImb='+N[0]+'&selJob='+N[1]+'&selCrid='+N[2]+'&selContlog='+N[3]+'&selContphy='+N[4]+'&selHUlog='+N[5]+'&selHUphy='+N[6]+'&selClass='+N[7]+'&selCategory='+N[8]+'&selorg3='+N[9]+'&seldest3='+N[10]+'&selOrgFac='+N[11]+'&selStd='+N[12];
		window.open(h,N[0],'top=50,left=50,height=500,width=900,scrollbars=1,menubar=1,toolbar=1,resizable=yes' );	
	}

	function mhts_imb(N)
	{

		var tt = new Date();
		var dt = new Date(N[2]);
		var t = N[1].substr(0,20);
		if (parseInt((tt-dt)/(1000*60*60*24)))
		 x = 1
		else x = '';
		h= "MHTS_dlg.cfm?facility="+N[0]+"&tracking="+t+'&all_days='+x;
		window.open(h,null,'top=50,left=50,height=500,width=900,scrollbars=1,menubar=1,toolbar=1,resizable=yes' );
	}
	
	function csv_sub()
	{
		myLoader();
		document.cookie="DOWNLOADID=dlDone;domain="+document.domain+";path=/;expires=Thu, 01 Jan 1970 00:00:00 UTC";
		
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
		var sDOW = document.getElementById('selDOW').value;
			
		if(sclass==1)
		{
			smode = document.getElementById('selMode').value;
			sair = document.getElementById('selAir').value;
		}
		
		var csvForm = d3.select("body")
		.append("form")
		.attr("method","post")
		.attr("action","diagCSV.cfm")
		.attr("name","csv_form")
		
		csvForm.append("input").attr("type","hidden").attr("name","dsn").attr("value",'<cfoutput>#opsvisdata#</cfoutput>');
		csvForm.append("input").attr("type","hidden").attr("name","selDir").attr("value",sdir);
		csvForm.append("input").attr("type","hidden").attr("name","selEOD").attr("value",seod);
		csvForm.append("input").attr("type","hidden").attr("name","bg_date").attr("value",sd);
		csvForm.append("input").attr("type","hidden").attr("name","ed_date").attr("value",sdend);
		csvForm.append("input").attr("type","hidden").attr("name","selClass").attr("value",sclass);
		csvForm.append("input").attr("type","hidden").attr("name","selCategory").attr("value",scat);
		csvForm.append("input").attr("type","hidden").attr("name","selFSS").attr("value",sfss);
		csvForm.append("input").attr("type","hidden").attr("name","selMode").attr("value",smode);
		csvForm.append("input").attr("type","hidden").attr("name","selAir").attr("value",sair);
		csvForm.append("input").attr("type","hidden").attr("name","selCntrLvl").attr("value","");
		csvForm.append("input").attr("type","hidden").attr("name","rdCert").attr("value","Y");
		csvForm.append("input").attr("type","hidden").attr("name","chkPol").attr("value",spol);
		csvForm.append("input").attr("type","hidden").attr("name","selHybStd").attr("value",shyb);
		csvForm.append("input").attr("type","hidden").attr("name","sortBy").attr("value","");		
		csvForm.append("input").attr("type","hidden").attr("name","selOrgFac").attr("value",params[0]);
		csvForm.append("input").attr("type","hidden").attr("name","selDOW").attr("value",sDOW);
		csvForm.append("input").attr("type","hidden").attr("name","selvariance").attr("value","");
		csvForm.append("input").attr("type","hidden").attr("name","fp_chk").attr("value","");
		csvForm.append("input").attr("type","hidden").attr("name","selMailer").attr("value",params[13]);
		csvForm.append("input").attr("type","hidden").attr("name","selOrg3").attr("value",params[14]);
		csvForm.append("input").attr("type","hidden").attr("name","selDest3").attr("value",params[15]);
		csvForm.append("input").attr("type","hidden").attr("name","selPhysCntr").attr("value",params[16]);
		csvForm.append("input").attr("type","hidden").attr("name","selDestFac").attr("value",params[17]);
		csvForm.append("input").attr("type","hidden").attr("name","selImbZip3").attr("value",params[18]);
		
		dlTrack(csvForm.node());
		
		document.csv_form.submit();
		
		csvForm.remove();
		//d3.select('#loader').remove();
	}
	
	function getraydesc(x) 
	{
		switch(''+x)
		{
			case '143':traydesc ='EXPRESS DROP SHIP'; break;
			case '157':traydesc = 'APPS single induction - incoming Std'; break;
			case '165':traydesc ='PRIORITY DROP SHIP'; break;
			case '205':traydesc ='DEL STD CMM MAN'; break;
			case '206':traydesc ='DEL LTR STD CMM MAN'; break;
			case '207':traydesc ='DEL FLTS STD CMM MAN'; break;
			case '221':traydesc ='FCM FLTS 5D BC/NBC'; break;
			case '222':traydesc ='FCM FLTS 3D BC/NBC'; break;
			case '231':traydesc ='FCM FLTS ADC BC/NBC'; break;
			case '232':traydesc ='FCM FLTS BC/NBC WKG'; break;
			case '241':traydesc ='FCM LTR BC 5D SCHEME'; break;
			case '242':traydesc ='FCM LTR 5D BC'; break;
			case '243':traydesc ='FCM LTR BC SCHEME2'; break;
			case '244':traydesc ='FCM LTR 3D BC'; break;
			case '245':traydesc ='FCM LTR AADC BC'; break;
			case '246':traydesc ='FCM LTR BC WKG'; break;
			case '255':traydesc ='FCM LTR 3D MACH'; break;
			case '258':traydesc ='FCM LTR AADC MACH'; break;
			case '260':traydesc ='FCM LTR MACH WKG'; break;
			case '267':traydesc ='FCM LTR 5D MANUAL'; break;
			case '268':traydesc ='FCM LTR MANUAL WKG'; break;
			case '269':traydesc ='FCM LTR 3D MANUAL'; break;
			case '270':traydesc ='FCM LTR ADC MANUAL'; break;
			case '272':traydesc ='FCM FLTS 5D BC'; break;
			case '273':traydesc ='FCM FLTS 3D BC'; break;
			case '274':traydesc ='FCM FLTS ADC BC'; break;
			case '275':traydesc ='FCM FLTS BC WKG'; break;
			case '278':traydesc ='FCM FLTS 5D NON BC'; break;
			case '279':traydesc ='FCM FLTS 3D NON BC'; break;
			case '280':traydesc ='FCM FLTS ADC NON BC'; break;
			case '282':traydesc ='FCM FLTS NON BC WKG'; break;
			case '289':traydesc ='FCM PARCELS 5D'; break;
			case '290':traydesc ='FCM PARCELS 3D'; break;
			case '291':traydesc ='FCM PARCELS ADC'; break;
			case '292':traydesc ='FCM PARCELS WKG'; break;
			case '321':traydesc ='PER FLTS 5D BC/NBC'; break;
			case '322':traydesc ='PER FLTS 3D BC/NBC'; break;
			case '329':traydesc ='PER FLTS SCF BC/NBC'; break;
			case '331':traydesc ='PER FLTS ADC BC/NBC'; break;
			case '332':traydesc ='PER FLTS BC/NBC WKG'; break;
			case '339':traydesc ='PER FLTS CR/5D'; break;
			case '340':traydesc ='PER IRREG CR/5D'; break;
			case '341':traydesc ='PER LTRS BC 5D SCHEME'; break;
			case '342':traydesc ='PER LTRS 5D BC'; break;
			case '343':traydesc ='PER LTRS BC SCHEME2'; break;
			case '344':traydesc ='PER LTRS 3D BC'; break;
			case '345':traydesc ='PER LTRS AADC BC'; break;
			case '346':traydesc ='PER LTRS BC WKG'; break;
			case '349':traydesc ='PER FLTS CR/5D SCH'; break;
			case '350':traydesc ='PER LTRS 5D NON BC'; break;
			case '351':traydesc ='PER FLTS 3D CR-RTS'; break;
			case '352':traydesc ='PER FLTS CR/5D/3D'; break;
			case '353':traydesc ='PER LTRS 3D NON BC'; break;
			case '354':traydesc ='PER IRREG CR/5D/3D'; break;
			case '355':traydesc ='PER IRREG 3D CR-RTS'; break;
			case '356':traydesc ='PER LTRS ADC NON BC'; break;
			case '359':traydesc ='PER LTRS NON BC WKG'; break;
			case '363':traydesc ='PER IRREG WKG W FCM'; break;
			case '365':traydesc ='PER IRREG CR/5D SCH'; break;
			case '366':traydesc ='PER LTRS CR1'; break;
			case '367':traydesc ='PER LTRS CR-RTS'; break;
			case '368':traydesc ='PER LTRS 3D CR-RTS'; break;
			case '369':traydesc ='PER LTRS WSS1'; break;
			case '370':traydesc ='PER LTRS WSH1'; break;
			case '371':traydesc ='PER FLTS CR-RTS SCH'; break;
			case '372':traydesc ='PER FLTS 5D BC'; break;
			case '373':traydesc ='PER FLTS 3D BC'; break;
			case '374':traydesc ='PER FLTS ADC BC'; break;
			case '375':traydesc ='PER FLTS BC WKG'; break;
			case '377':traydesc ='PER FLTS SCF BC'; break;
			case '378':traydesc ='PER FLTS 5D NON BC'; break;
			case '379':traydesc ='PER FLTS 3D NON BC'; break;
			case '380':traydesc ='PER FLTS ADC NON BC'; break;
			case '381':traydesc ='PER FLTS WKG W FCM'; break;
			case '382':traydesc ='PER FLTS NON BC WKG'; break;
			case '384':traydesc ='PER FLTS SCF NON BC'; break;
			case '385':traydesc ='PER FLTS CR1'; break;
			case '386':traydesc ='PER FLTS 5D CR-RTS'; break;
			case '387':traydesc ='PER FLTS WSS1'; break;
			case '388':traydesc ='PER FLTS WSH1'; break;
			case '389':traydesc ='PER IRREG 5D'; break;
			case '390':traydesc ='PER IRREG 3D'; break;
			case '391':traydesc ='PER IRREG ADC'; break;
			case '392':traydesc ='PER IRREG WKG'; break;
			case '394':traydesc ='PER IRREG SCF'; break;
			case '395':traydesc ='PER IRREG CR1'; break;
			case '396':traydesc ='PER IRREG 5D CR-RTS'; break;
			case '397':traydesc ='PER IRREG WSS1'; break;
			case '398':traydesc ='PER IRREG WSH1'; break;
			case '399':traydesc ='PER IRREG CR-RTS SCH'; break;
			case '421':traydesc ='NEWS FLTS 5D BC/NBC'; break;
			case '422':traydesc ='NEWS FLTS 3D BC/NBC'; break;
			case '429':traydesc ='NEWS FLTS SCF BC/NBC'; break;
			case '431':traydesc ='NEWS FLTS ADC BC/NBC'; break;
			case '432':traydesc ='NEWS FLTS BC/NBC WKG'; break;
			case '439':traydesc ='NEWS FLTS CR/5D'; break;
			case '440':traydesc ='NEWS IRREG CR/5D'; break;
			case '441':traydesc ='NEWS LTR BC 5D SCHEME'; break;
			case '442':traydesc ='NEWS LTRS 5D BC'; break;
			case '443':traydesc ='NEWS LTRS BC SCHEME2'; break;
			case '444':traydesc ='NEWS LTRS 3D BC'; break;
			case '445':traydesc ='NEWS LTRS AADC BC'; break;
			case '446':traydesc ='NEWS LTRS BC WKG'; break;
			case '449':traydesc ='NEWS FLTS CR/5D SCH'; break;
			case '450':traydesc ='NEWS LTRS 5D NON BC'; break;
			case '451':traydesc ='NEWS FLTS 3D CR-RTS'; break;
			case '452':traydesc ='NEWS FLTS CR/5D/3D'; break;
			case '453':traydesc ='NEWS LTRS 3D NON BC'; break;
			case '454':traydesc ='NEWS IRREG CR/5D/3D'; break;
			case '455':traydesc ='NEWS IRREG 3D CR-RTS'; break;
			case '456':traydesc ='NEWS LTRS ADC NON BC'; break;
			case '459':traydesc ='NEWS LTRS NON BC WKG'; break;
			case '463':traydesc ='NEWS IRREG WKG W FCM'; break;
			case '465':traydesc ='NEWS IRREG CR/5D SCH'; break;
			case '466':traydesc ='NEWS LTRS CR1'; break;
			case '467':traydesc ='NEWS LTRS CR-RTS'; break;
			case '468':traydesc ='NEWS LTRS 3D CR-RTS'; break;
			case '469':traydesc ='NEWS LTRS WSS1'; break;
			case '470':traydesc ='NEWS LTRS WSH1'; break;
			case '471':traydesc ='NEWS FLTS CR-RTS SCH'; break;
			case '472':traydesc ='NEWS FLTS 5D BC'; break;
			case '473':traydesc ='NEWS FLTS 3D BC'; break;
			case '474':traydesc ='NEWS FLTS ADC BC'; break;
			case '475':traydesc ='NEWS FLTS BC WKG'; break;
			case '477':traydesc ='NEWS FLTS SCF BC'; break;
			case '478':traydesc ='NEWS FLTS 5D NON BC'; break;
			case '479':traydesc ='NEWS FLTS 3D NON BC'; break;
			case '480':traydesc ='NEWS FLTS ADC NON BC'; break;
			case '481':traydesc ='NEWS FLTS WKG W FCM'; break;
			case '482':traydesc ='NEWS FLTS NON BC WKG'; break;
			case '484':traydesc ='NEWS FLTS SCF NON BC'; break;
			case '485':traydesc ='NEWS FLTS CR1'; break;
			case '486':traydesc ='NEWS FLTS 5D CR-RTS'; break;
			case '487':traydesc ='NEWS FLTS WSS1'; break;
			case '488':traydesc ='NEWS FLTS WSH1'; break;
			case '489':traydesc ='NEWS IRREG 5D'; break;
			case '490':traydesc ='NEWS IRREG 3D'; break;
			case '491':traydesc ='NEWS IRREG ADC'; break;
			case '492':traydesc ='NEWS IRREG WKG'; break;
			case '494':traydesc ='NEWS IRREG SCF'; break;
			case '495':traydesc ='NEWS IRREG CR1'; break;
			case '496':traydesc ='NEWS IRREG 5D CR-RTS'; break;
			case '497':traydesc ='NEWS IRREG WSS1'; break;
			case '498':traydesc ='NEWS IRREG WSH1'; break;
			case '499':traydesc ='NEWS IRREG CR-RTS SCH'; break;
			case '500':traydesc ='STD NFM 5D'; break;
			case '501':traydesc ='STD/PSVC 3D'; break;
			case '502':traydesc ='STD/PSVC ADC'; break;
			case '503':traydesc ='STD NFM MACH ASF'; break;
			case '505':traydesc ='STD NFM NDC'; break;
			case '506':traydesc ='STD/PSVC WKG'; break;
			case '507':traydesc ='STD NFM SCF'; break;
			case '509':traydesc ='STD NFM ASF'; break;
			case '514':traydesc ='STD NFM MACH NDC'; break;
			case '518':traydesc ='STD NFM MACH WKG'; break;
			case '521':traydesc ='STD FLTS 5D BC/NBC'; break;
			case '522':traydesc ='STD FLTS 3D BC/NBC'; break;
			case '529':traydesc ='STD FLTS CR-RTS SCH'; break;
			case '531':traydesc ='STD FLTS ADC BC/NBC'; break;
			case '532':traydesc ='STD FLTS BC/NBC WKG'; break;
			case '539':traydesc ='STD FLTS CR/5D'; break;
			case '541':traydesc ='STD LTR BC 5D SCHEME'; break;
			case '542':traydesc ='STD LTR 5D BC'; break;
			case '543':traydesc ='STD LTR BC SCHEME2'; break;
			case '544':traydesc ='STD LTR 3D BC'; break;
			case '545':traydesc ='STD LTR AADC BC'; break;
			case '546':traydesc ='STD LTR BC WKG'; break;
			case '549':traydesc ='STD FLTS CR/5D SCH'; break;
			case '555':traydesc ='STD LTR 3D MACH'; break;
			case '557':traydesc ='STD LTR BC'; break;
			case '558':traydesc ='STD LTR AADC MACH'; break;
			case '560':traydesc ='STD LTR MACH WKG'; break;
			case '564':traydesc ='STD LTR 5D CR-RT BC'; break;
			case '565':traydesc ='STD LTR 3D CR-RT BC'; break;
			case '567':traydesc ='STD LTR 5D CR-RT MACH'; break;
			case '568':traydesc ='STD LTR 3D CR-RT MACH'; break;
			case '569':traydesc ='STD LTR MACH'; break;
			case '570':traydesc ='STD IRREG NDC'; break;
			case '571':traydesc ='STD IRREG ASF'; break;
			case '572':traydesc ='STD FLTS 5D BC'; break;
			case '573':traydesc ='STD FLTS 3D BC'; break;
			case '574':traydesc ='STD FLTS ADC BC'; break;
			case '575':traydesc ='STD FLTS BC WKG'; break;
			case '578':traydesc ='STD FLTS 5D NON BC'; break;
			case '579':traydesc ='STD FLTS 3D NON BC'; break;
			case '580':traydesc ='STD FLTS ADC NON BC'; break;
			case '582':traydesc ='STD FLTS NON BC WKG'; break;
			case '586':traydesc ='STD FLTS CR-RTS'; break;
			case '587':traydesc ='STD FLTS ECRWSS1'; break;
			case '588':traydesc ='STD FLTS ECRWSH1'; break;
			case '589':traydesc ='STD FLTS ECRLOT1'; break;
			case '590':traydesc ='STD IRREG 5D'; break;
			case '591':traydesc ='STD/PSVC IRREG 3D'; break;
			case '592':traydesc ='STD/PSVC IRREG ADC'; break;
			case '594':traydesc ='STD IRREG WKG'; break;
			case '596':traydesc ='STD IRREG SCF'; break;
			case '598':traydesc ='STD IRREG CR-RTS'; break;
			case '599':traydesc ='STD IRREG WSS1'; break;
			case '600':traydesc ='STD IRREG WSH1'; break;
			case '601':traydesc ='STD IRREG LOT1'; break;
			case '603':traydesc ='STD MACH-IRREG 5D'; break;
			case '604':traydesc ='STD LTR 5D MANUAL'; break;
			case '605':traydesc ='STD LTR MANUAL WKG'; break;
			case '606':traydesc ='STD LTR 3D MANUAL'; break;
			case '607':traydesc ='STD LTR ADC MANUAL'; break;
			case '608':traydesc ='STD LTR MAN LOT1'; break;
			case '609':traydesc ='STD LTR 5D CR-RT MAN'; break;
			case '611':traydesc ='STD LTR 3D CR-RT MAN'; break;
			case '635':traydesc ='PSVC FLTS 5D BC'; break;
			case '636':traydesc ='PSVC FLTS 3D BC'; break;
			case '637':traydesc ='PSVC FLTS SCF BC'; break;
			case '638':traydesc ='PSVC FLTS ADC BC'; break;
			case '639':traydesc ='PSVC FLTS BC WKG'; break;
			case '648':traydesc ='PSVC FLTS 5D BC/NBC'; break;
			case '649':traydesc ='PSVC FLTS 5D NON BC'; break;
			case '650':traydesc ='PSVC FLTS 3D NON BC'; break;
			case '651':traydesc ='PSVC FLTS ADC NON BC'; break;
			case '653':traydesc ='PSVC FLTS NON BC WKG'; break;
			case '654':traydesc ='PSVC FLTS SCF NON BC'; break;
			case '657':traydesc ='PSVC FLTS CR1'; break;
			case '658':traydesc ='PSVC FLTS CR-RTS'; break;
			case '659':traydesc ='PSVC FLTS CR-RTS SCH'; break;
			case '660':traydesc ='STD/PSVC MACH 5D'; break;
			case '661':traydesc ='PSVC FLTS 3D BC/NBC'; break;
			case '662':traydesc ='STD/PSVC MACH ASF'; break;
			case '663':traydesc ='STD/PSVC MACH NDC'; break;
			case '664':traydesc ='STD/PSVC MACH WKG'; break;
			case '667':traydesc ='PSVC FLTS SCF BC/NBC'; break;
			case '668':traydesc ='PSVC FLTS ADC BC/NBC'; break;
			case '669':traydesc ='PSVC FLTS BC/NBC WKG'; break;
			case '670':traydesc ='STD MACH 5D'; break;
			case '672':traydesc ='STD MACH ASF'; break;
			case '673':traydesc ='STD MACH NDC'; break;
			case '674':traydesc ='STD MACH WKG'; break;
			case '680':traydesc ='PSVC MACH 5D'; break;
			case '682':traydesc ='PSVC MACH ASF'; break;
			case '683':traydesc ='PSVC MACH NDC'; break;
			case '684':traydesc ='PSVC MACH WKG'; break;
			case '687':traydesc ='PSVC MACH CR1'; break;
			case '688':traydesc ='PSVC PARCELS 5D'; break;
			case '690':traydesc ='PSVC IRREG 5D'; break;
			case '691':traydesc ='PSVC IRREG 3D'; break;
			case '692':traydesc ='PSVC IRREG ADC'; break;
			case '694':traydesc ='PSVC IRREG WKG'; break;
			case '696':traydesc ='PSVC IRREG SCF'; break;
			case '697':traydesc ='PSVC IRREG CR1'; break;
			case '698':traydesc ='PSVC IRREG CR-RTS'; break;
			default:traydesc='-';
		}
		return traydesc;
	}

	function dlTrack( event ) {
 
		var target = event.action;

		var downloadID = "dlDone"
		target += ( "?downloadID="+ downloadID);

		var cookiePattern = new RegExp( ( "downloadID=dlDone" + downloadID ), "i" );

		var cookieTimer = setInterval( checkCookies, 500 );

		function checkCookies() {

			if ( document.cookie.search( "DOWNLOADID=dlDone" ) >= 0 ) {
				clearInterval( cookieTimer );
				document.cookie="DOWNLOADID=dlDone;domain="+document.domain+";path=/;expires=Thu, 01 Jan 1970 00:00:00 UTC";
				d3.select('#loader').remove();
				return;
			}
		 
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
<h2>IMb - Commercial Mail Service Performance<br>
<sup style ="line-height: 0px;font-size:12px;text-variant: small-caps;font-family: times, Times New Roman;"> - <em>First 3000 Records are viewable. For entire list use download all to csv button.</em></sup>
</h2>
<iframe id="txtArea1" style="display:none"></iframe>
<div id ="loaderDiv" style="z-index: 3;"></div>
<div id='eOut' style='display:none;margin:0px 0px 0px 30px;'>
	<input class ="hyperFont" type = "button" value = "Excel" onClick="excel_out();" style='float:left'>
	<input class ="hyperFont" type = "button" value = "Download All to Csv" onClick="csv_sub();" style='float:left'>
	<div style='margin:0px 0px 0px 70%;'>
		<span> Prev 10 Recs 
		<input class ="hyperFont" type = "button" id='pgLeft' onclick="recTo-=10;recFrom-=10;splinterData(recFrom,recTo)" value = "&#10094;&#10094;" >
		GoTo:<input class ="inputFont" type = "number" min="1" max="99999" size="5" id='pgGo' onchange="this.value=Math.abs(this.value);recFrom=Math.floor(this.value);recTo=recFrom+9;splinterData(recFrom,recTo)" value = "" >
		<input class ="hyperFont" type = "button" id='pgRight' onclick='recTo+=10;recFrom+=10;splinterData(recFrom,recTo)' value = "&#10095;&#10095;" >
		 Next 10 Recs </span>
	</div>
</div>
<div id ="tableDiv" style='margin:0px 0px 10px 30px'></div>
<div id ="mainDiv" ></div>
</div>
</body>
</html>