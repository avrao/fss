<!doctype html>
<cfoutput>
<cfparam name="data" default="">
<cfparam name="fn" default="download.xls">

	<cfheader name="Content-disposition" value="attachment; filename=#fn#">	
	<cfcontent type="application/msexcel" variable="#ToBinary( ToBase64(data ) )#">

<script>
window.onload = function() {window.opener.test_app()};

</script>
<!----
<html>
<head>
<meta charset="utf-8">
<title>Downloading...</title>
</head>
</script> 	
<body >
#data#
</body>
</html>
--->
</cfoutput>