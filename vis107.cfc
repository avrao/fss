<cfcomponent>

<!---

<cfset day_table = 'V_BI_ADD_OD_RPT_day_ZIP3'>
<cfset week_table = 'V_BI_ADD_OD_RPT_WEEK_ZIP3'>
<cfset month_table = 'V_BI_ADD_OD_RPT_MONTH_ZIP3'>
<cfset quarter_table = 'V_BI_ADD_OD_RPT_QTR_ZIP3'>
--->


<cfset day_table = 'V_BI_ADD_OD_RPT_day_job'>
<cfset week_table = 'V_BI_ADD_OD_RPT_WEEK_job'>
<cfset month_table = 'V_BI_ADD_OD_RPT_MONTH_job'>
<cfset quarter_table = 'V_BI_ADD_OD_RPT_QTR_job'>


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
		<cfargument name="rdCert" type="string" required="yes">
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
         with AREADISTNAME as (
             select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
             from  areadistname_t
             where area_id not in ('4M','4N')
<!---            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
			)

			SELECT gp.*
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
			LEFT JOIN OPSVIS_ADM.bi_facility a
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
				select job_seq_id from OPSVIS_ADM.POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>--->
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
                        <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>
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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
        with AREADISTNAME as (
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
            )

			SELECT gp.*
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
			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null
--->			
			)

			SELECT gp.*
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
			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
		
		
		<cfquery name="dta" datasource="#dsn#">
        with AREADISTNAME as
         (select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---            
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
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
			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end 
            and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE fp.START_THE_CLOCK_DATE
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
		
		<cfquery name="dta" datasource="#dsn#">
        with AREADISTNAME as
         (select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---            with AREADISTNAME as
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
            )
			SELECT gp.*
			FROM (  SELECT
			fp.ml_cl_code as classCode,
            case when fp.ml_cl_code = 1 then 'First Class' 
            when fp.ml_cl_code = 2 then 'Periodicals' 
            when fp.ml_cl_code = 3 then 'Standard'
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
			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by fp.ml_cl_code
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
		<cfargument name="rdCert" type="string" required="yes">
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
         with AREADISTNAME as (
         select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---             
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
			)
			SELECT gp.*
			FROM (  SELECT
			fp.ml_cat_code,
            case when fp.ml_cat_code = 1 then 'Letters' 
            when fp.ml_cat_code = 2 then 'Flats' 
            when fp.ml_cat_code = 3 then 'Cards' 
            when fp.ml_cat_code = 4 then 'Packages'
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

			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT gp.*
			FROM (  SELECT
			st.orgn_entered,case when st.orgn_entered = 'Y' then 'Origin' when st.orgn_entered = 'N' then 'Destination' end as descrip,
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

			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
        with AREADISTNAME as (
         select/*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT gp.*
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
			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>
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
		<cfargument name="rdCert" type="string" required="yes">
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
        with AREADISTNAME as
         (select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---        (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
         from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
         where area not in ('4M','4N') and end_date is null--->
         )
			SELECT gp.*
			FROM (  SELECT
			st.hyb_svc_std,HYB_SVC_STD_DESC as descrip,
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
			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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

		<cfquery name="areaDist_q" datasource="#dsn#">
         select area_id as area,area_name,district_id as district,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---        select  distinct area ,site_name as area_name,district,district_name
         from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
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
			<cfquery name="wk" datasource="#dsn#">
                SELECT dt as beg_mon_date,add_months(dt,1)-1 as end_mon_date,to_char(dt,'mm/dd/yyyy') as strdate,to_char(add_months(dt,1)-1,'mm/dd/yyyy') as strend 
                FROM
                (select (select min(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3)+rownum as dt
                from V_BI_ADD_OD_RPT_DAY_ZIP3
                where rownum <= (select max(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3)-(select min(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3))
                where to_char(dt,'dd')=1
                order by dt desc
		 </cfquery>
		<cfelseif range is 'QTR'>
			<cfquery name="wk" datasource="#dsn#">
                SELECT dt as beg_qtr_date,add_months(dt,3)-1 as end_qtr_date,to_char(dt,'mm/dd/yyyy') as strdate, to_char(add_months(dt,3)-1,'mm/dd/yyyy') as strend 
                FROM
                (select (select min(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3)+rownum as dt
                from V_BI_ADD_OD_RPT_DAY_ZIP3
                where rownum <= (select max(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3)-(select min(ACTUAL_DLVRY_DATE) from V_BI_ADD_OD_RPT_DAY_ZIP3))
                where to_char(dt,'MM') IN('01','04','07','10') AND to_char(dt,'DD')  =1
                order by dt desc
			</cfquery>
		<cfelse>
			<cfquery name="wk" datasource="#dsn#">
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
		<cfargument name="rdCert" type="string" required="yes">
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
         select  /*+ result_cache */  area_id as area_id,area_name,district_id as district_id,district_name 
         from  areadistname_t
         where area_id not in ('4M','4N')        
<!---                    
            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null
--->			
			)

			SELECT gp.*
			FROM (  SELECT
		    fp.CONTR_LVL_CODE,
            bc.code_desc_long AS descrip,
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
			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            inner join bi_code_value bc
            on bc.CODE_TYPE_NAME ='CONTR_LVL_CODE'
            and fp.CONTR_LVL_CODE = bc.code_val 

            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
		<cfargument name="selPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">        
        <cfargument name="selRange" type="string" required="yes">        
        <cfargument name="selImbZip3" type="string" required="yes">  
        <cfargument name="selOrgFac" type="string" required="yes">    
        <cfargument name="selEntType" type="string" required="yes">                                                    
        <cfargument name="selInduct" type="string" required="yes">                                                    

                                          

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
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null
--->			
			)

			SELECT gp.*
			FROM (  SELECT b.mlr_name,fp.crid,
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
			LEFT JOIN OPSVIS_ADM.bi_facility a
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

            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT gp.*
			FROM (  SELECT
			nvl(fp.expected_air_ind,'N') as expected_air_ind,case when nvl(fp.expected_air_ind,'N') = 'Y' then 'Air' else 'Surface' end as descrip,
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

			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT gp.*
			FROM (  SELECT
			 nvl(fp.fss_scan_ind,'N') as fss_scan_ind,
               CASE
                  WHEN nvl(fp.fss_scan_ind,'N') = 'Y' THEN 'FSS'
                  WHEN nvl(fp.fss_scan_ind,'N') = 'N' THEN 'Non-FSS'
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

			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT gp.*
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

			LEFT JOIN OPSVIS_ADM.bi_facility a
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
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null
--->			
			)

			SELECT gp.*
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
			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = fp.orgn_fac_seq_id
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>

            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>

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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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

                                                           



<cfquery name="seq_q" datasource="#dsn#">
select crid_seq_id from bi_crid_stg
<cfif selMailer is ''>
where crid is null
<cfelse>
where crid in (#Replace(selMailer,"''","'","All")#) 
</cfif>

</cfquery>






<CFSET seq_list = valuelist(seq_q.crid_seq_id)>

		
		<cfquery name="dta" datasource="#dsn#">
         select DENSE_RANK () OVER (ORDER BY imb_code) AS rec_no,gp.*
          from
         (
			 SELECT 
               fp.orgn_fac_zip_3 AS origin_fac_zip3,
               SUBSTR(fp.SCAN_FAC_ZIP_9,1,5) AS fac_zip_code,
               ad.plt_fac_name AS plt_facility_name,               
               case when length(fp.op_code) < 3 then LPAD (fp.op_code, 3, 0) else to_char(fp.op_code) end AS op_code,               
               fp.mpe_id,
               cin.code_desc as declared_TRAY_CONTENT, 
               NVL (fp.sort_plan, '-') AS sort_plan,
               to_char(fp.scan_datetime,'MM/DD/YYYY HH24:MI') as scan_datetime,
               '_' || fp.imb_code  as imb_code,
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
               pr.mlr_name AS mailer_name,
               pr.crid AS edoc_crid,
               decode(fp.ml_cl_code,1,'First Class',2,'Periodicals',3,'Standard',4,'Packages',fp.ml_cl_code) as Mail_Class,
               decode(fp.ml_cat_code,1,'Letters',2,'Flats',3,'Periodical',fp.ml_cat_code) as Mail_Shape,
               fp.svc_std as svc_std,
               fp.lpo_type_code,
               rc.ROOT_CAUSE_desc as root_cause
    from
                        bi_app.BI_ADD_FAILED_PIECE_SCAN@p2sasp_usr fp
            INNER JOIN bi_plt_area_district@p2sasp_usr ad
              ON fp.scan_FAC_ZIP_3 = ad.plt_fac_zip_3
            left JOIN BI_CODE_VALUE@p2sasp_usr cv
                  ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
            left JOIN BI_CODE_VALUE@p2sasp_usr cin
                  ON cin.code_type_name = 'CIN_CODE'   AND cin.code_val = fp.HU_LBL_CIN_CODE
            left JOIN bi_OP_CODE@p2sasp_usr op
                 ON op.op_code = fp.op_code
             LEFT JOIN BI_ZIP4@p2sasp_usr z4
                  ON z4.ZIP_9 = SUBSTR (fp.mpe_DLVRY_POINT, 1, 9)
               INNER JOIN BI_CRID@p2sasp_usr cr
                 ON fp.edoc_sbmtr_crid_seq_id = cr.crid_seq_id
             INNER JOIN bi_opsvis_crid@p2sasp_usr pr
                ON Pr.CRID = CR.cRID 
           inner join bi_app.BI_MSTR_SVC_STD@p2sasp_usr st
             on st.svc_std = fp.svc_std and st.orgn_entered = fp.orgn_entered  and st.ml_cl_code = fp.ml_cl_code
            inner join
            V_MSTR_REL_EPFED_CONSLN@p2sasp_usr con
             on  con.epfed_fac_type_code = fp.epfed_fac_type_code
            INNER JOIN BI_APP.BI_MSTR_ROOT_CAUSE@P2SASP_USR RC
            ON RC.ROOT_CAUSE_CODe = fp.ROOT_CAUSE_CODe  
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
            
  


WHERE fp.actual_dlvry_date 
			= TO_DATE('#bg_date#','mm-dd-yyyy')
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
           and EXCL_STS_CODE is null
           and stop_scan_ind = 'Y'
            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>            
            <cfif seq_list is not ''>and fp.edoc_sbmtr_crid_seq_id in (#seq_list#) </cfif>
            
             <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3  = '#selImbZip3#' </cfif>              
             <cfif selOrgFac is not ''>and fp.orgn_fac_zip_3 = '#selOrgFac#' </cfif>                          


                        <cfif selDir is 'O'> 
			<cfif selFacility neq ''>and fp.orgn_fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif>            
			<cfelse>
			<cfif selFacility neq ''>and fp.destn_fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif>            

                        </cfif>            

			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
<!---			<cfif selMailer is not ''>  and pr.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              --->
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''>and fp.ORGN_ENTERED = '#selEod#'</cfif>
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          
  
  order by imb_code,scan_datetime
  ) gp
  where rownum < 10000
		</cfquery>        
  <cfreturn dta>
	</cffunction>



	<cffunction name="getFailedPcszip3" access="remote" returnformat="JSON">
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
		<cfargument name="rdCert" type="string" required="yes">
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

                                                           



<cfquery name="seq_q" datasource="#dsn#">
select crid_seq_id from bi_crid_stg
<cfif selMailer is ''>
where crid is null
<cfelse>
where crid in (#Replace(selMailer,"''","'","All")#) 
</cfif>
</cfquery>


<cfquery name="date_q" datasource="#dsn#">
select to_char(to_date('#bg_date#','mm/dd/yyyy') + level -1,'dd-mon-yyyy') as dt
from dual
connect by to_date('#bg_date#','mm/dd/yyyy') + level -1 <= to_date('#ed_date#','mm/dd/yyyy') 
</cfquery>

<CFSET seq_list = valuelist(seq_q.crid_seq_id)>
<CFSET date_list = quotedvaluelist(date_q.dt)>


		
		<cfquery name="dta" datasource="#dsn#">
        with AREADISTNAME as (
             select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
             from  areadistname_t
             where area_id not in ('4M','4N')
<!---            (select /*+ result_cache */ distinct area as area_id,site_name as area_name,district as district_id,district_name
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
			)
        
            select fac_name as <cfif selDir is 'O'>ORIGIN_FACILITY <cfelse>DESTN_FACILITY</cfif> , 
            TO_CHAR(actual_dlvry_date,'mm/dd/yyyy') as actual_dlvry_date  ,orgn_fac_zip_3,imb_dlvry_zip_3,
            sum(total_incl_piece_cnt-TOTAL_INCL_PASSED_PIECE_CNT) as failed_pieces,
            sum(total_incl_piece_cnt) as total_pieces,
            decode(sum(total_incl_piece_cnt),0,0,sum(total_incl_passed_piece_cnt)/sum(total_incl_piece_cnt)) as per
            from #day_table# fp
            LEFT JOIN OPSVIS_ADM.bi_facility a
            ON a.fac_SEQ_ID = 
            <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
            inner join
            AREADISTNAME ad
            on a.dist_id = ad.district_id 
            inner join BI_MSTR_SVC_STD st
            on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       


            WHERE fp.actual_dlvry_date in (#preservesinglequotes(date_list)#)
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>            
            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>            
   			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
				<cfif selDir is 'O'>
                    <cfif seldistrict neq ''>and fp.orgn_district in (#Replace(seldistrict,"''","'","All")#)</cfif>
                 <cfelse>
                    <cfif seldistrict neq ''>and fp.destn_district in (#Replace(seldistrict,"''","'","All")#)</cfif>                                    
                </cfif>
            <cfif seq_list is not ''>and fp.edoc_sbmtr_crid_seq_id in (#seq_list#) </cfif>
            <cfif selImbZip3 is not ''>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>                          
            <cfif selDir is 'O'> 
				<cfif selFacility neq ''>and fp.orgn_fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif>            
           <cfelse>
                <cfif selFacility neq ''>and fp.destn_fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif>            
            </cfif>            
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
<!---			<cfif selMailer is not ''>  and pr.crid in(#Replace(selMailer,"''","'","All")#) </cfif>              --->
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selEod neq ''>and fp.ORGN_ENTERED = '#selEod#'</cfif>
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          
  
    group by fac_name, actual_dlvry_date,orgn_fac_zip_3,imb_dlvry_zip_3
    having          SUM (total_incl_piece_cnt - TOTAL_INCL_PASSED_PIECE_CNT) > 0
         
         order by failed_pieces desc

 </cfquery>        
  <cfreturn dta>
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
		<cfargument name="rdCert" type="string" required="yes">
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
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT gp.*
			FROM (  SELECT
                   case when pol.job_seq_id is null then 'N' else 'Y' end as political,
                   case when pol.job_seq_id is null then 'Non-Political' else 'Political' end as descrip,			
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

			LEFT JOIN OPSVIS_ADM.bi_facility a
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
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
			WHERE 
            <cfif selRange is 'WEEK'>
            fp.ACTUAL_DLVRY_week
            <cfelseif selRange is 'mon'>
            fp.ACTUAL_DLVRY_month
            <cfelse>
            fp.actual_dlvry_quarter
            </cfif>

			= TO_DATE('#bg_date#','mm-dd-yyyy')
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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by 
                      case when pol.job_seq_id is null then 'N' else 'Y' end,
                      case when pol.job_seq_id is null then 'Non-Political' else 'Political' end
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
		<cfargument name="rdCert" type="string" required="yes">
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
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT gp.*
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

			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
 
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
                        left join V_MSTR_LU_EPFED_CONSLN con
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
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

<!---            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>--->
            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>
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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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
		<cfargument name="rdCert" type="string" required="yes">
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
            from OPSVIS_ADM.BI_AREA_DISTRICT_HIST
            where area not in ('4M','4N') and end_date is null--->
)
			SELECT gp.*
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

			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
 
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
            <cfif selPol neq '' and  selPol does not contain ','>
            left join POLITICAL_MAILING pol
                   on pol.job_seq_id = fp.job_seq_id
            </cfif>       
            left JOIN BI_CODE_VALUE@p2sasp_usr cv
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
            <cfif selInduct neq ''>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>

            <cfif selEntType neq ''>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq '' and selpol does not contain ','> <cfif #Replace(selPol,"''","'","All")# contains 'Y'> and pol.job_seq_id is not null<cfelse> and pol.job_seq_id is null </cfif></cfif>
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
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

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

</cfcomponent>