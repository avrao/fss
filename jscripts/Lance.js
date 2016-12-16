function scroll_tbl(t,h)
{
/*
 Uses thead,tbody,tfooter in a yable to create a scrolling table.
 expects that all rows are contained within one of the above categories	
 Currently only sets widths in one row of the tbody, which may case an error if colspan is used (assuming speed may be an issue with large tables
 Current arguments are table id (required) and  height (optional) defaults to 400px 

*/	
h=(!h)?400:h;
var table_id=document.getElementById(t);
if(table_id == null)
{alert('Table id not Found--Usage scroll_tbl(table_id,height)'); return false; 
}

var loc=document.getElementById(t).parentNode;
 function pd(v)
 {
  	 var x = 0;
	 if (window.getComputedStyle)
		x=parseInt(window.getComputedStyle(v,null).paddingLeft,10)+parseInt(window.getComputedStyle(v,null).paddingRight,10)//+parseInt(window.getComputedStyle(v,null).borderLeftWidth,10)+parseInt(window.getComputedStyle(v,null).borderRightWidth,10)
	 else
	 if (v.currentStyle)
		x= parseInt(v.currentStyle.paddingLeft,10)+parseInt(v.currentStyle.paddingRight,10); //+parseInt(v.currentStyle.borderLeftWidth,10)+parseInt(v.currentStyle.borderRightWidth,10);
	if (isNaN(x))
 	 x = 0;
	return x;	
 }
var ar=[];
var tar=[];
var tbar=[];
var test=[];
var i=0;
var c=0;
var r=0;
var w=0;
var b=0;

ar[i]=document.getElementById(t).getElementsByTagName('thead')[0];	
i += (ar[i])?1:0;
ar[i]=document.getElementById(t).getElementsByTagName('tbody')[0];	
b= (ar[i])?i:0;
i += (ar[i])?1:0;
ar[i]=document.getElementById(t).getElementsByTagName('tfoot')[0];	

if (ar[b]==null)
 {
    alert('Must hAve at least  tbody to use function'); 
    return false;
 }
for (var ttt=0;ttt<2;ttt++)
{
for (i=0;i<ar.length;i++)
{
 if (ar[i])	
  {
    var tr=ar[i].getElementsByTagName('tr');
	trl = (i==1)?1:tr.length;
	for (r=0;r<trl;r++)
	 {
       var td=tr[r].getElementsByTagName('td');
	   if (td.length==0) 
        td=tr[r].getElementsByTagName('th');
	  for (c=0;c<td.length;c++)
    	 {
		  if (td[c].clientWidth-pd(td[c]) > 0) 	 
  	       td[c].style.width=td[c].clientWidth-pd(td[c])+'px';
		  
	      test.push(td[c].offsetWidth);
    	  if (i==1 && r==0 && ttt==0)
	       w+=td[c].offsetWidth;
		  }
	 }
  } 
}
//	  prompt('ok',test);
//	  test.length=0;
}

for (i=0;i<ar.length;i++)
{
  if (ar[i])		
   {
     tar[i] = document.createElement('table');
     tbar[i]= document.createElement('tbody');
     tar[i].appendChild(tbar[i]);
     var tr=ar[i].getElementsByTagName('tr');
     for (var r=0;tr.length>0;r++)
      tbar[i].appendChild(tr[0]);
   }
}

var ld = document.createElement('div');
ld.style.textAlign="left";
 for (var i=0;i<tar.length;i++)
 {
 tar[i].cellSpacing=0;
 tar[i].cellPadding=0;
// tar[i].style.width=w+'px';
 if(i==b)
  {
	var d = document.createElement('div');
	d.style.height=h+"px";
	d.style.overflow='auto';
	d.appendChild(tar[i]); 
	d.style.width=w+20+'px';
    ld.appendChild(d);  		 	

  }
 else 
  ld.appendChild(tar[i]);  	
 }
 ld.style.width=w+25+'px';
 loc.appendChild(ld);

}



function createGuid()
{
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random()*16|0, v = c === 'x' ? r : (r&0x3|0x8);
        return v.toString(16);
    });
}





function msg_div(t,m)
{

var i = 0;	
var w = 0;
var mousedown=0;
var x = 0;
var y= 0;
var ar = m.split('\n');
for (i=0;i<ar.length;i++) 
  w = (ar[i].length > w)?ar[i].length:w;

function rm (id)
 {
  var n = document.getElementById(id);
  n.parentNode.removeChild(n);	 
 }
function mouse(e,id,v) 
{
//  var n = document.getElementById(id).getElementsByTagName('div')[0]; 	
//  var n1 = document.getElementById(id); 	
//  n.innerHTML = e.clientY+' '+e.clientX+' '+e.offsetY+' '+e.offsetX+' '+n1.offsetTop+' '+n1.offsetLeft;
 if (v == 1)
 {x=e.clientX;
  y=e.clientY;
 }
 mousedown=v;
}
function move(e,id) 
{

if (mousedown==1 && document.elementFromPoint(e.clientX,e.clientY).id==id)	
{
	
//  var n0 = document.getElementById(id).getElementsByTagName('div')[0]; 	
//  var n1 = document.getElementById(id); 	
//  n0.innerHTML = (e.clientY-y)+' '+e.clientX+' '+e.offsetY+' '+e.offsetX+' y-'+n1.offsetTop+' '+n1.offsetLeft+' '+y+' '+x;
	
  var n = document.getElementById(id);		
   //n.onmousemove= '';
   n.style.top = (e.clientY-y)+n.offsetTop+'px';	
   n.style.left = (e.clientX-x)+n.offsetLeft+'px';
   y=e.clientY;
   x=e.clientX;
//   n.onmousemove= function(){move(event,msgbox.id);}
}
}

var msgbox=document.createElement('div');
msgbox.id = createGuid();
msgbox.style.border='1px solid black';
msgbox.style.position='absolute';
msgbox.onmousedown = function(){mouse(event,msgbox.id,1);}
msgbox.onmouseup = function(){mouse(event,msgbox.id,0);}
msgbox.onmousemove= function(){move(event,msgbox.id);}
msgbox.onmouseout = function(){mouse(event,msgbox.id,0);}

//msgbox.style.height = '100px';
msgbox.style.width = (w*10) + 'px';
msgbox.style.top = '200px';
msgbox.style.backgroundColor='blue';
msgbox.style.textAlign="right";
var exitImg =document.createElement('img');  
exitImg.onclick =   function(){rm(msgbox.id);}
exitImg.src = 'images/close_icon.gif';
var msg = document.createElement('div');
msg.style.textAlign="center";
msg.style.backgroundColor='white';
msg.style.height='100%'

msg.innerHTML = m.replace(/\n/g,'<BR>');


msgbox.appendChild(exitImg);
msgbox.appendChild(msg);
document.getElementById('mainBody').appendChild(msgbox);
if (msg.offsetHeight > 400)
{
msg.style.height='400px';
msg.style.overflow='auto';	
}
}

/***
New scrolling table design

***/


function scr2_sw(node,err)
{
 var i = 0;
 var x = node.offsetWidth;
 node.style.width=x+'px';
 var y = node.offsetWidth;
  if(err) alert(x+' '+y);
 var z = (x-(y-x));
 node.style.width=z+'px';
 y = node.offsetWidth;
 while (y != x && i < 100)
 {
 z= (z-(y-x)); 	 
 node.style.width=z+'px';  
   y = node.offsetWidth;
 i++;
 }

  if(err) alert(node.style.width+' '+x+' '+y);
}

/*
function scr2_sw(node,err)
{
 var x = node.clientWidth;
 node.style.width=x+'px';
 var y = node.clientWidth;
  if(err)alert(x+' '+y);
 node.style.width=(x-(y-x))+'px';
}
*/

function scr2_tbl(t,h)
{
var loc=document.getElementById(t).parentNode;	
var cw = loc.offsetWidth;
loc.style.width='1200px'; 
h=(!h)?400:h;
var ar=[];
var tar=[];
var tbar=[];
var test=[];
var i=0;
var c=0;
var r=0;
var w=0;
var b=0;
var tb = document.getElementById(t);

	
ar[0]=tb.getElementsByTagName('thead')[0];	
ar[1]=tb.getElementsByTagName('tbody')[0];	
ar[2]=tb.getElementsByTagName('tfoot')[0];	

for (i=0;i<ar.length;i++)
{ if (i<2 && !ar[i]) {Alert('Thead and Tbody must be present to use this function')};
  if (i==2 && !ar[i]) ar.length=2;
}

var th = tb.getElementsByTagName('th');
for (i=0;i<th.length;i++)
{
  if (i==-1)
   scr2_sw(th[i],1)
  else    scr2_sw(th[i]);
}


var td = tb.getElementsByTagName('td');

for (i=0;i<td.length && i<30;i++)
{
 var fs = td[i].style.fontSize;	
// td[i].style.fontSize='100%'	
 if (i==-1)
 scr2_sw(td[i],1)
 else
 scr2_sw(td[i]);
 // td[i].style.fontSize=fs;
}




if (ar.length ==3) 
{
 var td = ar[2].getElementsByTagName('td'); 
 if (td.length ==0)
  td = ar[2].getElementsByTagName('th'); 
 for (i=0;i<td.length;i++)
 {
 scr2_sw(td[i]);
 }
}

w= tb.clientWidth;


for (i=0;i<ar.length;i++)
{
     tar[i] = document.createElement('table');
	 tar[i].id = t+'_'+i;
     tar[i].appendChild(ar[i]);
}

var ld = document.createElement('div');
ld.style.textAlign="left";
ld.style.marginLeft='auto';
ld.style.marginRight='auto';
 for (var i=0;i<tar.length;i++)
 {
 tar[i].cellSpacing=tb.cellSpacing;;
 tar[i].cellPadding=tb.cellPadding;
 if(i==1)
  {
	var d = document.createElement('div');
	d.style.height=h+"px";
	d.style.overflow='auto';
	d.style.width=(w+25)+'px';
    ld.appendChild(d);
	tar[i].style.width=w+'px';
	d.appendChild(tar[i]);  
  }
 else
  ld.appendChild(tar[i]);  
 }
ld.style.width=(w+35)+'px';

loc.appendChild(ld);
//loc.style.width=''; 
//alert(tar[0].offsetWidth+' '+tar[1].offsetWidth);	
	
}

function scr3_sw(node)
{
 var x = node.clientWidth;
 node.style.width=x+'px';
 var y = node.clientWidth;
 node.style.width=(x-(y-x))+'px';
}

function scr3_tbl(t,h)
{

var loc=document.getElementById(t).parentNode;	
h=(!h)?400:h;
var ar=[];
var tar=[];
var tbar=[];
var test=[];
var i=0;
var c=0;
var r=0;
var w=0;
var b=0;
var tb = document.getElementById(t);
	
ar[0]=tb.getElementsByTagName('thead')[0];	
ar[1]=tb.getElementsByTagName('tbody')[0];	
ar[2]=tb.getElementsByTagName('tfoot')[0];	

if(ar[0].offsetHeight + ar[1].offsetHeight <= h)
	return;

for (i=0;i<ar.length;i++)
{ if (i<2 && !ar[i]) {Alert('Thead and Tbody must be present to use this function')};
  if (i==2 && !ar[i]) ar.length=2;
}

var th = tb.getElementsByTagName('th');
for (i=0;i<th.length;i++)
 scr3_sw(th[i]);

var trs = ar[0].getElementsByTagName('tr');
//Add Cells to Header to account for scrollbar
var sCheck = trs[0].getElementsByTagName('th');//Don't duplicate cells
if(!sCheck || sCheck.length < 1)
	sCheck = trs[0].getElementsByTagName('td');
if(sCheck.length > 0)
	sCheck = sCheck[sCheck.length-1].id;
else 
	sCheck="";
if(!sCheck && sCheck != 'scrollbarCell'){
	for(i=0; i < trs.length;i++)
	{
		var scrollbarCell = document.createElement('td');
		scrollbarCell.id='scrollbarCell';
		scrollbarCell.style.width='20px';
		scrollbarCell.style.backgroundColor='transparent';
		scrollbarCell.style.border='0px solid transparent';
		trs[i].appendChild(scrollbarCell);
	}
}

var td = tb.getElementsByTagName('td');
for (i=0;i<td.length && i<30;i++)
 scr3_sw(td[i]);

if (ar.length ==3) 
{
 var td = ar[2].getElementsByTagName('td'); 
 if (td.length ==0)
  td = ar[2].getElementsByTagName('th'); 
 for (i=0;i<td.length;i++)
 scr3_sw(td[i]);
}
//var td =  tb.getElementsByTagName('tr')[0].getElementsByTagName('th');
//for (i=0;i<td.length;i++)
//w+=td[i].clientWidth;
w=tb.clientWidth;
//alert(w+' '+tb.clientWidth); 

for (i=0;i<ar.length;i++)
{
     tar[i] = document.createElement('table');
	 tar[i].id = t+'_'+i;
     tar[i].appendChild(ar[i]);
}

var ld = document.createElement('div');
ld.style.textAlign="left";
ld.style.marginLeft='auto';
ld.style.marginRight='auto';

 for (var i=0;i<tar.length;i++)
 {
 if (tb.cellSpacing)	 
 tar[i].cellSpacing=tb.cellSpacing;
 if (tb.cellPadding)	 
 tar[i].cellPadding=tb.cellPadding;
 if (tb.cssText)	 
 tar[i].cssText=tb.cssText;
 if (tb.className)	 
 tar[i].className=tb.className;
 tar[i].style.visibility="visible";
 
 if(i==1)
  {
	var d = document.createElement('div');
	d.style.height=h+"px";
	d.style.overflow='auto';
	d.appendChild(tar[i]); 
	 
	d.style.width=(w+25)+'px';
    ld.appendChild(d);
	d.appendChild(tar[i]);  		 	
  }
 else
  ld.appendChild(tar[i]);  
 }
ld.style.width=(w+30)+'px';

loc.appendChild(ld);	
}

function scr4_tbl(t,h)
{

var loc=document.getElementById(t).parentNode;	
h=(!h)?400:h;
var ar=[];
var tar=[];
var tbar=[];
var test=[];
var i=0;
var c=0;
var r=0;
var w=0;
var b=0;
var tb = document.getElementById(t);
	
ar[0]=tb.getElementsByTagName('thead')[0];	
ar[1]=tb.getElementsByTagName('tbody')[0];	
ar[2]=tb.getElementsByTagName('tfoot')[0];	

if(ar[1].offsetHeight <= h)
	return;

for (i=0;i<ar.length;i++)
{ if (i<2 && !ar[i]) {Alert('Thead and Tbody must be present to use this function')};
  if (i==2 && !ar[i]) ar.length=2;
}

//Add Cells to Header to account for scrollbar
var trs = ar[0].getElementsByTagName('tr');
var sCheck = trs[0].getElementsByTagName('th');//Don't duplicate cells
if(!sCheck || sCheck.length < 1)
	sCheck = trs[0].getElementsByTagName('td');
if(sCheck.length > 0)
	sCheck = sCheck[sCheck.length-1].id;
else 
	sCheck="";
if(!sCheck && sCheck != 'scrollbarCell'){
	for(i=0; i < trs.length;i++)
	{
		var scrollbarCell = document.createElement('td');
		scrollbarCell.id='scrollbarCell';
		scrollbarCell.style.width='20px';
		scrollbarCell.style.backgroundColor='transparent';
		scrollbarCell.style.border='0px solid transparent';
		trs[i].appendChild(scrollbarCell);
	}
}
/*
var th = tb.getElementsByTagName('th');
for (i=0;i<th.length;i++)
	scr3_sw(th[i]);

var trs = ar[1].getElementsByTagName('tr');
var td;
for (i=0;i<trs.length && i<5;i++)
{
	td = trs[i].getElementsByTagName('td');
	for (var ii=0;ii<td.length ;ii++)
	{
		scr3_sw(td[ii]);
	}
}


if (ar.length ==3) 
{
 var td = ar[2].getElementsByTagName('td'); 
 if (td.length ==0)
  td = ar[2].getElementsByTagName('th'); 
 for (i=0;i<td.length;i++)
 scr3_sw(td[i]);
}*/
var thsizes=[];
var th = tb.getElementsByTagName('th');
for (i=0;i<th.length;i++)
{
	thsizes[i]=th[i].clientWidth;
}

var tdsizes=[];
var trs = ar[1].getElementsByTagName('tr');
var td;
for (i=0;i<trs.length && i<5;i++)
{
	td = trs[i].getElementsByTagName('td');
	for (var ii=0;ii<td.length ;ii++)
	{
		tdsizes[ii]=td[ii].clientWidth;
	}
}

var tfsizes=[];
if (ar.length ==3) 
{
	var td = ar[2].getElementsByTagName('td'); 
	if (td.length ==0)
		td = ar[2].getElementsByTagName('th'); 
	for (i=0;i<td.length;i++)
		tfsizes[i]=td[i].clientWidth;
}


var th = tb.getElementsByTagName('th');
for (i=0;i<th.length;i++)
{
	th[i].style.width=thsizes[i]+'px';
}


var trs = ar[1].getElementsByTagName('tr');
var td;
for (i=0;i<trs.length && i<5;i++)
{
	td = trs[i].getElementsByTagName('td');
	for (ii=0;ii<td.length ;ii++)
	{
		td[ii].style.width=tdsizes[ii]+'px';
	}
}


if (ar.length ==3) 
{
	var td = ar[2].getElementsByTagName('td'); 
	if (td.length ==0)
		td = ar[2].getElementsByTagName('th'); 
	for (i=0;i<td.length;i++)
		td[i].style.width=tfsizes[i]+'px';
}

//return;
//var td =  tb.getElementsByTagName('tr')[0].getElementsByTagName('th');
//for (i=0;i<td.length;i++)
//w+=td[i].clientWidth;
w=tb.clientWidth;
//alert(w+' '+tb.clientWidth); 

for (i=0;i<ar.length;i++)
{
     tar[i] = document.createElement('table');
	 tar[i].id = t+'_'+i;
     tar[i].appendChild(ar[i]);
}

var ld = document.createElement('div');
ld.style.textAlign="left";
ld.style.marginLeft='auto';
ld.style.marginRight='auto';

 for (var i=0;i<tar.length;i++)
 {
 if (tb.cellSpacing)	 
 tar[i].cellSpacing=tb.cellSpacing;
 if (tb.cellPadding)	 
 tar[i].cellPadding=tb.cellPadding;
// if (tb.style.cssText)	 
// tar[i].style.cssText=tb.style.cssText;
 if (tb.className)	 
 tar[i].className=tb.className;
 tar[i].style.visibility="visible";
 
 if(i==1)
  {
	var d = document.createElement('div');
	d.style.height=h+"px";
	d.style.overflow='auto';
	d.appendChild(tar[i]); 
	 
	d.style.width=(w+25)+'px';
    ld.appendChild(d);
	d.appendChild(tar[i]);  		 	
  }
 else
  ld.appendChild(tar[i]);  
 }
ld.style.width=(w+30)+'px';

loc.appendChild(ld);	
}

function scrTblQuick(tableID,scrollHeight,doAll){
	
	var ttbl=document.getElementById(tableID);
	//Make Table Display for measurements.
	var thead =ttbl.getElementsByTagName('thead')[0];
	thead.style.display='';
	var tbody = ttbl.getElementsByTagName('tbody')[0];
	tbody.style.display='';
	var tfoot = ttbl.getElementsByTagName('tfoot')[0];
	if(tfoot)
		tfoot.style.display='';
	var node = ttbl.parentNode;
	if(!navigator.vendor)
	{
		tbody.style.width='';
		tbody.style.position='';
	}
	//Create div to add table to make sure table is correct size.
	var ddiv;
	if(node && node.id == "STQdiv")//Don't duplicate div
	{
		ddiv=node;
	}
	else
	{
		ddiv = document.createElement('div');
		ddiv.id="STQdiv";
		ddiv.style.textAlign='center';
		ddiv.style.margin='0 auto';
		//Add div to tables parent node
		if(node)
			node.appendChild(ddiv);
		else
			document.appendChild(ddiv);
	}
	ddiv.style.width='2000px';
	ddiv.appendChild(ttbl);
	
	var i=0;
	
	var th = thead.getElementsByTagName('tr');
	//Add Cells to Header to account for scrollbar
	var sCheck = th[0].getElementsByTagName('th');//Don't duplicate cells
	if(!sCheck || sCheck.length < 1)
		sCheck = th[0].getElementsByTagName('td');
	if(sCheck.length > 0)
		sCheck = sCheck[sCheck.length-1].id;
	else 
		sCheck="";
	if(!sCheck && sCheck != 'scrollbarCell'){
		for(i=0; i < th.length;i++)
		{
			var scrollbarCell = document.createElement('th');
			scrollbarCell.id='scrollbarCell';
			scrollbarCell.style.width='20px';
			scrollbarCell.style.backgroundColor='transparent';
			scrollbarCell.style.border='0px solid transparent';
			th[i].appendChild(scrollbarCell);
		}
	}

	if(tfoot)
	{
		var fth = tfoot.getElementsByTagName('tr');
		//Add Cells to Header to account for scrollbar
		sCheck = fth[0].getElementsByTagName('th');//Don't duplicate cells
		if(!sCheck || sCheck.length < 1)
			sCheck = fth[0].getElementsByTagName('td');
		sCheck = sCheck[sCheck.length-1].id;
		if(!sCheck && sCheck != 'scrollbarCell'){
			for(i=0; i < fth.length;i++)
			{
				var scrollbarCell = document.createElement('th');
				scrollbarCell.id='scrollbarCell';
				scrollbarCell.style.width='20px';
				scrollbarCell.style.backgroundColor='transparent';
				scrollbarCell.style.border='0px solid transparent';
				fth[i].appendChild(scrollbarCell);
			}
		}
	
		fth = tfoot.getElementsByTagName('th');
		if(!fth || fth.length < 1)
			fth=tfoot.getElementsByTagName('td');
		for(i=0; i < fth.length;i++)
		{
			if(fth[i].style.paddingLeft == '')
					fth[i].style.paddingLeft = '1px';
			if(fth[i].style.paddingRight == '')
					fth[i].style.paddingRight = '1px';
			fth[i].style.width = fth[i].clientWidth+'px';
		}
	}
	//Set width for ALL cells in header, this accounts for colspans and rowspans.
	th = thead.getElementsByTagName('th');
	if(!th || th.length < 1)
		th=thead.getElementsByTagName('td');
	for(i=0; i < th.length;i++)
	{
		if(th[i].style.paddingLeft == '')
				th[i].style.paddingLeft = '1px';
		if(th[i].style.paddingRight == '')
				th[i].style.paddingRight = '1px';
		th[i].style.width = th[i].clientWidth+'px';//-(th[i].offsetWidth-th[i].clientWidth)+'px';
	}
	//Set width for first row of first tbody. Does NOT account for colspans and rowspans only matter if first row has them.
	var tr = tbody.getElementsByTagName('tr');
	var doRows = (doAll == 1) ? tr.length : 5;
for (var ti=0;ti<tr.length && ti < doRows;ti++)
{
	var td = tr[ti].getElementsByTagName('td');
	if(tr[ti]){
		var hold;
/*		for(i = 0; i < 10 && i < tr.length; i++){
			hold = tr[i].getElementsByTagName('td');
			if(hold.length > td.length)
				td = hold;
		}*/
		for(i=0; i < td.length;i++)
		{
			if(td[i].style.paddingLeft == '')
					td[i].style.paddingLeft = '1px';
			if(td[i].style.paddingRight == '')
					td[i].style.paddingRight = '1px';
			var left = parseInt(td[i].style.paddingLeft.replace('px',''));
			var right = parseInt(td[i].style.paddingRight.replace('px',''));
			td[i].style.width =  td[i].clientWidth-(left+right)+'px';//-(td[i].offsetWidth-td[i].clientWidth)+'px';
		}
	}
	
}
	
	
	if(tfoot)
	{
		fth = tfoot.getElementsByTagName('th');
		if(!fth || fth.length < 1)
			fth=tfoot.getElementsByTagName('td');
		for(i=0; i < fth.length;i++)
		{
			if(fth[i].style.paddingLeft == '')
					fth[i].style.paddingLeft = '1px';
			if(fth[i].style.paddingRight == '')
					fth[i].style.paddingRight = '1px';
			fth[i].style.width = fth[i].clientWidth-(left+right)+'px';
		}
	}
	//Set Thead to display table so it doesn't resize.
	thead.style.display='table';
	if(tfoot)
		tfoot.style.display='table';

	//Set Tbody to block so it can scroll and set scroll parameters.
	tbody.style.display='block';
	tbody.style.overflow= 'auto';
	tbody.style.maxHeight=scrollHeight+'px';
	
	//To work in IE
	if(!navigator.vendor)
	{
		tbody.style.width=thead.offsetWidth+'px';
		tbody.style.position='absolute';
		if(tfoot)
			tfoot.style.marginTop = scrollHeight+'px';
	}
	//Set Div to table width + 10
	ddiv.style.width =  ttbl.offsetWidth+10+'px';	
	ddiv.style.minHeight =  thead.offsetHeight+(scrollHeight/1)+((tfoot) ? tfoot.offsetHeight:0)+'px';	
}


function setLoad(ContainerObject,Toggle,Message,overLayColor,messageColor,barColor)
{	
	if(Toggle){
		var ovl=document.createElement('div');
		ovl.id='overLoader';
		ContainerObject.appendChild(ovl);
		ovl.className='overlayLoader';
		ovl.style.position='absolute';
		if(overLayColor)
			ovl.style.backgroundColor=overLayColor;
		ovl.width='3000';
		var ul = document.createElement('ul');
		ovl.appendChild(ul);
		ul.className='loaderInlay';
		var lili;
		var w=0,i=0;
		for(i=0; i <7;i++)
		{
			lili = document.createElement('li');
			if(i==3){
				if(messageColor)
					lili.style.color=messageColor;
				lili.innerHTML=Message;
			}else if(barColor)
			{
				lili.style.backgroundColor =barColor;
			}
			ul.appendChild(lili);
			w+=lili.offsetWidth+5;
		}

		ul.style.width=w+1+'px';

		ovl.style.height = ContainerObject.offsetHeight+'px';
		ovl.style.width = ContainerObject.offsetWidth+'px';
		ovl.style.left= ContainerObject.offsetLeft+'px';
		ovl.style.top= ContainerObject.offsetTop+'px';
		
		ul.style.position='relative';
	} else {
		ovls = ContainerObject.querySelectorAll("[class=overlayLoader]");
		for(i=0; i <ovls.length;i++)
		{
			ContainerObject.removeChild(ovls[i]);
		}
	}
}

function D3scrTblQuick(tableID,scrollHeight){
		
		var ttbl=d3.select('#'+tableID);
		//Make Table Display for measurements.
		var thead =ttbl.selectAll('thead');
		if(!thead[0][0])
			return;
		thead.style('display','');
		var tbody = ttbl.selectAll('tbody');
		if(!tbody[0][0])
			return;
		tbody.style('display','');
		var tfoot = ttbl.selectAll('tfoot');
		if(tfoot[0][0])
			tfoot.style('display','');
		var node = ttbl[0][0].parentNode;
		//Create div to add table to make sure table is correct size.
		var ddiv;
		if(node && node.id == "STQdiv")//Don't duplicate div
		{
			ddiv=d3.select(node);
		}
		else
		{
			if(node)
			{
				ddiv=d3.select(node).append('div')
				.attr('id',"STQdiv")
				.style('textAlign','center')
				.style('margin','0 auto');
			}
			else
			{
				ddiv=d3.select('body').append('div')
				.attr('id',"STQdiv")
				.style('textAlign','center')
				.style('margin','0 auto');
			}
			
		}
		ddiv.style('width','2000px');
		ddiv.node().appendChild(ttbl[0][0]);
		
		var i=0;
		
		var th = thead.selectAll('tr');
		//Add Cells to Header to account for scrollbar
		var sCheck = th.selectAll('#scrollbarCell');//Don't duplicate cells
		if(!sCheck[0][0])
		{
			th.append('th')
			.attr('id','scrollbarCell')
			.style('width','20px')
			.style('background','transparent')
			.style('border','0px solid transparent');
		}
		

		if(tfoot[0][0])
		{
			var fth = tfoot.selectAll('tr');
			//Add Cells to Header to account for scrollbar
			sCheck = fth.selectAll('#scrollbarCell');//Don't duplicate cells
			if(!sCheck[0][0])
			{
				fth.append('th')
				.attr('id','scrollbarCell')
				.style('width','20px')
				.style('background','transparent')
				.style('border','0px solid transparent');
			}
		
			fth = tfoot.selectAll('th');
			if(!fth[0][0])
				fth=tfoot.selectAll('td');
			
			fth.each(function(d,i){
				if(this.style.paddingLeft == '')
						this.style.paddingLeft = '1px';
				if(this.style.paddingRight == '')
						this.style.paddingRight = '1px';
				this.style.width = this.clientWidth+'px';
			});
			
		}
		//Set width for ALL cells in header, this accounts for colspans and rowspans.
		//var hold=[];
		th = thead.selectAll('th');
		if(!th[0][0])
			th=thead.selectAll('td');
		th.each(function(d,i){
				if(this.style.paddingLeft == '')
						this.style.paddingLeft = '1px';
				if(this.style.paddingRight == '')
						this.style.paddingRight = '1px';
				this.style.width = this.clientWidth+'px';
				//hold.push(this);
			});
			
			//alert(hold);
		//Set width for first row of first tbody. Does NOT account for colspans and rowspans only matter if first row has them.

		 tbody.selectAll('td').each(function(d,i){
				if(this.style.paddingLeft == '')
					this.style.paddingLeft = '1px';
				if(this.style.paddingRight == '')
					this.style.paddingRight = '1px';
				var left = parseInt(this.style.paddingLeft.replace('px',''));
				var right = parseInt(this.style.paddingRight.replace('px',''));
				this.style.width =  (this.clientWidth-(left+right))+'px';
			});
		if(tfoot[0][0])
		{		
			fth = tfoot.selectAll('th');
			if(!fth[0][0])
				fth=tfoot.selectAll('td');
			
			fth.each(function(d,i){
				if(this.style.paddingLeft == '')
						this.style.paddingLeft = '1px';
				if(this.style.paddingRight == '')
						this.style.paddingRight = '1px';
				this.style.width = this.clientWidth+'px';
			});
			
		}
		//Set Thead to display table so it doesn't resize.
		thead.style('display','table');
		if(tfoot[0][0])
			tfoot.style('display','table');

		//Set Tbody to block so it can scroll and set scroll parameters.
		tbody
		.style('display','block')
		.style('overflow', 'auto')
		.style('max-height',(scrollHeight+'px'));
		
		//Set Div to table width + 10
		ddiv
		.style('width',  ttbl.offsetWidth+10+'px')
		.style('minHeight',  thead.offsetHeight+scrollHeight+((tfoot[0][0]) ? tfoot.offsetHeight:0)+'px');	
	}