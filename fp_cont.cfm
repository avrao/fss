<!DOCTYPE html>
<cfsetting showDebugOutput="No">
<!---<cfset selImb = '0004100011850702960530002178133'>
<cfset selContlog = 40852225>
<cfset SelJob = 1966856>
<cfset SelCrid = 4567>--->
<!---<CFDUMP VAR="#URL#">--->

<cfparam name="selStd" default="">
<cfparam name="selClass" default="">
<cfparam name="selorg3" default="">
<cfparam name="seldest3" default="">
<cfparam name="selOrgFac" default="">
<cfparam name="selImb" default="">
<cfparam name="selJob" default="">
<cfparam name="selCrid" default="">
<cfparam name="selContlog" default="">
<cfparam name="selContphy" default="">
<cfparam name="selHUlog" default="">
<cfparam name="selHUphy" default="">
<cfparam name="Excel_out" default="">
<cfparam name="dest_name" default="N">


<cfset fa = listlast(cgi.script_name,"/\")> 
<cfif Excel_out neq "" and Excel_out neq "N">	
	<cfheader name="Content-disposition" value="attachment; filename=#dateformat(now(), 'yyyy-mm-dd')#T#TimeFormat(now(), 'HH:mm:ss')##fa#.xls">	
	<cfcontent type="application/msexcel" variable="#ToBinary( ToBase64( Excel_out ) )#"> 
</cfif>

<!---   <cfif Excel_out is "Y">
   <cfheader name="Content-disposition" value="inline">
    <cfcontent type="application/vnd.ms-excel"> 
  </cfif>--->

<cfset Barcode_id = mid(selImb,1,2)>
<cfset Service_type_code = mid(selImb,3,3)>
<cfif mid(selImb,6,1) is '9'>
 <cfset mlr_id  = mid(selImb,6,9)>  
 <cfset seq_id  = mid(selImb,15,6)> 
<cfelse>  
 <cfset mlr_id  = mid(selImb,6,6)>  
 <cfset seq_id  = mid(selImb,12,9)> 
</cfif>


<cfif selOrgFac is not ''>
<cfquery name="orgFac" datasource="#opsvisdata#">
 select * from BI_facility
WHERE fac_seq_id = <cfqueryparam  value="#selOrgFac#">
</cfquery>
<cfset org_name = #orgFac.fac_name#>
</cfif>
<cfparam name="Org_Name" default=""> 

<cfif seldest3 neq ''>
<cfquery name="destq" datasource="#opsvisdata#">
select plt_fac_name
from bi_plt_area_district@p2sasp_usr
where plt_fac_zip_3=#seldest3#
</cfquery>
<cfif destq.recordcount eq 1>
<cfset dest_name = seldest3 & ' ' & destq.plt_fac_name>
<cfelse>
<cfset dest_name = seldest3>
</cfif>
</cfif>






<cfquery name="mlr_q" datasource="#opsvisdata#" timeout="20">
select mlr_name as mailer_name from bi_mailer_id@P2SASP_USR a
inner join bi_crid@P2SASP_USR b
on a.crid_seq_id = b.crid_seq_id
inner join bi_opsvis_crid@P2SASP_USR c
on C.CRID = b.crid
where mlr_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mlr_id#">
</cfquery>

<cfquery name="edoc_q" datasource="#opsvisdata#" timeout="20">
select mlr_name as mailer_name,c.crid from 
bi_crid@P2SASP_USR b
inner join bi_opsvis_crid@P2SASP_USR c
on C.CRID = b.crid
where b.crid_seq_id = <cfqueryparam  cfsqltype="cf_sql_decimal" value="#SelCrid#">
</cfquery>



<cfquery name="job_q" datasource="#opsvisdata#" timeout="20">
select  job_id,job_name_title_issue from 
bi_job@P2SASP_USR a
where job_seq_id = <cfqueryparam  cfsqltype="cf_sql_decimal" value="#selJob#">
</cfquery>



<cfif selContLog is not ''>
<cfquery name="Cntr_q" datasource="#opsvisdata#" timeout="20">
 select distinct a.phys_CONTR_SEQ_ID,a.IMCB_CODE,y.Start_the_clock_date,a.critical_entry_time,y.actual_entry_datetime,y.start_the_clock_source, 
a.schd_ship_datetime,a.scan_datetime,
case when a.ep_lcle_key is null or upper(a.ep_lcle_key) = 'ORIGIN' THEN  a.epfed_pstl_code ELSE a.ep_lcle_key end as ep,
c.FAC_NAME,
b.code_desc as induct_code_desc, b.code_desc_long as induct_code_desc_long,
a.EXCL_STS_CODE,
e.code_desc as src_code_desc,e.code_desc_long as src_code_desc_long,a.appt_id,EPFED_CONSLN_SHORT_DESC,
f.CODE_DESC_long as cont_lvl,
sf.facility_desc
from 
bi_physical_container@P2SASP_USR a
LEFT join
 V_MSTR_REL_EPFED_CONSLN@P2SASP_USR VR
  on a.EPFED_FAC_TYPE_CODE = VR.EPFED_FAC_TYPE_CODE
LEFT join 
V_MSTR_LU_EPFED_CONSLN@P2SASP_USR VC
on VR.EPFED_FAC_TYPE_CONSLN_CODE  = VC.EPFED_FAC_TYPE_CONSLN_CODE 
inner join
 bi_logical_container@p2sasp_USR  y
on a.logical_contr_seq_id = y.logical_contr_seq_id
left join 
bi_app.BI_SPM_GROUP_CTRL@p2sasp_usr grp
on y.spm_grp_seq_id =grp.spm_grp_seq_id
left join v_mstr_facility sf
on grp.ORGN_FAC_SEQ_ID = sf.fac_seq_id
left join bi_code_value@P2SASP_USR b
on a.INDCTN_MTHD = b.code_val and b.code_type_name = 'INDCTN_MTHD'
left join bi_facility@P2SASP_USR c
on a.ep_fac_seq_id = c.fac_seq_id
left join bi_plt_area_district@P2SASP_USR d
on substr(a.ep_pstl_code,1,3) = d.PLT_FAC_ZIP_3
left join bi_code_value@P2SASP_USR e
on y.START_THE_CLOCK_SOURCE = e.code_val and e.code_type_name = 'START_THE_CLOCK_SOURCE'
 LEFT JOIN bi_code_value@P2SASP_USR f
  ON a.CONTR_LVL_CODE = f.code_val AND f.code_type_name = 'CONTR_LVL_CODE'


where 
a.logical_CONTR_SEQ_ID = <cfqueryparam  cfsqltype="cf_sql_decimal" value="#selContLog#">

</cfquery>

<cfelse>

<cfquery name="Cntr_q" datasource="#opsvisdata#" timeout="20">
 select distinct a.phys_CONTR_SEQ_ID,a.IMCB_CODE,a.Start_the_clock_date,a.critical_entry_time,a.actual_entry_datetime,a.start_the_clock_source, 
a.schd_ship_datetime,a.scan_datetime,
case when a.ep_lcle_key is null or upper(a.ep_lcle_key) = 'ORIGIN' THEN  a.epfed_pstl_code ELSE a.ep_lcle_key end as ep,
c.FAC_NAME,
b.code_desc as induct_code_desc, b.code_desc_long as induct_code_desc_long,
a.EXCL_STS_CODE,
e.code_desc as src_code_desc,e.code_desc_long as src_code_desc_long,a.appt_id,EPFED_CONSLN_SHORT_DESC,
f.CODE_DESC_long as cont_lvl,
sf.facility_desc
from 
bi_physical_container@P2SASP_USR a
inner join 
bi_app.BI_SPM_GROUP_CTRL@p2sasp_usr grp
on a.spm_grp_seq_id =grp.spm_grp_seq_id
left join v_mstr_facility sf
on grp.ORGN_FAC_SEQ_ID = sf.fac_seq_id
LEFT join
 V_MSTR_REL_EPFED_CONSLN@P2SASP_USR VR
  on a.EPFED_FAC_TYPE_CODE = VR.EPFED_FAC_TYPE_CODE
LEFT join 
V_MSTR_LU_EPFED_CONSLN@P2SASP_USR VC
on VR.EPFED_FAC_TYPE_CONSLN_CODE  = VC.EPFED_FAC_TYPE_CONSLN_CODE 
left join bi_code_value@P2SASP_USR b
on a.INDCTN_MTHD = b.code_val and b.code_type_name = 'INDCTN_MTHD'
left join bi_facility@P2SASP_USR c
on a.ep_fac_seq_id = c.fac_seq_id
left join bi_plt_area_district@P2SASP_USR d
on substr(a.ep_pstl_code,1,3) = d.PLT_FAC_ZIP_3
left join bi_code_value@P2SASP_USR e
on a.START_THE_CLOCK_SOURCE = e.code_val and e.code_type_name = 'START_THE_CLOCK_SOURCE'
 LEFT JOIN bi_code_value@P2SASP_USR f
  ON a.CONTR_LVL_CODE = f.code_val AND f.code_type_name = 'CONTR_LVL_CODE'
where
<cfif trim(selContPhy) neq ''>
a.phys_CONTR_SEQ_ID = <cfqueryparam  cfsqltype="cf_sql_decimal" value="#selContPhy#">
<cfelse>
a.phys_CONTR_SEQ_ID = <cfqueryparam  cfsqltype="cf_sql_decimal" value="0">
</cfif>
</cfquery>
</cfif>


<cfparam name="cntrlist" default="">
<cfset cntrlist = valuelist(cntr_q.phys_CONTR_SEQ_ID,',')>


<cfif cntrlist is not ''>
<cfquery name="CntrScan_q" datasource="#opsvisdata#" timeout="20">
 select distinct ac.PHYS_CONTR_SEQ_ID,nvl(ac.scan_site_id,ac.unit_zip_code) as scan_site_id ,c.code_desc as scan_desc,s.code_desc as scan_src_desc, 
SCAN_DATETIME,appt_id
from BI_ASSOCD_CONTAINER_SCAN@p2sasp_usr ac
left join bi_code_value@p2sasp_usr c
on c.code_type_name = 'SCAN_TYPE'
and ac.SCAN_TYPE = c.code_val
left join bi_code_value@p2sasp_usr s
on s.code_type_name = 'SCAN_SOURCE'
and ac.SCAN_SOURCE = s.code_val
where PHYS_CONTR_SEQ_ID in (#cntrlist#)
ORDER BY  ac.PHYS_CONTR_SEQ_ID,ac.SCAN_DATETIME
</cfquery>

</cfif>




<cfquery name="TRAY_Q" datasource="#opsvisdata#" timeout="20">
 select a.imtb_code,a.START_THE_CLOCK_DATE,CRITICAL_ENTRY_TIME,actual_ENTRY_dateTIME,
SCHD_INDCTN_DATETIME,FAC_NAME, EXCL_STS_CODE,  
b.code_desc as induct_code_desc, b.code_desc_long as induct_code_desc_long,
case when a.ep_lcle_key is null or upper(a.ep_lcle_key) = 'ORIGIN' THEN  a.epfed_pstl_code ELSE a.ep_lcle_key end as ep,
huc.code_desc as code_desc, NVl(NVL(hu.SCAN_SITE_ID,HU.ORGN_ZIP_5),hu.UNIT_ZIP_CODE) as SCAN_SITE_ID,s.code_desc as s_src,c.code_desc as c_type ,hu.DEVICE_ID,hu.LOCAL_SCAN_DATETIME
from bi_app.bi_physical_hu@p2sasp_usr a
left join
bi_hu_cin_code@p2sasp_usr huc 
on a.HU_LBL_CIN_CODE = HUC.CODE_CIN
left join bi_code_value@P2SASP_USR b
on a.INDCTN_MTHD = b.code_val and b.code_type_name = 'INDCTN_MTHD'
left join bi_facility@P2SASP_USR f
on a.ep_fac_seq_id = f.fac_seq_id
left join bi_app.BI_ASSOCD_HU_SCAN@p2sasp_usr hu
on a.mailg_seq_id = hu.mailg_seq_id   and a.job_Seq_id = hu.job_seq_id and a.PHYS_HU_SEQ_ID = hu.PHYS_HU_SEQ_ID
 AND a.mailg_date = hu.mailg_date
left join bi_code_value@p2sasp_usr c
on c.code_type_name = 'SCAN_TYPE'
and hu.SCAN_TYPE = c.code_val
left join bi_code_value@p2sasp_usr s
on s.code_type_name = 'SCAN_SOURCE'
and hu.SCAN_SOURCE = s.code_val
where
<cfif selhuLog is not ''>
 a.LOGICAL_hu_SEQ_ID = <cfqueryparam  cfsqltype="cf_sql_decimal" value="#selHuLog#">
<cfelseif selhuphy is not ''>
 a.PHYS_hu_SEQ_ID =    <cfqueryparam  cfsqltype="cf_sql_decimal" value="#selHuPhy#">
<cfelse> 
 a.PHYS_hu_SEQ_ID = 0
</cfif>
 order by a.imtb_code, LOCAL_SCAN_DATETIME
</cfquery>



<SCRIPT>

  function getCoord(obj, offsetLeft, offsetTop){
      var orig = obj;
      var left = 0;
      var top = 0;
      if(offsetLeft) left = offsetLeft;
      if(offsetTop) top = offsetTop;
      if(obj.offsetParent){
            left += obj.offsetLeft;
             top += obj.offsetTop;
            while (obj = obj.offsetParent) {
       //              left += (obj.offsetLeft-obj.scrollLeft+obj.clientLeft);
       //              top += (obj.offsetTop-obj.scrollTop+obj.clientTop);
                     left += (obj.offsetLeft+obj.clientLeft);
                     top += (obj.offsetTop+obj.clientTop);
             }
       }
      return {left:left, top:top, width: orig.offsetWidth, height: orig.offsetHeight};
   }





function hide_msg(){
document.getElementById("msg").style.display='none';
document.getElementById("msg").style.left=0;
document.getElementById("msg").style.top=0;
document.getElementById("msg").style.width= 1+'px';
document.getElementById("msg").style.height =1+'px';
document.getElementById("msg").innerHTML="" ;
}


function show_msg(ev,v,txt,w,r){
  //pos = getCoord(v);
//alert(w);

document.getElementById("msg").style.height ='';
if (txt.length == 5)
{

   if (aryfac[txt] == undefined)
    txt = 'Not in Facility Table'
	else
	txt = aryfac[txt].replace('&','&amp;');	
}
	
if (r && false)
 document.getElementById("msg").style.left=ev.clientX+ r +  'px'
else
  document.getElementById("msg").style.left=ev.clientX+ 25 +  'px';
document.getElementById("msg").style.top=ev.clientY + 'px';
if (w)
 document.getElementById("msg").style.width= w+'px';
else
 document.getElementById("msg").style.width= 250+'px';
document.getElementById("msg").innerHTML=txt;
if (document.body.clientHeight-ev.clientY < document.getElementById("msg").clientHeight)
 document.getElementById("msg").style.top=ev.clientY - document.getElementById("msg").clientHeight + 'px';
document.getElementById("msg").style.display='inline';
//alert(document.getElementById("msg").clientHeight);
}


function submitExcel(elementParentId)
{
	var output = document.getElementById(elementParentId);
	document.getElementById('Excel_out').value = output.innerHTML;
	document.out_form.method = "post";
	document.out_form.submit();
	document.getElementById('Excel_out').value="";	
}

/*function exc()
{
	document.out_form.Excel_out.value = 'Y';
	document.out_form.submit(); 
}*/

function print_it()
{
document.getElementById('p').style.display='none';	
document.getElementById('e').style.display='none';	
window.print();
document.getElementById('p').style.display='inline'	
document.getElementById('e').style.display='inline'	
}

</SCRIPT>


<cfscript>

function src(x,y)
{
 var srcdesc = ''; 		
switch(x)
{
case '1': if (y is 1) srsdesc ='SV UNLD SCAN DATETIME'; else srsdesc ='SV CONTAINER UNLOAD SCAN'; break;
case '2': if (y is 1) srsdesc ='FIRST IMD SCAN DATETIME'; else srsdesc ='IM-DAS SCAN DATE/TIME'; break;
case '3': if (y is 1) srsdesc ='FAST APPT UNLD SCAN DATETIME'; else srsdesc ='FAST APPOINTMENT TRAILER UNLOAD SCAN START DATETIME'; break;
case '4': if (y is 1) srsdesc ='FAST ACT APPT DATETIME'; else srsdesc ='FAST ACTUAL APPOINTMENT DATE/TIME'; break;
case '5': if (y is 1) srsdesc ='FAST SCHD APPT DATETIME'; else srsdesc ='FAST SCHEDULED APPOINTMENT DATE/TIME'; break;
case '6': if (y is 1) srsdesc ='PO! POSTG STMT ARR DATETIME'; else srsdesc ='POSTAGE STATEMENT CHECK IN FROM POSTALONE!'; break;
case '7': if (y is 1) srsdesc ='EDOC SCHD INDCTN DATETIME'; else srsdesc ='EDOC SCHEDULED INDUCTION DATE/TIME'; break;
case '8': if (y is 1) srsdesc ='EDOC SCHD SHIP DATETIME'; else srsdesc ='EDOC SCHEDULED SHIP DATE/TIME'; break;                  
default: if (y is 1) srsdesc ='UNKNOWN'; else srsdesc ='UNKNOWN';

}
return srsdesc;
}
	
	






function nvl(x) 
{ 
if (x is '')
return '&nbsp;';
else
return  x;
}

function cls(c)
{
 var desc = ''; 	
 switch(c)
{
   case '1':desc = 'First Class'; break;
   case '2':desc = 'Periodicals'; break;
   case '3':desc = 'Standard'; break;   	
   case '4':desc = 'Parcels'; break;   		
   default: desc = 'Unknown';  
}
return desc;
}

</cfscript>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!---
<title>Container-Tray Detail</title>
--->
<title><cfoutput>IMb:#selimb#</cfoutput></title>

<link rel="stylesheet" type="text/css" href="styles/CommonStyleSheet.css">
<link rel="stylesheet" type="text/css" href="styles/d3styles.css">
<script language="javascript" src="jscripts/Lance.js"></script>
</head>

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

.pbTable {
	font-size:12px;
}

.oddRec td{
	background: #CCC;
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
	
</script>

<body style="margin:0px;" onload="window.focus()">
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
      <div id="page-content-wrapper" style="width:850px">
<br>
<div>
<!---<cfif excel_out is 'N'>--->
<span id = "p" style="float:left;color:blue; text-decoration:underline;cursor:pointer" onClick="print_it()">Print</span>
<span id = "e" style="float:Right;color:blue; text-decoration:underline;cursor:pointer" onClick="submitExcel('excelCont')">Excel</span>
<!---</cfif>--->
<h3 style="text-align: center;postion:relative; top:-10px; COLOR:BLUE">CONTAINER-TRAY DETAILED INFORMATION</h3>

</div>
<div id="excelCont">
<table class='pbTable' style="margin: 0px auto;">
<caption>PIECE LEVEL INFORMATION</caption>
<thead>
<tr>
<th>IMb CODE</th>
<th>MAILER ID</th>
<th>MAILER NAME</th>
<th>SEQUENCE ID</th>
<th>JOB ID</th>
<th>JOB NAME</th>
<th>EDOC CRID</th>
<th>EDOC NAME</th>
</tr>
</thead>
<cfoutput>
<tbody>
<tr>
<td style="mso-number-format:\@">#SelImb#</td>
<td >#mlr_id#</td>
<td >#nvl(mlr_q.mailer_name)#</td>
<td >#seq_id#</td>
<td >#job_q.job_id#</td>
<td >#job_q.job_name_title_issue#</td>
<td >#EDOC_q.crid#</td>
<td >#EDOC_q.mailer_name#</td>
</tr>
</tbody>
</cfoutput>
</table>
<table class='pbTable' style="margin: 0px auto;">
<thead>
<tr>
<th>CLASS</th>
<th>STANDARD</th>
<th>ORIGINATING</th>
<th>DESTINATING</th>
</tr>
</thead>
<tbody>
<cfoutput>
<tr>
<td >#cls(selClass)#</td>
<td >#selStd#</td>
<td >#selorg3# #org_name#</td>
<td >#dest_name#</td>
</tr>
</cfoutput>
</tbody>
</table>

<table class='pbTable' style="margin: 0px auto;">
<caption>CONTAINER LEVEL INFORMATION</caption>
<thead>
<TR>
<th >CONTAINER BARCODE</th>
<th>STC DATE</th>
<th>STC USED</th>
<th>STC FACILITY</th>
<th>CET</th>
<th>ACTUAL ENTRY DATE</th>
<th>INDUCTION METHOD</th>
<th>SHIP DATE</th>
<th>SCAN DATE</th>
<th >ENTRY POINT</th>
<th>ORIGIN FACILITY</th>
<!---<th>EXCLUSION</th>--->
<th>FAST APPT ID</th>
<th>ENTRY TYPE</th>
<th>CNTR LVL TYPE</th>
</TR>
</thead>
<tr>
<cfif Cntr_q.recordcount neq 0>
<cfoutput query="Cntr_q">
<tbody>
<TR>
<td style="mso-number-format:\@">#IMCB_CODE#</td>
<td >#nvl(DATEFORMAT(Start_the_clock_date,'MM/DD/YYYY'))#</td>
<!---<td style = "color:blue"><a onMouseOver="javascript:show_msg(event,this,'#src_code_desc_long#',250,40)"
             onmouseout="javascript:hide_msg()" >#nvl(replace(replace(src_code_desc,'_',' ','All'),'NIM','IMD','ALL'))#</a></td>--->
           
<td style = "color:blue"><a onMouseOver="javascript:show_msg(event,this,'#src(start_the_clock_source,2)#',250,40)"
             onmouseout="javascript:hide_msg()" >#nvl(src(start_the_clock_source,1))#</a></td>
<td >#nvl(facility_desc)#</td>             
<td >#nvl(critical_entry_time)#
<td >#nvl(DATEFORMAT(actual_entry_datetime,'MM/DD/YYYY'))# #timeFORMAT(actual_entry_datetime,'HH:mm')#</td>
<td style = "color:blue">
<a onMouseOver="javascript:show_msg(event,this,'#replace(induct_code_desc_long,'usps','USPS','All')#',250,40)"
             onmouseout="javascript:hide_msg()" >#nvl(induct_code_desc)#</a></td>
<td >#nvl(DATEFORMAT(schd_ship_datetime,'MM/DD/YYYY'))# #timeFORMAT(schd_ship_datetime,'HH:mm')#</td>
<td >#nvl(DATEFORMAT(scan_datetime,'MM/DD/YYYY'))# #timeFORMAT(scan_datetime,'HH:mm')#</td>
<td style="mso-number-format:\@">#nvl(ep)#</td>
<td >#nvl(FAC_NAME)#</td>
<!---<td ><CFIF EXCL_STS_CODE IS ''>N<cfelse>Y</CFIF></td>--->
<td >#NVL(APPT_ID)#</td>
<td >#NVL(EPFED_CONSLN_SHORT_DESC)#</td>
<td >#NVL(cont_lvl)#</td>
</tr>
</tbody>
<cfquery dbtype="query" name = "scanlist">
select * from
CntrScan_q
where PHYS_CONTR_SEQ_ID = #PHYS_CONTR_SEQ_ID# 
</cfquery>
<cfif scanlist.recordcount neq 0>
<tr>
<td colspan = 13 style = "border-bottom-width:4px">
<table class='pbTable' cellspacing="0" cellpadding="0" style="margin:0 auto">
<thead>
<TR>
<tH style="border:none">Container Scan Records</tH>
<th>Site ID</th>
<th >Scan Type</th>
<th >Scan Source</th>
<th>Scan Date</th>
<th>APPT ID</th>
</TR>
</thead>
<tbody>
<cfloop query="scanlist">
<tr>

<td></td>
<td>#nvl(scan_site_id)#</td>
<td>#nvl(scan_desc)#</td>
<td>#nvl(scan_src_desc)#</td>
<td>#nvl(DATEFORMAT(scan_datetime,'MM/DD/YYYY'))# #timeFORMAT(scan_datetime,'HH:mm')#</td>
<td>#nvl(appt_id)#</td>
</tr>
</td>
</cfloop>
</tbody>
</table>
</tr>
</cfif>
</cfoutput>
<cfelse>
<td colspan = 11>
<B>Orphan Handling Unit:</B> This piece is not associated with any container-level induction information.
</td>
</cfif>
</table>



<cfif Cntr_q.recordcount neq 0>
<table class='pbTable' style="margin: 0px auto;">
<caption>TRAY LEVEL INFORMATION</caption>
<thead>
<TR>
<th>TRAY BARCODE</th>
<th>TRAY (CIN) TYPE</th>
<th>SITE ID</th>
<th>SCAN TYPE</th>
<th>SCAN SOURCE</th>
<th>SCAN DATE</th>
<th>DEVICE ID</th>
</TR>
</thead>
<tbody>
<cfset imtb = ''>
<cfset ex = "style='background-color:none'">
<cfoutput query="tray_q">
<cfif COMPARE(imtb_code,imtb) neq 0 and currentrow gt 1>
<cfif ex  eq "style='background-color:none'"><cfset ex = "style='background-color:yellow'"><cfelse><cfset ex = "style='background-color:none'"></cfif> 
</cfif>
<cfset imtb = IMTB_CODE>
<TR>
<td #ex# style="mso-number-format:\@">#nvl(IMTB_CODE)#</td>
<td #ex# >#nvl(code_desc)#</td>
<td #ex# title='#fac_name#'>#nvl(scan_site_id)#</td>
<td #ex#>#nvl(c_type)#</td>
<td #ex#>#nvl(s_src)#</td>
<td #ex#>#nvl(DATEFORMAT( LOCAL_SCAN_DATETIME,'MM/DD/YYYY'))# #timeFORMAT( LOCAL_SCAN_DATETIME,'HH:mm')#</td>
<td #ex#>#nvl(device_id)#</td>
</TR>
</cfoutput>
</tbody>
</table>
<cfelse>
<!---**************--->
<table class='pbTable'  style="margin: 0px auto;">
<caption>TRAY LEVEL INFORMATION</caption>
<thead>
<TR>
<th>TRAY BARCODE</th>
<th>STC DATE</th>

<th>CET</th>
<th>ACTUAL ENTRY DATE</th>
<th>INDUCTION METHOD</th>
<th>INDUCTION DATE</th>
<th >ENTRY POINT</th>
<th>ORIGIN FACILITY</th>
<!---<th>EXCLUSION</th>--->
<th>TRAY (CIN) TYPE</th>
<th>SITE ID</th>
<th>SCAN DATE</th>
</TR>
</thead>
<tr>
<tbody>
<cfoutput query="tray_q">
<TR>
<td style="mso-number-format:\@">#nvl(IMTB_CODE)#</td>
<td >#nvl(DATEFORMAT(Start_the_clock_date,'MM/DD/YYYY'))#</td>
<td >#nvl(critical_entry_time)#</td>
<td >#nvl(DATEFORMAT(actual_entry_datetime,'MM/DD/YYYY'))# #timeFORMAT(actual_entry_datetime,'HH:mm')#</td>
<td style = "color:blue">
<a onMouseOver="javascript:show_msg(event,this,'#replace(induct_code_desc_long,'usps','USPS','All')#',250,40)"
             onmouseout="javascript:hide_msg()" >#nvl(induct_code_desc)#</a></td>

<td >#nvl(DATEFORMAT(SCHD_INDCTN_DATETIME,'MM/DD/YYYY'))#</td>
<td style="mso-number-format:\@">#nvl(ep)#</td>
<td >#nvl(FAC_NAME)#</td>
<!---<td ><CFIF EXCL_STS_CODE IS ''>N<cfelse>Y</CFIF></td>--->
<td >#nvl(code_desc)#</td>
<td> #nvl(scan_site_id)#</td>
<td>#nvl(DATEFORMAT( LOCAL_SCAN_DATETIME,'MM/DD/YYYY'))# #timeFORMAT( LOCAL_SCAN_DATETIME,'HH:mm')#</td>
</tr>
</cfoutput>
</tbody>
</table>

</cfif>
</div>

<div id='msg'
style='position:absolute;left:0;top:0;width:0;height:0;border:1px solid
black;background-color:white;display:none;padding:5px'></div>

</div>
<cfform name="out_form">
<cfoutput>
<input type = "hidden" name="selImb" value ='#selimb#' />
<input type = "hidden" name="selJob" value ='#selJob#' />
<input type = "hidden" name="selCrid" value ='#selCrid#' />
<input type = "hidden" name="selContlog" value ='#selContlog#' />
<input type = "hidden" name="selContphy" value ='#selContphy#' />
<input type = "hidden" name="selHUlog" value ='#selHUlog#' />
<input type = "hidden" name="selHUphy" value ='#selHUphy#' />
<input type = "hidden" id="Excel_out" name="Excel_out" value ='' />
</cfoutput>
</cfform>
</body>
</html>