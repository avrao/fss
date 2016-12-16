<!doctype html>
<cfset datasource = 'TERADATA_LAB'>
<cfquery datasource="#datasource#" name="test">
SELECT SvcStdDayTimeCode,SvcStdDayTimeCodeDesc, SUM (rcf.MailPieceCount) tp_tot,SUM (rcf.OntimeCount) ontime,tp_tot - ontime failedcount,ontime*100.00/tp_tot Scores
FROM ppr_datalab.PTSMSTRRootCauseZip5DayAGG rcf
WHERE rcf.StopTheClockDate = '2016-11-08'
and rcf.MailClassCode = 'PM'
GROUP BY 1,2 order by tp_tot desc


</cfquery>
<html>
<head>
<meta charset="utf-8">
<title>Untitled Document</title>
</head>

<body>
</body>
</html>