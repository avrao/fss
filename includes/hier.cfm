
<cfoutput>
<cfquery name="cntr_type_q" datasource="#opsvisdata#">
select code_val,code_desc_long
 from  bi_code_value 
 where  CODE_TYPE_NAME ='CONTR_LVL_CODE'
 and code_val != '-1'
 order by code_desc_long
</cfquery>


<cfquery name="hier_q" datasource="#opsvisdata#">
select * from areadistname_t
where area_id not in ('4N','4M')
order by area_name,district_name
</cfquery>

<style>
.slct {
    font-size:16px;
  line-height: 1.3333333;
    padding: 10px 16px;
    margin: 0px 3px;
    -webkit-border-radius:6px;
    -moz-border-radius:6px;
    border-radius:6px;
    -webkit-box-shadow: 0 3px 5px ##cFcFcF;
    -moz-box-shadow: 0 3px 5px ##cFcFcF;
    box-shadow: 0 3px 5px ##cFcFcF;
   background-image: linear-gradient(to bottom, ##ffffff, ##C0C0C0);
   background-image: -ms-linear-gradient(top, ##ffffff 0%, ##C0C0C0 100%);   
    /*border:solid  gray 1px;*/
	
	/*background-color: buttonface;*/
    box-sizing: border-box;

    border: 2px outset buttonface;
}

.chk {
transform: scale(2);
-webkit-transform: scale(2);
margin-right:10px; !important;
}
.fset
{
	display:inline-block;
	border:none;
	padding:0px;
	margin:0px;	
	font-size:20px;	
	
}

</style>




<script>
var area_hier = [];
var dist_hier = [];
var  tmp = '';
<!--<cfloop query="hier_q">-->

if (tmp != '#area_id#')
{
  var ar = [];	
  ar.push('#area_id#');
  ar.push('#area_name#');  
  area_hier.push(ar);
  tmp = '#area_id#';
}

  var ar = [];	
  ar.push('#area_id#');  
  ar.push('#district_id#');
  ar.push('#district_name#');  
  dist_hier.push(ar);


<!--</cfloop>-->



function load_area()
{
var i = 0;
var sel = document.getElementById('selArea');
if (sel) 
 {
	 
    var ar = document.getElementById('selArea').options;
    ar[ar.length]= 	new Option('NATIONAL','HQ');  	
    for (i=0;i<area_hier.length;i++)
     {
         ar[ar.length]= 	new Option(area_hier[i][1],area_hier[i][0]);  
     }
 }
}


function load_district()
{
var i = 0;
var selectedArea = document.getElementById('selArea')
var selectedAreaidx = (selectedArea)?selectedArea.selectedIndex:0;
var selectedAreaval = (selectedArea)?selectedArea[selectedAreaidx].value:null; 
var sel = document.getElementById('selDistrict');
if (sel) 
 {
    var ar = document.getElementById('selDistrict').options;
	sel.length = 0;
    ar[ar.length]= 	new Option('ALL DISTRICTS','');  		
    for (i=0;i<dist_hier.length;i++)
     {
        if(dist_hier[i][0] == selectedAreaval  || selectedAreaval == 'HQ')
		 {
             ar[ar.length]= 	new Option(dist_hier[i][2],dist_hier[i][1]);  
		  	 
		 }
		 
     }
  }
}

	function fin_ret(res)
	{

      var sel=document.getElementById('selFacility')
	  sel.length=0;
	  for (var i=0;i<res.length;i++)
	  {
		if(i==0)
		{
		  var opt = document.createElement('option');
		  opt.value = 'All';
		  opt.innerHTML = 'All Facilities';
		  sel.appendChild(opt);
		}
		  
       var opt = document.createElement('option');
       opt.value = res[i][0];
       opt.innerHTML = res[i][1];
    	sel.appendChild(opt);
	  }
	  sel.disabled=false;
		
	}


	function fin_err(res)
	{
		alert(res);
	}

function get_val(v)
{
 var sel=document.getElementById(v);
 return sel.options[sel.selectedIndex].value; 
}

function get_checkmark(v)
{
 var sel=document.getElementById(v);
 return (sel.checked)? 'Y' : '';
}



function loading(v)
{
     var sel=document.getElementById(v);
 	  sel.disabled=true;
	  sel.length=0;
	  var opt = document.createElement('option');
	  opt.value = '';
      opt.innerHTML = 'Loading';
	  sel.appendChild(opt);
 }

function get_dt_rng(d,r)
{
 var dt = new Date(d)
 var dt_str = '';
 if (r=='Week')
  dt = (dt.year,dt.month,dt.day+6);
 if (r=='Mon') 
  dt = (dt.year,dt.month+1,-1); 
 if (r=='Qtr')  
  dt = (dt.year,dt.month+3,-1);  
alert(dt);  
 return sel.options[sel.selectedIndex].value; 
}

function get_cat()
{
 var ar = [];
 var list = document.getElementsByTagName('input')
 for (var i = 0;i<list.length;i++)
  {
	if (list[i].id.substr(0,3) == 'cat')
	 if (list[i].checked)
    	 ar.push(list[i].id.substr(3)); 
  }
   	
 return	 ar.toString();
}

function load_fin()
{
loading('selFacility');
var e=new top10();
var bg = get_val('selDate');
var a = get_val('selArea');
var d = get_val('selDistrict');
var c = get_val('selClass');
var s = get_cat();
var r = get_val('selRange');
var p = get_val('selBMEU');

  e.setCallbackHandler(fin_ret);	
  e.setErrorHandler(fin_err);
  e.getFac('#opsvisdata#',bg,a,d,r,p);
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
	load_fin();	
	}


	function date_err(res)
	{
		alert(res);
	}

function load_dates()
{

var e=new top10();
var r = get_val('selRange');

  e.setCallbackHandler(date_ret);	
  e.setErrorHandler(date_err);
  e.getdates('#opsvisdata#',r);
}


function std_ret(res)
	{

      var sel=document.getElementById('selHybStd')
	  sel.length=0;
	  for (var i=0;i<res.length;i++)
	  {
       if (i==0)
	   {
         var opt = document.createElement('option');
         opt.value = '';
         opt.innerHTML = 'All Standards';
    	  sel.appendChild(opt);
	   }
       var opt = document.createElement('option');
       opt.value = res[i][0];
       opt.innerHTML = res[i][1];
    	sel.appendChild(opt);
	  }
	  sel.disabled=false;
		
	}


	function std_err(res)
	{
		alert(res);
	}

function load_std()
{

var e=new top10();
var c = get_val('selClass');
var eod = get_val('selEOD');

  e.setCallbackHandler(std_ret);	
  e.setErrorHandler(std_err);
  e.getHybStd('#opsvisdata#',c,eod);
}






</script>
<div >
        <fieldset class="fset"><legend>Reporting Period</legend> <select name="selRange" id= "selRange" class="slct" >
        <option value="Week">Week</option>
        <option value="Mon">Month</option>
        <option value="Qtr">Quarter</option>        
        </select></fieldset>
        <fieldset class="fset"><legend>Date</legend> <select name="selDate" id= "selDate" class="slct" style="min-width:100px"></select></fieldset>
        <fieldset class="fset"><legend>Area</legend>  <select name="selArea" id= "selArea" class="slct" ></select></fieldset>
        <fieldset class="fset"><legend>District</legend>  <select name="selDistrict" id= "selDistrict" class="slct"></select> </fieldset>
        <fieldset class="fset"><legend>Facility</legend>  <select name="selFacility" id= "selFacility" style="min-width:200px"  class="slct"></select>   </fieldset>      
</div>



<script>
d3.select('##selArea')
.on('change',load_district);
d3.select('##selDistrict')
.on('change',load_fin);
var x = d3.select('##selRange')
.on('change',load_dates);

</script>

</cfoutput>