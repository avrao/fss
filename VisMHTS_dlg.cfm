<!---<cfdump var="#url#">
<cfabort>--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>


<head>
<title>MHTS</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="styles/spm.css" type="text/css">
</head>


  
  
 


<script language="JavaScript">

var iframe_cnt = 0;
var iframe = document.createElement("iframe");
iframe.id = 'iframe';
iframe.height = 200;
iframe.width = 800;
<cfif not isdefined('id_tag')>
h = "http://mhts.usps.gov/mits.php?facility="+<cfoutput>'#facility#'</cfoutput> +"&tracking=" +<cfoutput>'#tracking#'</cfoutput>+"&all_days=" + <cfoutput>#all_days#</cfoutput>;
<cfelse>
h = "http://mhts.usps.gov/mits.php?facility="+<cfoutput>'#facility#'</cfoutput> +"&id_tag=" +<cfoutput>'#ID_TAG#'</cfoutput>;
</cfif>
//prompt("",h);
iframe.src = h;	


if (iframe.attachEvent){

    iframe.attachEvent("onload", function()
	 {
       iframe_cnt+=1;
	   if  (iframe_cnt==2)
	    {
     	location.href = iframe.src;
		window.resizeTo(window.screen.availWidth,window.screen.availHeight);
		}
    });

} else {

    iframe.onload = function(){

      iframe_cnt+=1;
	   if  (iframe_cnt==2)
	    {
     	location.href = iframe.src;
		window.resizeTo(window.screen.availWidth,window.screen.availHeight);		
		}

    };

}

 




</script>










<body style="margin:50px">
<center>
<h1 STYLE="COLOR:BLUE">You are being redirected to MHTS.USPS.GOV</h1>
<h1 STYLE="COLOR:BLUE">Please wait.....</h1>
<img src="images/Loading_bar_blue.gif">
</center>
<br><br>
 
</body >


</html>

<script>
document.body.appendChild(iframe);
</script>


