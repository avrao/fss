<!doctype html>
<cfoutput>
<cfajaxproxy cfc="top10" jsclassname="top10">
<cfajaximport>

<cfsetting showdebugoutput="no">

<cfparam name="chkpol" default="">
<cfparam name="selEod" default="Y">
<cfparam name="selDir" default="O">
<cfparam name="selStd" default="1">
<cfparam name="selClass" default="1">
<cfparam name="selCategory" default="1,3">
<cfparam name="selArea" default="All">
<cfparam name="selDistrict" default="All">
<cfparam name="top10" default="10">
<cfparam name="od" default="ORGN_AREA">
<cfparam name="selHybStd" default="11">
<cfparam name="std_out" default="Overnight">
<cfparam name="selFSS" default="">
<cfparam name="selCntrLvl" default="">
<cfparam name="selcert" default="Y">
<cfparam name="selAir" default="">
<cfparam name="selMode" default="Y">



<html>
<head>
<meta charset="utf-8">
<title>Top 10</title>
<link rel="stylesheet" type="text/css" href="styles/CommonStyleSheet.css">
<link rel="stylesheet" type="text/css" href="styles/d3styles.css">
<script language="javascript" src="jscripts/Lance.js"></script>
<script src='jscripts/d3.min.js'></script>
<script src='jscripts/crossfilter.min.js'></script>
<script src='jscripts/dc.min.js'></script>

<script>              
function get_filter(v)
{

 var sel= v;
 var filter =  '<B style="color:blue; font-size:12px">'+sel.parentNode.firstElementChild.innerHTML+':</b>'+ '<i style="font-size:12px">' +sel.options[sel.selectedIndex].text +'<\i>  |  '; 
 return filter;
}
function get_checks(v)
{
 var inp = v;
 if (inp.type == 'checkbox' && inp.checked)
 if (v.name.substr(0,3) == 'cat') 
  var filter =  '<B style="color:blue; font-size:12px"> Shape :</b>'+ '<i style="font-size:12px">' +inp.dataset.label +'<\i>  |  '
 else
   var filter =  '<B style="color:blue; font-size:12px"> Option :</b>'+ '<i style="font-size:12px">' +inp.dataset.label +'<\i>  |  '
 return filter;
}



function hide_element(v,h)
{
document.getElementById(v).style.display=h;
}

function update_filters()
{
var ar = [];
var fltr =d3.select('##rpt_filters');
fltr.select('##fbox').remove();
var div = fltr.append('fieldset')
.attr('id','fbox')
.style('margin','0 15%')


div .append('legend')
.append('input')
.attr('type','button')
.attr('value','Return to Menu')
.on('click',function() {hide_element('zip3tbl','none');hide_element('rpt_table','none');hide_element('hdr','');hide_element('fbox','none');hide_element('rpt_graph','none');});
//.text('Return to Menu');

d3.selectAll('select')
.each(function() {ar.push(get_filter(this))});

d3.selectAll('input')
.each(function() {ar.push(get_checks(this))});


div.selectAll('span').data(ar).enter().append('span')
.html(function(d) {return d });

document.getElementById('hdr').style.display='none';
}


</script>

<style>

body {background-color:##f3f3f3;
      margin:0;
	  font-size: 14px;
      line-height: 1.42857143;
      color: ##333;
	  font-family:Arial, Helvetica, sans-serif
	  }

html, body
{
height:100%;
width:100%;	
font-weight: 400;
	
}
/*div {box-sizing:border-box}
*:before, *:after
{box-sizing:border-box
}*/

h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 {
    font-family: inherit;
    font-weight: 500;
    line-height: 1.1;
    color: inherit;
}


row{
    margin-left:0px;
    margin-right:0px;
}

##wrapper {
    padding-left: 0px;
    position: absolute;	
    transition: all .8s ease 0s;
    height: 90%
}

##sidebar-wrapper {
    margin-left: -150px;
    left: 0px;
    width: 150px;
    background: ##21435F;
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
##page-content-wrapper {
    padding-left: 20px;
    margin-left: 0;
    width: 100%;
    height: auto;
}
##wrapper.active {
    padding-left: 150px;
}
##wrapper.active ##sidebar-wrapper {
    left: 150px;
}

##page-content-wrapper {
  width: 100%;
}

##sidebar_menu li a, .sidebar-nav li a {
    color: ##999;
    display: block;
    float: left;
    text-decoration: none;
    width: 150px;
    background: ##21435F;
    border-top: 1px solid ##373737;
    border-bottom: 1px solid ##1A1A1A;
    -webkit-transition: background .5s;
    -moz-transition: background .5s;
    -o-transition: background .5s;
   -ms-transition: background .5s;
    transition: background .5s;
}
.sidebar_name {
    padding-top: 25px;
    color: ##fff;
    opacity: .7;
}

.sidebar-nav li {
  line-height: 40px;
  text-indent: 20px;
}

.sidebar-nav li a {
  color: ##999999;
  display: block;
  text-decoration: none;
}

.sidebar-nav li a:hover {
  color: ##fff;
  background: rgba(255,255,255,0.2);
  text-decoration: none;
}

.sidebar-nav li a:active,
.sidebar-nav li a:focus {
  text-decoration: none;
}

.sidebar-nav > .sidebar-brand {
  height: 65px;
  line-height: 60px;
  font-size: 18px;
}

.sidebar-nav > .sidebar-brand a {
  color: ##999999;
}

.sidebar-nav > .sidebar-brand a:hover {
  color: ##fff;
  background: none;
}

##main_icon
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
    ##wrapper {
    padding-left: 0px;
    transition: all .4s ease 0s;
}
##sidebar-wrapper {
    left: 0px;
}
##wrapper.active {
    padding-left: 150px;
}
##wrapper.active ##sidebar-wrapper {
    left: 150px;
    width: 150px;
    transition: all .4s ease 0s;
}
}
</style>
<script>

function toggle()
{
 var t = document.getElementById('wrapper');
 if (t.className == 'active')
 t.className = ''
 else
 t.className = 'active';
}
function init()
{
load_area();
load_district();
load_dates();
load_std();

}

</script>
</head>

<body onload="init()">
<cfform>
<div id="banner" style="margin:0px auto; background: ##21435F; height:60px; color:##FFFFFF">
<input type='button' value='|||' onclick="toggle()" class='pbnobtn' style='margin:5px 15px;width:40px;height:40px;font-size:20px;float:left;transform: rotate(90deg);'>
<h1  style="margin:5px 20px;font-size:45px;float:left;"> IV</h1>
<div style='padding:10px 25px 5px 0px;'>
<span style=" font-size:20px;"> Informed Visibility </span><br>
<span  style="font-size:15px;"> The single source for all your mail visibility needs </span>
</div><br>
</div>
<!---
<div style="margin:0px auto; background: ##6F6F6F; height:15px; color:##FFFFFF">
</div>
--->



<div id="wrapper" class="">
      
      <!-- Sidebar -->
            <!-- Sidebar -->
      <div id="sidebar-wrapper">
      <ul id="sidebar_menu" class="sidebar-nav">
           <li class="sidebar-brand"><a id="menu-toggle" href="##" >Menu</a></li>
      </ul>
        <ul class="sidebar-nav" id="sidebar">     
          <li><a>Link1</span></a></li>
          <li><a>link2</a></li>
        </ul>
      </div>
          
      <!-- Page content -->
      <div id="page-content-wrapper">
        <!-- Keep all page content within the page-content inset div! -->

        
        
        <div class="page-content inset">
          <div id ="hdr" class="row" style="padding:50px; font-size:24px" >
          <cfinclude template="includes\hier.cfm">
          <br>
          <fieldset class="fset"><legend>Mail Direction</legend>  
          <select class ="slct" name="selDir" id ="selDir">
           <option value="O">Orginating</option>
           <option value="D">Destinating</option>
          </select></fieldset>
          <fieldset class="fset"><legend>Top</legend>  
          <select class ="slct" name="selTop" id ="selTop">
           <option value="10">10</option>
           <option value="25">25</option>
           <option value="50">50</option>           
           <option value="100000">All</option>
          </select></fieldset>
         <fieldset class="fset"><legend>Mailing</legend>
          <select class ="slct" name="selCert" id ="selCert">
           <option value="Y">Full Service</option>
           <option value="N">Non-Compliant</option>
           <option value="">Both</option>           
          </select></fieldset>
          <fieldset class="fset"><legend>Air/Surface</legend>
          <select class ="slct" name="selAir" id ="selAir">
           <option value="">Combined</option>           
           <option value="Y">Air</option>
           <option value="N">Surface</option>
          </select></fieldset>
          <fieldset class="fset"><legend>Mode</legend>
          <select class ="slct" name="selMode" id ="selMode">
           <option value="Y">Matrix</option>           
           <option value="N">Measured</option>
          </select></fieldset>

          <fieldset class="fset"><legend>Plants/DU-BMEU</legend>
          <select class ="slct" name="selBMEU" id ="selBMEU" onchange="load_fin()">
           <option value="">Plants & DU</option>
           <option value="P">Plants Only</option>
           <option value="D">Delv Units Only</option>           
          </select></fieldset>
          <br><br>
          <fieldset class="fset"><legend>Entry</legend> 
           <select class ="slct" name="selEOD" id ="selEOD"  onchange="load_std()">
           <option value="Y">Origin Entered</option>
           <option value="N">Destination Entered</option>
		   <option value="">All Mail</option>                      
          </select></fieldset>

          <fieldset class="fset"><legend>Class</legend>
          <select class ="slct" name="selClass" id ="selClass" onchange="load_std()">
           <option value="1">First</option>
           <option value="2">Periodicals</option>
           <option value="3">Standard</option>           
		   <option value="">All Classes</option>                      
          </select></fieldset>
          <fieldset class="fset"><legend>Service Standard</legend>
          <select class ="slct" name="selHybStd" id ="selHybStd">
           <option value="11">Overnight</option>
           <option value="12">2-3 Days</option>
           <option value="13">3-5 Days</option>           
		   <option value="">All Standard</option>                      
          </select></fieldset>
         <fieldset class="fset"><legend>Container Type</legend> 
         <cfselect class ="slct"  name="selCntrLvl" id = "selCntrLvl" query="cntr_type_q" display="code_desc_long" value="code_val" queryPosition="below">
         <option value = ''>All Containers
         </cfselect></fieldset>
          <br><br>| 
            <input class = "chk" type = "checkbox" name="cat1" id="cat1" data-label="Letters">Letters |
            <input class = "chk" type = "checkbox" name="cat3" id="cat3" data-label="Cards" >Cards |
            <input class = "chk" type = "checkbox" name="cat2" id="cat2" data-label="Flats" >Flats |
            <input class = "chk" type = "checkbox" name="selFSS" id="selFSS"  data-label="FSS Only">FSS Only |
            <input class = "chk" type = "checkbox" name="chkpol" id="chkpol"  data-label="Politcal Mailings Only" >Political Mailings Only |
            <input class ="slct" id="subtn" type = "button" value = "Submit Request" style="float:right" onClick="update_filters();load_data(); ">
          
          </div>
          <div id="rpt_filters">
          
          
          </div>
          <div id="rpt_table" style="text-align:center">
                <cfinclude template="includes\stc10.cfm">
          </div>
          
          <div id="rpt_graph" style="width:1005px; margin:0 auto";>
              
          </div>
          <div id="zip3tbl" style="width:1005px; margin:0 auto;text-align:center";>
              
          </div>

          
        </div>
      </div>
      
    </div>
</cfform>
</body>
</html>
</cfoutput>