<!doctype html>
<!---<cfset opsvisdata = "opsvis_user">--->
<cfset opsvisdata = 'iv_spduser'>
<cfajaxproxy cfc="visSPPV" jsclassname="TDF">
<cfajaximport>

<cfsetting showdebugoutput="no">

<!--- params --->
<cfparam name='selArea' default=''/>
<cfparam name='selDistrict' default=''/>
<cfparam name='selFacility' default="37571"/>
<cfparam name='selMailer' default=''/>
<cfparam name='selDOW' default=''/>
<cfparam name='selClass' default=''/>
<cfparam name='selCategory' default=''/>
<cfparam name='selCntrLvl' default=''/>
<cfparam name='selEod' default=''/>
<cfparam name='selHybStd' default=''/>
<cfparam name='selAir' default=''/>
<cfparam name='selFSS' default=''/>
<cfparam name='selImbZip3' default=''/>
<cfparam name='selOrgFac' default=''/>
<cfparam name='selPol' default=''/>
<cfparam name='selEntType' default=''/>
<cfparam name='selInduct' default=''/>
<cfparam name='selfpzip3' default=''/>
<cfparam name='selfporg3' default=''/>
<cfparam name='selfpdate' default=''/>
<cfparam name='selCert' default=''/>
<cfparam name='selMlrFlg' default='N'/>
<cfparam name='selState' default=''/>
<cfparam name='selUR' default=''/>
<cfparam name='selurbk' default=''/>
<cfparam name='selRange' default=''/>
<cfparam name='selDir' default=''/>
<cfparam name='selAir' default=''/>
<cfparam name='selMode' default=''/>
<cfparam name='selDate' default='11/12/2016'/>
<cfparam name='selDestnFac' default=''/>

<!--- params --->

<cfscript>
function ap(v)
{
var x = v;
 if(x is not '' and  x does not contain "'" )
 x = "'" & x & "'"; 
 return x;
	
}


</cfscript>






<html>
<head>

<meta charset="utf-8">
<title>Processing Vis</title></title>
<link rel="stylesheet" type="text/css" href="styles/CommonStyleSheet.css">
<link rel="stylesheet" type="text/css" href="styles/d3styles.css">
<script language="javascript" src="jscripts/Lance.js"></script>
<script src='jscripts/d3.min.js'></script>
<script src='jscripts/crossfilter.min.js'></script>
<script src='jscripts/dc.min.js'></script>
<script src='jscripts/d3keybindings.js'></script>

<style>
.darkrow td
{
	background-color:#C8C8C8;
}
.lightrow td
{
	background-color:#f3f3f3;
}


body {
	background-color:#f3f3f3;
}

tspan {white-space:normal;} 
tspan:nth-child(2n)
{ display:block; }

	

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
//	font-family: times, Times New Roman;
	font-family:"Lucida Sans Unicode", "Lucida Grande", sans-serif
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
eset
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
	var csa_dataset = [];  
	var csa_hdr = [];
	var fp_dataset = [];  
	var fp_hdr = [];
	var fp_datasetindv= [];  
	var fp_dtindv=[];	
	var fp_sub= [];  	
	var fp_hdrindv = [];
	var trendDataset = [];
	var trendId = 0;
	var trendCnt=0;	
    var col_start=6;	
    var current_failed_pieces = 10000;
    var newdiropt = false;
    var date_rng = [];
	var initLoader = loader({width: 480, height: 150, container: "#mainDiv", id: "initLoader",msg:"Loading . . . "});
	var myLoader = loader({width: 480, height: 150, container: "#loaderDiv", id: "loader",msg:"Retrieving . . . "});
	var AreaLoader = loader2({width: 175, height: 175, container: "#chart-Area", id: "AreaLoader",msg:""});
	var DistrictLoader = loader2({width: 175, height: 175, container: "#chart-District", id: "DistrictLoader",msg:""});
	var FacilityLoader = loader2({width: 175, height: 175, container: "#chart-Facility", id: "FacilityLoader",msg:""});
	var EntryLoader = loader2({width: 175, height: 175, container: "#chart-EOD", id: "EODLoader",msg:""});
	var DOWLoader = loader2({width: 175, height: 175, container: "#chart-DOW", id: "DOWLoader",msg:""});
	var ClassLoader = loader2({width: 175, height: 175, container: "#chart-Class", id: "ClassLoader",msg:""});
	var ShapeLoader = loader2({width: 175, height: 175, container: "#chart-Shape", id: "ShapeLoader",msg:""});

	var filterHds = ['Entry: ','Area: ','District: ','Range: ','Week: ','Level: ','Rollup: ','Class: ','Std.: ','Shape: '];
	var filterArgs = ['Destination','National','','Week','04/23/2016','Originating From View','Area','Standard','DSCF 3-4','Letters'];


function disp_fpcont(res,r,c)
{
cmaf = d3.format(',');
dtf = d3.format('%m/%d/%/%Y');
perf = d3.format('.1%');
var cnt = fp_dataset.length;	
//if (cnt-30 < r) r=cnt-30;
if (r<0) r=0;
//res = fp_dataset.slice(r,c+r);      
var pc = res.shift();
var pc_hdr = pc.shift();

var cntr = res.shift();
var cntr_hdr = cntr.shift();

var tray = res.shift();
var tray_hdr = tray.shift();



var temp_rc = 'darkrow';	
   d3.select("#fpcontdiv").remove();

   var div = d3.select('body')
   .append('div')
   .attr('id','fpcontdiv')
   .style('position','absolute')
   .style('top','150px')
   .style('left','150px')
   ;

   div.call(d3.behavior.drag().on("drag", move).on("dragend",function () {d3.select('body').node().focus();}));
   
	div.style('display','');
	div.selectAll('#fpconttable').remove();
	var tb = div.append('table')
 .attr('id','fpconttable')
 .style('margin','auto')
 .style('font-size','12px')
 .style('border','double 6px') 
 .style('background','#d3d3d3')
 .style('box-shadow','0px 0px 0px 2px black, 20px 20px 50px #888888')
 .attr('class','pbTable');

 var thead = tb.append('thead');
/*   var t =thead.append('tr')
		.append('th')
		.attr('colspan',pc_hdr.length);
		t.append('input')
		.attr('type','button')
		.attr('value','X')
		.style('float','right')
		.on('click', function() {d3.select('#fpcontdiv').remove()});
*/		
/*
		t.append('input')
		.attr('type','button')
		.attr('value','Excel')
		.style('float','right')
		.on('click', function() {excel_out('#zip3table')});
*/
/*		
		t.append('label')		
		.text('Use Mouse Wheel to scroll or Page-Up/Page-Down')
		.style('text-align','center');
*/		
   var t =thead.append('tr')
		.append('th')
		.attr('colspan',pc_hdr.length)
		.style('text-align','center')
		.text('CONTAINER-TRAY DETAILED INFORMATION');
		t.append('input')
		.attr('type','button')
		.attr('value','X')
		.style('float','right')
		.on('click', function() {d3.select('#fpcontdiv').remove()});
		
   var t =thead.append('tr')
		.append('th')
		.attr('colspan',pc_hdr.length)
		.style('text-align','center')
		.text('Piece Level Information');

 

var hdrcell = thead.append('tr')
 .selectAll('th')
  .data(pc_hdr)
 .enter()
 .append('th')
 .style('position','relative')
 .text(function(d) {return d.replace(/_/g,' ')});

 /*
 hdrcell
	.append('label')
	.attr('id',function(d,i) {return 'dnarrow3-'+ i})
	.attr('class','arrow-down')
	.on('click',function() {sortit(this,fp_dataset,30)});
 hdrcell	
	.append('label')
	.attr('id',function(d,i) {return 'uparrow3-'+ i})
	.attr('class','arrow-up')
	.on('click',function() {sortit(this,fp_dataset,30)});
	;
*/

   tb.append('tbody')
  //    .on('wheel', function() {d3.event.preventDefault(); (d3.event.deltaY <0) ? disp_table(r-1,c) : disp_table(r+1,c);  })
	  .selectAll("tr") 
	  .data(pc)
	  .enter()
      .append('tr')

	  .attr('class',function(d,i) {
	      if (i % 3 == 0)
		  {  
		   if (temp_rc == 'darkrow')
		    temp_rc = 'lightrow'
			else  
			temp_rc = 'darkrow'; 
		  }

		  return temp_rc;
		  })
	  .selectAll("td") 
	  .data(function(d){return d})
	  .enter()	  
      .append('td')	  
	  //.on('click',function(d,i) {xx_fprpt(this,i)})
	  .style('padding','4px')	  
	  .style('cursor','pointer')	  	  
	  .style('text-align',function(d,i) {return 'center'})	  
      .text(function(d,i) {return (i==0)? d.replace('_','') :  d});


var tb = div.append('table')
 .attr('id','fpcontlist')
 .style('margin','auto')
 .style('font-size','12px')
 .style('border','double 6px') 
 .style('background','#d3d3d3')
 .style('box-shadow','0px 0px 0px 2px black, 20px 20px 50px #888888')
 .attr('class','pbTable');
	  
 var thead = tb.append('thead');
   var t =thead.append('tr')
		t.append('th')
		.attr('colspan',cntr_hdr.length-5)
		.style('text-align','center')
		.text('Container Level Information');
		t.append('th')
		.attr('colspan',cntr_hdr.length-5)
		.style('text-align','center')
		.text('Container Scan Information');
	var hdrcell = thead.append('tr')
	 .selectAll('th')
	  .data(cntr_hdr)
	 .enter()
	 .append('th')
	 .style('position','relative')
	 .text(function(d) {return d.replace(/_/g,' ')});
   var btr = tb.append('tbody')
  //    .on('wheel', function() {d3.event.preventDefault(); (d3.event.deltaY <0) ? disp_table(r-1,c) : disp_table(r+1,c);  })
	  .selectAll("tr") 
	  .data(cntr)
	  .enter()
      .append('tr')

	  .attr('class',function(d,i) {
	      if (i % 3 == 0)
		  {  
		   if (temp_rc == 'darkrow')
		    temp_rc = 'lightrow'
			else  
			temp_rc = 'darkrow'; 
		  }

		  return temp_rc;
		  })
	  .selectAll("td") 
	  .data(function(d){return d})
	  .enter()	  
      .append('td')	  
	  //.on('click',function(d,i) {xx_fprpt(this,i)})
	  .style('padding','4px')	  
	  .style('cursor','pointer')	  	  
	  .style('text-align',function(d,i) {return 'center'})	  
      .text(function(d,i) {return  d});
	  if (cntr.length == 0)
	  {
	   btr.append('tr')
		.append('td')
		.attr('colspan',cntr_hdr.length)
		.style('text-align','center')
		.text('Orphan Handling Unit: This piece is not associated with any container-level induction information.');
	  }
	  
	  	

	  /*
       d3.select('body').call(d3.keybinding()
      .on('page-down', function() {
		  if (!d3.select('#datatable').empty())
		   {
		   d3.event.preventDefault(); if (r+c < cnt) disp_table(r+c,c);
		   }
		   })	  
	  .on('page-up', function() {
 		  if (!d3.select('#datatable').empty())
		  {
  		  d3.event.preventDefault(); (r-c < 0) ? disp_table(0,c) : disp_table(r-c,c);
	      }
		  })
	  .on('escape', function() {
 		  if (!d3.select('#datatable').empty())
		  {
            d3.select('#datatable').remove();  
			fp_dataset.length = 0;
	      }
		  })
		  
		  );	  
*/
//yyy

var tb = div.append('table')
 .attr('id','fptraylist')
 .style('margin','auto')
 .style('font-size','12px')
 .style('border','double 6px') 
 .style('background','#d3d3d3')
 .style('box-shadow','0px 0px 0px 2px black, 20px 20px 50px #888888')
 .attr('class','pbTable');
	  
 var thead = tb.append('thead');
   var t =thead.append('tr')
		t.append('th')
		.attr('colspan',tray_hdr.length)
		.style('text-align','center')
		.text('Tray Scan Information');
	var hdrcell = thead.append('tr')
	 .selectAll('th')
	  .data(tray_hdr)
	 .enter()
	 .append('th')
	 .style('position','relative')
	 .text(function(d) {return d.replace(/_/g,' ')});
   var btr = tb.append('tbody')
  //    .on('wheel', function() {d3.event.preventDefault(); (d3.event.deltaY <0) ? disp_table(r-1,c) : disp_table(r+1,c);  })
	  .selectAll("tr") 
	  .data(tray)
	  .enter()
      .append('tr')

	  .attr('class',function(d,i) {
	      if (i % 3 == 0)
		  {  
		   if (temp_rc == 'darkrow')
		    temp_rc = 'lightrow'
			else  
			temp_rc = 'darkrow'; 
		  }

		  return temp_rc;
		  })
	  .selectAll("td") 
	  .data(function(d){return d})
	  .enter()	  
      .append('td')	  
	  //.on('click',function(d,i) {xx_fprpt(this,i)})
	  .style('padding','4px')	  
	  .style('cursor','pointer')	  	  
	  .style('text-align',function(d,i) {return 'center'})	  
      .text(function(d,i) {return (i==0)? d.replace('_','') :  d});
	  


	  /*
       d3.select('body').call(d3.keybinding()
      .on('page-down', function() {
		  if (!d3.select('#datatable').empty())
		   {
		   d3.event.preventDefault(); if (r+c < cnt) disp_table(r+c,c);
		   }
		   })	  
	  .on('page-up', function() {
 		  if (!d3.select('#datatable').empty())
		  {
  		  d3.event.preventDefault(); (r-c < 0) ? disp_table(0,c) : disp_table(r-c,c);
	      }
		  })
	  .on('escape', function() {
 		  if (!d3.select('#datatable').empty())
		  {
            d3.select('#datatable').remove();  
			fp_dataset.length = 0;
	      }
		  })
		  
		  );	  
*/





//d3.select('body').node().focus();
 d3.select('#loader').remove();
 

}



	function fpcont_ret(res)
	{
       disp_fpcont(res,0,1)
		d3.select('#loader').remove();
	}


function fpcont(h,v)
{ 
 var td = v[0][0].getElementsByTagName('td');
 var imb = td[h.indexOf('IMB_CODE')].title;
 myLoader();
		var e=new TDF();
		e.setCallbackHandler(fpcont_ret);	
		e.setErrorHandler(area_data_err);
		e.getfpcont('<cfoutput>#opsvisdata#</cfoutput>',imb,fp_dtindv);
}


function open_pdf()
{
 window.open('ProcessingVisualization_ReportNotes.pdf');	
}

function vcnt(v)
{

  var x =document.getElementById(v).value;
  if (x != '')
   x = x.split(',').length
  else x=0;   
  return x	
}

function mhts_imb(f,t,a)
{

var tt = new Date();
var dt = new Date(a);
t = t.substr(1,20);
if (parseInt((tt-dt)/(1000*60*60*24)))
 x = 1
else x = '';
var h= "visMHTS_dlg.cfm?facility="+f+"&tracking="+t+'&all_days='+x;
window.open(h,null,'top=50,left=50,height=500,width=900,scrollbars=1,menubar=1,toolbar=1,resizable=yes' );
}



function mhts(f,idtag)
{
var h= "visMHTS_dlg.cfm?facility="+f+"&id_tag="+idtag;
window.open(h,null,'top=50,left=50,height=500,width=900,scrollbars=1,menubar=1,toolbar=1,resizable=yes' );
}


function csvfp_all()
{
 var bdy =  d3.select('body');
 bdy.selectAll('#outform').remove();
 var frm = bdy.append('form').attr('id','outform').attr('name','outform').attr('action','vis10csv.cfm').attr('method','post');
 frm.append('input').attr('type','hidden').attr('name','dsn').attr('value','<CFOUTPUT>#opsvisdata#</CFOUTPUT>');
 frm.append('input').attr('type','hidden').attr('name','rluvp').attr('value','1'); 
 frm.append('input').attr('type','hidden').attr('name','selDir').attr('value',function () {return getEleVal('selDir')});  
 frm.append('input').attr('type','hidden').attr('name','selEod').attr('value',function () {return getEleVal('selEod')});  
 frm.append('input').attr('type','hidden').attr('name','selDOW').attr('value',function () {return getEleVal('selDOW')});   
 frm.append('input').attr('type','hidden').attr('name','bg_date').attr('value',function () {return getEleVal('selfpdate')});   
 frm.append('input').attr('type','hidden').attr('name','ed_date').attr('value','');    
 frm.append('input').attr('type','hidden').attr('name','selArea').attr('value',function () {return getEleVal('selArea')});    
 frm.append('input').attr('type','hidden').attr('name','selDistrict').attr('value',function () {return getEleVal('selDistrict')});     
 frm.append('input').attr('type','hidden').attr('name','selClass').attr('value',function () {return getEleVal('selClass')});      
 frm.append('input').attr('type','hidden').attr('name','selCategory').attr('value',function () {return getEleVal('selCategory')});       
 frm.append('input').attr('type','hidden').attr('name','selFSS').attr('value',function () {return getEleVal('selFSS')});        
 frm.append('input').attr('type','hidden').attr('name','selMode').attr('value',function () {return getEleVal('selMode')});         
 frm.append('input').attr('type','hidden').attr('name','selAir').attr('value',function () {return getEleVal('selAir')});        
 frm.append('input').attr('type','hidden').attr('name','selCntrLvl').attr('value',function () {return getEleVal('selCntrLvl')});         
 frm.append('input').attr('type','hidden').attr('name','selCert').attr('value',function () {return getEleVal('selCert')});     
 frm.append('input').attr('type','hidden').attr('name','selPol').attr('value',function () {return getEleVal('selPol')});  
 frm.append('input').attr('type','hidden').attr('name','selHybStd').attr('value',function () {return getEleVal('selHybStd')});  
 frm.append('input').attr('type','hidden').attr('name','sortby').attr('value','');   
 frm.append('input').attr('type','hidden').attr('name','selDOW').attr('value',function () {return getEleVal('selDOW')}); 
 frm.append('input').attr('type','hidden').attr('name','selFacility').attr('value',function () {return getEleVal('selFacility')});  
 frm.append('input').attr('type','hidden').attr('name','selRange').attr('value',function () {return getEleVal('selRange')}); 
 frm.append('input').attr('type','hidden').attr('name','selMailer').attr('value',function () {return getEleVal('selMailer')});  
 frm.append('input').attr('type','hidden').attr('name','selImbZip3').attr('value',function () {return getEleVal('selfpzip3')});  
 frm.append('input').attr('type','hidden').attr('name','selOrgFac').attr('value',function () {return getEleVal('selfporg3')});   
 frm.append('input').attr('type','hidden').attr('name','selEntType').attr('value',function () {return getEleVal('selEntType')});    
 frm.append('input').attr('type','hidden').attr('name','selInduct').attr('value',function () {return getEleVal('selInduct')}); 
 frm.append('input').attr('type','hidden').attr('name','selState').attr('value',function () {return getEleVal('selState')});           
 frm.append('input').attr('type','hidden').attr('name','selUR').attr('value',function () {return getEleVal('selUR')});            
 frm.append('input').attr('type','hidden').attr('name','selurbk').attr('value',function () {return getEleVal('selurbk')});             
 frm.append('input').attr('type','hidden').attr('name','selDestnFac').attr('value',function () {return getEleVal('selDestnFac')});              
 document.outform.submit();
 bdy.selectAll('#outform').remove();
}
	
function sortit(t,db,r)
{
 var asc = t.id.substr(0,7)=='uparrow'; 	
 var cell =  t.id.substr(t.id.indexOf('-')+1);
 var totals =  (cell > 5000)
 db.sort(function(a,b)
  {
if (totals)
 {
	var namea = addit(a,cell);
	var nameb = addit(b,cell);
 }
else
{
	var namea = a[cell];
	var nameb = b[cell];	
}
    if (namea == 'notfound')
	 return 1;
    if (nameb == 'notfound')
	 return -1;

	if (asc)
	 {
    	if (namea < nameb) return-1;
 	 	if (namea > nameb) return 1;  
	 } else
	 {
    	if (namea > nameb) return-1;
 	 	if (namea < nameb) return 1;  
	 }	 
	return 0;
  })
if (d3.select('#datatable2').empty())  
 disp_table(0,r)
else   
 disp_table2(0,r);
}

	
	
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
		svg.append('text').text(config.msg).attr('fill','#FFF').style('font-size','18px').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps').style('font-weight','bold').attr('textLength',180);
				
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
		svg.append('text').text(config.msg).attr('fill','#FFF').style('font-size','18px').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps').style('font-weight','bold').attr('textLength',180);
				
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
/*
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
	*/
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
			d3.select('#RAll').style('color','silver');
		else
			d3.select('#RAll').style('color','blue');
		
		cfrm_sub();
	}
	
	var loadCnt=19;
	
	function streamLineChart(res,paramId,contId,chartId,cTitle,loaderId,range)
	{	
        var maxRows = 10;    
		var len=res.length;
		var selParam = d3.select('#'+paramId).node().value;
		if(loadCnt > 0 && selParam != '')
		{
			res.forEach( function(d,i) {if(selParam.search(d[0])>=0){range = len-i-1;}})
			
			if (range == undefined){d3.select('#'+paramId).node().value=''; cfrm_sub()}
		}


		if(!range || res.length < 11)
			range=0;
		else if(res.length - range < 10)
		{
			range = res.length-10;
		}
		else if(res.length - range >= res.length)
		{
			range = 0;
		}

		loadCnt--;
		if(loadCnt <=0)
		{
			d3.select('#'+loaderId).remove();
			if (ReqId > 0)
			 d3.select('#undobtn').node().disabled = false
			else
			  d3.select('#undobtn').node().disabled = true;
		}
		
		
		
		var w = 350;
		var h = 350;
		var padding = 50;
		
		var high = d3.max(res,function(d){return d[2];});
		var low = 0;//d3.min(res,function(d){return d[2];});
		var diff=high-low;
		
		var mult=res.length/10;
		//Create scale functions
		yScale = d3.scale.ordinal().rangeBands([h - padding, padding]);


		xScale = d3.scale.linear()
			 .domain([0,1])
			 .range([padding, w - padding]);
			 
		xScale2 = d3.scale.linear()
			 .domain([low,high])
			 .range([padding, w - padding]);
							 
		var	cScale = d3.scale.linear().domain([0,0.7,1]).range(["#700","#C00","#0C0"]);	
		var	cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range(["#EC9792","#EC9792","#FDBB9B","#FDBB9B","#fee090","#fee090","#91bfdb","#91bfdb","#7C9FCE","#7C9FCE"]);	

		var perF = d3.format('.1%');
		var sigF = d3.format('.3g');
		var comF = d3.format(',');
		var siF = d3.format('.3s');
		  
       function pdg(v)
	   {
	    var s='';
		for (var i=0;i<v;i++)
		{
		 s+=String.fromCharCode(160);	
		}
		return s;
	   }

		var order = [];
		var holdData = res.slice(0);
		res = res.slice(Math.max(res.length-10-range,0),res.length-range);
		res.forEach(function(d,i){order.push(d[1]+pdg(i))});

		yScale.domain(order);
		
		var formatAsPercentage = d3.format("%");

		//Define X axis
		var yAxis = d3.svg.axis()
						  .scale(yScale)
						  .orient("right");


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

		var rdiv = (h-(padding*2))/((res.length<10)?res.length:10)/2;
		var rw = 210/((res.length<10)?res.length:10);
		
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
					if(len-rng < 10)
						rng = len-10;
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
					if(len-rng < 10)
						rng = len-10;
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
			
			
					svg.select('#magnifier')
			.on('click',(function(AR,pID,cID,chID,title,LID,rng){
				return function doSe(){
					d3.select('#searchBlock').style('display','').style('top',window.innerHeight/3+window.pageYOffset+'px');
					d3.select('#searchTarget').node().value='';
					d3.select('#searchTarget').node().focus();
					d3.select('#commitSearch').on('click',function(){					
						d3.select("#searchBlock").style("display","none");
                        var n=d3.select('#'+pID).node();
						var nar = [];
						var targetSearch=d3.select('#searchTarget').node().value.toUpperCase();
						var len = AR.length;
						AR.forEach(function(d,i){
			               if(chID != 'svgMailer')
						   {    
							if(d[1].search(targetSearch)>=0)
								rng=len-i-1;
						   }
						    else
						   {
							 if(d[1].search(targetSearch)==0 && targetSearch != "")
                               nar.push("'"+d[0]+"'"); 

						   }
							
						})
                   	 if (chID == 'svgMailer') 
					  {
   				      n.value =  nar.toString();
  					  if (n.value != '') 						 
						  {
						  selMlrFlg.value ='Y';
						  cfrm_sub();
						  }
					  }
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
			  .append("g")
				.attr("transform", "translate(" + 0 + "," + 0 + ")")
				.call(zoom);	
			
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
//			.text(function() { return (paramId == 'selMailer' && vcnt(paramId) == 1) ? cTitle+' CSA' :  cTitle})
            .text(cTitle)
			.style('font-weight','bold')
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

<!--- --->
/* if (paramId == 'selMailer')
 {
			svg.append("g").attr('id','csaicon')
			.on('click',function() {d3.select('#csatable').style('display','')})
			.on('mouseover',function(){d3.select(this).style('cursor','pointer').select('path').attr('stroke','blue');})
			.on('mouseout',function(d,i){d3.select(this).style('cursor','').select('path').attr('stroke','silver');})
			.attr('transform','translate('+(w-padding-40)+' '+(7)+')')
			.append("path")
			.attr('d',"M22,14H10c-1.105,0-2,0.895-2,2s0.895,2,2,2h12c1.105,0,2-0.895,2-2 S23.105,14,22,14z M22,21H10c-1.105,0-2,0.895-2,2s0.895,2,2,2h12c1.105,0,2-0.895,2-2S23.105,21,22,21z M22,7H10 C8.895,7,8,7.895,8,9s0.895,2,2,2h12c1.105,0,2-0.895,2-2S23.105,7,22,7z M29,0H3C1.343,0,0,1.343,0,3v26c0,1.657,1.343,3,3,3h26 c1.657,0,3-1.343,3-3V3C32,1.343,30.657,0,29,0z M28,27c0,0.552-0.448,1-1,1H5c-0.552,0-1-0.448-1-1V5c0-0.552,0.448-1,1-1h22 c0.552,0,1,0.448,1,1V27z")
			.attr('fill','silver')
			.attr('transform','scale(0.5,0.5)') 
 }
 */
 //zzz
 if (paramId == 'selMailer')
 {
			svg.append("g").attr('id','csaicon')
			.on('click',function() {d3.select('#csatable').style('display','')})
			.on('mouseover',function(){d3.select(this).style('cursor','pointer').select('text').style('text-decoration','underline');})
			.on('mouseout',function(d,i){d3.select(this).style('cursor','').select('text').style('text-decoration','none');})
			.attr('transform','translate('+(w-padding-45)+' '+(17)+')')
			.append("text")
			.text('csa')
			.style("text-anchor", "start").style('font-size','14px').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps')			
			.attr('fill','blue');
 }

<!--- --->



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
						//.attr("x", w-padding)
						//.attr("width", 9)
					})
					.on("mouseout",function(){d3.select(this).transition()
						.style("fill", "url(#shadeV)")
						//.attr("x", w-padding)
						//.attr("width", 5)
					});
	
			if(len<=maxRows){
				d3.select('#'+contId).select("#scroll-rect").style('display','none');
				d3.select('#'+contId).select("#scroll-track").style('display','none');
			}


<!------>

		}
		
		if(holdData.length <= 11)
			svg.select('#magnifier').style('display','none');
		else
			svg.select('#magnifier').style('display','');
        
		if (vcnt('selMailer') ==1 && d3.select('#selClass').node().value == "'1'" && csa_dataset.length > 0)
           svg.select('#csaicon').style('display','')
		else 
 		 svg.select('#csaicon').style('display','none');
		
		
		//var rdiv = (h-(padding*2))/((res.length<11)?res.length:11)/2;
		//var rw = 210/((res.length<11)?res.length:11);


		
		var fdb=container
			   .selectAll(".failDropBars")
			   .data(res);
			   
		fdb.enter()
			   .append("rect")
				.attr("class", function(d,i) { return "failDropBars r"+i;})
			   .attr("x", function(d,i) { return xScale2(d[2]);})
			   .attr("y", function(d,i) { return yScale(d[1]+pdg(i))+rdiv-rw/2+2;})
			   .attr("width", 1)
			   .attr("height",function(d,i) { return Math.abs(h-padding-yScale(d[1]+pdg(i))+rdiv-rw/2+2);} )
			   .attr("fill",  'silver')
			   .attr("opacity", 0.25);
			   
		fdb.transition().duration(500).attr("class", function(d,i) { return "failDropBars r"+i;})
			   .attr("x", function(d,i) { return xScale2(d[2]);})
			   .attr("y", function(d,i) { return yScale(d[1]+pdg(i))+rdiv-rw/2+2;})
			   .attr("width", 1)
			   .attr("height",function(d,i) { return Math.abs(h-padding-yScale(d[1]+pdg(i))+rdiv-rw/2+2);} )
			   .attr("fill",  'silver')
			   .attr("opacity", 0.25);
			   
		//fdb.transition();

		fdb.exit().transition().remove();
		
		var fpie=container
			   .selectAll(".failPie")
			   .data(res);
			   
		var tle =fpie.enter()
			   .append("rect")
				.attr("class", "failPie")
			   .attr("x", function(d,i) { return xScale2(low);})
			   .attr("y", function(d,i) { return yScale(d[1]+pdg(i))+rdiv-rw/2+2;})
			   .attr("width", function(d) {return Math.abs(xScale2(d[2])-xScale2(low));})
			   .attr("height", rw-4)
			   .attr("fill", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';})
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
			   .append('title');
//			   .text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
/*		tle.append("tspan").attr('display','block').text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
		tle.append("tspan").attr('display','block').text(function(d) {return 'Total Pieces: '+comF(d[4]);})
		tle.append("tspan").attr('display','block').text(function(d) {return 'Percent: '+perF(d[3]);})	*/
		
		fpie.transition().duration(500).attr("x", function(d,i) { return xScale2(low);})
			   .attr("y", function(d,i) { return yScale(d[1]+pdg(i))+rdiv-rw/2+2;})
			   .attr("width", function(d) {return Math.abs(xScale2(d[2])-xScale2(low));})
			   .attr("height", rw-4)
			   .attr("fill", function(d) {if(selParam == '' || selParam.search("'"+d[0]+"'")>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';});
			   
		var tle = fpie.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
			   .select('title');
//			   .text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
		tle.selectAll('tspan').remove();	
		tle.append("tspan").text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
		tle.append("tspan").text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})
		tle.append("tspan").text(function(d) {return '\nPercent: '+perF(d[3]);})	
			   
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
			   .attr("height",function(d,i) { return Math.abs(yScale(d[1]+pdg(i))+rdiv-padding);})
			   .attr("fill", 'silver')
			   .attr("opacity", 0.25);
		
		pdb.transition().duration(500).attr("class", function(d,i) { return "perDropBars c"+i;})
			   .attr("x", function(d,i) {	return xScale(d[3])-0.5;})
			   .attr("y", padding)
			   .attr("width", 1)
			   .attr("height",function(d,i) { return Math.abs(yScale(d[1]+pdg(i))+rdiv-padding);})
			   .attr("fill", 'silver')
			   .attr("opacity", 0.25);
			   
		//pdb.transition();

		pdb.exit().transition().remove();
		
		var fpc=container
			   .selectAll(".failPer")
			   .data(res);
			   
		tle = fpc.enter()
			   .append("circle")
				.attr("class", "failPer")
			   .attr("cx", function(d,i) {	return xScale(d[3]);})
			   .attr("cy", function(d,i) { return yScale(d[1]+pdg(i))+rdiv;})
			   .attr("r", 5)
			   .attr("stroke", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale(d[3]);return 'white'; })
			   .attr("stroke-width", 2)
			   .attr("fill", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';})
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',0.25).attr('stroke','');})
			   .append('title');
//			   .text(function(d) {return 'Percent: '+perF(d[3])+'\nTotal Pieces: '+comF(d[4]);})
		
		fpc.transition().duration(500).attr("class", "failPer")
			   .attr("cx", function(d,i) {	return xScale(d[3]);})
			   .attr("cy", function(d,i) { return yScale(d[1]+pdg(i))+rdiv;})
			   .attr("r", 5)
			   .attr("stroke", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale(d[3]);return 'white'; })
			   .attr("stroke-width", 2)
			   .attr("fill", function(d) {if(selParam == '' || selParam.search(d[0])>=0)return cScale2(Math.floor(d[3]*100)/100);return 'silver';});
			   
		tle = fpc.on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d){updateGraphs(d[0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .perDropBars').filter(".c"+i).attr('opacity',0.25).attr('stroke','');})
			   .select('title');
//			   .text(function(d) {return 'Percent: '+perF(d[3])+'\nTotal Pieces: '+comF(d[4]);})
			   
		tle.selectAll('tspan').remove();	
		tle.append("tspan").text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
		tle.append("tspan").text(function(d) {return '\nTotal Pieces: '+comF(d[4]);})
		tle.append("tspan").text(function(d) {return '\nPercent: '+perF(d[3]);})	



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
				.selectAll('text').attr('fill','#darkblue').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps').style('font-weight','bold')
			   .on('mouseover',function(d,i){d3.select(this).attr('opacity',0.5).style('cursor','pointer');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',1).attr('stroke','cyan');})
			   .on('click',function(d,i){updateGraphs(res[i][0],paramId)})//id
			   .on('mouseout',function(d,i){d3.select(this).attr('opacity',1).style('cursor','');d3.selectAll('#'+chartId+' .failDropBars').filter(".r"+i).attr('opacity',0.25).attr('stroke','');})
			   .append('title')
			   .text(function(d,i) {return 'Failed Pieces: '+comF(res[i][2]);});
			   
			   svg.append("text")
			.attr("class", "y label")
			.attr("x", w-padding)
			.attr("y", padding/3)
			.text('Reset').style('font-weight','bold').style('font-size','10px').style('text-decoration','underline').style('cursor','pointer').style('font-variant','small-caps').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif')
			.attr('fill',function(){if(selParam == '')return 'silver';return 'blue'})
			.attr('id','resetLink')
			.on('click',function(){d3.select('#'+paramId).node().value=''; if (paramId == 'selMailer') d3.select('#'+'selMlrFlg').node().value='N'; cfrm_sub();});
			
		}
		else
		{
			var Ytext=svg.select('.y.axis').call(yAxis).selectAll('text');
			Ytext.selectAll('title').remove();
			Ytext.attr('fill','#darkblue').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps').style('font-weight','bold')
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
	
	}
	
	function Area_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		chartHistory[rp].Area_Chart=(function(data,v){
		return function(){
				d3.select('#selArea').node().value=v;
				streamLineChart(data,'selArea','chart-Area','svgArea','Area','loader');
			}
		})(res,d3.select('#selArea').node().value)

		if(ReqId != rp)
			return;

		streamLineChart(res,'selArea','chart-Area','svgArea','Area','loader');
	}
	
	
	function District_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].District_Chart=(function(data,v){
		return function(){
				d3.select('#selDistrict').node().value=v;
  			streamLineChart(data,'selDistrict','chart-District','svgDistrict','District','loader');		
			}
		})(res,d3.select('#selDistrict').node().value)

		
 	if(ReqId != rp)
			return;
	
		streamLineChart(res,'selDistrict','chart-District','svgDistrict','District','loader');		
	}

	function Facility_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].Facility_Chart=(function(data,v){
		return function(){
				d3.select('#selFacility').node().value=v;
			streamLineChart(data,'selFacility','chart-Facility','svgFacility','Facility','loader');		
			}
		})(res,d3.select('#selFacility').node().value)

		
 	if(ReqId != rp)
			return;
		
		streamLineChart(res,'selFacility','chart-Facility','svgFacility','Facility','loader');		
	}


	function Mailer_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].Mailer_Chart=(function(data,v){
		return function(){
				d3.select('#selMailer').node().value=v;
			streamLineChart(data,'selMailer','chart-Mailer','svgMailer','Mailer','loader');		
			}
		})(res,d3.select('#selMailer').node().value)

		
 	if(ReqId != rp)
			return;
		
		streamLineChart(res,'selMailer','chart-Mailer','svgMailer','Mailer','loader');		
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
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].Class_Chart=(function(data,v){
		return function(){
				d3.select('#selClass').node().value=v;
		streamLineChart(data,'selClass','chart-Class','svgClass','Mail Class','loader');		
			}
		})(res,d3.select('#selClass').node().value)

		
 	if(ReqId != rp)
			return;
		
		streamLineChart(res,'selClass','chart-Class','svgClass','Mail Class','loader');		
	}

	function Cntr_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].Cntr_Chart=(function(data,v){
		return function(){
				d3.select('#selCntrLvl').node().value=v;
		streamLineChart(data,'selCntrLvl','chart-Cntr','svgCntr','Container Level','loader');		
			}
		})(res,d3.select('#selCntrLvl').node().value)

		
 	if(ReqId != rp)
			return;
		
		streamLineChart(res,'selCntrLvl','chart-Cntr','svgCntr','Container Level','loader');		
	}


	function trend_Chart(res)
	{	
      if (res[1].length != 5 ) 
	  {
		trendCnt += 1;
	  }
	 else
	 {  
       var rp = res.pop()[0]; 
	   if(ReqId != rp || res.length==1)
			return;
	   if (trendId != ReqId)
	    {
	 	    trendDataset.length=0;
			trendId=ReqId;
			trendCnt = 0;
		}
       trendCnt += 1;    		
   	   res.shift();
	   if (res[0])   		
	   trendDataset.push(res[0]);
	 }//else
//       if (trendDataset.length == 8 || getEleVal('selRange') != 'WEEK')
       if (trendCnt == 8 || getEleVal('selRange') != 'WEEK')
	   {
	      trendDataset.sort(function(a,b)
		  {
			  // return d3.ascending(a[0], b[0]);
			   return new Date(a[0])-new Date(b[0]);
//			  	var namea = a[0];
//                var nameb = b[0];	
//			   	if (namea < nameb) return-1;
//             	if (namea > nameb) return 1;  
		  });
	   Load_Trend_Graph(trendDataset); 
	   trendCnt = 0;
	   }

	}


	
	function Cat_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].Cat_Chart=(function(data,v){
		return function(){
				d3.select('#selCategory').node().value=v;
		streamLineChart(data,'selCategory','chart-Shape','svgShape','Mail Shape','loader');		
			}
		})(res,d3.select('#selCategory').node().value)

		
 	if(ReqId != rp)
			return;
		
		streamLineChart(res,'selCategory','chart-Shape','svgShape','Mail Shape','loader');		
	}
	
	function EOD_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].EOD_Chart=(function(data,v){
		return function(){
				d3.select('#selEod').node().value=v;
		streamLineChart(data,'selEod','chart-EOD','svgEOD','Entry','loader');		
			}
		})(res,d3.select('#selEod').node().value)

		
 	if(ReqId != rp)
			return;
		
		streamLineChart(res,'selEod','chart-EOD','svgEOD','Entry','loader');		
	}
	
	function SVCSTD_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].SVCSTD_Chart=(function(data,v){
		return function(){
				d3.select('#selHybStd').node().value=v;
		streamLineChart(data,'selHybStd','chart-SVCSTD','svgSVCSTD','Svc. Std.','loader');		
			}
		})(res,d3.select('#selHybStd').node().value)

		
 	if(ReqId != rp)
			return;
		
		streamLineChart(res,'selHybStd','chart-SVCSTD','svgSVCSTD','Svc. Std.','loader');		
	}

	function Air_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].Air_Chart=(function(data,v){
		return function(){
				d3.select('#selAir').node().value=v;
		streamLineChart(data,'selAir','chart-Air','svgair','Air/Surface','loader');		
			}
		})(res,d3.select('#selAir').node().value)
 	if(ReqId != rp)
			return;
		
		streamLineChart(res,'selAir','chart-Air','svgair','Air/Surface','loader');		
	}

	function FSS_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].FSS_Chart=(function(data,v){
		return function(){
				d3.select('#selFSS').node().value=v;
		streamLineChart(data,'selFSS','chart-FSS','svgFSS','FSS','loader');		
			}
		})(res,d3.select('#selFSS').node().value)
 	if(ReqId != rp)
			return;
		
		streamLineChart(res,'selFSS','chart-FSS','svgFSS','FSS','loader');		
	}

	function zip3_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].zip3_Chart=(function(data,v){
		return function(){
				d3.select('#selImbZip3').node().value=v;
		streamLineChart(data,'selImbZip3','chart-zip3org','svgzip3','Destination Zip3','loader');		
			}
		})(res,d3.select('#selImbZip3').node().value)
 	if(ReqId != rp)
			return;		
			
		streamLineChart(res,'selImbZip3','chart-zip3org','svgzip3','Destination Zip3','loader');		
	}

	function orgfac_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].orgfac_Chart=(function(data,v){
		return function(){
				d3.select('#selOrgFac').node().value=v;
		streamLineChart(data,'selOrgFac','chart-zip3org','svgorg','Origin Facility','loader');		
			}
		})(res,d3.select('#selOrgFac').node().value)
 	if(ReqId != rp)
			return;		
		
		streamLineChart(res,'selOrgFac','chart-zip3org','svgorg','Origin Facility','loader');		
	}


	function pol_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].pol_Chart=(function(data,v){
		return function(){
				d3.select('#selPol').node().value=v;
		streamLineChart(data,'selPol','chart-pol','svgpol','Political Mailing','loader');		
			}
		})(res,d3.select('#selPol').node().value)
 	if(ReqId != rp)
			return;		
		
		streamLineChart(res,'selPol','chart-pol','svgpol','Political Mailing','loader');		
	}

	function enttype_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].enttype_Chart=(function(data,v){
		return function(){
				d3.select('#selEntType').node().value=v;
		streamLineChart(data,'selEntType','chart-enttype','svgenttype','Entry Mode','loader');		
			}
		})(res,d3.select('#selEntType').node().value)
 	if(ReqId != rp)
			return;		
		
		streamLineChart(res,'selEntType','chart-enttype','svgenttype','Entry Mode','loader');		
	}

	function induct_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].induct_Chart=(function(data,v){
		return function(){
				d3.select('#selInduct').node().value=v;
		streamLineChart(data,'selInduct','chart-induct','svginduct','Induction Method','loader');		
			}
		})(res,d3.select('#selInduct').node().value)
 	if(ReqId != rp)
			return;		
		
		streamLineChart(res,'selInduct','chart-induct','svginduct','Induction Method','loader');		
	}

	function ur_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].ur_Chart=(function(data,v){
		return function(){
				d3.select('#selUR').node().value=v;
		streamLineChart(data,'selUR','chart-ur','svgur','Urban/Rural','loader');		
			}
		})(res,d3.select('#selUR').node().value)
 	if(ReqId != rp)
			return;		
		
		streamLineChart(res,'selUR','chart-ur','svgur','Urban/Rural','loader');		
	}

	function urbk_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].urbk_Chart=(function(data,v){
		return function(){
				d3.select('#selurbk').node().value=v;
		streamLineChart(data,'selurbk','chart-urbk','svgurbk','Urban/Rural Analysis','loader');		
			}
		})(res,d3.select('#selurbk').node().value)
 	if(ReqId != rp)
			return;		
		
		streamLineChart(res,'selurbk','chart-urbk','svgurbk','Urban/Rural','loader');		
	}



	function state_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].state_Chart=(function(data,v){
		return function(){
				d3.select('#selState').node().value=v;
		streamLineChart(data,'selState','chart-state','svgstate','States','loader');		
			}
		})(res,d3.select('#selState').node().value)
 	if(ReqId != rp)
			return;		
		
		streamLineChart(res,'selState','chart-state','svgstate','States','loader');		
	}


	function fullsvc_Chart(res)
	{	
        var rp = res.pop()[0];  
		res.shift();
		res=res.reverse();
		chartHistory[rp].fullsvc_Chart=(function(data,v){
		return function(){
				d3.select('#selCert').node().value=v;
		streamLineChart(data,'selCert','chart-fullsvc','svgfullsvc','Full Service','loader');		
			}
		})(res,d3.select('#selCert').node().value)
 	if(ReqId != rp)
			return;		
		
		streamLineChart(res,'selCert','chart-fullsvc','svgfullsvc','Full Service','loader');		
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

    function gettrdate(sd,srng,i)
	{
	  if (srng == 'WEEK')
	  {
		var d = new Date(sd);
	    d.setDate(d.getDate()-(7*i)); 
        d=(d.getMonth()+1) +'/' + d.getDate()+'/'+d.getFullYear();
		return d
	  }
	  if (srng == 'MON' || srng == 'QTR')
	  {
		var d = new Date(sd);
		if (srng=='QTR') d.setMonth(d.getMonth()+3);
	    d.setMonth(d.getMonth()-(i)); 
          
        d=(d.getMonth()+1) +'/' + d.getDate()+'/'+d.getFullYear();
		return d
	  }
	  	
		
		
		
	}
	

	function get_val(v)
	{
	 var sel=document.getElementById(v);
	 return sel.options[sel.selectedIndex].value; 
	}

	function get_ur(v,d)
	{
	 var sel=document.getElementById(v);
	 var ar = sel.value.split(',');
	 var p = (d=='O') ? 2 : 1;
	 for (i=0;i<ar.length;i++)
	 ar[i] = ar[i].replace(ar[i].charAt(p),'');
	 
	 return ar.toString();
	}



	function getEleVal(v)
	{
	 return document.getElementById(v).value
	}

	function cfrm()
	{
    listSelections();		
	document.getElementById("subtn").style.border = 'Red 4px solid';
   if (document.getElementById("selDir").value == 'O' && !d3.select('#svgorg').empty())
	  {
   	   d3.select('#svgorg').remove();
	   newdiropt = true
//	   resetAll();
	  }
   if (document.getElementById("selDir").value == 'D' && !d3.select('#svgzip3').empty())	 
	  {
  	   d3.select('#svgzip3').remove();
   	   newdiropt = true
//	   resetAll();
	  }
    ReqId=-1;
	chartHistory.length=0;
	chartHistory[0] ={};
    getdatethru();        
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
function keybindt2(r,c,cnt)
{
	       d3.select('body').call(d3.keybinding()
      .on('page-down', function() {
		  if (!d3.select('#datatable').empty())
		   {
		   d3.event.preventDefault(); if (r+c < cnt) disp_table(r+c,c);
		   }
		   })	  
	  .on('page-up', function() {
 		  if (!d3.select('#datatable').empty())
		  {
  		  d3.event.preventDefault(); (r-c < 0) ? disp_table(0,c) : disp_table(r-c,c);
	      }
		  })
	  .on('escape', function() {
 		  if (!d3.select('#datatable').empty())
		  {
            d3.select('#datatable').remove();  
	      }
		  })
		  
		  );	  
}


function inpkeypress(t,event,i)
{
	
if (event.charCode == 13)
if (t.value == '')
 disp_table2(0,30,'','')
else 
 disp_table2(0,30,t,i);
}

function toUnique(a,b,c){//array,placeholder,placeholder
b=a.length;
while(c=--b)while(c--)a[b]!==a[c]||a.splice(c,1);
return a // not needed ;)
}



function column_search(d,i)
{

var a = [];
var col = d.cellIndex;
for (var i = 0;i<fp_datasetindv.length;i++)
 {
	if (fp_datasetindv[i][col] != '')
	a.push(fp_datasetindv[i][col]);
 }
a = toUnique(a);
a.sort();
a.unshift(' ');
var inp = d3.select(d)
var hold =  inp.node().onclick;
if (inp.node().style.color=='yellow')
{
 disp_table2(0,30,'','');
 return true;	
}
d3.select('#filtersel').remove();

var sel = inp.append('select');
sel
.attr('id','filtersel')
.style('class','slct')
.style('margin-bottom','10px')
.on('change',function () {disp_table2(0,30,this.value,col)})
.on('mousedown', function() {d3.event.stopPropagation()})
;
var options = sel
.selectAll('option')
.data(a).enter()
.append('option')
.attr('value',function(d) {return d})
.text(function(d) {return String(d).replace(/_/,'')});


inp.on('click',null);
sel.node().focus();
}



var t2zoom=1;
function disp_table2(r,c,tv,col)
{
d3.select('#zip3table').style('display','none');	
cmaf = d3.format(',');
dtf = d3.format('%m/%d/%/%Y');
perf = d3.format('.1%');
var cnt = fp_datasetindv.length;	

var imb = fp_hdrindv.indexOf('IMB_CODE');
var stc = fp_hdrindv.indexOf('START_THE_CLOCK_DATE');
var fzc = fp_hdrindv.indexOf('FAC_ZIP_CODE');
var tag = fp_hdrindv.indexOf('ID_TAG');
var imcb = fp_hdrindv.indexOf('IMCB_CODE');

if (tv && tv != '')
{
var test = fp_datasetindv.filter(function(d) { if (String(d[col]).substr(0,tv.length).toUpperCase() == tv.toUpperCase()) return d})	;
}


if (r<0) r=0;
if (cnt-c < r) r=cnt-c;
if (test)
 res = test.slice(r,c+r);      
else
 res = fp_datasetindv.slice(r,c+r);      


var temp_rc = 'darkrow';	

   var div = d3.select('#fptable');
   // div.call(d3.behavior.drag().on("drag", move));
   div.call(d3.behavior.drag().on("drag", move).on("dragend",function () {d3.select('body').node().focus();}));	  
	div.style('display','');
	div.selectAll('#datatable2').remove();
	var tb = div.append('table')
 .style('transform','scale('+t2zoom+','+t2zoom+')')	
 .attr('id','datatable2')
 .style('font-size','12px')
 .style('border','double 6px') 
 .style('background','#fff')
 .style('box-shadow','0px 0px 0px 2px black, 20px 20px 50px #888888')
 .style('position','absolute')
 .attr('class','pbTable');


 var thead = tb.append('thead');
   thead.on('wheel', function() {d3.event.preventDefault();  (d3.event.deltaY <0) ? t2zoom += .02 : t2zoom -=.02; d3.select('#datatable2').style('transform','scale('+t2zoom+','+t2zoom+')')	}) 
   var t =thead.append('tr')
		.append('th')
		.attr('colspan',fp_hdrindv.length)
		t.append('input')
		.attr('type','button')
		.attr('value','X')
		.style('float','right')
		//.style('position','fixed')
		.on('click', function() {d3.select('#datatable2').remove(); keybindt2(r,c,cnt); d3.select('#zip3table').style('display',''); fp_datasetindv.length=0;});
		
		
		t.append('input')
		.attr('type','button')
		.attr('value','Excel')
		.style('float','left')		
		.on('click', function() {csvfp_all()});

		t.append('label')		
		.text('Use Mouse Wheel/Page-Up/Page-Down to scroll || Click on titles to filter')
		.style('float','left')
		.style('margin-left','6px');

 t =thead.append('tr')		
 		.append('th')
		.attr('colspan',fp_hdrindv.length);

		t.append('input')
		.attr('type','button')
		.attr('value','\u21e6')
		.style('float','left')
		.on('click', function() {if (col_start > 6) col_start-=1; disp_table2(r,c,tv,col)});

		t.append('input')
		.attr('type','button')
		.attr('value','\u21e8')
		.style('float','left')
		.on('click', function() {if (col_start < fp_hdrindv.length-7) col_start+=1; disp_table2(r,c,tv,col);});

		t.append('input')
		.attr('type','button')
		.attr('value','\u21e7')
		.style('float','left')
		.on('click', function() {(r-1 < 0) ? disp_table(0,c) : disp_table2(r-1,c,tv,col);});

		t.append('input')
		.attr('type','button')
		.attr('value','\u21e9')
		.style('float','left')
		.on('click', function() {if (r+1 < cnt) disp_table2(r+1,c,tv,col);});
 
 
 


var hdrcell = thead.append('tr')
.style('height','66px')
 .selectAll('th')
  .data(fp_hdrindv)
 .enter()
 .append('th')
 .style('position','relative')
 .on('click',function(d,i) {column_search(this,i)})
 .style('display',function(d,i) {return ((i > 5 && i < col_start ) || i > col_start+6 ) ? 'none' : ''})	 
 .style('border-width',function(d,i) {return (col_start> 6 && i==5) ? '1px 3px 1px 1px' : '1px 1px 1px 1px'})   
 .style('color',function(d,i) {return (i===col) ? 'yellow' : ''})	  
 .style('cursor','pointer')	   
 .style('width',function(d,i) {return (i==0) ? '30px' : ''})	  
 .html(function(d) {return d.replace(/_/g,'<br> ')});
 hdrcell
	.append('label')
	.attr('id',function(d,i) {return 'dnarrowfp-'+ i})
	.attr('class','arrow-down')
	.on('click',function() {sortit(this,fp_datasetindv,30)});
 hdrcell	
	.append('label')
	.attr('id',function(d,i) {return 'uparrowfp-'+ i})
	.attr('class','arrow-up')
	.on('click',function() {sortit(this,fp_datasetindv,30)});
	;
 

   var tby =tb.append('tbody')
     tby
      .on('wheel', function() {d3.event.preventDefault(); (d3.event.deltaY <0) ? disp_table2(r-1,c,tv,col) : disp_table2(r+1,c,tv,col);  })
	  .selectAll("tr") 
	  .data(res)
	  .enter()
      .append('tr')
	  .attr('class',function(d,i) {
		  if (i>0 && res[i][0] != res[i-1][0])
		   {
		   if (temp_rc == 'darkrow')
		    temp_rc = 'lightrow'
			else  
			temp_rc = 'darkrow'; 
		   }
		  return temp_rc;
		  })
	  .selectAll("td") 
	  .data(function(d){return d})
	  .enter()	  
      .append('td')	  
	  .style('cursor','pointer')	  
	  .style('padding','4px')	  
	  .style('text-align',function(d,i) {return (i==0) ? 'center' : 'center'})	  
	  .style('text-overflow','ellipsis')
	  .style('white-space','nowrap')	  
	 .style('display',function(d,i) {return ((i > 5 && i < col_start ) || i > col_start+6 ) ? 'none' : ''})	 
	 .style('border-width',function(d,i) {return (col_start> 6 && i==5) ? '1px 3px 1px 1px' : '1px 1px 1px 1px'})   
	  
//      .text(function(d,i) {return (d == null) ? '' : String(d).replace(/_/,'').substr(0,17) + ((String(d).length<18) ? '' : '...') })
      .text(function(d,i) {return (d == null) ? '' : String(d).replace(/_/,'') })	  
	  .attr('title',function(d,i) {return (d == null) ? '' : String(d).replace(/_/,'') }) 
	  .on('mouseover',function(d,i) {if (i== imcb || i== imb || (i==tag && d)) this.style.textDecoration='underline'})
	  .on('mouseout',function(d,i) {if (i== imcb || i== imb || (i==tag && d)) this.style.textDecoration=''})	  
	  .on('click',function(d,i) {
		  if (i == imb) 
		  mhts_imb(d3.select(this.parentNode).data()[0][fzc],d,d3.select(this.parentNode).data()[0][stc]);
         if (i == tag && d) 
		  mhts(d3.select(this.parentNode).data()[0][fzc],d);		  
         if (i == imcb) 
		  fpcont(fp_hdrindv,d3.select(this.parentNode));		  
	  })
	  ;
//.on('click',function() {if (col_start < hdr.length-7) col_start+=1; disp_table(r,c)});

       d3.select('body').call(d3.keybinding()
 	  .on('arrow-right', function() {
 		  if (!d3.select('#datatable2').empty())
		  {
  		  d3.event.preventDefault(); if (col_start < fp_hdrindv.length-7) col_start+=1; disp_table2(r,c,tv,col);
	      }
		  })
 	  .on('arrow-left', function() {
 		  if (!d3.select('#datatable2').empty())
		  {
  		  d3.event.preventDefault(); if (col_start > 6) col_start-=1; disp_table2(r,c,tv,col)
	      }
		  })
 	  .on('arrow-up', function() {
 		  if (!d3.select('#datatable2').empty())
		  {
  		  d3.event.preventDefault(); (r-1 < 0) ? disp_table(0,c) : disp_table2(r-1,c,tv,col);
	      }
		  })
      .on('arrow-down', function() {
		  if (!d3.select('#datatable2').empty())
		   {
		   d3.event.preventDefault(); if (r+1 < cnt) disp_table2(r+1,c,tv,col);
		   }
		   })	  
     .on('page-down', function() {
		  if (!d3.select('#datatable2').empty())
		   {
		   d3.event.preventDefault(); if (r+c < cnt) disp_table2(r+c,c,tv,col);
		   }
		   })	  
	  .on('page-up', function() {
 		  if (!d3.select('#datatable2').empty())
		  {
  		  d3.event.preventDefault(); (r-c < 0) ? disp_table2(0,c) : disp_table2(r-c,c,tv,col);
	      }
		  })
	  .on('escape', function() {
 		  if (!d3.select('#datatable2').empty())
		  {
            d3.select('#datatable2').remove();  d3.select('#zip3table').style('display','');
			fp_datasetindv.length=0;
     		keybindt2(r,c,cnt)
	      }
		  })
		  
		  );	  
		  
d3.select('body').node().focus();
 d3.select('#loader').remove();
 

}



  function pieces_indv(res)
  {
    fp_dtindv = res.DATA.pop()[1];
	fp_datasetindv = res.DATA;  
	fp_hdrindv = res.COLUMNS;
      disp_table2(0,30,'',''); 
    d3.select('#loader').remove();
  }




function fprpt(t,v)
{
	var trtd = t.parentNode.getElementsByTagName('td');
		myLoader();
 		var srlupv = document.getElementById('rlupv').value;
		var sdir = document.getElementById('selDir').value;
		var seod = document.getElementById('selEod').value;
		var sDOW = document.getElementById('selDOW').value;
		var sd = trtd[0].innerHTML;
		var sdend=getenddate(sd)
		var sarea = document.getElementById('selArea').value;
		var sdist = document.getElementById('selDistrict').value;
		var sfac = document.getElementById('selFacility').value;
		var sclass = document.getElementById('selClass').value;
		var scat = document.getElementById('selCategory').value;
		var sfss = document.getElementById('selFSS').value;
		var smode = 'Y';
		var sair = document.getElementById('selAir').value;
		var spol = document.getElementById('selPol').value;
		var shyb = document.getElementById('selHybStd').value;
		var srng = document.getElementById('selRange').value;		
		var scntr = document.getElementById('selCntrLvl').value;			
		var scert = document.getElementById('selCert').value;				
		var smlr = document.getElementById('selMailer').value;
		var szip3 = trtd[4].innerHTML;
		var sorg = trtd[2].innerHTML;
		var seodt = document.getElementById('selEntType').value;
		var sindc = document.getElementById('selInduct').value;		
		var state = document.getElementById('selState').value;
		var sur = document.getElementById('selUR').value;
		var surbko = get_ur('selurbk','O');																																						
		var surbkd = get_ur('selurbk','D');																																								
		var smflag  = document.getElementById('selMlrFlg').value;		
		var sdfac  = trtd[8].innerHTML;

		document.getElementById('selfpdate').value = sd;			
		document.getElementById('selfpzip3').value = szip3;	
        document.getElementById('selfporg3').value = sorg;			
        document.getElementById('selDestnFac').value = sdfac;					
		var e=new TDF();
//    	 e.setHTTPMethod("POST");
		e.setCallbackHandler(pieces_indv);	
		e.setErrorHandler(area_data_err);
		e.getFailedPcsData('<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd,sdfac);
	

}


function move(){
    this.parentNode.appendChild(this);
                var dragTarget = d3.select(this);
                dragTarget.style({
                                left: d3.event.dx + parseInt(dragTarget.style("left")) + "px",
                top: d3.event.dy + parseInt(dragTarget.style("top")) + "px"
                });
}

//d3.select('body').node().focus();

function cbh_app(msg)
{
alert(msg);
}

function test_app()
{
alert(1);
}


function excel_export()
{
 d3.select('#excel_btn').node().disabled = true; 
 d3.select('#exportdiv').remove();
 var ediv = d3.select('body').append('div')
 .style('display','none')
 .attr('id','exportdiv');
 var tb = ediv.append('table');

 var thead = tb.append('thead');
 var hdrcell = thead.append('tr')
 .selectAll('th')
 .data(fp_hdr)
 .enter()
 .append('th')
 .style('position','relative')
 .style('border','black solid 2px')
 .style('color','#FFFFFF')  
 .style('background-color','#21435F')
 .text(function(d) {return d.replace(/_/g,' ')});

   tb.append('tbody')
	  .selectAll("tr") 
	  .data(fp_dataset)
	  .enter()
      .append('tr')
	  .selectAll("td") 
	  .data(function(d){return d})
	  .enter()	  
      .append('td')	  
	 	.style('border','black solid 1px')	  
      .text(function(d,i) {return (i==7)? +d*100 :d});

 d3.select('#exportfrm').remove();
 x = 1;
 var eform= d3.select('body').append('form')
 .attr('action','export_excel.cfm')
 .attr('method','post')
// .attr('target','_blank')
 .attr('name','exportfrm')
 .attr('id','exportfrm') ;

 eform.append('input')
 .attr('type','hidden')
 .attr('name','data')
 .attr('id','datastr') 
 .attr('value',function() {return ediv.node().innerHTML;});

 eform.append('input')
 .attr('type','hidden')
 .attr('name','fn')
 .attr('value','Three_digit_listing.xls' );

 eform.node().submit();
// ColdFusion.Ajax.submitForm('exportfrm','export_excel.cfm',cbh_app);

  d3.select('#exportdiv').node().innerHTML = '';
  d3.select('#datastr').node().value = '';  
  d3.select('#exportdiv').remove();  
 d3.select('#exportfrm').remove();	  
setTimeout(function() {
  d3.select('#excel_btn').node().value='Excel';
  d3.select('#excel_btn').node().disabled = false; 
},15000);

//	 var url = 'data:application/vnd.ms-excel,'+encodeURIComponent(ediv.node().innerHTML);
//	 location.href = url;
//window.open('data:application/vnd.ms-excel;base64,'+window.btoa(ediv.node().innerHTML));
}


function disp_table(r,c)
{
cmaf = d3.format(',');
dtf = d3.format('%m/%d/%/%Y');
perf = d3.format('.1%');
var cnt = fp_dataset.length;	
//if (cnt-30 < r) r=cnt-30;
if (r<0) r=0;
res = fp_dataset.slice(r,c+r);      
var temp_rc = 'darkrow';	
var fsid = fp_hdr.indexOf('FAC_SEQ_ID');


   var div = d3.select('#zip3table');

   div.call(d3.behavior.drag().on("drag", move).on("dragend",function () {d3.select('body').node().focus();}));
   
	div.style('display','');
	div.selectAll('#datatable').remove();
	var tb = div.append('table')
 .attr('id','datatable')
 .style('margin','auto')
 .style('font-size','12px')
 .style('border','double 6px') 
 .style('background','#d3d3d3')
 .style('box-shadow','0px 0px 0px 2px black, 20px 20px 50px #888888')
 .attr('class','pbTable');

 var thead = tb.append('thead');
   var t =thead.append('tr')
		.append('th')
		.attr('colspan',fp_hdr.length);
	//	.on('mousedown',function() {d3.event.preventDefault(); d3.select(window).on('mousemove', null); div.on('mouseup', function() {d3.select(window).on('mousemove',null)})  });

		t.append('input')
		.attr('type','button')
		.attr('value','X')
		.style('float','right')
		.on('click', function() {d3.select('#zip3table').style('display','none'); d3.select('#datatable').remove();	fp_dataset.length = 0; });

//xxx
		t.append('input')
		.attr('type','button')
		.attr('value','Excel')
		.attr('id','excel_btn')
		.style('float','left')
		.on('click',function() {
			d3.select('#excel_btn').node().value = 'Downloading...'; 
			setTimeout(function() {excel_export()},1000); 
			});

		
		t.append('label')		
		.text('Use Mouse Wheel to scroll or Page-Up/Page-Down')
		.style('text-align','center');


var hdrcell = thead.append('tr')
 .selectAll('th')
  .data(fp_hdr)
 .enter()
 .append('th')
 .style('position','relative')
 .style('display',function(d,i) {return (i==fsid) ? 'None' : '';}) 
// .style('width',function(d,i) {return (i==2 || i==3 || i==4) ? '150px' : '70px'})	  
 .text(function(d) {return d.replace(/_/g,' ')});

 hdrcell
	.append('label')
	.attr('id',function(d,i) {return 'dnarrow3-'+ i})
	.attr('class','arrow-down')
	.on('click',function() {sortit(this,fp_dataset,30)});
 hdrcell	
	.append('label')
	.attr('id',function(d,i) {return 'uparrow3-'+ i})
	.attr('class','arrow-up')
	.on('click',function() {sortit(this,fp_dataset,30)});
	;


   tb.append('tbody')
      .on('wheel', function() {d3.event.preventDefault(); (d3.event.deltaY <0) ? disp_table(r-1,c) : disp_table(r+1,c);  })
	  .selectAll("tr") 
	  .data(res)
	  .enter()
      .append('tr')
//	  .attr('class',function(d) {return (d[0] % 2 == 0) ? 'darkrow' : 'lightrow'})
	  .attr('class',function(d,i) {
//		  if (i>0 && res[i][0] != res[i-1][0])
//		   {
	      if (i % 3 == 0)
		  {  
		   if (temp_rc == 'darkrow')
		    temp_rc = 'lightrow'
			else  
			temp_rc = 'darkrow'; 
		  }
//		   }
		  return temp_rc;
		  })
//	  .style('display',function(d) {return (cls.indexOf(d[8]) != -1) ? '' : 'none'}) 	  
	  .selectAll("td") 
	  .data(function(d){return d})
	  .enter()	  
      .append('td')	  
	  .on('click',function(d,i) {fprpt(this,i)})
//      .style('width',function(d,i) {return (i==2 || i==3 || i==4) ? '150px' : '70px'})
	  .style('padding','4px')	  
	  .style('cursor','pointer')	  	  
	  .style('text-align',function(d,i) {return (i==1 || i == 3) ? 'left' : 'center'})	  
 	 .style('display',function(d,i) {return (i==fsid) ? 'None' : '';}) 	  
      .text(function(d,i) {return (i==5 || i==6) ? cmaf(d) : (i==7) ? perf(d): d});

       d3.select('body').call(d3.keybinding()
	  .on('arrow-up', function() {
 		  if (!d3.select('#datatable').empty())
		  {
  		  d3.event.preventDefault(); (r-1 < 0) ? disp_table(0,c) : disp_table(r-1,c);
	      }
		  })
      .on('arrow-down', function() {
		  if (!d3.select('#datatable').empty())
		   {
		   d3.event.preventDefault(); if (r+1 < cnt) disp_table(r+1,c);
		   }
		   })	  
      .on('page-down', function() {
		  if (!d3.select('#datatable').empty())
		   {
		   d3.event.preventDefault(); if (r+c < cnt) disp_table(r+c,c);
		   }
		   })	  
	  .on('page-up', function() {
 		  if (!d3.select('#datatable').empty())
		  {
  		  d3.event.preventDefault(); (r-c < 0) ? disp_table(0,c) : disp_table(r-c,c);
	      }
		  })
	  .on('escape', function() {
 		  if (!d3.select('#datatable').empty())
		  {
            d3.select('#datatable').remove();  
			fp_dataset.length = 0;
	      }
		  })
		  
		  );	  

d3.select('body').node().focus();
 d3.select('#loader').remove();
}



function disp_csa(r,c,noshow)
{
cmaf = d3.format(',');
dtf = d3.format('%m/%d/%/%Y');
perf = d3.format('.1%');
var hold = 0;
var cnt = csa_dataset.length;	
//if (cnt-30 < r) r=cnt-30;
if (r<0) r=0;
res = csa_dataset.slice(r,c+r);      
var temp_rc = 'darkrow';	

   var div = d3.select('#csatable');

   div.call(d3.behavior.drag().on("drag", move).on("dragend",function () {d3.select('body').node().focus();}));
if (noshow)
	div.style('display','none');  
  else	
	div.style('display','');
	div.selectAll('#csadatatable').remove();
	var tb = div.append('table')
 .attr('id','csadatatable')
 .style('margin','auto')
 .style('font-size','12px')
 .style('border','double 6px') 
 .style('background','#d3d3d3')
 .style('box-shadow','0px 0px 0px 2px black, 20px 20px 50px #888888')
 .attr('class','pbTable');

 var thead = tb.append('thead');
   var t =thead.append('tr')
		.append('th')
		.attr('colspan',csa_hdr.length-1);

	t.append('label')
		.style('float','left')
    	.text('Customer Supplier Agreement:');
	t.append('label')
		.style('float','left')
		.style('color','Yellow')		
		.style('margin-left','4px')				
    	.text(csa_dataset[0][1]);
	t.append('label')
		.style('float','left')
		.style('margin-left','6px')						
    	.text('Customer Registration Number:');
	t.append('label')
		.style('float','left')
		.style('color','Yellow')		
		.style('margin-left','4px')						
    	.text(csa_dataset[0][2]);

		t.append('input')
		.attr('type','button')
		.attr('value','X')
		.style('float','right')
		.on('click', function() {d3.select('#csatable').style('display','none');	 });
/*
		t.append('label')		
		.text('Use Mouse Wheel to scroll or Page-Up/Page-Down')
		.style('text-align','center');
*/

var hdrcell = thead.append('tr')
 .selectAll('th')
  .data(csa_hdr)
 .enter()
 .append('th')
 .style('display',function(d,i) {return (i<3) ? 'none' : ''} ) 
 .text(function(d) {return d.replace(/_/g,' ')});

 hdrcell
	.append('label')
	.attr('id',function(d,i) {return 'dnarrow3-'+ i})
	.attr('class','arrow-down')
	.on('click',function() {sortit(this,csa_dataset,30)});
 hdrcell	
	.append('label')
	.attr('id',function(d,i) {return 'uparrow3-'+ i})
	.attr('class','arrow-up')
	.on('click',function() {sortit(this,csa_dataset,30)});
	;


   tb.append('tbody')
      .on('wheel', function() {d3.event.preventDefault(); (d3.event.deltaY <0) ? disp_csa(r-1,c) : disp_csa(r+1,c);  })
	  .selectAll("tr") 
	  .data(res)
	  .enter()
      .append('tr')
	  .attr('class',function(d,i) {
	      if ((d[3]*1) % 2 == 0)
		    temp_rc = 'lightrow'
			else  
			temp_rc = 'darkrow'; 
		  return temp_rc;
		  })

	  .selectAll("td") 
	  .data(function(d){return d})
	  .enter()	  
      .append('td')	  
      .style('display',function(d,i) {return (i<3) ? 'none' : ''} ) 
	  .style('padding','4px')	  
	  .style('cursor','pointer')	  	  
	  .style('text-align',function(d,i) {return (i==5 ) ? 'left' : 'center'})	  
      .text(function(d,i) {return  d});

       d3.select('body').call(d3.keybinding()
      .on('page-down', function() {
		  if (!d3.select('#csadatatable').empty())
		   {
		   d3.event.preventDefault(); if (r+c < cnt) disp_csa(r+c,c);
		   }
		   })	  
	  .on('page-up', function() {
 		  if (!d3.select('#csadatatable').empty())
		  {
  		  d3.event.preventDefault(); (r-c < 0) ? disp_csa(0,c) : disp_csa(r-c,c);
	      }
		  })
	  .on('escape', function() {
            d3.select('#csatable').style('display','none')
		  })
		  
		  );	  

d3.select('body').node().focus();
// d3.select('#loader').remove();

}


function csa_data(res)
{
csa_dataset.length = 0;
csa_hdr.length=0;
if (res.DATA.length > 0)
{
var rp = res.DATA[0][0];
  if(ReqId != rp)
			return;
}
csa_dataset = res.DATA;
csa_hdr = res.COLUMNS;
disp_csa(0,30,1);
	
}





  function pieces_data(res)
  {
/* 
	fp_dataset = res.DATA;  
	 = res.COLUMNS;
*/
    var exc_time = res.pop();  
	//alert(exc_time);
	fp_hdr = res.shift();  
	fp_dataset = res;	

      disp_table(0,30); 
    d3.select('#loader').remove();
	
	
	              
  }
		
   function sfp()
    {
		if (!d3.select('#datatable').empty() )
		 {
			return true;  
		 }
		 if (getEleVal('selDistrict') == '' && getEleVal('selFacility') == '')
		 {
			 alert('District or facility is needed');
			 return true;  
		 }
		myLoader();
 		var srlupv = document.getElementById('rlupv').value;
		var sdir = document.getElementById('selDir').value;
		var seod = document.getElementById('selEod').value;
		var sDOW = document.getElementById('selDOW').value;
		var sd = document.getElementById('selDate').value;
		var sdend=getenddate(sd)
		var sarea = document.getElementById('selArea').value;
		var sdist = document.getElementById('selDistrict').value;
		var sfac = document.getElementById('selFacility').value;
		var sclass = document.getElementById('selClass').value;
		var scat = document.getElementById('selCategory').value;
		var sfss = document.getElementById('selFSS').value;
		var smode = 'Y';
		var sair = document.getElementById('selAir').value;
		var spol = document.getElementById('selPol').value;
		var shyb = document.getElementById('selHybStd').value;
		var srng = document.getElementById('selRange').value;		
		var scntr = document.getElementById('selCntrLvl').value;			
		var scert = document.getElementById('selCert').value;				
		var smlr = document.getElementById('selMailer').value;
		var szip3 = document.getElementById('selImbZip3').value;		
		var sorg = document.getElementById('selOrgFac').value;				
		var seodt = document.getElementById('selEntType').value;						
		var sindc = document.getElementById('selInduct').value;		
		var state = document.getElementById('selState').value;														
		var sur = document.getElementById('selUR').value;																
		var surbko = get_ur('selurbk','O');																																						
		var surbkd = get_ur('selurbk','D');																																								

        var smflag  = document.getElementById('selMlrFlg').value;		
		
		var e=new TDF();
//	    e.setHTTPMethod("POST");
		e.setCallbackHandler(pieces_data);	
		e.setErrorHandler(area_data_err);
		e.getFailedPcszip3('<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);


	}

 function chartsperrow(t)
  {
    document.getElementById('chartsdiv').style.width = (t.value*380+50)+'px';
  }

	var doInit;
	function init()
	{
		doInit=true;

		var e=new TDF();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(area_data_err);
		e.getDates('<cfoutput>#opsvisdata#</cfoutput>','');
		
//		get_std();
	}

	function chg_DateRng(n)
	{
		var e=new TDF();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(area_data_err);
		e.getDates('<cfoutput>#opsvisdata#</cfoutput>',n);
	} 



 function to_date(v)
 {
  var ar = v.split('/');
  return new Date(ar[2],ar[0]-1,ar[1]);	 
	 
 } 
 function load_thru_Dates(res)
 {
   var sd = document.getElementById('selDate').value;	 	 
   var ed = getenddate(sd);	 
   if (to_date(res) >= to_date(sd) && to_date(res) < to_date(ed))
   filterArgs[4] = filterArgs[4].substr(0,10) + '-' +res;
      listSelections();
 }

 function getdatethru()
  {
		var e=new TDF();
		e.setCallbackHandler(load_thru_Dates);	
		e.setErrorHandler(area_data_err);
		e.getthrudate('<cfoutput>#opsvisdata#</cfoutput>');
  }
 



 function getenddate(v)
  {
	for (var i=0;i<date_rng.length;i++)
	  if (date_rng[i][0]==v)
	   return date_rng[i][1];
	return v;   
	  
  } 
	  
	ReqId=-1;
	chartHistory=[];
	chartHistory[0] ={};
	
  function doHistory(dir)
	{
	d3.select('#loader').remove();
	loadCnt=19;
		if(dir+ReqId < 0 || dir+ReqId >= chartHistory.length)
			return;
		ReqId+=dir;
		for (var key in chartHistory[ReqId]) {
		  if (chartHistory[ReqId].hasOwnProperty(key)) {
				chartHistory[ReqId][key]();
		  }
		  
		}
	loadCnt=19;		
   for (var key in chartHistory[ReqId]) {
		  if (chartHistory[ReqId].hasOwnProperty(key)) {
				chartHistory[ReqId][key]();
		  }
		  
		}		
	}

	
	
	function cfrm_sub()
	{
		d3.select('#mainSvg').remove();
        trendDataset.length=0;
		myLoader();
        d3.select('#csaicon').style('display','none');
		if (newdiropt)
		 { newdiropt = false;
	      // resetAll();         
		 }
		
		d3.selectAll("#loadShield")
			.attr("fill",'gray');
		listSelections();
		document.getElementById("subtn").style.border = 'none';
		//document.getElementById('selArea').selectedOptions[0].text
		var srlupv = document.getElementById('rlupv').value;
		var sdir = document.getElementById('selDir').value;
		var seod = document.getElementById('selEod').value;
		var sDOW = document.getElementById('selDOW').value;
		var sd = document.getElementById('selDate').value;
		var sdend=getenddate(sd)
		var sarea = document.getElementById('selArea').value;
		var sdist = document.getElementById('selDistrict').value;
		var sfac = document.getElementById('selFacility').value;
		var sclass = document.getElementById('selClass').value;
		var scat = document.getElementById('selCategory').value;
		var sfss = document.getElementById('selFSS').value;
		var smode = 'Y';
		var sair = document.getElementById('selAir').value;
		var spol = document.getElementById('selPol').value;
		var shyb = document.getElementById('selHybStd').value;
		var srng = document.getElementById('selRange').value;		
		var scntr = document.getElementById('selCntrLvl').value;			
		var scert = document.getElementById('selCert').value;				
		var smlr = document.getElementById('selMailer').value;
		var szip3 = document.getElementById('selImbZip3').value;		
		var sorg = document.getElementById('selOrgFac').value;				
		var seodt = document.getElementById('selEntType').value;				
		var sindc = document.getElementById('selInduct').value;		
		var smflag  = document.getElementById('selMlrFlg').value;
		var state = document.getElementById('selState').value;													
		var sur = document.getElementById('selUR').value;
		var surbko = get_ur('selurbk','O');		
		var surbkd = get_ur('selurbk','D');																																																																												

		if(sclass==1)
		{
			smode = document.getElementById('selMode').value;
			sair = document.getElementById('selAir').value;
		}
		
		ReqId++;
        chartHistory[ReqId] = {};
		loadCnt=19;
      
	    if (smlr != '' &&  smlr.indexOf(',') == -1)
		{
         
		var e=new TDF();
		e.setCallbackHandler(csa_data);	
		e.setErrorHandler(area_data_err);
		e.getcsa(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',smlr);

		}

        for (var i=0;i<8;i++)
		{
		var trendDate	= gettrdate(sd,srng,i);
		var newrange=srng;
		if (srng=='QTR') newrange='MON';
		var e=new TDF();
		e.setCallbackHandler(trend_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByTrend(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,trendDate,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,newrange,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		}



		var e=new TDF();
		e.setCallbackHandler(Mailer_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByMailerData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd,smflag);
        if (sdir == 'O')
		{
		var e=new TDF();
		e.setCallbackHandler(zip3_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDestZip3(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		} else
		{
		var e=new TDF();
		e.setCallbackHandler(orgfac_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByOrgFacData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		}

		var e=new TDF();
		e.setCallbackHandler(state_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByState(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);

		var e=new TDF();
		e.setCallbackHandler(Display_Overalls);	
		e.setErrorHandler(area_data_err);
		e.getByOverallData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(Area_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByAreaData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(District_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDistData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(Facility_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByFacilityData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
<!---		var e=new TDF();
		e.setCallbackHandler(DOW_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByDayData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,"","","","Y",spol,shyb,'',sDOW,sfac);--->
		var e=new TDF();
		e.setCallbackHandler(Cntr_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByCntrData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(Class_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByClassData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(Cat_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByCatData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(EOD_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByEODData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(SVCSTD_Chart);	
		e.setErrorHandler(area_data_err);
		e.getBySvcStdData(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(Air_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByAir(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(FSS_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByFSS(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(pol_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByPolitical(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(enttype_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByEntType(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(induct_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByInductMthd(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(fullsvc_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByFuLLSvc(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(ur_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByURT(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);
		var e=new TDF();
		e.setCallbackHandler(urbk_Chart);	
		e.setErrorHandler(area_data_err);
		e.getByURBK(ReqId,'<cfoutput>#opsvisdata#</cfoutput>',srlupv,sdir,seod,sd,sdend,sarea,sdist,sclass,scat,sfss,smode,sair,scntr,scert,spol,shyb,'',sDOW,sfac,srng,smlr,szip3,sorg,seodt,sindc,state,sur,surbko,surbkd);



		
	}
	function Display_Overalls(res)
	{
        var rp = res.pop()[0];  
		res.shift();
		chartHistory[rp].Display_Overalls=(function(data){
		return function(){
		var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range(["#EC9792","#EC9792","#FDBB9B","#FDBB9B","#fee090","#fee090","#91bfdb","#91bfdb","#7C9FCE","#7C9FCE"]);	
		var toColor = cScale2(res[0][3]);
		var perF = d3.format('.1%');
		var sigF = d3.format('.3g');
		var comF = d3.format(',');
		
		current_failed_pieces = data[0][2];
		d3.select('#OverallScore').style('background',toColor).text(perF(res[0][3]));
        if (getEleVal('selFacility') == '' && (getEleVal('selDistrict') == '' || getEleVal('selImbZip3') == ''))
		{
 		  d3.select('#OverallFail')
		  .attr('title','')  
		  .on('click',null)		  
		  .style('background',toColor)
		  .style('text-decoration','')
		  .style('cursor','default')
		  .text(comF(res[0][2]));
		}
		else
		{
 		  d3.select('#OverallFail')
		  .attr('title','Click to drill to individual pieces')  
		  .on('click',sfp)
		  .style('background',toColor)
		  .style('text-decoration','underline')
		  .style('cursor','pointer')
		  .text(comF(res[0][2]));
		}
		
		d3.select('#OverallPieces').style('background',toColor).text(comF(res[0][4]));
			}
		})(res)

		if(ReqId != rp)
			return;
		
		
		var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range(["#EC9792","#EC9792","#FDBB9B","#FDBB9B","#fee090","#fee090","#91bfdb","#91bfdb","#7C9FCE","#7C9FCE"]);	
		var toColor = cScale2(res[0][3]);
		var perF = d3.format('.1%');
		var sigF = d3.format('.3g');
		var comF = d3.format(',');
		current_failed_pieces = res[0][2];
		d3.select('#OverallScore').style('background',toColor).text(perF(res[0][3]));
        if (getEleVal('selFacility') == '' && (getEleVal('selDistrict') == '' || getEleVal('selImbZip3') == ''))
		{
 		  d3.select('#OverallFail')
		  .attr('title','')  
		  .on('click',null)		  
		  .style('background',toColor)
		  .style('text-decoration','')
		  .style('cursor','default')
		  .text(comF(res[0][2]));
		}
		else
		{
 		  d3.select('#OverallFail')
		  .attr('title','Click to drill to individual pieces')  
		  .on('click',sfp)
		  .style('background',toColor)
		  .style('text-decoration','underline')
		  .style('cursor','pointer')
		  .text(comF(res[0][2]));
		}
		
		d3.select('#OverallPieces').style('background',toColor).text(comF(res[0][4]));
	}
	<!--- trendgraph--->
	var c0070="#EC9792";
	var c7080="#FDBB9B";
	var c8090="#fee090";
	var c9095="#91bfdb";
	var c9510="#7C9FCE";

	
		function Load_Trend_Graph(res)
	{	
		var w = 500;
		var h = 160;
		var padding = 40;

		var rdiv = (w-(padding*2))/(8)/2;
		var rw = 300/8;
		
		dataset=res;
		var high =d3.max(dataset, function(d) { return d[2]; });
		//Create scale functions
		xScale = d3.time.scale()
							 .domain([d3.min(dataset, function(d) { return new Date(d[0]); }), new d3.max(dataset, function(d) { return new Date(d[0]); })])
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
		
		if (getEleVal('selRange') == 'WEEK') 
		{var timeF = d3.time.saturday;
		 var chartTitle ='8 Week Processing Trend';
		}
	   	if (getEleVal('selRange') == 'MON' || getEleVal('selRange') == 'QTR') 
		{
 		var timeF = d3.time.month;
  	    var chartTitle ='8 Month Processing Trend';
		}

					 
		var	cScale = d3.scale.linear().domain([0,0.7,1]).range(["#700","#C00","#0C0"]);	
		
		var cScale2 = d3.scale.linear().domain([0,0.699,0.7,0.799,0.8,0.899,0.9,0.949,0.95,1]).range([c0070,c0070,c7080,c7080,c8090,c8090,c9095,c9095,c9510,c9510]);		

		//Define X axis
		var xAxis = d3.svg.axis()
						  .scale(xScale)
						  .orient("bottom")
						  //.innerTickSize(-h+padding*2)
						  //.ticks(5)
						  .ticks(timeF, 1)
						  .tickFormat(d3.time.format('%m-%d'));

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
		.x(function(d) { return xScale(new Date(d[0])); })
		.y(function(d) { return yScale(d[2]); });
		
		var line2 = d3.svg.line()
//		.interpolate("cardinal")
		.x(function(d) { return xScale(new Date(d[0])); })
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
				.style("text-anchor", "start").style('font-size','12px').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps');
			svg.select('.y.axis').call(yAxis).selectAll('text').style('font-size','12px').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps');
			svg.select('.y2.axis').call(yAxis2).selectAll('text').style('font-size','12px').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps');
			
			var fpie=container
				   .selectAll(".failPie")
				   .data(dataset);
				   
			fpie.enter()
				   .append("rect")
					.attr("class", "failPie")
				   .attr("x", function(d,i) { return xScale(new Date(d[0]))-rw/2+2;})
				   .attr("y", function(d) { return yScale(d[2]);})
				   .attr("height",  function(d) {return Math.abs(yScale(d[2])-yScale(0));})
				   .attr("width",rw-4)
				   .style("fill", function(d) {return cScale2(Math.floor(d[3]*100)/100);}) .append('title')
				   .text(function(d) {return 'Failed Pieces: '+comF(d[2]);})

			fpie.transition().duration(500).attr("x", function(d,i) { return xScale(new Date(d[0]))-rw/2+2;})
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
			.text(chartTitle).style('font-size','12px').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps')
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
//aaa				   
			fpie.enter()
				   .append("rect")
				   .on('click',function(d) {d3.select('#selDate').node().value=d[0];filterArgs[4]=d[0];cfrm_sub()})
					.attr("class", "failPie")
				   .attr("x", function(d,i) { return xScale(new Date(d[0]))-rw/2+2;})
				   .attr("y", function(d) { return yScale(d[2]);})
				   .attr("height",  function(d) {return Math.abs(yScale(d[2])-yScale(0));})
				   .attr("width",rw-4)
				   .style("fill", function(d) {return cScale2(Math.floor(d[3]*100)/100);}) .append('title')
				   .text(function(d) {return 'Failed Pieces: '+comF(d[2]);})
                   


			container.append("g")
			.attr("class", "lineTrend2")
			.append("path")
			.datum(dataset)
//			.attr("class", "lineV")
			.attr("d",  line2)
//			.attr('stroke', 'url(#temperature-gradient)')
			.attr('stroke','black')
			.attr("opacity",0.50)			
			.attr('stroke-width', 1)
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
				.style("text-anchor", "start").style('font-size','10px').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps').style('font-weight','bold');


			//Create Y axis
			svg.append("g")
				.attr("class", "y axis")
				.attr("transform", "translate(" + padding + ",0)")
				.call(yAxis)
				.selectAll('text').style('font-size','10px').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps').style('font-weight','bold');

			//Create Y axis
			svg.append("g")
				.attr("class", "y2 axis")
				.attr("transform", "translate(" + (w-padding) + ",0)")
				.call(yAxis2)
				.selectAll('text').style('font-size','10px').style('font-family','"Lucida Sans Unicode", "Lucida Grande", sans-serif').style('font-variant','small-caps').style('font-weight','bold');

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
	<!--- trendgraph--->
	
	
	






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

	function chg_rng(t)
	{
        d3.select('#subtn').node().disabled=true;
		var e=new TDF();
		e.setCallbackHandler(load_Dates);	
		e.setErrorHandler(area_data_err);
		e.getDates('<cfoutput>#opsvisdata#</cfoutput>',t.value);
		
//		cfrm();
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
		//res.shift();
		defDate = <cfoutput>'#selDate#';</cfoutput>
		date_rng = res;
		var sel = document.getElementById('selDate');
		sel.options.length=0;
		res.forEach(function(d,i){
			sel.options[sel.options.length]= 	new Option(d[0],d[0]);
			if (d[0] == defDate)
			sel.selectedIndex = i;
		});
		filterArgs[4]=sel.options[sel.selectedIndex].text;
		if(doInit)
		{
			doInit=false;
        	filterArgs[4]=sel.options[sel.selectedIndex].text;
			document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';
			cfrm_sub();			
		}
		if(d3.select('#subtn').node().disabled== true)
		  {
	        d3.select('#subtn').node().disabled=false;
			document.getElementById("subtn").style.border = 'Red 4px solid';
		  }
		getdatethru();
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

<!---
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
--->
	function excel_out(t)
	{
		var ua = window.navigator.userAgent;
		var msie = ua.indexOf("MSIE "); 

		if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
		{
			txtArea1.document.open("txt/html","replace");
			txtArea1.document.write(d3.select(t).node().innerHTML);
			txtArea1.document.close();
			txtArea1.focus(); 
			sa=txtArea1.document.execCommand("SaveAs",true,"Performance.xls");
		}  
		else  
			window.open('data:application/vnd.ms-excel;filename=Performance.xls;base64,'+window.btoa(d3.select(t).node().innerHTML));
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
		cfrm_sub();
	}
</script>
</head>

<body onload="init()" style="margin:0px;">

<div id="banner" style="margin:0px auto; background: #21435F; height:60px; color:#FFFFFF">
<input type='button' value='|||' <!---onclick="toggle()"---> class='pbnobtn' style='margin:5px 15px;width:40px;height:40px;font-size:20px;float:left;transform: rotate(90deg);'>
<h1  style="margin:5px 20px;font-size:45px;float:left;"> IV</h1>
<div style='padding:10px 25px 5px 0px;'>
<span style=" font-size:18px;"> Informed Visibility </span><br>
<span  style="font-size:13px;"> The single source for all your mail visibility needs </span>
<label style="font-style:italic; font-size:15px; position:relative; left:+20px; top:-15px">Enterprise Analytics </label>
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
<cfoutput>
		<input type='hidden' id='selArea' name='selArea' value="#ap(selArea)#">
		<input type='hidden' id='selDistrict' name='selDistrict' value="#ap(selDistrict)#"> <!---"'980'"--->
		<input type='hidden' id='selFacility' name='selFacility' value="#ap(selFacility)#"><!---"'16031'"--->
		<input type='hidden' id='selMailer' name='selMailer' value="#ap(selMailer)#">        
		<input type='hidden' id='selDOW' name='selDOW' value="#ap(selDOW)#">
		<input type='hidden' id='selClass' name='selClass' value="#ap(selClass)#">
		<input type="hidden" name="selCategory" id="selCategory" value = "#ap(selCategory)#">        
		<input type="hidden" name="selCntrLvl" id="selCntrLvl" value = "#ap(selCntrLvl)#">                
		<input type='hidden' id='selEod' name='selEod' value="#ap(selEod)#">
		<input type='hidden' id='selHybStd' name='selHybStd' value="#ap(selHybStd)#">
		<input type='hidden' id='selAir' name='selAir' value="#ap(selAir)#">      
		<input type='hidden' id='selFSS' name='selFSS' value="#ap(selFSS)#">                  
		<input type='hidden' id='selImbZip3' name='selImbZip3' value="#ap(selImbZip3)#">                          
		<input type='hidden' id='selOrgFac' name='selOrgFac' value="#ap(selOrgFac)#">                          
		<input type='hidden' id='selPol' name='selPol' value="#ap(selPol)#">                                  
		<input type='hidden' id='selEntType' name='selEntType' value="#ap(selEntType)#">
		<input type='hidden' id='selInduct' name='selInduct' value="#ap(selInduct)#">
		<input type='hidden' id='selfpzip3' name='selfpzip3' value="#ap(selfpzip3)#">        
		<input type='hidden' id='selfporg3' name='selfporg3' value="#ap(selfporg3)#">                
		<input type='hidden' id='selfpdate' name='selfpdate' value="#ap(selfpdate)#">                        
		<input type='hidden' id='selCert' name='selCert' value="#ap(selCert)#">                                
		<input type='hidden' id='selMlrFlg' name='selMlrFlg' value="#ap(selMlrFlg)#">                                        
		<input type='hidden' id='selState' name='selState' value="#ap(selState)#">                
		<input type='hidden' id='selUR' name='selUR' value="#ap(selUR)#">                        
		<input type='hidden' id='selurbk' name='selurbk' value="#ap(selurbk)#">
		<input type='hidden' id='selDestnFac' name='selfporg3' value="#ap(selfporg3)#">                                                        
</cfoutput>
	<fieldset class="fset"><legend>Date By:</legend>

		<select class ="slct" name = "selRange" id = "selRange" onchange = "filterHds[4]=this.options[this.selectedIndex].text;filterArgs[3]=this.options[this.selectedIndex].text;chg_rng(this);">
		<option value = 'WEEK'>Week</option> 
		<option value = 'MON'>Month</option> 
		<option value = 'QTR'>Quarter</option> 
		</select>

		<!---<input class ="slct" type = "Radio" name  = "rng" id  = "rngWK" style='display:none;' onclick = "filterArgs[3]='Week';chg_DateRng('WEEK');cfrm();" checked>Week
		<input class ="slct" type = "Radio" name  = "rng" id  = "rngMON" style='display:none;' onclick = "filterArgs[3]='Month';chg_DateRng('MON');cfrm();" >Month
		<input class ="slct" type = "Radio" name  = "rng" id  = "rngQTR" style='display:none;' onclick = "filterArgs[3]='QTR';chg_DateRng('QTR');cfrm();" >QTR--->

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

	<fieldset class="fset"><legend></legend>
		<input class ="slct" id="subtn" type = "button" value = "Submit Request" onClick="document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';cfrm_sub();">        
	</fieldset>
	<fieldset class="fset"><legend></legend>
		<input class ="slct" id="hideFilt" type = "button" value = "Hide" onClick="document.getElementById('chartsdiv').style.display='inline-block'; document.getElementById('filtDiv').style.display='none'; document.getElementById('sFilt').style.display='';d3.select('#flist').style('display','');">        
	</fieldset>
	<!--- <fieldset class="fset"><legend>Facility</legend>  <select name="selFacility" id= "selFacility" style="min-width:200px"  class="slct"></select>   </fieldset>  --->    
</div>
	<fieldset class="fset" id="sFilt" style='display:none'><legend></legend>
		<input class ="slctSmall" type = "button" value = "Show Filters" onClick="document.getElementById('chartsdiv').style.display='inline-block'; document.getElementById('filtDiv').style.display='';d3.select('#flist').style('display','none');document.getElementById('sFilt').style.display='none';">
		<div id='flist' style='float:right'></div>
	</fieldset>
</fieldset>
<div id='chRow' style="display:inline-block;margin:5px;">
<input class ="slctSmall" type='button' id="undobtn" value='Undo' onclick='doHistory(-1)' disabled>
<select class ="slctSmall" onchange = "chartsperrow(this)">
		<option value = 1>1 Chart Per Row</option>
		<option value = 2>2 Charts Per Row</option> 
		<option value = 3>3 Charts Per Row</option> 
		<option value = 4 selected> 4 Charts Per Row</option> 
		<option value = 5>5 Charts Per Row</option> 
		<option value = 6>6 Charts Per Row</option> 
		<option value = 7>7 Charts Per Row</option> 
		</select></div>
<input class ="slctSmall" type='button' id="notes" value='Report Notes' onclick='open_pdf()' >
<h2>Service Performance Processing Visualization</h2><iframe id="txtArea1" style="display:none"></iframe> 
<div id ="loaderDiv" style="z-index: 3; left:50%;top:50%;  position:absolute"> </div>



<div style='margin:0px 150px 0px 150px;'>
<div style="margin:0px 50px 20px 50px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family:"Lucida Sans Unicode", "Lucida Grande", sans-serif"><legend style='font-weight:bold;font-size: 24px;'>Processing Score</legend><div id="OverallScore" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div style="margin:0px 50px 20px 50px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family:"Lucida Sans Unicode", "Lucida Grande", sans-serif">
<legend style='font-weight:bold;font-size: 24px;'>Failed Pieces</legend>
<div id="OverallFail"  style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px">
</div>
</div>
<div style="margin:0px 50px 20px 50px;display:inline-block;max-width:380px;text-align:center;text-variant: small-caps;font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif"><legend style='font-weight:bold;font-size: 24px;'>Total Pieces</legend><div id="OverallPieces" style="font-size: 18px;padding:40px 0px;border-radius: 15px;box-sizing:border-box;color:white;text-shadow:#474747 2px 2px 4px;height:100px;width:200px"></div></div>
<div id="color-key" style='margin:0px 50px 20px 50px;display:inline-block;'>
	<strong>Color Key</strong>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;margin-right:4px;background-color:#7C9FCE"></div><span>Score 95&ndash;100%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;margin-right:4px;background-color:#91bfdb"></div><span>Score 90&ndash;95%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;margin-right:4px;background-color:#fee090"></div><span>Score 80&ndash;90%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;margin-right:4px;background-color:#FDBB9B"></div><span>Score 70&ndash;80%</span>
	</div>
	<div style="height:24px;">
		<div style="float:left;height:20px;width:20px;border:1px black solid;margin-right:4px;background-color:#EC9792"></div><span>Score 0&ndash;70%</span>
	</div>
</div>
<input type='button' id="RAll" style="font-size: 10px;border:none;text-decoration:underline;padding:10px 0px;background:transparent;color:silver;height:40px;width:80px;cursor:pointer;" value='Reset All' onClick='resetAll();'/>
</div>
<div id="trend-Graph" style="text-align:center; min-width:80%;"></div>
<div id="chartsdiv" style='width:1570px; margin:0 auto'>
<div id="chart-Area" style="display:inline-block;max-width:380px;"></div>
<div id="chart-District" style="display:inline-block;max-width:380px;"></div>
<div id="chart-Facility" style="display:inline-block;max-width:380px;"></div>
<div id="chart-Mailer" style="display:inline-block;max-width:380px;"></div>
<div id="chart-state" style="display:inline-block;max-width:380px;"></div>
<div id="chart-EOD" style="display:inline-block;max-width:380px;"></div>
<div id="chart-Cntr" style="display:inline-block;max-width:380px;"></div>
<div id="chart-Class" style="display:inline-block;max-width:380px;"></div>
<div id="chart-Shape" style="display:inline-block;max-width:380px;"></div>
<div id="chart-SVCSTD" style="display:inline-block;max-width:380px;"></div>
<div id="chart-Air" style="display:inline-block;max-width:380px;"></div>
<div id="chart-FSS" style="display:inline-block;max-width:380px;"></div>
<div id="chart-zip3org" style="display:inline-block;max-width:380px;"></div>
<div id="chart-pol" style="display:inline-block;max-width:380px;"></div>
<div id="chart-enttype" style="display:inline-block;max-width:380px;"></div>
<div id="chart-induct" style="display:inline-block;max-width:380px;"></div>
<div id="chart-fullsvc" style="display:inline-block;max-width:380px;"></div>
<div id="chart-ur" style="display:inline-block;max-width:380px;"></div>
<div id="chart-urbk" style="display:inline-block;max-width:380px;"></div>
</div>
<div id="zip3table" style="position:absolute; top:200px; left:200px; ;text-align:center; display:none; ">
</div>
<div id="csatable" style="position:absolute; top:100px; left:200px; ;text-align:center; display:none; ">
</div>

<div id="fptable" style="position:absolute; top:100px; left:50px; width:1500px; text-align:center; display:none; <!---overflow-x:scroll;overflow-y:hidden --->">
</div>

<div id='searchBlock' style='padding: 25px;display: none;border: solid 2px blue;background:#f3f3f3;position: absolute; top:50%; left:50%; text-align:center;margin: 0 auto;'>
Search by Name:
<input id='searchTarget' type='text' onkeyup='if (event.keyCode == 13) {d3.select("#commitSearch").node().click();}'/> <input type='button' id='commitSearch' value='submit' onClick='d3.select("#searchBlock").style("display","none");')/>
</div>
<input class ="hyperFont" type = "button" id='eOut' value = "Excel" onClick="excel_out();" style='display:none;margin:0px 0px 0px 30px;'>
<div id ="tableDiv" style='margin:0px 0px 10px 30px'></div>
<div id ="mainDiv" ></div>
</div>
</body>
</html>