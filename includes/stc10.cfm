<cfoutput>

<script>
var myLoader = loader({width: 480, height: 150, container: "##rpt_table", id: "loader"});
var myLoader2 = loader({width: 360, height: 100, container: "##zip3tbl", id: "loader2"});

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


var dataset;
var dataset2;
var zip3dataset =[];
var zip3dataset2;


function showchart(n,v)
{
	if (v[0] == 'No Data')
	 return true;
hide_element('rpt_graph','');	 
 var p = d3.select('##variance');
 if(p.empty())  d3.select('##rpt_graph').append('div')
  .attr('id','variance')
  .style('display','inline-block')
  .style('margin','0 auto') ;
  
   p.selectAll('h2').remove();
   p.append('h2').text(n+' Variance');

 var p = d3.select('##failures');
 if(p.empty())  d3.select('##rpt_graph').append('div')
  .attr('id','failures')
  .style('display','inline-block')   
  .style('width','500px')       
  .style('margin','0 auto') ;
   p.selectAll('h2').remove();
   p.append('h2').text(n+' Late Piece Distribution');



  var dta = [];
 for (var i = 5;i<v.length;i++)
  {
  dta.push([i-9,v[i]]);
  }

 var piedta = [];
 for (var i = 10;i<v.length;i++)
  {
  piedta.push([i-9,v[i]]);
  }


var chart = dc.barChart("##variance"); 
 //d3.csv("morley.csv", function(error, experiments) 

  experiments = dta;
  
   var ndx                 = crossfilter(experiments), 
       runDimension        = ndx.dimension(function(d) {return +d[0];}), 
       speedSumGroup       = runDimension.group().reduceSum(function(d) {return d[1]}); 
  
   chart 
     .width(500) 
     .height(300) 
	 .margins({left: 80, right: 30, top: 0, bottom: 40})
     .x(d3.scale.linear().domain([-4,4])) 
     .brushOn(false)
     .centerBar("true") 
     .yAxisLabel("Pieces") 
     .xAxisLabel("Days to Deliver") 	 
   .dimension(runDimension) 
     .group(speedSumGroup) 
     .on('renderlet', function(chart) { 
         chart.selectAll('rect').on("click", function(d) { 
             console.log("click!", d); 
         }); 
     }); 
     chart.render(); 
 	
	
	var pie = dc.pieChart("##failures");


 var cs = d3.scale.ordinal().domain([1,2,3,4]).range(["##FF0000","##DF0000","##CF0000","##AF0000"]);
  var ndx2           = crossfilter(piedta),
       runDimension2        = ndx2.dimension(function(d) {return +d[0];}), 
      speedSumGroup2 = runDimension2.group().reduceSum(function(d) {return d[1]}); 

  pie
    .width(500)
    .height(300)
    .slicesCap(4)
    .innerRadius(50)
	.colors(function(d) {return cs(d)})
    .dimension(runDimension2)
    .group(speedSumGroup2)
    .legend(dc.legend().legendText(function(d,i) {return (i==0) ? d.name +' Day' : d.name + ' Days' }))
    // workaround for ##703: not enough data is accessible through .label() to display percentages
    .on('pretransition', function(pie) {
        pie.selectAll('text.pie-slice').text(function(d) {
            return <!---d.data.key + ' ' + --->dc.utils.printSingleValue((d.endAngle - d.startAngle) / (2*Math.PI) * 100) + '%';
        })
    });

  pie.render();


show3digit(v[0],0,4); 	
	
	
}

function show3digit(v,r,c)
{
//	res = dataset.slice(r,c+r);      
	cma = d3.format(',');
	res = [];
    for (var i=0;i<zip3dataset.length;i++)
	 {
       if(zip3dataset[i][6] == v)
        {res.push(zip3dataset[i].slice());
		 res[res.length-1][6] =  d3.round((+res[res.length-1][4]-res[res.length-1][5])/(res[res.length-1][4]+.0000001)*100,2); 
		}
	 }
	 if(res.length==0)
	  {
	    return true;
	  }
	 else
	  hide_element('zip3tbl','');

	  var cnt = res.length;
	  res = res.slice(r,c+r);      
      var dataTable = d3.select('##zip3tbl');
      dataTable.select('##tabzip3').remove();
//      dataTable.select('##loader').remove();
      var tab = dataTable
	  .append('table')
	  .attr('id','tabzip3')
	  .attr('class','pbTable')
	  .style('margin','20px auto')
	  .style('font-size','12px');
 var hw = ['250px','50px','250px','50px','80px','80px','80px','20px'] 	  
 var hs = ['left','center','left','center','right','right','center','center'] 	  
 var hdrcol = ['ORIGIN FACILITY','ZIP 3','DESTN FACILITY','ZIP 3','TOTAL PIECES','FAILED PIECES','SERVICE SCORE'];	  
 var head = tab.append('thead');

	var t =head.append('tr')
		.append('th')
		.attr('colspan',hs.length);
		
		t.append('input')
		.attr('type','button')
		.attr('value','>>')
		.style('float','right')
		.on('click',function() {show3digit(v,(cnt<r+c)? r : r+c,c)});
		
		t.append('input')		
		.attr('type','button')
		.attr('value','<<')
		.style('float','right')
		.on('click',function() {show3digit(v,(r-c > 0) ? r-c : 0,c)});

         t.append('label')
		 .attr('text-align','center')
		 .style('font-size','16px')
		 .text('Top 3 Digit Impacts ranking');		
		
		head.append('tr')
		.selectAll('th').data(hdrcol).enter()
		.append('th')
		.style('width',function(d,i) {return hw[i]})
		.text(function(d){return d;})	   	   

   
	  
	  tab.append('tbody')
		.selectAll('tr').data(res).enter()
		.append('tr')
//		.on('mouseover', function(d,i) {showchart(d[0],extra[i])})
		.selectAll('td').data(function(d){return d}).enter()
		.append('td')
		.style('padding','3px')
		.style('cursor',function(d,i) {return (i==0) ? 'pointer' : ''})
		.style('text-align',function(d,i) {return hs[i]})				
		.text(function(d,i){return (i==4 || i== 5) ? cma(d) : d;})	   	   
	
     
}

function process_data(r,c)
{

//    var datagroup= d3.nest()
//	.key(function(d) {return d[1]})
//	.rollup(function(d) {return [d3.sum(d,function(d) {return d[3]}),d3.sum(d,function(d) {return d[4]})]})
	
	cma = d3.format(',');
	res = dataset.slice(r,c+r);      
    extra = dataset2.slice(r,c+r);      
	var seqlist = [];
	for (var i=0;i<extra.length;i++)
	 seqlist.push(extra[i][0]);
	 

    zip3dataset = [];
	load_zip3(seqlist); 
   
      
      var dataTable = d3.select('##rpt_table');
      dataTable.select('##tab').remove();
      dataTable.select('##loader').remove();
      var tab = dataTable
	  .append('table')
	  .attr('id','tab')
	  .attr('class','pbTable')
	  .style('margin','20px auto')
	  .style('font-size','12px');

 var hw = ['250px','100px','130px','30px','30px','20px','25px','20px']; 	  
 var hs = ['left','left','left','right','right','center','center','center'] ;	  
 var hdrcol = ['FACILITY','AREA','DISTRICT','TOTAL PIECES','FAILED PIECES','% FAILED','SERVICE SCORE','NATIONAL IMPACT'];	  
 var head = tab.append('thead');

	var t =head.append('tr')
		.append('th')
		.attr('colspan',hs.length);
		
		t.append('input')
		.attr('type','button')
		.attr('value','>>')
		.style('float','right')
		.on('click',function() {process_data((r+c<dataset.length)? r+c : r,c)});
		
		t.append('input')		
		.attr('type','button')
		.attr('value','<<')
		.style('float','right')
		.on('click',function() {process_data((r-c > 0) ? r-c : 0,c)});

         t.append('label')
		 .attr('text-align','center')
		 .style('font-size','16px')
		 .text('Top Facility Impacts ranking');		
		
		head.append('tr')
		.selectAll('th').data(hdrcol).enter()
		.append('th')
		.style('width',function(d,i) {return hw[i]})
		.text(function(d){return d;})	   	   


	  
	  tab.append('tbody')
		.selectAll('tr').data(res).enter()
		.append('tr')
		.on('mouseover', function(d,i) {showchart(d[0],extra[i])})
		.selectAll('td').data(function(d){return d}).enter()
		.append('td')
		.style('padding','3px')
		.style('cursor',function(d,i) {return (i==0) ? 'pointer' : ''})
		.style('text-align',function(d,i) {return hs[i]})				
		.text(function(d,i){return (i==3 || i== 4) ? cma(d) : d;})	   	   
	
      showchart(res[0][0],extra[0]);   	
	  show3digit(extra[0],0,4)
}


	function zip3data_ret(res)
	{
    if(res.length==0)
     {
     zip3dataset = [['No Data','','',0,0,0,0,0]];
	 }
    else	
	{
    zip3dataset = res.DATA;
	}

      d3.select('##loader2').remove();		
	}


	function zip3data_err(res)
	{
		//alert('e-'+res);
	}




function load_zip3(seqlist)
{
d3.select('##tabzip3').remove();	
d3.select('##loader2').remove();		
myLoader2();  	
var e=new top10();
var dir = get_val('selDir');
var cls = get_val('selClass');
var cat = get_cat();
var a = get_val('selArea');
var d = get_val('selDistrict');
var top = get_val('selTop');
var eod =get_val('selEOD');
var std = get_val('selHybStd');
var fss = get_checkmark('selFSS')
var pol = get_checkmark('chkpol')
var cntr=get_val('selCntrLvl');
var cert=get_val('selCert');
var air=get_val('selAir');
var mode=get_val('selMode');
var dt=get_val('selDate');
var r=get_val('selRange');
var b=get_val('selBMEU');

  e.setCallbackHandler(zip3data_ret);	
  e.setErrorHandler(zip3data_err);
  e.getstctop10zip3('#opsvisdata#',pol,eod,dir,cls,cat,a,d,top,std,fss,cntr,cert,air,mode,dt,r,b,seqlist.toString());
}



	function data_ret(res)
	{
    if(res.length==0)
     {
     dataset = [['No Data','','',0,0,0,0,0]];
     dataset2 = [['No Data','','',0,0,0,0,0]]	 
	 }
    else	
	{
    dataset = res[0];
    dataset2 = res[1];	
	}
    process_data(0,10);
		
	}


	function data_err(res)
	{
		alert(res);
	}



function load_data()
{
hide_element('rpt_table','');hide_element('fbox','');//hide_element('rpt_graph','');


      var dataTable = d3.select('##rpt_table');
      dataTable.select('##tab').remove();
      dataTable.select('##loader').remove();

myLoader();
var e=new top10();
var dir = get_val('selDir');
var cls = get_val('selClass');
var cat = get_cat();
var a = get_val('selArea');
var d = get_val('selDistrict');
var top = get_val('selTop');
var eod =get_val('selEOD');
var std = get_val('selHybStd');
var fss = get_checkmark('selFSS')
var pol = get_checkmark('chkpol')
var cntr=get_val('selCntrLvl');
var cert=get_val('selCert');
var air=get_val('selAir');
var mode=get_val('selMode');
var dt=get_val('selDate');
var r=get_val('selRange');
var b=get_val('selBMEU');

  e.setCallbackHandler(data_ret);	
  e.setErrorHandler(data_err);
  e.getstctop10('#opsvisdata#',pol,eod,dir,cls,cat,a,d,top,std,fss,cntr,cert,air,mode,dt,r,b);
}
</script>
</cfoutput>