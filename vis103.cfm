<!doctype html>

<cfsetting showdebugoutput="no">
<cfajaxproxy cfc="vis10" jsclassname="vis10">
<cfajaximport>

<cfquery name="hier_q" datasource="#opsvisdata#">
select * from areadistname_t
where area_id not in ('4N','4M')
order by area_name,district_name
</cfquery>


<cfquery name="cls_q" datasource="#opsvisdata#">
select code_val,code_desc,code_desc_long from bi_code_value
where code_type_name = 'ML_CL_CODE'
and code_val > 0
order by to_number(code_val)
</cfquery>

<cfquery name="cat_q" datasource="#opsvisdata#">
select code_val,code_desc,code_desc_long from bi_code_value
where code_type_name = 'ML_CAT_CODE'
and code_val > 0
order by to_number(code_val)
</cfquery>

<cfquery name="hyb_q" datasource="#opsvisdata#">
select distinct hyb_svc_std,hyb_svc_std_desc
 from bi_mstr_svc_std
where hyb_svc_std > 0
order by hyb_svc_std
</cfquery>


<cfparam name="seldate" default="05/14/2016">

<html>
<head>
<link rel="stylesheet" type="text/css" href="styles/CommonStyleSheet.css">
<link rel="stylesheet" type="text/css" href="styles/d3styles.css">
<link rel="stylesheet" type="text/css" href="styles/dc.css">
<script language="javascript" src="jscripts/Lance.js"></script>
<script src='jscripts/d3.min.js'></script>
<script src='jscripts/crossfilter.min.js'></script>
<script src='jscripts/dc.min.js'></script>
<!---<script src='underscore-min.js'></script>--->

<meta charset="utf-8">
<title>Top 10</title>
<style>
	.dc-chart g.row text {fill: darkblue}
 .dc-chart g.row rect.deselected + text {fill: #88C}

	.node rect {
			cursor: move;
			fill-opacity: .9;
			shape-rendering: crispEdges;
		}

body {background-color:#f3f3f3;
      margin:0;
	  font-size: 14px;
      line-height: 1.42857143;
      color: #333;
	  font-family:Arial, Helvetica, sans-serif
	  }

	.color-box {
            display:inline-block;		
			height: 20px;
			width: 20px;
			border: 1px black solid;
			margin-right: 4px;
	}
	#color-key {
		<!---float: left;--->
		display:inline-block;
		width: 225px;
		height: 213px;
		padding-left: 15px;
		padding-right: 15px;
		padding-top: 20px;
    	
	}
	#color-key .row {
		margin-top: 5px;
		margin-left: 10px;
		margin-right: 0px;
	}
			


</style>

</head>

<body onload="load_facilities();myLoader2();">
<div id="banner" style="margin:0px auto; background: #21435F; height:60px; color:#FFFFFF">
<input type='button' value='|||' onclick="toggle()" class='pbnobtn' style='margin:5px 15px;width:40px;height:40px;font-size:20px;float:left;transform: rotate(90deg);'>
<h1  style="margin:5px 20px;font-size:45px;float:left;"> IV</h1>
<div style='padding:10px 25px 5px 0px;'>
<span style=" font-size:20px;"> Informed Visibility </span><br>
<span  style="font-size:15px;"> The single source for all your mail visibility needs </span>
</div><br>
</div>
<div id="loader_div" style="text-align:center"></div> 
<div id ="mainscr" style="visibility:hidden; padding-left:100px; width:1300px">

 <div style="text-align:center; margin:0 auto; display:inline-block">
 <h1>Top 10 Impacts - Actual Delivery Date</h1>
 <h3>Variance</h3>
 <div id="variance" style="clear:both">
 </div>
 </div>
        <div class="col-xs-12 col-sm-6 col-md-3" style="display:inline-block">
            <div id="color-key" class="dc-chart">
            <strong>Color Key</strong>
                <div class="row">
                    <div class="color-box col-xs-3" style="background-color:#4575b4"></div><span class="col-xs-9">Score 95&ndash;100%</span>
                </div>
                <div class="row">
                    <div class="color-box col-xs-3" style="background-color:#91bfdb"></div><span class="col-xs-9">Score 90&ndash;95%</span>
                </div>
                <div class="row">
                    <div class="color-box col-xs-3" style="background-color:#fee090"></div><span class="col-xs-9">Score 80&ndash;90%</span>
                </div>
                <div class="row">
                    <div class="color-box col-xs-3" style="background-color:#fc8d59"></div><span class="col-xs-9">Score 70&ndash;80%</span>
                </div>
                <div class="row">
                    <div class="color-box col-xs-3" style="background-color:#d73027"></div><span class="col-xs-9">Score 0&ndash;70%</span>
                </div>
                <div class="row">
                    <span class="col-xs-12">Graphs represent failed volume</span>
                </div>
            </div>
        </div> 

 <div id="chart1" >
     <div style=" margin:0px;padding:0px;"></span> 
     <strong>Origin Area</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:dc.filterAll();dc.redrawAll();sub_grp(chart2,failedpiecesDist,2,0);sub_grp(chart3,failedpiecesFac,3,0)">reset</a> 
       <span id = "cht1" style="margin-left:75px; visibility:hidden">
       <input type="button" value='<<' onclick="sub_grp(chart2,failedpiecesDist,1,-1)">
       <input type="button" value='>>' onclick="sub_grp(chart2,failedpiecesDist,1,1)">              
       </span>
     </div>
  </div> 
 <div id="chart2"> 
     <div style=" margin:0px; padding:0px;"></span> 
     <strong>Origin District</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:chart2.filterAll();chart3.filterAll();dc.redrawAll();sub_grp(chart3,failedpiecesFac,3,0)">reset</a> 
       <span id = "cht2" style="margin-left:75px; visibility:hidden;">
       <input type="button" value='<<' onclick="sub_grp(chart2,failedpiecesDist,2,-1)">
       <input type="button" value='>>' onclick="sub_grp(chart2,failedpiecesDist,2,1)">              
       </span>
     </div>
  </div>
 <div id="chart3"> 
     <div style=" margin:0px; ;"></span> 
     <strong>Origin Facility</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:chart3.filterAll();dc.redrawAll();">reset</a> 
       <span id = "cht3" style="margin-left:75px; visibility:hidden">
       <input type="button" value='<<'  onclick="sub_grp(chart3,failedpiecesFac,3,-1)">
       <input type="button" value='>>'  onclick="sub_grp(chart3,failedpiecesFac,3,1)">              
       </span>
     </div>
  </div>
 <div id="chart4"> 
     <div style=" margin:0px; ;"></span> 
     <strong>Class</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:chart4.filterAll();dc.redrawAll();sub_grp(chart6,failedpiecesHyb,6,0)">reset</a> 
       <span id = "cht4" style="margin-left:75px; visibility:hidden">
       <input type="button" value='<<'  onclick="sub_grp(chart4,failedpiecesCls,3,-1)">
       <input type="button" value='>>'  onclick="sub_grp(chart4,failedpiecesCls,3,1)">              
       </span>
     </div>
  </div>



 <div id="chart5"> 
     <div style=" margin:0px; ;"></span> 
     <strong>Shape</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:chart5.filterAll();dc.redrawAll();">reset</a> 
       <span id = "cht5" style="margin-left:75px; visibility:hidden">
       <input type="button" value='<<'  onclick="sub_grp(chart5,failedpiecesCat,3,-1)">
       <input type="button" value='>>'  onclick="sub_grp(chart5,failedpiecesCat,3,1)">              
       </span>
     </div>
  </div>

 <div id="chart6"> 
     <div style=" margin:0px; ;"></span> 
     <strong>Standard</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:chart6.filterAll();sub_grp(chart3,failedpiecesFac,3,0); dc.redrawAll();">reset</a> 
       <span id = "cht6" style="margin-left:75px; visibility:hidden">
       <input type="button" value='<<'  onclick="sub_grp(chart6,failedpiecesHyb,3,-1)">
       <input type="button" value='>>'  onclick="sub_grp(chart6,failedpiecesHyb,3,1)">              
       </span>
     </div>
  </div>


 <div id="chart7"> 
     <div style=" margin:0px; ;"></span> 
     <strong>Air/Surface</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:chart7.filterAll();dc.redrawAll();">reset</a> 
       <span id = "cht7" style="margin-left:75px; visibility:hidden">
       <input type="button" value='<<'  onclick="sub_grp(chart7,failedpiecesHyb,3,-1)">
       <input type="button" value='>>'  onclick="sub_grp(chart7,failedpiecesHyb,3,1)">              
       </span>
     </div>
  </div>

 <div id="chart8" > 
     <div style=" margin:0px; ;"></span> 
     <strong>Service Type</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:chart8.filterAll();dc.redrawAll();">reset</a> 
       <span id = "cht8" style="margin-left:75px; visibility:hidden">
       <input type="button" value='<<'  onclick="sub_grp(chart8,failedpiecesHyb,3,-1)">
       <input type="button" value='>>'  onclick="sub_grp(chart8,failedpiecesHyb,3,1)">              
       </span>
     </div>
  </div>

 <div id="chart9" > 
     <div style=" margin:0px; ;"></span> 
     <strong>Facility Type</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:chart9.filterAll();dc.redrawAll();">reset</a> 
       <span id = "cht9" style="margin-left:75px; visibility:hidden">
       <input type="button" value='<<'  onclick="sub_grp(chart9,failedpiecesHyb,3,-1)">
       <input type="button" value='>>'  onclick="sub_grp(chart9,failedpiecesHyb,3,1)">              
       </span>
     </div>
  </div>



</div><!---main--->
<script>

<!--- ***********************--->
var myLoader = loader({width: 480, height: 150, container: "#loader_div", id: "loader"});
var myLoader2 = loader({width: 360, height: 100, container: "#loader_div", id: "loader2"});

function loader(config) {
  return function() {
    var radius = Math.min(config.width, config.height) / 2;
    var tau = 2 * Math.PI;

    var arc = d3.svg.arc()
            .innerRadius(radius*0.5)
            .outerRadius(radius*0.9)
            .startAngle(0);

    var svg = d3.select(config.container).append("svg")
        .attr("id", config.id)
        .attr("width", config.width)
        .attr("height", config.height)


      .append("g")
        .attr("transform", "translate(" + config.width / 2 + "," + config.height / 2 + ")")

    var background = svg.append("path")
            .datum({endAngle: 0.80*tau})
            .style("fill", "##21435F")
            .attr("d", arc)
            .call(spin, 1500)

    function spin(selection, duration) {
        selection.transition()
            .ease("linear")
            .duration(duration)
            .attrTween("transform", function() {
                return d3.interpolateString("rotate(0)", "rotate(360)");
            });

        setTimeout(function() { spin(selection, duration); }, duration);
    }

    function transitionFunction(path) {
        path.transition()
            .duration(7500)
            .attrTween("stroke-dasharray", tweenDash)
            .each("end", function() { d3.select(this).call(transition); });
    }

  };
}
<!--- ***********************--->

function reset_start(v)
{
 for (var i = v; i <  cht_list.length;i++)
  {
   cht_list[i].st=0;
   cht_list[i].mx=0;  	
  }
}


function sub_grp(cht,grp,ar,dir)
{

	 if (dir == 0) cht_list[ar].st = 0;        
     if (cht_list[ar].st+11 <= cht_list[ar].mx || cht_list[ar].mx == 0 || dir == -1) 
	  cht_list[ar].st+=dir;
	 if (cht_list[ar].st <0) cht_list[ar].st = 0;
	 var st = cht_list[ar].st;

	var x = 
		{
		all: function()
		 {
			 return grp.top(Infinity).filter(function(d,i) 
			 {return (i >=st && i < st+10 && d.value.tp > 0)});
		 },
		top: function() {return grp.top(Infinity).filter(function(d,i) {return (i >=st && i < st+10 && d.value.tp > 0)});}
		,
		size: function() {return grp.top(Infinity).filter(function(d,i) {return (d.value.tp > 0)});}
		
		}
	cht_list[ar].mx = x.size().length;	
	if (cht_list[ar].mx > 10 && ar > 1)
	 document.getElementById('cht'+ar).style.visibility=''
	else 
	 document.getElementById('cht'+ar).style.visibility='hidden';	
	cht.group(x);
	cht.redraw();	
}
var dataset=[];
var facilities = [];
var area_hier = [];
var dist_hier = [];
var cls_hier = [];
var cat_hier = [];
var hyb_hier = [];
var ariance = [];
var  tmp = '';

var air_hier = [['Y','AIR'],['N','Surface'],['','Unknown']];
var cert_hier = [['Y','Full Service'],['N','Non Compliant']];
var factype_hier = [[0,'BMEU Only'],[1,'Plant']];

var cht_list = [];
for (var i = 0;i<10;i++)
cht_list.push({st:0,mx:0});


var dist_st = 0;
<!--<cfoutput><cfloop query="hier_q">-->
if (tmp != '#area_id#')
{
  var ar = [];	
  ar.push('#area_id#');
  ar.push('#area_name#');  
  area_hier.push(ar);
  tmp = '#area_id#';
}

  var ar = [];	
  ar.push('#district_id#');
  ar.push('#district_name#');  
  ar.push('#area_id#');    
  dist_hier.push(ar);
<!--</cfloop></cfoutput>-->

<!--<cfoutput><cfloop query="cls_q">-->
  var ar = [];	
  ar.push('#code_val#');
  ar.push('#code_desc_long#');  
  ar.push('#code_desc#');    
  cls_hier.push(ar);
<!--</cfloop></cfoutput>-->

<!--<cfoutput><cfloop query="cat_q">-->
  var ar = [];	
  ar.push('#code_val#');
  ar.push('#code_desc_long#');  
  ar.push('#code_desc#');    
  cat_hier.push(ar);
<!--</cfloop></cfoutput>-->

<!--<cfoutput><cfloop query="hyb_q">-->
  var ar = [];	
  ar.push('#hyb_svc_std#');
  ar.push('#hyb_svc_std_desc#');  
  hyb_hier.push(ar);
<!--</cfloop></cfoutput>-->



<!--d3 formats--->
	var dateFormat  = d3.time.format('%Y-%m-%d');
	var dateFormat2 = d3.time.format('%m/%d/%Y');
	var timestampFormat = d3.time.format('%m/%d/%Y %H:%M');
	var numFormat = d3.format(',d');
	var floatFormat = d3.format(".2f");
	var pctFormat  = d3.format(",.1%");
	var dayHourFormat = function(h) { return Math.round(h/24,0) + "d " + floatFormat(h % 24) + "h"; };
<!--d3 formats--->

var chart1,chart2,chart3,chart4,chart5,chart6,chart7,chart8,chart9;
var natDim,areaDim,distDim,facDim,clsDim,catDim,hybDim;
var failedpieces,failedpiecesDist,failedpiecesFac,failedpiecesCls,failedpiecesCat,failedpiecesHyb;
var numRowCap = 10;


//	var ndx = crossfilter();
//	var all = ndx.groupAll();

function get_name(a,v)
{
for (var i=0;i<a.length;i++)
{
  if (v.length > 4)
   x = 1;	
  if (a[i][0]==v)
   return a[i][1];		
   
}
return v;
}

function get_area(a,v)
{
for (var i=0;i<a.length;i++)
{
  if (v.length > 2)
   x = 1;	
  if (a[i][0]==v)
   return a[i][2];		
   
}
return 'Others';
}


function load_facilities()
{
var vis_ret = function(res)
{
facilities =res.DATA;	
load_data()
}
var vis_err = function(res)
{
alert(res);		
}

	var e=new vis10();
    e.setCallbackHandler(vis_ret);	
    e.setErrorHandler(vis_err);
    e.getsvisfac(<cfoutput>'#opsvisdata#','#seldate#'</cfoutput>);
}

function load_data()
{
var vis_ret = function(res)
{
dataset =res.DATA;	
d3.select('#loader2').remove();
showchart()
}
var vis_err = function(res)
{
alert(res);		
}

	var e=new vis10();
    e.setCallbackHandler(vis_ret);	
    e.setErrorHandler(vis_err);
    e.getsvisdata(<cfoutput>'#opsvisdata#','14-may-2016'</cfoutput>);
}


/*var areaRowChart = dc.rowChart("#chart-row-area"); */
var cbColorRange = ["#d73027","#fc8d59","#fee090","#91bfdb","#4575b4"];
	function cbColor() { return d3.scale.threshold().domain([0.7,0.8,0.9,0.95]).range(cbColorRange );}
		
//var cbColorRange = ["pink","yellow","lightgreen"];
//	function cbColor() { return d3.scale.threshold().domain([0.9,.95]).range(cbColorRange);}	
	
	function rollupOthers(group, rowCap) {
		var tp = 0;
		var fp = 0;
		var ary = group.top(Infinity);
		for (var i = rowCap; i < ary.length; i++) {
			tp += ary[i].value.tp;
			fp += ary[i].value.fp
		}
		tp = d3.round(tp/(ary.length-rowCap));
		fp = d3.round(fp/(ary.length-rowCap));		

		return {fp: fp, tp: tp, pass: tp-fp};
	}


function reduceAdd(p, v) {
 				p.fp += v[7]-v[6];  
				p.tp += v[7];
				p.pass += v[6];
 			return p;
}

function reduceRemove(p, v) {
			p.fp -= v[7]-v[6];  
			p.tp -= v[7];
			p.pass -= v[6];
			return p;
}

function reduceInitial() {
  return {fp : 0,tp : 0,pass : 0};
}

function orderValue(p) {
  return p.fp;
}

function fvariance(v1,v2,d)
{
if (d==0)
{	
for (var i = 0; i < v1.length;i++)
  v1[i] += v2[i];	
}
if (d==1)
{	
for (var i = 0; i < v1.length;i++)
  v1[i] -= v2[i];	
}  

}


function createScoreGroup(dimension) {
		return dimension.group().reduce(
			function (p,v) {
				p.fp += v[7]-v[6];  
				p.tp += v[7];
				p.pass += v[6];
				fvariance(p.variance,[v[10],v[11],v[12],v[13],v[14],v[15],v[16],v[17],v[18]],0);
				return p;
			},
			function (p,v) {
			p.fp -= v[7]-v[6];  
			p.tp -= v[7];
			p.pass -= v[6];
			fvariance(p.variance,[v[10],v[11],v[12],v[13],v[14],v[15],v[16],v[17],v[18]],1);			
			return p;
			},
			function () {
				return {
				fp : 0,
				tp : 0,
				pass : 0,
				variance :[0,0,0,0,0,0,0,0,0]}
			}
		).order(orderValue);

	}


function showVariance()
{
	
var chart = dc.barChart("#variance"); 
 //d3.csv("morley.csv", function(error, experiments) 
 
  
  
   var vndx                 = crossfilter(ariance), 
       runDimension        = vndx.dimension(function(d) {return +d[0];}), 
       SumGroup       = runDimension.group().reduceSum(function(d) {return d[1]}); 
  
   chart 
     .width(900) 
     .height(200) 
	 .margins({left: 80, right: 30, top: 0, bottom: 40})
     .x(d3.scale.linear().domain([-4,4])) 
     .brushOn(false)
     .centerBar("true") 
     .yAxisLabel("Pieces") 
     .xAxisLabel("Days to Deliver") 	 
   .dimension(runDimension) 
     .group(SumGroup) 
    /* .on('renderlet', function(chart) { 
         chart.selectAll('rect').on("click", function(d) { 
             console.log("click!", d); 
         }); 
     })*/; 
     chart.render(); 
	
	
	
}




function load_variance()
{
ariance.length=0;	
 for (var i = 10;i<19;i++)
  {
  ariance.push([i-14,natDim.groupAll().reduceSum(function(d) {return d[i]}).value()]);
  }
  showVariance();
}


function createSimpleDimension(xfilter, attr) {
		return xfilter.dimension(function (d) {
			return d[attr];
		});
	}




function showchart()
{

 var ndx = crossfilter(dataset); 
// var all = ndx.groupAll();
 var idx = crossfilter(dataset);  
 
 var didx = crossfilter(dataset);  
// var areaDim  = ndx.dimension(function(d) {return d[2];});
 natDim = createSimpleDimension(ndx,0);
 areaDim = createSimpleDimension(ndx,2);
 clsDim = createSimpleDimension(ndx,1);
 catDim = createSimpleDimension(ndx,9); 
 hybDim = createSimpleDimension(ndx,22);  
 distDim = createSimpleDimension(ndx,3);
 facDim = createSimpleDimension(ndx,5);
 airDim = createSimpleDimension(ndx,21); 
 certDim = createSimpleDimension(ndx,8);  
 factypeDim = createSimpleDimension(ndx,23);   

 
// var distDim  = idx.dimension(function(d) {return d[3];});

// var failedpieces = areaDim.group().reduceSum(function(d) {return +d[7]-d[6];});
 failedpieces =  createScoreGroup(areaDim); 
 failedpiecesDist =  createScoreGroup(distDim);  
 failedpiecesFac =  createScoreGroup(facDim);  
 failedpiecesCls =  createScoreGroup(clsDim);   
 failedpiecesCat =  createScoreGroup(catDim);    
 failedpiecesHyb =  createScoreGroup(hybDim);     
 failedpiecesAir =  createScoreGroup(airDim);     
 failedpiecesCert =  createScoreGroup(certDim);      
 failedpiecesFactype =  createScoreGroup(factypeDim);       
 
/*
 var failedpiecesDist =  remove_empty_bins(failedpiecesDist);   
function remove_empty_bins(source_group) {
    return {
        all:function () {
          vi  return source_group.all().filter(function(d) {
                return d.value != 0;
            });
        }
    };
}
*/
 
 
//var failedpiecesDist = distDim.group().reduce(reduceAdd,reduceRemove, reduceInitial).order(orderValue).top(10);
 


chart1 = createRowChart("#chart1", areaDim, failedpieces, 300, 300,area_hier);
chart2 = createRowChart("#chart2", distDim, failedpiecesDist, 300, 300,dist_hier);
chart3 = createRowChart("#chart3", facDim, failedpiecesFac, 300, 300,facilities);
chart4 = createRowChart("#chart4", clsDim, failedpiecesCls, 300, 300,cls_hier);
chart5 = createRowChart("#chart5", catDim, failedpiecesCat, 300, 300,cat_hier);
chart6 = createRowChart("#chart6", hybDim, failedpiecesHyb, 300, 300,hyb_hier);
chart7 = createRowChart("#chart7", airDim, failedpiecesAir, 300, 300,air_hier);
chart8 = createRowChart("#chart8", certDim, failedpiecesAir, 300, 300,cert_hier);
chart9 = createRowChart("#chart9", factypeDim, failedpiecesFactype, 300, 300,factype_hier);
function createRowChart(chartname, dimension, group, width, height, lookup,  numRowCap)  
{
var chart = dc.rowChart(chartname);
      numRowCap = typeof numRowCap !== 'undefined' ? numRowCap : 11;
     chart.dimension(dimension) 
     .group(group)
     .width(width) 
     .height(height) 
<!---	.label(function(d){return (d.others) ? 'Others' : get_name(lookup,d.key)})--->
     .label(function(d){return (d.value.tp == 0) ? '' : get_name(lookup,d.key)})
     .elasticX(true) 
	 .colors(cbColor())
 	.colorAccessor(function (d) {
				return (d.others) ? rollupOthers(group, numRowCap).pass/rollupOthers(group, numRowCap).tp:  d.value.pass/d.value.tp;
			})
   	.valueAccessor(function (d) {
		          	if (d.others) 
				{
				 x=1;
				}
				return (d.others) ? rollupOthers(group, numRowCap).fp : d.value.fp;
			})	 
		.title(function(d) {
				var other = (d.others) ? rollupOthers(group,numRowCap) : null;
				if (d.others) 
				{
				 x=1;
				}
				var key = get_name(lookup,d.key);
				var cnt = (d.others) ? other.fp : d.value.fp;
				var tot = (d.others) ? other.tp : d.value.tp;
				var pct = (d.others) ? other.pass/other.tp : d.value.pass/d.value.tp;
				return key + ' \nFailures: ' + numFormat(cnt) + ' \nTotal: ' + numFormat(tot) + ' \nPerformace: ' + pctFormat(pct);
			})			
     .controlsUseVisibility(true)
//	 .turnOnControls(true)
	 .ordering(function(d) { return -d.value.fp})
	 .rowsCap(numRowCap)
	 .othersGrouper(false)
	 
/*	 .othersGrouper(

	       function(d) 
		    { 
			 var results = []; 
			 var st = 0;
			if (chart.anchorName() == 'chart2') st = dist_st;
				for(i in d) {if (i > st-1) 
				results.push(d[i]); }
			return results}
			 )
*/			 
     .xAxis().ticks(4).tickFormat(d3.format("s"))
	 ;
      chart.on('pretransition', function(chart) {
        chart.selectAll("rect,text").on("click", function (d) {
            chart.filter(null)
                .filter(d.key)
                .redrawGroup();
        });
       });

 	chart.on('renderlet.somename',function(chart) {
		load_variance();

    chart.selectAll('text,rect').on('click.foo',function(d) { 
		 if (chart.anchorName() == 'chart1') { chart2.filterAll();chart3.filterAll();
		  reset_start(0);sub_grp(chart2,failedpiecesDist,2,0);
		  
		  }
	 if (chart.anchorName() == 'chart2') {
		  reset_start(3); sub_grp(chart3,failedpiecesFac,3,0)
		  }		  
	 if (chart.anchorName() == 'chart4') {
		  sub_grp(chart5,failedpiecesCat,5,0);
		  sub_grp(chart6,failedpiecesHyb,6,0)		  
		  }		  
	 if (chart.anchorName() == 'chart5') {
		  sub_grp(chart6,failedpiecesHyb,6,0)		  
		  }		  
	 if (chart.anchorName() == 'chart6') {
		  sub_grp(chart3,failedpiecesFac,3,0)		  
		  }		  

	 if (chart.anchorName() == 'chart9') {
		  sub_grp(chart3,failedpiecesFac,3,0)		  
		  }		  
		  
		  
	});
	
/*    chart.selectAll('rect').on('click.foo',function(d) {
		 if (chart.anchorName() == 'chart1') {
		areaDim2.filterAll(); areaDim2.filter(d.key);  dc.redrawAll();}
	});	*/
	
	});		

  return chart;
}


 dc.renderAll(); 

d3.selectAll('.dc-chart').select('g').attr('transform','translate(30,0)');

load_variance();

document.getElementById('mainscr').style.visibility=''; 

}
</script>
 
</body>

</html>