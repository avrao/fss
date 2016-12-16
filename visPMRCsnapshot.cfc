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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			OriginArea AS OArea
			,OriginAreaID AS OAreaid

			, SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per
			
			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf

			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)

			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			OriginDistrict AS ODistrict  
			,OriginDistrictID AS ODistrictid  

			, SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)

			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			UPPER(OriginFacility) AS OPDC
			, OriginationPDCZipCode AS OPDCid
			, SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			DestArea AS DArea
			,DestAreaID AS DAreaid

			, SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode	in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			DestDistrict AS DDistrict  
			,DestDistrictID AS DDistrictid  

			,SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per
			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			UPPER(DestFacility) AS DPDC
			, DestinationPDCZipCode AS DPDCID
			
			, SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf

			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			UPPER(RootCauseFacility) AS PDC
			, RootCausePDCZipCode AS PDCID        

			, SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			TransportationModeCodeDesc AS Tmode_DESC 
			,TransportationModeCode AS Tmode_ID 

			,SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per
			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT
			SvcStdDayTimeCodeDesc  AS SVC_STD
			,cast(SvcStdDayTimeCode as char(2)) as SvcStdDayTimeCode

			, SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			SalesSourceCode AS SalesCode 
			,SalesSourceCodeDesc AS descript

			, SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			ProcessCategoryCODE AS Shape
			,Shape AS descript

			,SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			UPPER(RootType) AS RootCauseType
			, RootType as RootCauseTypeId

			, SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>

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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			UPPER(RootCause) AS RootCause
			,RootCause as RootCauseTestID

			,SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>
			
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
				<cfset ar[count2][4] = #per#/10000>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			StartTheClockDate
			,cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) as  stc

			,SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>
			
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
				<cfset ar[count2][4] = #per#/10000>
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
			StopTheClockdate
			,cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) as  stoptc

			,SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			
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
				<cfset ar[count2][4] = #per#/10000>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByProductCode" access="remote" returntype="array">
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
			MailClassCode AS id
			,MailClassCodeDesc as descrip

			,SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			
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
				<cfset ar[count2][4] = #per#/10000>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset ar[count2][6] = #bg_date#>
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
		<cfargument name="selProCode" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			'NAT' AS id
			,'National' as descrip

			,SUM (MailPieceCount) AS tp_tot
			,SUM (MailPieceCount)- SUM (OntimeCount) AS fp_tot
			,decode(SUM (MailPieceCount),0,0, (SUM (OntimeCount)*10000)/SUM (MailPieceCount)) as per

			FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
			
			WHERE StopTheClockDate BETWEEN cast('#bg_date#' as date format 'mm/dd/yyyy')
			AND cast('#bg_date#' as date format 'mm/dd/yyyy')+cast('#ed_date#' as number)
			
			<cfif selOArea neq ''>and OriginAreaID in (#Replace(selOArea,"''","'","All")#)</cfif>
			<cfif selDArea neq ''>and DestAreaID in (#Replace(selDArea,"''","'","All")#)</cfif>
			<cfif selODistrict neq ''>and OriginDistrictID in (#Replace(selODistrict,"''","'","All")#)</cfif>
			<cfif selDDistrict neq ''>and DestDistrictID in (#Replace(selDDistrict,"''","'","All")#)</cfif>
			<cfif selOFacility neq ''>and OriginationPDCZipCode in (#Replace(selOFacility,"''","'","All")#)</cfif>
			<cfif selDFacility neq ''>and DestinationPDCZipCode in (#Replace(selDFacility,"''","'","All")#)</cfif>
			<cfif selRootPlant neq ''>and RootCausePDCZipCode in (#Replace(selRootPlant,"''","'","All")#)</cfif>
			<cfif selSST neq ''>and TransportationModeCode in (#Replace(selSST,"''","'","All")#)</cfif>
			<cfif selMode neq ''>and SvcStdDayTimeCode in (#Replace(selMode,"''","'","All")#)</cfif>
			<cfif selSSC neq ''>and SalesSourceCode in (#Replace(selSSC,"''","'","All")#)</cfif>
			<cfif selShape neq ''>and ProcessCategoryCODE in (#Replace(selShape,"''","'","All")#)</cfif>
			<cfif selRootType neq ''>and RootType in (#Replace(selRootType,"''","'","All")#)</cfif>
			<cfif selRoot neq ''>and RootCause in (#Replace(selRoot,"''","'","All")#)</cfif>
			<cfif selSTC neq ''>and cast((StartTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selSTC,"''","'","All")#)</cfif>
			<cfif selStopTC neq ''>and cast((StopTheClockDate (format 'mm/dd/yyyy')) as char(10)) in (#Replace(selStopTC,"''","'","All")#)</cfif>
			<cfif selProCode neq ''>and MailClassCode in (#Replace(selProCode,"''","'","All")#)</cfif>
			
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
				<cfset ar[count2][4] = #per#/10000>
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
				<!---select * from (
				SELECT TRUNC (SYSDATE) - ROWNUM as dt,to_char(TRUNC (SYSDATE) - ROWNUM,'MM/DD/YYYY') as strdate
				FROM DUAL CONNECT BY ROWNUM < 36
				<cfif range neq ''>where to_char(dt,'d')=7</cfif>
				)--- >
				SELECT distinct to_char(StopTheClockDate,'MM/DD/YYYY') as strdate
				FROM edwptsPRODview.PTSMSTRRootCauseZip5DayAGG rcf
				<cfif range neq ''>where to_char(StopTheClockDate,'d')=7</cfif>
				order by StopTheClockDate desc--->
				select to_char(PeriodID,'MM/DD/YYYY') as strdate from EDWptsPRODview.TimePeriod where PeriodID between date-8 and date-1<cfif range neq ''> and to_char(PeriodID,'d')=7</cfif> order by 1 desc;
			</cfquery>
		<cfset ar = arraynew(1)>
		<cfloop query="wk">
			<cfset ar[currentrow]= '#strdate#'>      
		</cfloop>        
		<cfreturn ar>

	</cffunction>

</cfcomponent>