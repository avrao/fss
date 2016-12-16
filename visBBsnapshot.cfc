<cfcomponent>

	<cffunction name="getByAreaData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			AD.AREA_NAME AS area,
			AD.AREA_ID AS areaID,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
			GROUP BY 
			AD.AREA_NAME,
			AD.AREA_ID
			order by  fp_tot desc
         
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
			<cfset count=1>
				<cfset ar[count2][1] = #Areaid#>
				<cfset ar[count2][2] = #Area#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>

	</cffunction>
	
	<cffunction name="getByDistData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			AD.DISTRICT_NAME AS district,
			AD.DISTRICT_ID AS districtID,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
			GROUP BY 
			AD.DISTRICT_NAME,
			AD.DISTRICT_ID
			order by  fp_tot desc
         
		</cfquery>
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #Districtid#>
				<cfset ar[count2][2] = #District#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByFacilityData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			STC_FAC.FAC_NAME AS stc_facility,
			STC_FAC.FAC_SEQ_ID AS stc_facilityID,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and AD.DISTRICT_ID in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
			GROUP BY 
			STC_FAC.FAC_NAME,
			STC_FAC.FAC_SEQ_ID
			order by  fp_tot desc
         
		</cfquery>
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #stc_facilityid#>
				<cfset ar[count2][2] = #stc_facility#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByFirstScanFacility" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			FIRST_SCAN_FAC.FAC_NAME AS first_scan_facility,
			FIRST_SCAN_FAC.FAC_SEQ_ID AS first_scan_facilityID,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and AD.DISTRICT_ID in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and STC_FAC.FAC_SEQ_ID in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
			GROUP BY 
			FIRST_SCAN_FAC.FAC_NAME,
			FIRST_SCAN_FAC.FAC_SEQ_ID
			order by  fp_tot desc
         
		</cfquery>
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
			<cfset count=1>
				<cfset ar[count2][1] = #first_scan_facilityid#>
				<cfset ar[count2][2] = #first_scan_facility#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>

	</cffunction>
	
	<cffunction name="getByDevice" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME as first_scan_device,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and AD.DISTRICT_ID in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and STC_FAC.FAC_SEQ_ID in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
			GROUP BY 
			bb.first_scan_device,first_scan_fac.FAC_NAME
			order by  fp_tot desc
         
		</cfquery>
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #first_scan_device#>
				<cfset ar[count2][2] = #first_scan_device#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByMH" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			bb.MULTIPLE_HANDLINGS,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and AD.DISTRICT_ID in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and STC_FAC.FAC_SEQ_ID in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			
			GROUP BY 
			bb.MULTIPLE_HANDLINGS
			order by  fp_tot desc
         
		</cfquery>
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #MULTIPLE_HANDLINGS#>
				<cfset ar[count2][2] = #MULTIPLE_HANDLINGS#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

	<cffunction name="getByMClassData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			UPPER(mail_class.code_desc_long) AS mail_class,
			mail_class.CODE_VAL AS mail_classID,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and AD.DISTRICT_ID in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and STC_FAC.FAC_SEQ_ID in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
			GROUP BY 
			mail_class.code_desc_long,
			mail_class.CODE_VAL
			order by  fp_tot desc
         
		</cfquery>
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #mail_classID#>
				<cfset ar[count2][2] = #mail_class#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

	<cffunction name="getByPKGData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			UPPER(pkg_level.code_desc_long) AS PACKAGE_LEVEL,
			pkg_level.CODE_VAL AS PACKAGE_LEVELID,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and AD.DISTRICT_ID in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and STC_FAC.FAC_SEQ_ID in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
			GROUP BY 
			pkg_level.code_desc_long,
			pkg_level.CODE_VAL
			order by  fp_tot desc
         
		</cfquery>
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #PACKAGE_LEVELID#>
				<cfset ar[count2][2] = #PACKAGE_LEVEL#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>	
	
	<cffunction name="getByDiscData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			UPPER(epfed.code_desc_long) AS entry_discount,
			epfed.CODE_VAL AS entry_discountID,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and AD.DISTRICT_ID in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and STC_FAC.FAC_SEQ_ID in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
			GROUP BY 
			epfed.code_desc_long,
			epfed.CODE_VAL
			order by  fp_tot desc
         
		</cfquery>
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #entry_discountID#>
				<cfset ar[count2][2] = #entry_discount#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>	
	
	<cffunction name="getByPreparerData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			mp.crid as mp_id,mp.mailer_name AS mail_preparer,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and AD.DISTRICT_ID in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and STC_FAC.FAC_SEQ_ID in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
			GROUP BY 
			mp.crid,
			mp.mailer_name
			order by  fp_tot desc
         
		</cfquery>
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #mp_id#>
				<cfset ar[count2][2] = #mail_preparer#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #per#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>	
	
	<cffunction name="getByOwnerData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT 
			mo.crid as mo_id,mo.mailer_name AS mail_owner,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and AD.DISTRICT_ID in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and STC_FAC.FAC_SEQ_ID in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
			GROUP BY 
			mo.crid,
			mo.mailer_name
			order by  fp_tot desc
         
		</cfquery>
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #mo_id#>
				<cfset ar[count2][2] = #mail_owner#>
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
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selFSFacility" type="string" required="yes">
		<cfargument name="selDevice" type="string" required="yes">
		<cfargument name="selMClass" type="string" required="yes">
		<cfargument name="selPKG" type="string" required="yes">
		<cfargument name="selDIS" type="string" required="yes">
		<cfargument name="selPREP" type="string" required="yes">
		<cfargument name="selOWN" type="string" required="yes">
		<cfargument name="selMH" type="string" required="yes">
		<cfargument name="selBRKDWN" type="string" required="yes">
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT  
			'NAT' AS id
			,'National' as descrip,
			SUM (bb.bundle_count) AS tp_tot,
			SUM (broken_#selBRKDWN#_count) AS fp_tot,
			nvl(1-SUM (broken_#selBRKDWN#_count)/SUM (bb.bundle_count),0) AS per
			
			FROM spduser.SPD_BNDL_BREAKAGE bb
			inner join spduser.bi_crid mp
			on bb.mail_preparer_crid = mp.crid 
			inner join spduser.bi_crid mo
			on bb.mail_owner_crid = mo.crid 
			inner join iv_app.facility stc_fac
			on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
			inner join iv_app.facility first_scan_fac
			on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
			inner join spduser.AREADISTNAME_t ad
			on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
			inner join spduser.code_value mail_class
			on mail_class.code_type_name = 'ML_CL_CODE' 
			AND bb.ml_cl_code = mail_class.code_val 
			inner join spduser.code_value pkg_level
			on pkg_level.code_type_name = 'PKG_LVL_CODE' 
			AND bb.ml_cl_code = pkg_level.code_val 
			inner join spduser.code_value epfed
			on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
			AND bb.entry_discount = epfed.code_val
			
			WHERE bb.mailg_date = to_date('#bg_date#','mm/dd/yyyy')
			<cfif selArea neq ''>and AD.AREA_ID in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and AD.DISTRICT_ID in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and STC_FAC.FAC_SEQ_ID in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selFSFacility neq ''>and FIRST_SCAN_FAC.FAC_SEQ_ID in (#Replace(selFSFacility,"''","'","All")#)</cfif>
			<cfif selDevice neq ''>and bb.first_scan_device || ' : ' || first_scan_fac.FAC_NAME in (#Replace(selDevice,"''","'","All")#)</cfif>
			<cfif selMClass neq ''>and mail_class.CODE_VAL in (#Replace(selMClass,"''","'","All")#)</cfif>
			<cfif selPKG neq ''>and pkg_level.CODE_VAL  in (#Replace(selPKG,"''","'","All")#)</cfif>
			<cfif selDIS neq ''>and epfed.CODE_VAL in (#Replace(selDIS,"''","'","All")#)</cfif>
			<cfif selPREP neq ''>and mp.crid in (#Replace(selPREP,"''","'","All")#)</cfif>
			<cfif selOWN neq ''>and mo.crid in (#Replace(selOWN,"''","'","All")#)</cfif>
			<cfif selMH neq ''>and bb.MULTIPLE_HANDLINGS in (#Replace(selMH,"''","'","All")#)</cfif>
			
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
				SELECT distinct  to_char(bb.mailg_date,'MM/DD/YYYY') AS strdate
			
				FROM spduser.SPD_BNDL_BREAKAGE bb
				inner join spduser.bi_crid mp
				on bb.mail_preparer_crid = mp.crid 
				inner join spduser.bi_crid mo
				on bb.mail_owner_crid = mo.crid 
				inner join iv_app.facility stc_fac
				on bb.start_the_clock_facility = STC_FAC.FAC_SEQ_ID 
				inner join iv_app.facility first_scan_fac
				on bb.first_scan_fac_seq_id = first_scan_FAC.FAC_SEQ_ID 
				inner join spduser.AREADISTNAME_t ad
				on first_scan_fac.DIST_ID = AD.DISTRICT_ID 
				inner join spduser.code_value mail_class
				on mail_class.code_type_name = 'ML_CL_CODE' 
				AND bb.ml_cl_code = mail_class.code_val 
				inner join spduser.code_value pkg_level
				on pkg_level.code_type_name = 'PKG_LVL_CODE' 
				AND bb.ml_cl_code = pkg_level.code_val 
				inner join spduser.code_value epfed
				on epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' 
				AND bb.entry_discount = epfed.code_val
				
				ORDER BY strdate desc
			</cfquery>
		<cfset ar = arraynew(1)>
		<cfloop query="wk">
			<cfset ar[currentrow]= '#strdate#'>      
		</cfloop>        
		<cfreturn ar>

	</cffunction>

</cfcomponent>