<cfcomponent>

	<cffunction name="getByOAreaData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			ozc.AreaName AS OArea
			,ozc.Areaid AS OAreaid

			, SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID

			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)

			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
			<cfset count=1>
				<cfset ar[count2][1] = #OAreaid#>
				<cfset ar[count2][2] = #OArea#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>

	</cffunction>
	
	<cffunction name="getByODistData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			ozc.DistrictName AS ODistrict  
			,ozc.DistrictID AS ODistrictid  

			, SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID
			
			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)

			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #ODistrictid#>
				<cfset ar[count2][2] = #ODistrict#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByOFacilityData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			UPPER(TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN NetworkName         
			WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN TurnaroundName
			WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN NetworkNMOName 
			WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN TurnaroundNMOName 
			WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN WeekendName
			ELSE NetworkName END)) AS OPDC

			, TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
			WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
			WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
			WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
			WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
			ELSE opdc.NetworkZipCode END) AS OPDCid

			, SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID

			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #OPDCid#>
				<cfset ar[count2][2] = #OPDC#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByDAreaData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			dzc.AreaName AS DArea
			,dzc.AreaID AS DAreaid

			, SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID

			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc

		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
			<cfset count=1>
				<cfset ar[count2][1] = #DAreaid#>
				<cfset ar[count2][2] = #DArea#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>

	</cffunction>
	
	<cffunction name="getByDDistData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			dzc.DistrictName AS DDistrict  
			,dzc.DistrictID AS DDistrictid  

			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID

			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'

			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #DDistrictid#>
				<cfset ar[count2][2] = #DDistrict#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

	<cffunction name="getByDFacilityData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			UPPER(TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCName     
			WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2Name
			WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFName
			ELSE ADCName END)) AS DPDC

			, TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode  
			WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode
			WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode
			ELSE ADCZipCode END) AS DPDCID
			
			, SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID

			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #DPDCID#>
				<cfset ar[count2][2] = #DPDC#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

	<cffunction name="getByRootFacilityData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			UPPER(TRIM (rzc.RootCausePDC)) AS PDC

			, TRIM (rzc.RootCausePDCZipCode) AS PDCID        

			, SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID
			
			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #PDCID#>
				<cfset ar[count2][2] = #PDC#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>	
	
	<cffunction name="getBySSTData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'AIR' WHEN rcf.TransportationModeCode IN ('S') THEN 'SURFACE'  END AS Tmode_DESC 
			,rcf.TransportationModeCode AS Tmode_ID 

			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID
			
			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			AND rcf.TransportationModeCode IN ('A','S')
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #Tmode_ID#>
				<cfset ar[count2][2] = #Tmode_DESC#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>	
	
	<cffunction name="getByModeData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			CASE
			WHEN rcf.SvcStdDayTimeCode = '1D' THEN 'OVERNIGHT'
			WHEN rcf.SvcStdDayTimeCode = '2D' THEN 'TWO DAY'
			WHEN rcf.SvcStdDayTimeCode = '3D' THEN 'THREE DAY'
			END  AS SVC_STD

			, CAST(rcf.SvcStdDayTimeCode as char(2)) SvcStdDayTimeCode

			, SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID

			
			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #SvcStdDayTimeCode#>
				<cfset ar[count2][2] = #SVC_STD#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>	
	
	<cffunction name="getBySSCData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			rcf.SalesSourceCode AS SalesCode 
			,case when rcf.SalesSourceCode = 'R' then 'RETAIL' when rcf.SalesSourceCode = 'P' then 'PC POSTAGE' else 'MANIFEST' end AS descript

			, SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID

			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #SalesCode#>
				<cfset ar[count2][2] = #descript#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>	
	
	<cffunction name="getByShapeData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			c.ProcessCategoryCODE AS Shape
			,c.ProcessCategoryDesc AS descript

			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID

			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #Shape#>
				<cfset ar[count2][2] = #descript#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>	
	
	<cffunction name="getByRCTData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			UPPER(CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) 
			THEN '5-Other' ELSE TRIM(rct.RootCauseTypeID || '-' || rt.RootCauseType) END) AS RootCauseType
			, CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) 
			THEN 5 ELSE  rt.RootCauseTypeID END AS RootCauseTypeId


			, SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID

			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>

			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #RootCauseTypeId#>
				<cfset ar[count2][2] = #RootCauseType#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>	
	
	<cffunction name="getByRootData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			UPPER(CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 'Dest-Delv(Temp)+'||TRIM(rcf.RootCauseTestID) ELSE rct.RootCauseRecord END) AS RootCause
			,rcf.RootCauseTestID

			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID


			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			
			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #RootCauseTestID#>
				<cfset ar[count2][2] = #RootCause#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>	
	
	<cffunction name="getBySTCData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			rcf.StartTheClockDate
			,cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) as  stc

			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID


			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			
			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #stc#>
				<cfset ar[count2][2] = #stc#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByStopTCData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			rcf.StopTheClockdate
			,cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) as  stoptc

			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID


			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			
			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #stoptc#>
				<cfset ar[count2][2] = #stoptc#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByOverallData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selOArea" type="string" required="yes">
		<cfargument name="selDArea" type="string" required="yes">
		<cfargument name="selODistrict" type="string" required="yes">
		<cfargument name="selDDistrict" type="string" required="yes">
		<cfargument name="selOFacility" type="string" required="yes">
		<cfargument name="selDFacility" type="string" required="yes">
		<cfargument name="selRootPlant" type="string" required="yes">
		<cfargument name="selSST" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selSSC" type="string" required="yes">
		<cfargument name="selShape" type="string" required="yes">
		<cfargument name="selRootType" type="string" required="yes">
		<cfargument name="selRoot" type="string" required="yes">
		<cfargument name="selSTC" type="string" required="yes">
		<cfargument name="selStopTC" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			'NAT' AS id
			,'National' as descrip

			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt) AS tp_tot
			,SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)- SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) AS fp_tot
			,decode(SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt),0,0, cast(SUM (rcf.Svc1DaySvcOT + rcf.Svc2DaySvcOT + rcf.Svc3DaySvcOT) as decimal(18,8))/ SUM (rcf.Svc1DaySvcCnt + rcf.Svc2DaySvcCnt + rcf.Svc3DaySvcCnt)) as per

			FROM EDWPTSPRODVIEW.RootCausePM90DaysFact rcf
			
			
			INNER JOIN EDWPTSPRODVIEW.PTSMPAggFact af
			ON rcf.MailPieceID = af.MailPieceID   
			INNER JOIN EDWPTSPRODVIEW.PTSProcessCategoryGroup c
			ON af.ProcessCategoryCode = c.ProcessCategoryCode   
			INNER JOIN EDWPTSPRODVIEW.TimePeriod otp						
			ON rcf.StartTheClockDate = otp.PeriodID      
			INNER JOIN EDWPTSPRODVIEW.RootCausePDCMapping rzc
			ON rcf.RootCausePDCZipCode = rzc.RootCausePDCZipCode
			INNER JOIN EDWPTSPRODVIEW.ZipCode ozc
			ON rcf.StartTheClockZipCode = ozc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseOrigZip3Mapping opdc
			ON ozc.ZipCode3 = opdc.ZipCode3
			INNER JOIN EDWPTSPRODVIEW.ZipCode dzc
			ON rcf.StopTheClockZipCode = dzc.ZipCode
			INNER JOIN EDWPTSPRODVIEW.RootCauseDestZip3Mapping dpdc
			ON dzc.ZipCode3 = dpdc.DestZipCode3
			INNER JOIN EDWPTSPRODVIEW.RootCauseTest rct
			ON rcf.RootCauseTestID = rct.RootCauseTestID
			INNER JOIN EDWPTSPRODVIEW.RootCauseType rt
			ON rct.RootCauseTypeID = rt.RootCauseTypeID
			LEFT OUTER JOIN EDWCMNDIMPRODVIEW.FACMasterFacility ddu
			ON rcf.ExpectedDDUFacilityID = ddu.MasterFacilityID


			WHERE rcf.StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			AND rcf.MismatchDestinationZipCodeInd = '0'
			AND rcf.UniqueZIPInd = '0'
			AND rcf.BusinessZIPInd = '0'
			AND rcf.PTSActiveZIPInd in ('1')
			AND rcf.PMOtherExclInd = '0'
			AND rcf.OPMgntOrigInd in (' ', 'I')
			AND rcf.OPMgntDestInd in (' ', 'I')
			AND rcf.SalesSourceCode in ('P', 'M', 'R')
			AND rcf.MailTypeCode in ('DM')
			AND rcf.DeliveryExceptionCode <> 'P' 
			AND rcf.APCInd in (0)
			AND ozc.MilitaryZip5Ind <> '1'
			AND dzc.MilitaryZip5Ind <> '1'
			<cfif selOArea neq ''>and ozc.AreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and dzc.AreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and ozc.DistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and dzc.DistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and TRIM (CASE WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkZipCode THEN opdc.NetworkZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundZipCode THEN opdc.TurnaroundZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.NetworkNMOZipCode THEN opdc.NetworkNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.TurnaroundNMOZipCode THEN opdc.TurnaroundNMOZipCode
				WHEN rt.RootCauseTypeID = 1 AND rzc.RootCausePDCZipCode = opdc.WeekendZipCode THEN opdc.WeekendZipCode
				ELSE opdc.NetworkZipCode END) 
				in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and TRIM (CASE WHEN rzc.RootCausePDCZipCode = dpdc.ADCZipCode THEN ADCZipCode WHEN rzc.RootCausePDCZipCode = dpdc.ADC2ZipCode THEN ADC2ZipCode WHEN rzc.RootCausePDCZipCode = dpdc.SCFZipCode THEN SCFZipCode ELSE ADCZipCode END) in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and TRIM (rzc.RootCausePDC) in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and (CASE WHEN rcf.TransportationModeCode IN ('A') THEN 'A' ELSE rcf.TransportationModeCode END) in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and rcf.SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and rcf.SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and c.ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and CASE WHEN rcf.RootCauseTestID IN (700, 800, 900, 1000, 1100, 1300, 1500, 1600) THEN 5 ELSE rct.RootCauseTypeID END in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and rcf.RootCauseTestID in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((rcf.StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((rcf.StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			
			GROUP BY 1,2
			order by  fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #id#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset ar[count2][6] = #bg_date#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

	<cffunction name="getDates" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="range" type="string" required="yes">
			<cfquery name="wk" datasource="#dsn#">
				select * from (
				SELECT TRUNC (SYSDATE) - ROWNUM as dt,to_char(TRUNC (SYSDATE) - ROWNUM,'MM/DD/YYYY') as strdate
				FROM DUAL CONNECT BY ROWNUM < 36
				)
				<cfif range neq ''>where to_char(dt,'d')=7</cfif>
			</cfquery>
		<cfset ar = arraynew(1)>
		<cfloop query="wk">
			<cfset ar[currentrow]= '#strdate#'>      
		</cfloop>        
		<cfreturn ar>

	</cffunction>

</cfcomponent>