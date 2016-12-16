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


</style>

</head>

<body onload="load_facilities()">
<div id="banner" style="margin:0px auto; background: #21435F; height:60px; color:#FFFFFF">
<input type='button' value='|||' onclick="toggle()" class='pbnobtn' style='margin:5px 15px;width:40px;height:40px;font-size:20px;float:left;transform: rotate(90deg);'>
<h1  style="margin:5px 20px;font-size:45px;float:left;"> IV</h1>
<div style='padding:10px 25px 5px 0px;'>
<span style=" font-size:20px;"> Informed Visibility </span><br>
<span  style="font-size:15px;"> The single source for all your mail visibility needs </span>
</div><br>
</div>
<div id ="mainscr" style="visibility:hidden; margin-top:20px">


 <div id="chart1"  >
     <div style=" margin:0px;padding:0px;"></span> 
     <strong>Origin Area</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:chart1.filterAll();areaDim2.filterAll();chart2.filterAll();distDim2.filterAll();chart3.filterAll();dc.redrawAll();sub_grp(chart2,failedpiecesDist,2,0)">reset</a> 
       <span id = "cht1" style="margin-left:75px; visibility:hidden">
       <input type="button" value='<<' onclick="sub_grp(chart2,failedpiecesDist,1,-1)">
       <input type="button" value='>>' onclick="sub_grp(chart2,failedpiecesDist,1,1)">              
       </span>
     </div>
  </div> 
 <div id="chart2"> 
     <div style=" margin:0px; padding:0px;"></span> 
     <strong>Origin District</strong>
       <a class="reset" style="visibility: hidden;" href="javascript:chart2.filterAll();distDim2.filterAll();chart3.filterAll();dc.redrawAll();sub_grp(chart3,failedpiecesFac,3,0)">reset</a> 
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
       <a class="reset" style="visibility: hidden;" href="javascript:clsDim2.filterAll(); clsDim3.filterAll(); chart4.filterAll();dc.redrawAll();sub_grp(chart6,failedpiecesHyb,6,0)">reset</a> 
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
       <a class="reset" style="visibility: hidden;" href="javascript:chart5.filterAll();dc.redrawAll();">reset</a> 
       <span id = "cht6" style="margin-left:75px; visibility:hidden">
       <input type="button" value='<<'  onclick="sub_grp(chart6,failedpiecesHyb,3,-1)">
       <input type="button" value='>>'  onclick="sub_grp(chart6,failedpiecesHyb,3,1)">              
       </span>
     </div>
  </div>



</div><!---main--->
<script>
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
var  tmp = '';


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

var chart1,chart2,chart3,chart4,chart5,chart6;
var areaDim,distDim,areaDim2,distDim2,facDim,areaDim3,clsDim,catDim,hybDim;
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




function createScoreGroup(dimension) {
		return dimension.group().reduce(
			function (p,v) {
				p.fp += v[7]-v[6];  
				p.tp += v[7];
				p.pass += v[6];
				return p;
			},
			function (p,v) {
			p.fp -= v[7]-v[6];  
			p.tp -= v[7];
			p.pass -= v[6];
			return p;
			},
			function () {
				return {
				fp : 0,
				tp : 0,
				pass : 0}
			}
		).order(orderValue);
	}


//xxx

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
 areaDim = createSimpleDimension(ndx,2);
 clsDim = createSimpleDimension(ndx,1);
 catDim = createSimpleDimension(ndx,9); 
 hybDim = createSimpleDimension(ndx,22);  
 areaDim2 = createSimpleDimension(idx,2); 
 distDim = createSimpleDimension(idx,3);
 areaDim3 = createSimpleDimension(didx,2);
 distDim2 = createSimpleDimension(didx,3);
 facDim = createSimpleDimension(didx,5);
 clsDim2 = createSimpleDimension(idx,1);
 catDim2 = createSimpleDimension(idx,9); 
 hybDim2 = createSimpleDimension(idx,22);   
 clsDim3 = createSimpleDimension(didx,1);
 catDim3 = createSimpleDimension(didx,9); 
 hybDim3 = createSimpleDimension(didx,22);   
 
// var distDim  = idx.dimension(function(d) {return d[3];});

// var failedpieces = areaDim.group().reduceSum(function(d) {return +d[7]-d[6];});
 failedpieces =  createScoreGroup(areaDim); 
 failedpiecesDist =  createScoreGroup(distDim);  
 failedpiecesFac =  createScoreGroup(facDim);  
 failedpiecesCls =  createScoreGroup(clsDim);   
 failedpiecesCat =  createScoreGroup(catDim);    
 failedpiecesHyb =  createScoreGroup(hybDim);     
 
 
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
function createRowChart(chartname, dimension, group, width, height, lookup,  numRowCap)  
{
var chart = dc.rowChart(chartname);
      numRowCap = typeof numRowCap !== 'undefined' ? numRowCap : 11;
     chart.dimension(dimension) 
     .group(group)
     .width(width) 
     .height(height) 
	.label(function(d){return (d.others) ? 'Others' : get_name(lookup,d.key)})
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
    chart.selectAll('text,rect').on('click.foo',function(d) { 
		 if (chart.anchorName() == 'chart1') { chart2.filterAll();chart3.filterAll();
		  areaDim2.filterAll(); areaDim3.filterAll(); areaDim2.filter(d.key); areaDim3.filter(d.key); distDim2.filterAll();  facDim.filterAll();  dc.redrawAll();
		  reset_start(0);sub_grp(chart2,failedpiecesDist,2,0);
		  }
	 if (chart.anchorName() == 'chart2') {
		  chart3.filterAll(); facDim.filterAll();  distDim2.filterAll(); distDim2.filter(d.key);  dc.redrawAll();
		  reset_start(3); sub_grp(chart3,failedpiecesFac,3,0)
		  }		  
	 if (chart.anchorName() == 'chart4') {
		  sub_grp(chart5,failedpiecesCat,5,0);
		  sub_grp(chart6,failedpiecesHyb,6,0)		  
		  clsDim2.filter(d.key); dc.redrawAll();
		  clsDim3.filter(d.key); dc.redrawAll();		  
		  }		  
	 if (chart.anchorName() == 'chart5') {
		  sub_grp(chart6,failedpiecesHyb,6,0)		  
		  catDim2.filter(d.key); dc.redrawAll();
		  catDim3.filter(d.key); dc.redrawAll();		  
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
sub_grp(chart2,failedpiecesDist,2,0);
sub_grp(chart3,failedpiecesFac,3,0);
sub_grp(chart4,failedpiecesCls,4,0);
sub_grp(chart5,failedpiecesCat,5,0);
sub_grp(chart6,failedpiecesHyb,6,0)		  

d3.selectAll('.dc-chart').select('g').attr('transform','translate(30,0)');
document.getElementById('mainscr').style.visibility=''; 
}
</script>
 
</body>

</html>