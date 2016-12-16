<cfcomponent>



<cfset day_table = 'V_BI_ADD_OD_RPT_day_ZIP3'>
<cfset week_table = 'V_BI_ADD_OD_RPT_WEEK_ZIP3'>
<cfset month_table = 'V_BI_ADD_OD_RPT_MONTH_ZIP3'>
<cfset quarter_table = 'V_BI_ADD_OD_RPT_QTR_ZIP3'>


<!---
<cfset day_table = 'V_BI_ADD_OD_RPT_day_ZIP3_STG3'>
<cfset week_table = 'V_BI_ADD_OD_RPT_WEEK_ZIP3_STG3'>
<cfset month_table = 'V_BI_ADD_OD_RPT_MONTH_ZIP3_STG3'>
<cfset quarter_table = 'V_BI_ADD_OD_RPT_QTR_ZIP3_STG3'>
--->

<cfset sdate = parsedatetime(dateformat(dateadd('d',-14,now()),'mm/dd/yyyy'))>
<cfset flist = 'ACTUAL_DLVRY_DATE,IMB_DLVRY_ZIP_3,DESTN_FAC_ZIP_3,ORGN_FAC_ZIP_3,EXCL_STS_CODE,ROOT_CAUSE_CODE,POINT_OF_FAILURE,SVC_STD,SVC_VARIANCE,ML_CL_CODE,ML_CAT_CODE,EDOC_SBMTR_CRID_SEQ_ID,
EDOC_SBMTR_CRID,CERTIFIED_MAILER_IND,DESTN_FAC_SEQ_ID,ORGN_FAC_SEQ_ID,RPT_ORGN_FAC_SEQ_ID,MHTS_FAC_SEQ_ID,EPFED_FAC_TYPE_CONSLN_CODE,INDCTN_MTHD,ORGN_ENTERED,JOB_SEQ_ID,OP_CODE,SV_SCAN_IND,
SCAN_FAC_ZIP_9,SCAN_FAC_ZIP_3,SCAN_DATETIME,MPE_ID,MPE_DLVRY_POINT,MPE_DLVRY_ZIP_9,IMB_CODE,IMB_DLVRY_POINT,IMB_DLVRY_ZIP_5,IMB_MID_SEQ_ID,IMCB_CODE,IMTB_CODE,ID_TAG,HU_LBL_CIN_CODE,
HU_LVL_CODE,HU_TYPE_CODE,SORT_PLAN,CRITICAL_ENTRY_TIME,ACTUAL_ENTRY_DATETIME,RUN_START_DATETIME,MAILG_DATE,MAILG_SEQ_ID,START_THE_CLOCK_DATE,SPM_CALC_BATCH_DATE,SPM_GRP_SEQ_ID,SPM_SCAN_PARTITION_KEY,
PHYS_CONTR_SEQ_ID,LOGICAL_CONTR_SEQ_ID,ASSOCD_PIECE_SCAN_SEQ_ID,ASSOCD_PIECE_SCAN_HDR_SEQ_ID,PHYS_HU_SEQ_ID,LOGICAL_HU_SEQ_ID,EPFED_FAC_TYPE_CODE,ORGN_FAC_ZIP_5,FINAL_OP_CODE,CONTR_LVL_CODE,
RATE_CAT_CODE,RATE_TYPE_CODE,EXPECTED_DLVRY_DATE,CLEARANCE_TIME,RECORD_TYPE_CODE,PREP_TYPE_CODE,RANGE_IND,STOP_SCAN_DATETIME,STOP_SCAN_FAC_ZIP_CODE,LAST_SCAN_OP_CODE,LAST_SCAN_DATETIME,
LAST_SCAN_FAC_ZIP_CODE,PIECE_RANGE_SEQ_ID,PHYS_PIECE_SEQ_ID,VIRTUAL_SACK_SEQ_ID,DATE_PARTITION_KEY,MAILER_PARTITION_KEY,CREATE_DATETIME,RUN_SEQ_NBR,WIDE_FOV_SEQ_NBR,POCKET_NBR,DPS_SEQ_NBR,
STOP_SCAN_IND,FSS_SCAN_IND,BUNDLE_SCAN_IND,CAIR_SCAN_IND,FEDEX_AIR_SCAN_IND,THS_CLEAN_AIR_SCAN_IND,PLANT_DU_FAIL_RSN_CODE,PHYS_BUNDLE_SEQ_ID,END_TO_END_TRANSIT_HRS,END_TO_END_TRANSIT_HRS_ADJ,
DOA_DESTN_PLNT_IND,DESTN_PLNT_SCAN_DATETIME,DESTN_PLNT_FAC_SEQ_ID,DESTN_PLNT_OP_CODE,DESTN_PLNT_MACH_TYPE,DSTNC_ORGN_FAC_DESTN_PLNT,DSTNC_ORGN_FAC_DESTN_PLNT_ZIP,DSTNC_ORGN_ZIP_DESTN_PLNT_ZIP,
DESTN_PLNT_FAC_ZIP_5,EXPECTED_AIR_IND,POLITICAL_MAILING_IND,ORGN_LOC_CODE,DESTN_LOC_CODE'>


	<cffunction name="getByAreaData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">                
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">                                                    
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                
                
		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>


		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
         with AREADISTNAME as (
             select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
             from  areadistname_t
             where area_id not in ('4M','4N')
<!---            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
			)

			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
			area_name,ad.area_id,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <!---
			<cfif selPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>--->

			WHERE 
                        <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<!---<cfif selArea neq 'All'>and ad.area_id = '#selArea#'</cfif>
			<cfif selDistrict neq 'All'>and ad.district_id = '#selDistrict#'</cfif>--->
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>                
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
            <cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              

			group by area_name,ad.area_id
			) gp
			where  tp_tot > 0
			order by fp_tot
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
			<cfset count=1>
				<cfset ar[count2][1] = #area_id#>
				<cfset ar[count2][2] = #area_name#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>

	</cffunction>
	
	<cffunction name="getByDistData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">                
        <cfargument name="selOrgFac" type="string" required="yes">
        <cfargument name="selEntType" type="string" required="yes">                                
        <cfargument name="selInduct" type="string" required="yes">   
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                             
        
		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>

		

		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
        with AREADISTNAME as (
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
            )

			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */  gp.*
			FROM (  SELECT
			district_name,ad.district_id,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<!---<cfif selDistrict neq 'All'>and ad.district_id = '#selDistrict#'</cfif>--->
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>    
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                                      
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by district_name,ad.district_id
			) gp
            where  tp_tot > 0
			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #district_id#>
				<cfset ar[count2][2] = #district_name#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByFacilityData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">        
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">  
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                          

                                                            


		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
        with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null
--->			
			)

			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
			<cfif selDir is 'O'>
				fp.orgn_fac_seq_id as fac_key,
				REPLACE(fac_name,'/','-') as fac_name,
			<cfelse>
				fp.destn_fac_seq_id as fac_key,
				REPLACE(fac_name,'/','-') as fac_name,
			</cfif> 
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by <cfif selDir is 'O'>
				fp.orgn_fac_seq_id,ORGN_FAC_ZIP_3,
				REPLACE(fac_name,'/','-')
			<cfelse>
				fp.destn_fac_seq_id,
				REPLACE(fac_name,'/','-')
			</cfif> 
			) gp
            where  tp_tot > 0
			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #fac_key#>
				<cfset ar[count2][2] = #fac_name#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByDayData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'air_piece_cnt'>
		 <cfset fail_piece_cnt = 'air_fail_piece_cnt'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(piece_cnt-air_piece_cnt)'>
		  <cfset fail_piece_cnt = '(fail_piece_cnt-air_fail_piece_cnt)'>
		<cfelse>
		  <cfset piece_cnt = 'piece_cnt'>
		  <cfset fail_piece_cnt = 'fail_piece_cnt'>
		</cfif>
		
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
        with AREADISTNAME as
         (select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---            
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
			)
			SELECT dow,day,tp_tot,PER_tot,fp_tot
			FROM (  SELECT to_char(start_the_clock_date,'d') as dow, UPPER(to_char(start_the_clock_date,'day')) as day,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ (sum(#piece_cnt#) +.000000001)   
			AS PER_tot
			FROM  V_BI_AGG_STC_OD_DAY fp
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end 
            and st.ml_cl_code = fp.ml_cl_code
			WHERE fp.START_THE_CLOCK_DATE
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by to_char(start_the_clock_date,'d'),UPPER(to_char(start_the_clock_date,'day'))
			) gp
            where  tp_tot > 0
			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
			<cfset count=1>
				<cfset ar[count2][1] = #dow#>
				<cfset ar[count2][2] = #day#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByClassData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">                          
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">                                                    
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

        

                            

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<!---<cfif selEod contains 'Y' and selEod does not contain 'N' ><cfset selEod ='Y'>
		<cfelseif selEod contains 'N' and selEod does not contain 'Y' ><cfset selEod ='N'>
		<cfelse><cfset selEod =''></cfif>--->
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
        with AREADISTNAME as
         (select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---            with AREADISTNAME as
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
            )
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
			fp.ml_cl_code as classCode,
            case when fp.ml_cl_code = 1 then 'FIRST CLASS' 
            when fp.ml_cl_code = 2 then 'PERIODICALS' 
            when fp.ml_cl_code = 3 then 'STANDARD'
             end as descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<!---<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>--->
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>         
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                               
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by fp.ml_cl_code
                 			order by fp_tot desc
			) gp
            where  tp_tot > 0
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #classCode#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByCatData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">                         
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">  
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                          

                            

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>


		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
         with AREADISTNAME as (
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---             
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
			)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
			fp.ml_cat_code,
            case when fp.ml_cat_code = 1 then 'LETTERS' 
            when fp.ml_cat_code = 2 then 'FLATS' 
            when fp.ml_cat_code = 3 then 'CARDS' 
            when fp.ml_cat_code = 4 then 'PACKAGES'
            end as descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<!---<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>--->
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>  
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>   
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                                     
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by fp.ml_cat_code
			) gp
            where  tp_tot > 0
     			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #ml_cat_code#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByEODData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">  
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                          

                                                    

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
			st.orgn_entered,case when st.orgn_entered = 'Y' then 'ORIGIN' when st.orgn_entered = 'N' then 'DESTINATION' end as descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by st.orgn_entered
			) gp
            where  tp_tot > 0
			order by fp_tot desc            
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #orgn_entered#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByOverallData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">        
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">                                                    
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                


                                                      

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
        		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
       with AREADISTNAME as (
         select/*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
			'OverAll' as id,'OverAll' as descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ (sum(#piece_cnt#) +.000000001)   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)<cfelseif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
			<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			) gp
            where  tp_tot > 0
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
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getBySvcStdData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">        
        <cfargument name="selMailer" type="string" required="yes">  
        <cfargument name="selImbZip3" type="string" required="yes">
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                            

                    
                                              
		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
        		 
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
        with AREADISTNAME as
         (select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---        (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
         from BI_AREA_DISTRICT_HIST
         where area not in ('4M','4N') and end_date is null--->
         )
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
			st.hyb_svc_std,upper(HYB_SVC_STD_DESC) as descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
 			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif> 
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                                      
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by st.hyb_svc_std,HYB_SVC_STD_DESC
			) gp
            where  tp_tot > 0
			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #hyb_svc_std#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getAreaDistData" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">    

		<cfquery name="areaDist_q" datasource="#dsn#" blockfactor="100">
         select area_id as area,area_name,district_id as district,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---        select  distinct area ,site_name as area_name,district,district_name
         from BI_AREA_DISTRICT_HIST
         where area not in ('4M','4N') and end_date is null
			order by area_name,district_name--->
		</cfquery>

		<cfset ar = arraynew(2)>
		<cfloop query="areaDist_q">
		<cfset ar[currentrow][1]= '#area_name#'>
		<cfset ar[currentrow][2]= '#area#'>
		<cfset ar[currentrow][3]= '#district_name#'>    
		<cfset ar[currentrow][4]= '#district#'>      
		</cfloop>

		<cfreturn ar>

	</cffunction>

	<cffunction name="getDates" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="range" type="string" required="yes">
		
		<cfif range is 'MON'>
			<cfquery name="wk" datasource="#dsn#" blockfactor="100">
                SELECT dt as beg_mon_date,add_months(dt,1)-1 as end_mon_date,to_char(dt,'mm/dd/yyyy') as strdate,to_char(add_months(dt,1)-1,'mm/dd/yyyy') as strend 
                FROM
                (select (select min(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3)+rownum as dt
                from V_BI_ADD_OD_RPT_DAY_ZIP3
                where rownum <= (select max(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3)-(select min(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3))
                where to_char(dt,'dd')=1
                order by dt desc
		 </cfquery>
		<cfelseif range is 'QTR'>
			<cfquery name="wk" datasource="#dsn#" blockfactor="100">
                SELECT dt as beg_qtr_date,add_months(dt,3)-1 as end_qtr_date,to_char(dt,'mm/dd/yyyy') as strdate, to_char(add_months(dt,3)-1,'mm/dd/yyyy') as strend 
                FROM
                (select (select min(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3)+rownum-1 as dt
                from V_BI_ADD_OD_RPT_DAY_ZIP3
                where rownum <= (select max(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3)-(select min(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3))
                where to_char(dt,'MM') IN('01','04','07','10') AND to_char(dt,'DD')  =1
                order by dt desc
			</cfquery>
		<cfelse>
			<cfquery name="wk" datasource="#dsn#" blockfactor="100">
               SELECT dt AS beg_wk_date,DT + 6 AS end_wk_date,TO_CHAR (dt, 'MM/DD/YYYY') AS strdate,to_char(DT + 6,'mm/dd/yyyy') as strend  
                FROM (SELECT   (SELECT MIN (ACTUAL_DLVRY_DATE) FROM V_BI_ADD_OD_RPT_DAY_ZIP3)+ ROWNUM AS dt
                FROM V_BI_ADD_OD_RPT_DAY_ZIP3
                WHERE ROWNUM <=  (SELECT MAX (ACTUAL_DLVRY_DATE) FROM V_BI_ADD_OD_RPT_DAY_ZIP3)- (SELECT MIN (ACTUAL_DLVRY_DATE) FROM V_BI_ADD_OD_RPT_DAY_ZIP3))
                WHERE TO_CHAR (dt, 'd') = 7
                ORDER BY dt DESC
			</cfquery>
		</cfif>
		
		<cfset ar = arraynew(2)>
		<cfloop query="wk">
			<cfset ar[currentrow][1]= '#strdate#'>      
			<cfset ar[currentrow][2]= '#strend#'>                  
		</cfloop>        
		<cfreturn ar>

	</cffunction>


	<cffunction name="getHybStd" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">    
		<cfargument name="selClass" type="string" required="yes">                                 			
		<cfargument name="selEOD" type="string" required="yes">                                 			

        <cfquery name="std_q" datasource="#dsn#">
         select distinct
         ML_CL_CODE, HYB_SVC_STD,HYB_SVC_STD_DESC 
          from 
        BI_MSTR_SVC_STD
        where hyb_svc_std > 0
        <cfif selClass is not ''>and ml_cl_code = '#selClass#'</cfif>
        <cfif selEOD is not ''>and ORGN_ENTERED = '#selEod#'</cfif> 
        <!---<cfif selEOD is  'Y'>and hyb_svc_std not in (21,22)</cfif>--->
        order by  hyb_svc_std
   </cfquery>
 	<cfset ar = arraynew(2)>
   <cfloop query="STD_Q">
      <cfset ar[currentrow][1]= '#HYB_SVC_STD#'>
      <cfset ar[currentrow][2]= '#HYB_SVC_STD_DESC#'>      
    </cfloop>
		<cfreturn ar>
	</cffunction>


	<cffunction name="getByCntrData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">        
        <cfargument name="selRange" type="string" required="yes">        
        <cfargument name="selMailer" type="string" required="yes"> 
        <cfargument name="selImbZip3" type="string" required="yes"> 
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">                                                    
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

        

                            
                       
		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
	  	
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
       with AREADISTNAME as(
         select  /*+ result_cache */  area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null
--->			
			)

			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
		    fp.CONTR_LVL_CODE,
            upper(bc.code_desc_long) AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            inner join iv_app.bi_code_value bc
            on bc.CODE_TYPE_NAME ='CONTR_LVL_CODE'
            and fp.CONTR_LVL_CODE = bc.code_val 

			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>            
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
            <cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>                          
			<!---cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE = '#selCntrLvl#' </cfif>--->  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
            group by                    
            fp.CONTR_LVL_CODE,
            bc.code_desc_long 

			) gp
            where  tp_tot > 0
			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #CONTR_LVL_CODE#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
    

	<cffunction name="getByMailerData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">        
        <cfargument name="selRange" type="string" required="yes">        
        <cfargument name="selMailer" type="string" required="yes">                
        <cfargument name="selImbZip3" type="string" required="yes">  
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                            
        <cfargument name="selMlrFlg" type="string" required="yes">                                                    
                                          

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
        with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null
--->			
			)

			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT UPPER(b.mlr_name) AS mlr_name,fp.crid,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            inner join 
            bi_opsvis_crid b
            ON fp.CRID = b.CRID

			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
            <cfif selMlrFlg is 'Y'>
                  <cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>
            </cfif>      
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by fp.crid,b.mlr_name
			) gp
            where  tp_tot > 0
			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #crid#>
				<cfset ar[count2][2] = #mlr_name#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
    
	<cffunction name="getByAir" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">   
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">    
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                        

                                                 

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
			nvl(fp.expected_air_ind,'N') as expected_air_ind,case when nvl(fp.expected_air_ind,'N') = 'Y' then 'AIR' else 'SURFACE' end as descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  

			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by nvl(fp.expected_air_ind,'N')
			) gp
            where  tp_tot > 0
   			order by fp_tot desc 
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #expected_air_ind#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
    
	<cffunction name="getByFSS" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">       
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                            

                                             

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
			 nvl(fp.fss_scan_ind,'N') as fss_scan_ind,
               CASE
                  WHEN nvl(fp.fss_scan_ind,'N') = 'Y' THEN 'FSS'
                  WHEN nvl(fp.fss_scan_ind,'N') = 'N' THEN 'NON-FSS'
               END
                  AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by nvl(fp.fss_scan_ind,'N')
			) gp
            where  tp_tot > 0
			order by fp_tot desc            
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #fss_scan_ind#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

	<cffunction name="getByDestZip3" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">    
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">   
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                         

                                                

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
                  IMB_DLVRY_ZIP_3,
                  IMB_DLVRY_ZIP_3 || '-' || destfac.plt_fac_name
                   AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
                      INNER JOIN bi_plt_area_district destfac
                      ON destfac.plt_fac_zip_3 = fp.IMB_DLVRY_ZIP_3
                      and destfac.district =  fp.destn_district
 
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
<!---            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              --->
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by IMB_DLVRY_ZIP_3, IMB_DLVRY_ZIP_3 || '-' || destfac.plt_fac_name
			) gp
            where  tp_tot > 0
      			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #IMB_DLVRY_ZIP_3#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

	<cffunction name="getByOrgFacData" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">        
        <cfargument name="selRange" type="string" required="yes">        
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes"> 
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes"> 
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                           

                                                           


		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
        with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null
--->			
			)

			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
				fp.orgn_fac_seq_id as fac_key,
				REPLACE(fac_name,'/','-') as fac_name,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = fp.orgn_fac_seq_id
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and fp.destn_area in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and fp.destn_district in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and fp.destn_fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif>            
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
	        <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
<!---            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          --->
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by 
				fp.orgn_fac_seq_id,
				REPLACE(fac_name,'/','-')
			) gp
            where  tp_tot > 0
			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #fac_key#>
				<cfset ar[count2][2] = #fac_name#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>


	<cffunction name="getFailedPcsData" access="remote"  returntype="query">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">        
        <cfargument name="selRange" type="string" required="yes">        
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes"> 
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">
        <cfargument name="selDestnFac" type="string" required="yes">
                                                            

                                                           



<cfquery name="seq_q" datasource="#dsn#">
select crid_seq_id from bi_crid_stg
<cfif selMailer is ''>
where crid is null
<cfelse>
where crid in (#Replace(selMailer,"''","'","All")#) 
</cfif>

</cfquery>






<CFSET seq_list = valuelist(seq_q.crid_seq_id)>

		
		<cfquery name="dta" datasource="#dsn#" blockfactor="70">
        with fpieces as
        (
          SELECT /*+ result_cache */DENSE_RANK () OVER (ORDER BY imb_code) AS rec_no, gp.*
          from
          (
          <!--- dly--->
          select #flist# from
             IV_app.BI_ADD_FAILED_PIECE_SCAN_dly fp
            inner join bi_facility a
            on a.fac_seq_id = <cfif selDir is 'O'> fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>    
           WHERE fp.actual_dlvry_date 
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        
            <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
             <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3  = '#selImbZip3#' </cfif>              
             <cfif selOrgFac is not ''>and fp.orgn_fac_zip_3 = '#selOrgFac#' </cfif>                          
             <cfif seldestnFac is not ''>and fp.destn_fac_seq_id = #selDestnFac# </cfif>                                       
            
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
           and EXCL_STS_CODE is null
            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"'","","All")#)</cfif>
           <cfif selPol neq ''>and POLITICAL_MAILING_IND in (#replace(Replace(selPol,"''","'","All"),'E','Y','ALL')#)</cfif>             
            <cfif seq_list is not ''>and fp.edoc_sbmtr_crid_seq_id in (#seq_list#) </cfif>
			<cfif selDir is 'O'> 
				<cfif selFacility neq ''>and fp.orgn_fac_seq_id in (#Replace(selFacility,"'","","All")#)</cfif>            
                <cfelse>
                <cfif selFacility neq ''>and fp.destn_fac_seq_id in (#Replace(selFacility,"'","","All")#)</cfif>            
            </cfif>            
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"'","","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"'","","All")#)</cfif>
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"'","","All")#) </cfif>  
			<cfif selEod neq ''>and fp.ORGN_ENTERED = '#selEod#'</cfif>
            <cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>                
          <!--- dly--->            
          union
          <!--- wkly--->
          select #flist# from
             IV_app.BI_ADD_FAILED_PIECE_SCAN_wkly fp
            inner join bi_facility a
            on a.fac_seq_id = <cfif selDir is 'O'> fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>    
           WHERE fp.actual_dlvry_date 
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        
            <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
             <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3  = '#selImbZip3#' </cfif>              
             <cfif selOrgFac is not ''>and fp.orgn_fac_zip_3 = '#selOrgFac#' </cfif>                          
             <cfif seldestnFac is not ''>and fp.destn_fac_seq_id = #selDestnFac# </cfif>                                       
            
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
           and EXCL_STS_CODE is null
            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"'","","All")#)</cfif>
           <cfif selPol neq ''>and POLITICAL_MAILING_IND in (#replace(Replace(selPol,"''","'","All"),'E','Y','ALL')#)</cfif>             
            <cfif seq_list is not ''>and fp.edoc_sbmtr_crid_seq_id in (#seq_list#) </cfif>
			<cfif selDir is 'O'> 
				<cfif selFacility neq ''>and fp.orgn_fac_seq_id in (#Replace(selFacility,"'","","All")#)</cfif>            
                <cfelse>
                <cfif selFacility neq ''>and fp.destn_fac_seq_id in (#Replace(selFacility,"'","","All")#)</cfif>            
            </cfif>            
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"'","","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"'","","All")#)</cfif>
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"'","","All")#) </cfif>  
			<cfif selEod neq ''>and fp.ORGN_ENTERED = '#selEod#'</cfif>
            <cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>                
          <!--- dly--->            
            
            order by imb_code,scan_datetime             
           ) gp
        )                   

      select * from
      (   
			 SELECT 
               rec_no,
               ad.plt_fac_name AS plt_facility_name,               
               case when length(fp.op_code) < 3 then LPAD (fp.op_code, 3, 0) else to_char(fp.op_code) end AS op_code,               
               fp.mpe_id,
               NVL (fp.sort_plan, '-') AS sort_plan,
               to_char(fp.scan_datetime,'MM/DD/YYYY HH24:MI') as scan_datetime,
               '_' || fp.imb_code  as imb_code,
               cin.code_desc as declared_TRAY_CONTENT, 
               fp.orgn_fac_zip_3 AS origin_fac_zip3,
               SUBSTR(fp.SCAN_FAC_ZIP_9,1,5) AS fac_zip_code,
               fp.mpe_dlvry_point AS sort_zip,
               NVL (z4.carrier_route_id, '-') as route_id,
               LPAD (fp.id_tag, 16, 0) AS id_tag,
               to_char(fp.start_the_clock_date,'mm/dd/yyyy') as start_the_clock_date, 
               NVL (fp.imcb_code, 'Logical Contr') AS imcb_code,
               to_char(fp.actual_entry_datetime,'MM/DD/YYYY HH24:MI')  AS actual_entry_datetime,
               fp.critical_entry_time AS critical_entry_time,
               fp.CLEARANCE_TIME,
               NVL (cv.code_desc, '') AS INDCTN_MTHD,
               NVL (op.op_desc, '') AS op_code_desc,
               cr.mailer_name,
               cr.crid AS edoc_crid,
               decode(fp.ml_cl_code,1,'First Class',2,'Periodicals',3,'Standard',4,'Packages',fp.ml_cl_code) as Mail_Class,
               decode(fp.ml_cat_code,1,'Letters',2,'Flats',3,'Periodical',fp.ml_cat_code) as Mail_Shape,
               fp.svc_std as svc_std,
               <!---fp.lpo_type_code,--->
               rc.ROOT_CAUSE_desc as root_cause,
               orgn_loc_code as ORGN_Urban_Rural, 
               destn_loc_code as destn_Urban_Rural                
    from
            fpieces fp
            INNER JOIN IV_APP.bi_plt_area_district ad
              ON fp.scan_FAC_ZIP_3 = ad.plt_fac_zip_3
            left JOIN iv_app.BI_CODE_VALUE cv
                  ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
            left JOIN iv_app.BI_CODE_VALUE cin
                  ON cin.code_type_name = 'CIN_CODE'   AND cin.code_val = fp.HU_LBL_CIN_CODE
            left JOIN IV_APP.bi_OP_CODE op
                 ON op.op_code = fp.op_code
             LEFT JOIN IV_APP.BI_ZIP4_STG z4
                  ON z4.ZIP_9 = SUBSTR (fp.mpe_DLVRY_POINT, 1, 9)
               INNER JOIN IV_APP.BI_CRID cr
                 ON fp.edoc_sbmtr_crid_seq_id = cr.crid_seq_id
<!---             INNER JOIN IV_APP.opsvis_crid pr
                ON Pr.CRID = CR.cRID --->
           inner join spduser.BI_MSTR_SVC_STD st
             on st.svc_std = fp.svc_std and st.orgn_entered = fp.orgn_entered  and st.ml_cl_code = fp.ml_cl_code
            inner join
            IV_APP.V_MSTR_REL_EPFED_CONSLN con
             on  con.epfed_fac_type_code = fp.epfed_fac_type_code
            INNER JOIN IV_APP.BI_MSTR_ROOT_CAUSE RC
            ON RC.ROOT_CAUSE_CODe = fp.ROOT_CAUSE_CODe  
<!---            <cfif selPol neq '' and  selPol does not contain ','>
            left join IV_APP.POLITICAL_MAILINGS pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>   --->    
   			<cfif selHybStd neq ''>where st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
     order by rec_no,scan_datetime
     )
       where rownum < 10000
		</cfquery>        
        <cfset rn = dta.recordcount>
        <cfset temp = queryaddrow(dta)>
        <cfset temp = querysetcell(dta,'plt_facility_name','#bg_date#')>
  <cfreturn dta>
	</cffunction>



	<cffunction name="getFailedPcszip3" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">        
        <cfargument name="selRange" type="string" required="yes">        
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes"> 
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">    
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                        

                                                           



<cfquery name="seq_q" datasource="#dsn#">
select crid_seq_id from bi_crid_stg
<cfif selMailer is ''>
where crid is null
<cfelse>
where crid in (#Replace(selMailer,"''","'","All")#) 
</cfif>
</cfquery>


<cfquery name="date_q" datasource="#dsn#" >
select to_char(to_date('#bg_date#','mm/dd/yyyy') + level -1,'dd-mon-yyyy') as dt
from dual
connect by to_date('#bg_date#','mm/dd/yyyy') + level -1 <= to_date('#ed_date#','mm/dd/yyyy') 
</cfquery>

<CFSET seq_list = valuelist(seq_q.crid_seq_id)>
<CFSET date_list = quotedvaluelist(date_q.dt)>


		
		<cfquery name="dta" datasource="#dsn#" result="results" blockfactor="100" >
         with AREADISTNAME as (
             select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
             from  areadistname_t
             where area_id not in ('4M','4N')
			)
            select /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ 
            TO_CHAR(actual_dlvry_date,'mm/dd/yyyy') as actual_dlvry_date ,
            <cfif selDir is 'O'>a.fac_name<cfelse>b.fac_name</cfif> as ORIGIN_FACILTY,
            orgn_fac_zip_3,
            <cfif selDir is 'O'>b.fac_name<cfelse>a.fac_name</cfif> as DESTN_FACILITY,
            imb_dlvry_zip_3,
            sum(total_incl_piece_cnt-TOTAL_INCL_PASSED_PIECE_CNT) as failed_pieces,
            sum(total_incl_piece_cnt) as total_pieces,
            round(decode(sum(total_incl_piece_cnt),0,0,sum(total_incl_passed_piece_cnt)/sum(total_incl_piece_cnt))*1000)/1000 as per,
            fp.destn_fac_seq_id as fac_seq_id
            from #day_table# fp
            LEFT JOIN bi_facility a
            ON a.fac_SEQ_ID = 
            <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
            LEFT JOIN bi_facility b
            ON b.fac_SEQ_ID = 
            <cfif selDir is 'D'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
            inner join
            AREADISTNAME ad
            on a.dist_id = ad.district_id 
            inner join BI_MSTR_SVC_STD st
            on st.svc_std = fp.svc_std  and st.orgn_entered = fp.orgn_entered
             and st.ml_cl_code = fp.ml_cl_code


            WHERE fp.actual_dlvry_date in (#preservesinglequotes(date_list)#)
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"'","","All")#)</cfif>
            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"'","","All")#)</cfif>            
            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>            
   			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
				<cfif selDir is 'O'>
                    <cfif seldistrict neq ''>and fp.orgn_district in (#Replace(seldistrict,"'","","All")#)</cfif>
                 <cfelse>
                    <cfif seldistrict neq ''>and fp.destn_district in (#Replace(seldistrict,"'","","All")#)</cfif>                                    
                </cfif>
            <cfif seq_list is not ''>and fp.edoc_sbmtr_crid_seq_id in (#seq_list#) </cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"'","","All")#) </cfif>                          
            <cfif selDir is 'O'> 
				<cfif selFacility neq ''>and fp.orgn_fac_seq_id in (#Replace(selFacility,"'","","All")#)</cfif>            
           <cfelse>
                <cfif selFacility neq ''>and fp.destn_fac_seq_id in (#Replace(selFacility,"'","","All")#)</cfif>            
            </cfif>            
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"'","","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"'","","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"'","","All")#)</cfif>
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"'","","All")#) </cfif>  
			<cfif selEod neq ''>and fp.ORGN_ENTERED  in (#Replace(selEod,"''","'","All")#) </cfif>
			<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>                
    group by a.fac_name,b.fac_name, actual_dlvry_date,orgn_fac_zip_3,imb_dlvry_zip_3,fp.destn_fac_seq_id
    having          SUM (total_incl_piece_cnt - TOTAL_INCL_PASSED_PIECE_CNT) > 0
         
         order by failed_pieces desc

 </cfquery>        
 

 		<cfset ar = arraynew(2)>
		<cfset clist = '#arraytolist(dta.getcolumnList())#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(#clist#)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #actual_dlvry_date#>
				<cfset ar[count2][2] = #ORIGIN_FACILTY#>
				<cfset ar[count2][3] = #orgn_fac_zip_3#>
				<cfset ar[count2][4] = #DESTN_FACILITY#>
				<cfset ar[count2][5] = #imb_dlvry_zip_3#>
				<cfset ar[count2][6] = #failed_pieces#>
				<cfset ar[count2][7] = #total_pieces#>
				<cfset ar[count2][8] = #per#>
				<cfset ar[count2][9] = #fac_seq_id#>                
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #results.executiontime#>                                                

 
 
 
  <cfreturn ar>
	</cffunction>

	<cffunction name="getByPolitical" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
                <cfargument name="selRange" type="string" required="yes">
                <cfargument name="selMailer" type="string" required="yes">        
                <cfargument name="selImbZip3" type="string" required="yes">    
                <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">  
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                          

                                                

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
                   NVL(political_mail_ind,'Y') AS political,
                  CASE
                      WHEN NVL(political_mail_ind,'Y') = 'N' THEN 'NON-POLITICAL'
                      WHEN NVL(political_mail_ind,'Y') = 'E' THEN 'OFFICIAL ELECTION MAIL'
                      WHEN NVL(political_mail_ind,'Y') = 'Y' THEN 'POLITICAL'
                   END
                      AS descrip,
                   sum(#piece_cnt#) as tp_tot,
		   sum(#fail_piece_cnt#) as fp_tot,
                   decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
<!---                      INNER JOIN bi_plt_area_district destfac
                      ON destfac.plt_fac_zip_3 = fp.IMB_DLVRY_ZIP_3
                      and destfac.district =  fp.destn_district--->
 
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code

			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>


            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
                        <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by 
                      NVL(political_mail_ind,'Y')

			) gp
            where  tp_tot > 0
      			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #political#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

	<cffunction name="getByEntType" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">    
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">  
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                          

                                                

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
                       fp.EPFED_FAC_TYPE_CONSLN_CODE,
                       epfed_consln_short_desc AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
 
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
                        left join iv_app.V_MSTR_LU_EPFED_CONSLN con
                        on fp.EPFED_FAC_TYPE_CONSLN_CODE = con.EPFED_FAC_TYPE_CONSLN_CODE                         
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

<!---            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>--->
            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>
            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by fp.EPFED_FAC_TYPE_CONSLN_CODE,
                       epfed_consln_short_desc
			) gp
            where  tp_tot > 0
      			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #EPFED_FAC_TYPE_CONSLN_CODE#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
    
	<cffunction name="getByInductMthd" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
	        <cfargument name="selRange" type="string" required="yes">
	        <cfargument name="selMailer" type="string" required="yes">        
	        <cfargument name="selImbZip3" type="string" required="yes">    
	        <cfargument name="selOrgFac" type="string" required="yes">    
	        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">                                                    
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                


                                                

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
			fp.INDCTN_MTHD,
		         NVL (cv.code_desc, '') AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
 
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            left JOIN  iv_app.bi_code_value cv
                  ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>
            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			group by fp.INDCTN_MTHD,
		              NVL (cv.code_desc, '')
			) gp
            	where  tp_tot > 0
   			order by fp_tot desc
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #INDCTN_MTHD#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

	<cffunction name="getByFuLLSvc" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">       
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">    
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                        

                                             

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  
			 SELECT NVL (fp.CERTIFIED_MAILER_IND, 'N') AS CERTIFIED_MAILER_IND,
                   CASE
                      WHEN NVL (fp.CERTIFIED_MAILER_IND, 'N') = 'Y' THEN 'FULL SERVICE'
                      WHEN NVL (fp.CERTIFIED_MAILER_IND, 'N') = 'N' THEN 'NON-COMPLIANT'
                   END
                      AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
           
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

            <!---BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>--->
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          

			group by NVL (fp.CERTIFIED_MAILER_IND, 'N')
			) gp
            where  tp_tot > 0
			order by fp_tot desc            
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #CERTIFIED_MAILER_IND#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

<cffunction name="getthrudate" access="remote" returntype="string">
	<cfargument name="dsn" type="string" required="yes">
    <cfquery name="thru_q" datasource="#dsn#">
        select to_char(actual_dlvry_date,'mm/dd/yyyy') as dt
        from
        (
            select actual_dlvry_date, per
            from
            (
                select   actual_dlvry_date,  rw/avg(rw) over() as per 
                from
                (
                select actual_dlvry_date, count(total_incl_piece_cnt) rw   
                FROM V_BI_ADD_OD_RPT_day_ZIP3
                where actual_dlvry_date > (select max(actual_dlvry_date)-7 from V_BI_ADD_OD_RPT_day_ZIP3)
                group by  actual_dlvry_date
                )
            )
            where per >.8 
            order by actual_dlvry_date desc
        )
        where rownum < 2
    </cfquery>
		<cfreturn thru_q.dt>
	</cffunction>


	<cffunction name="getByTrend" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">        
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                            

                                                      

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
        		
		<cfquery name="dta" datasource="#dsn#" blockfactor="100">
       with AREADISTNAME as (
         select/*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  SELECT
            <cfif selRange is 'WEEK'>
            to_char(fp.ACTUAL_DLVRY_week,'mm/dd/yyyy') as id,
            <cfelseif selRange is 'mon'>
            to_char(fp.ACTUAL_DLVRY_month,'mm/dd/yyyy') as id,
            <cfelse>
            to_char(fp.actual_dlvry_quarter,'mm/dd//yyyy') as id
            </cfif>
            'OverAll' as descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ (sum(#piece_cnt#) +.000000001)   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
			 <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)<cfelseif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
			<cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
            group by 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			) gp
            where  tp_tot > 0
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
<!---				<cfset ar[count2][1] = '#bg_date#'>
				<cfset ar[count2][2] = ''>
				<cfset ar[count2][3] = 0>
				<cfset ar[count2][4] = 1>
				<cfset ar[count2][5] = 0>--->
		<cfloop query="dta">
				<cfset ar[count2][1] = #id#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
        <cfif count2 is 2><cfset count2 = 3></cfif> 
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>





<cffunction name="getcsa" access="remote" returntype="query">
<cfargument name="ReqId" type="string" required="yes">
<cfargument name="dsn" type="string" required="yes">
<cfargument name="crid" type="string" required="yes">
<cfquery name="csa_q" datasource="#dsn#">
    select #reqID# as reqId, mailer_name,crid,sepn_nbr as seperations,contr_destn_zip_code,fac_name,
    label_zip_code,
    cls.code_desc_long as mail_class,
    cat.code_desc_long as Processing_category,
    pro.code_desc_long as processing_code,
    min_contr_load,
    to_char(eff_date,'mm/dd/yyyy') as eff_date
    from IV_APP.FAST_CSA csa
    inner join bi_crid cr
    on csa.crid_seq_id = cr.crid_seq_id
    inner join bi_facility f
    on csa.fac_seq_id = f.fac_seq_id
    inner join iv_app.code_value cls
    on cls.code_val = csa.ml_cl_code
    and cls.code_type_name = 'CSA_ML_CL_CODE'
    inner join iv_app.code_value cat
    on cat.code_val = csa.PRCSG_CAT
    and cat.code_type_name = 'PRCSG_CAT'
    inner join iv_app.code_value pro
    on pro.code_val = csa.PRCSG_CODE
    and pro.code_type_name = 'CSA_PRCSG_CODE'
    where crid =#Replace(crid,"''","'","All")#
    and eff_date <= sysdate
    and discontinue_date is null 
    order by sepn_nbr
</cfquery>
 <cfreturn csa_q>
</cffunction>

	<cffunction name="getByState" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">       
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">  
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                          

                                             

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  
			 SELECT s.state_abbr,
                         s.state_name
                         AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
                       inner join 
                        <!---state_t---> 
                        (
                        select distinct state_name,abbr_state_name as state_abbr
                         from IV_APP.ZIP3_STATE_MAP
                        ) s
                       on <cfif selDir is 'O'>a.phys_state<cfelse>fp.mailg_state </cfif> = s.state_abbr 
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

             <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>            
<!---            <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>--->

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          

			group by s.state_abbr,
                         s.state_name
			) gp
            where  tp_tot > 0
			order by fp_tot desc            
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #state_abbr#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

<cffunction name="getByURT" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">       
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">  
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                          

                                             

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        

)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  
			 
			 SELECT <cfif selDir is 'O'>  fp.orgn_loc_code <cfelse> fp.destn_loc_code </cfif> as ur_code,
                    decode(<cfif selDir is 'O'>  fp.orgn_loc_code <cfelse> fp.destn_loc_code </cfif>,'U','Urban','R','Rural','Not Defined')
                         AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
                       inner join 
                        <!---state_t---> 
                        (
                        select distinct state_name,abbr_state_name as state_abbr
                         from IV_APP.ZIP3_STATE_MAP
                        ) s
                       on <cfif selDir is 'O'>a.phys_state<cfelse>fp.mailg_state </cfif> = s.state_abbr 
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        

            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>                        
<!---       <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>--->
            <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          

			group by <cfif selDir is 'O'>  fp.orgn_loc_code <cfelse> fp.destn_loc_code </cfif>
                        
			) gp
            where  tp_tot > 0
			order by fp_tot desc            
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #ur_code#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

<cffunction name="getByURBK" access="remote" returntype="array">
		<cfargument name="ReqId" type="string" required="yes">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="rlupv" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
		<cfargument name="selArea" type="string" required="yes">
		<cfargument name="selDistrict" type="string" required="yes">
		<cfargument name="selClass" type="string" required="yes">
		<cfargument name="selCategory" type="string" required="yes">
		<cfargument name="selFSS" type="string" required="yes">
		<cfargument name="selMode" type="string" required="yes">
		<cfargument name="selAir" type="string" required="yes">
		<cfargument name="selCntrLvl" type="string" required="yes">
		<cfargument name="selCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selRange" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">       
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">  
        <cfargument name="selState" type="string" required="yes">
        <cfargument name="selUR" type="string" required="yes">
        <cfargument name="surbko" type="string" required="yes">        
        <cfargument name="surbkd" type="string" required="yes">                

                                                          

                                             

		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>
		
		<cfquery name="dta" datasource="#dsn#">
         with AREADISTNAME as(
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        

)
			SELECT /*+ opt_param('_GBY_HASH_AGGREGATION_ENABLED' 'true')  parallel(4)   */ gp.*
			FROM (  
			 
			 SELECT 
			           case 
               when orgn_loc_code = 'U' and destn_loc_code = 'U' then 'UU'
               when orgn_loc_code = 'U' and destn_loc_code = 'R' then 'UR'
               when orgn_loc_code = 'R' and destn_loc_code = 'U' then 'RU'
               when orgn_loc_code = 'R' and destn_loc_code = 'R' then 'RR'
               when orgn_loc_code is null or  destn_loc_code is null then 'XX' 
          end as loc,
          case when orgn_loc_code = 'U' and destn_loc_code = 'U' then 'Urban to Urban'
               when orgn_loc_code = 'U' and destn_loc_code = 'R' then 'Urban to Rural'
               when orgn_loc_code = 'R' and destn_loc_code = 'U' then 'Rural to Urban'
               when orgn_loc_code = 'R' and destn_loc_code = 'R' then 'Rural to Rural'
               when orgn_loc_code is null or  destn_loc_code is null then 'Not Defined' 
               end AS descrip, 

			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            <cfif selRange is 'WEEK'>
            #week_table# fp
            <cfelseif selRange is 'Mon'>
            #month_table# fp
            <cfelse>
            #quarter_table# fp
            </cfif>

			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
                       inner join 
                        <!---state_t---> 
                        (
                        select distinct state_name,abbr_state_name as state_abbr
                         from IV_APP.ZIP3_STATE_MAP
                        ) s
                       on <cfif selDir is 'O'>a.phys_state<cfelse>fp.mailg_state </cfif> = s.state_abbr 
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
<!---            <cfif surbko neq ''> and nvl(fp.orgn_loc_code,'X') in (#Replace(surbko,"''","'","All")#)</cfif>            
            <cfif surbkd neq ''> and nvl(fp.destn_loc_code,'X') in (#Replace(surbkd,"''","'","All")#)</cfif>--->

            <cfif selUR neq ''> and <cfif selDir eq 'O'> fp.orgn_loc_code <cfelse>fp.destn_loc_code</cfif><cfif selUR is "''"> is null<cfelse> in (#Replace(selUR,"''","'","All")#)</cfif></cfif>
            <cfif selState neq ''><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>

            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq ''>and nvl(fp.political_mail_ind,'Y') in (#Replace(selPol,"''","'","All")#) </cfif>

			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          

			group by 
			   case 
               when orgn_loc_code = 'U' and destn_loc_code = 'U' then 'UU'
               when orgn_loc_code = 'U' and destn_loc_code = 'R' then 'UR'
               when orgn_loc_code = 'R' and destn_loc_code = 'U' then 'RU'
               when orgn_loc_code = 'R' and destn_loc_code = 'R' then 'RR'
               when orgn_loc_code is null or  destn_loc_code is null then 'XX' 
          end ,
              case when orgn_loc_code = 'U' and destn_loc_code = 'U' then 'Urban to Urban'
               when orgn_loc_code = 'U' and destn_loc_code = 'R' then 'Urban to Rural'
               when orgn_loc_code = 'R' and destn_loc_code = 'U' then 'Rural to Urban'
               when orgn_loc_code = 'R' and destn_loc_code = 'R' then 'Rural to Rural'
               when orgn_loc_code is null or  destn_loc_code is null then'Not Defined' 
               end 

                        
			) gp
            where  tp_tot > 0
			order by fp_tot desc            
		</cfquery>        
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
				<cfset ar[count2][1] = #loc#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>

	<cffunction name="getfpcont" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="imb_code" type="string" required="yes">
		<cfargument name="selDate" type="string" required="yes">        
		<cfquery name="fpfont_q" datasource="#dsn#">
        with imb as
        ( 
        select
        case when substr(imb_code,6,1) = '9' then substr(imb_code,6,9) else substr(imb_code,6,6) end as mlr_id, 
        case when substr(imb_code,6,1) = '9' then substr(imb_code,15,6) else substr(imb_code,12,9) end as seq_id, 
         
        fp.* 
        from IV_app.BI_ADD_FAILED_PIECE_SCAN_dly fp 
        where actual_dlvry_date = to_DATE('#SELDATE#','MM/DD/YYYY')
        and imb_code = '#IMB_CODE#'            
        and rownum < 2) 
        select i.imb_code,i.mlr_id,i.seq_id,b.mailer_name,j.job_id,JOB_NAME_TITLE_ISSUE,edoc.crid,edoc.mailer_name as edoc_name,
        decode(i.ml_cl_code,1,'First Class',2,'Periodicals',3,'Standard','Other') as class,i.svc_std,i.phys_CONTR_SEQ_ID,i.logical_CONTR_SEQ_ID
        ,i.phys_hu_SEQ_ID,i.logical_hu_SEQ_ID
        from imb i
        inner join iv_app.bi_job j
        on i.job_seq_id = j.job_seq_id
        left join 
        iv_app.bi_mailer_id m
        on m.mlr_id = i.mlr_id
        left join iv_app.bi_crid b
        on m.crid_seq_id = b.crid_seq_id
        left join iv_app.bi_crid edoc
        on i.EDOC_SBMTR_CRID_SEQ_ID = edoc.crid_seq_id
        </cfquery>
		
        <cfquery name="cont_q" datasource="#dsn#">
    SELECT DISTINCT
       a.phys_CONTR_SEQ_ID,
       a.IMCB_CODE,
       to_char(nvl(a.Start_the_clock_date,y.Start_the_clock_date),'mm/dd/yyyy') as start_the_clock_date,
       e.code_desc_long AS stc_src,
       c.FAC_NAME AS FACILTY,
       a.critical_entry_time AS CET,
       to_char(nvl(a.actual_entry_datetime,y.actual_entry_datetime),'mm/dd/yyyy HH24:mi') as actual_entry_datetime,
       b.code_desc AS Induction_Method,
       a.schd_ship_datetime AS Ship_Date,
       to_char(a.scan_datetime,'mm/dd/yyyy HH24:mi') AS Scan_Date,
       CASE
          WHEN a.ep_lcle_key IS NULL OR UPPER (a.ep_lcle_key) = 'ORIGIN'
          THEN
             a.epfed_pstl_code
          ELSE
             a.ep_lcle_key
       END
          AS Entry_Point,
       sf.fac_name,
       a.appt_id,
       e.code_desc AS Entry_Type,
       EPFED_CONSLN_SHORT_DESC,
       f.CODE_DESC_long AS cont_lvl,
       nvl(ac.scan_site_id, ac.unit_zip_code) as scan_site_id, Cc.code_desc as scan_desc, sc.code_desc as scan_src_desc, 
        to_char(ac.SCAN_DATETIME,'mm/dd/yyyy HH24:mi') as scan_dtm, ac.appt_id
  FROM iv_app.bi_physical_container a
       LEFT JOIN V_MSTR_REL_EPFED_CONSLN VR
          ON a.EPFED_FAC_TYPE_CODE = VR.EPFED_FAC_TYPE_CODE
       LEFT JOIN iv_app.V_MSTR_LU_EPFED_CONSLN VC
          ON VR.EPFED_FAC_TYPE_CONSLN_CODE = VC.EPFED_FAC_TYPE_CONSLN_CODE
       LEFT JOIN iv_app.bi_logical_container y
          ON a.logical_contr_seq_id = y.logical_contr_seq_id
       LEFT JOIN iv_app.SPM_GROUP_CTRL_MAP grp
          ON nvl(a.spm_grp_seq_id,y.spm_grp_seq_id) = grp.spm_grp_seq_id
       LEFT JOIN bi_facility sf ON grp.ORGN_FAC_SEQ_ID = sf.fac_seq_id
       LEFT JOIN iv_app.bi_code_value b
          ON a.INDCTN_MTHD = b.code_val AND b.code_type_name = 'INDCTN_MTHD'
       LEFT JOIN bi_facility c ON a.ep_fac_seq_id = c.fac_seq_id
       LEFT JOIN bi_plt_area_district d
          ON SUBSTR (a.ep_pstl_code, 1, 3) = d.PLT_FAC_ZIP_3
       LEFT JOIN iv_app.bi_code_value e
          ON     nvl(a.START_THE_CLOCK_SOURCE,y.START_THE_CLOCK_SOURCE) = e.code_val
             AND e.code_type_name = 'START_THE_CLOCK_SOURCE'
       LEFT JOIN iv_app.bi_code_value f
          ON     a.CONTR_LVL_CODE = f.code_val
             AND f.code_type_name = 'CONTR_LVL_CODE'
      left Join           
       iv_app.BI_ASSOCD_CONTAINER_SCAN ac
       on  a.phys_contr_seq_id =  ac.phys_contr_seq_id
        left join iv_app.bi_code_value cc
        on cc.code_type_name = 'SCAN_TYPE'
        and ac.SCAN_TYPE = cc.code_val
        left join iv_app.bi_code_value sc
        on sc.code_type_name = 'SCAN_SOURCE'
        and ac.SCAN_SOURCE = sc.code_val                 
        where 
            <CFIF fpfont_q.phys_CONTR_SEQ_ID IS not ''>
             a.phys_contr_seq_id = #fpfont_q.phys_CONTR_SEQ_ID#
           <cfelseif fpfont_q.logical_CONTR_SEQ_ID IS not ''>
            a.logical_CONTR_SEQ_ID = #fpfont_q.logical_CONTR_SEQ_ID#
           <cfelse> 
            a.phys_contr_seq_id = 0
           </CFIF>
        
        </cfquery>
        
<cfquery name="tray_q" datasource="#dsn#">
 
    select a.imtb_code as tray_barcode,
    huc.code_desc as tray_cin_type,
    NVl(NVL(hu.SCAN_SITE_ID,HU.ORGN_ZIP_5),hu.UNIT_ZIP_CODE) as SCAN_SITE_ID,
    c.code_desc as scan_type , 
    s.code_desc as scan_src,
    hu.LOCAL_SCAN_DATETIME AS SCAN_DATE,
    hu.DEVICE_ID
from iv_app.bi_physical_hu a
    left join
    iv_app.bi_hu_cin_code huc 
    on a.HU_LBL_CIN_CODE = HUC.CODE_CIN
    left join iv_app.bi_code_value b
    on a.INDCTN_MTHD = b.code_val and b.code_type_name = 'INDCTN_MTHD'
    left join iv_app.bi_facility f
    on a.ep_fac_seq_id = f.fac_seq_id
    left join iv_app.BI_ASSOCD_HU_SCAN hu
    on a.mailg_seq_id = hu.mailg_seq_id   and a.job_Seq_id = hu.job_seq_id and a.PHYS_HU_SEQ_ID = hu.PHYS_HU_SEQ_ID
     AND a.mailg_date = hu.mailg_date
    left join iv_app.bi_code_value c
    on c.code_type_name = 'SCAN_TYPE'
    and hu.SCAN_TYPE = c.code_val
    left join iv_app.bi_code_value s
    on s.code_type_name = 'SCAN_SOURCE'
    and hu.SCAN_SOURCE = s.code_val
   where
	<CFIF fpfont_q.phys_HU_SEQ_ID IS not ''>
     a.phys_hu_seq_id = #fpfont_q.phys_HU_SEQ_ID#
    <cfelseif fpfont_q.logical_CONTR_SEQ_ID IS not ''>
    a.logical_HU_SEQ_ID = #fpfont_q.logical_HU_SEQ_ID#
    <cfelse> 
    a.phys_HU_seq_id = 0
    </CFIF>
    order by a.imtb_code, LOCAL_SCAN_DATETIMe
</cfquery>                

        
        <cfset ctr= 1> 
		<cfset ar = arraynew(3)>
			<cfset ar[1][ctr][1]= 'IMb Code'>      
			<cfset ar[1][ctr][2]= 'Mailer ID'>                  
			<cfset ar[1][ctr][3]= 'Sequence ID'>                              
			<cfset ar[1][ctr][4]= 'Mailer'>                              
			<cfset ar[1][ctr][5]= 'Job ID'>                              
			<cfset ar[1][ctr][6]= 'Job Name'>                                          
			<cfset ar[1][ctr][7]= 'EDOC CRID'>                                                      
			<cfset ar[1][ctr][8]= 'EDOC Name'>                                                                  
                <cfset ctr+= 1> 
		<cfloop query="fpfont_q">
			<cfset ar[1][ctr][1]= '_#imb_code#'>      
			<cfset ar[1][ctr][2]= '#mlr_id#'>                  
			<cfset ar[1][ctr][3]= '#seq_id#'>                              
			<cfset ar[1][ctr][4]= '#mailer_name#'>                              
			<cfset ar[1][ctr][5]= '#job_id#'>                              
			<cfset ar[1][ctr][6]= '#JOB_NAME_TITLE_ISSUE#'>                                                      
			<cfset ar[1][ctr][7]= '#crid#'>
			<cfset ar[1][ctr][8]= '#edoc_name#'>            
		</cfloop>        
        <cfset ctr = 1> 
			<cfset ar[2][ctr][1]= 'IMCB Code'>      
			<cfset ar[2][ctr][2]= 'STC DATE'>                  
			<cfset ar[2][ctr][3]= 'STC Src'>                              
			<cfset ar[2][ctr][4]= 'STC Facility'>                              
			<cfset ar[2][ctr][5]= 'CET'>                              
			<cfset ar[2][ctr][6]= 'AET'>                                          
			<cfset ar[2][ctr][7]= 'Induct Mthd'>                                                      
			<cfset ar[2][ctr][8]= 'Ship Date'>
   			<cfset ar[2][ctr][9]= 'Scan Date'>
   			<cfset ar[2][ctr][10]= 'Entry Point'>            
   			<cfset ar[2][ctr][11]= 'Org Facility'>                        
   			<cfset ar[2][ctr][12]= 'Fast Appt'>                                    
   			<cfset ar[2][ctr][13]= 'Entry Type'>                                                
			<cfset ar[2][ctr][14]= 'Cntr Type'>      
			<cfset ar[2][ctr][15]= 'Site ID'>            
			<cfset ar[2][ctr][16]= 'Scan Desc'>            
			<cfset ar[2][ctr][17]= 'Scan Source'>                                                          
			<cfset ar[2][ctr][18]= 'Scan Dtm'>            
			<cfset ar[2][ctr][19]= 'Appt'>                        
            
        <cfset ctr+= 1>                                                                   
		<cfloop query="cont_q">
			<cfset ar[2][ctr][1]= '#IMCB_CODE#'>      
			<cfset ar[2][ctr][2]= '#Start_the_clock_date#'>                  
			<cfset ar[2][ctr][3]= '#stc_src#'>                              
			<cfset ar[2][ctr][4]= '#fac_name#'>                              
			<cfset ar[2][ctr][5]= '#CET#'>                              
			<cfset ar[2][ctr][6]= '#actual_entry_datetime#'>                                                      
			<cfset ar[2][ctr][7]= '#Induction_Method#'>
			<cfset ar[2][ctr][8]= '#dateformat(SHIP_DATE,'mm/dd/yyyy')# #timeformat(SHIP_DATE,'HH:MM')# '>
			<cfset ar[2][ctr][9]= '#scan_date#'>            
			<cfset ar[2][ctr][10]= '#entry_point#'>            
			<cfset ar[2][ctr][11]= '#FACILTY#'>            
			<cfset ar[2][ctr][12]= '#appt_id#'>            
			<cfset ar[2][ctr][13]= '#Entry_Type#'>            
			<cfset ar[2][ctr][14]= '#cont_lvl#'>  
			<cfset ar[2][ctr][15]= '#SCAN_SITE_ID#'>            
			<cfset ar[2][ctr][16]= '#SCAN_DESC#'>            
			<cfset ar[2][ctr][17]= '#SCAN_SRC_DESC#'>                                                          
			<cfset ar[2][ctr][18]= '#SCAN_dtm#'>            
			<cfset ar[2][ctr][19]= '#APPT_ID#'>                        
            <cfset ctr+= 1>             
		</cfloop>        
        <cfset ctr = 1> 
			<cfset ar[3][ctr][1]= 'Tray Barcode'>      
			<cfset ar[3][ctr][2]= 'Tray(Cin) Code'>                  
			<cfset ar[3][ctr][3]= 'Site ID'>                              
			<cfset ar[3][ctr][4]= 'Scan Type'>                              
			<cfset ar[3][ctr][5]= 'Scan Source'>                              
			<cfset ar[3][ctr][6]= 'Scan Date'>                                          
			<cfset ar[3][ctr][7]= 'Device ID'>                                                      
	

        <cfset ctr+= 1>                                                                   
		<cfloop query="tray_q">
			<cfset ar[3][ctr][1]= '_#TRAY_BARCODE#'>      
			<cfset ar[3][ctr][2]= '#TRAY_CIN_TYPE#'>                  
			<cfset ar[3][ctr][3]= '#SCAN_SITE_ID#'>                              
			<cfset ar[3][ctr][4]= '#SCAN_TYPE#'>                              
			<cfset ar[3][ctr][5]= '#SCAN_SRC#'>                              
			<cfset ar[3][ctr][6]= '#SCAN_DATE#'>                                                      
			<cfset ar[3][ctr][7]= '#DEVICE_ID#'>
            <cfset ctr+= 1>             
		</cfloop>        
        
        
		<cfreturn ar>

	</cffunction>

</cfcomponent>