<cfcomponent>

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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">

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
		
		<!---<cfif selEod contains 'Y' and selEod does not contain 'N' ><cfset selEod ='Y'>
		<cfelseif selEod contains 'N' and selEod does not contain 'Y' ><cfset selEod ='N'>
		<cfelse><cfset selEod =''></cfif>--->
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT gp.*
			FROM (  SELECT
			area_name,ad.area_id,
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
			areadistname_t ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')-1</cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<!---<cfif selArea neq 'All'>and ad.area_id = '#selArea#'</cfif>
			<cfif selDistrict neq 'All'>and ad.district_id = '#selDistrict#'</cfif>--->
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#) </cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in (#Replace(selCntrLvl,"''","'","All")#)</cfif>  
            <cfif selDir is 'O'><cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif><cfelse>
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif></cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by area_name,ad.area_id
			) gp
			
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">

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
		
		<!---<cfif selEod contains 'Y' and selEod does not contain 'N' ><cfset selEod ='Y'>
		<cfelseif selEod contains 'N' and selEod does not contain 'Y' ><cfset selEod ='N'>
		<cfelse><cfset selEod =''></cfif>--->
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT gp.*
			FROM (  SELECT
			district_name,ad.district_id,
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
			areadistname_t ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')-1</cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<!---<cfif selDistrict neq 'All'>and ad.district_id = '#selDistrict#'</cfif>--->
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#) </cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in (#Replace(selCntrLvl,"''","'","All")#)</cfif>  
            <cfif selDir is 'O'><cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif><cfelse>
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif></cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by district_name,ad.district_id
			) gp
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">

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
		
		<!---<cfif selEod contains 'Y' and selEod does not contain 'N' ><cfset selEod ='Y'>
		<cfelseif selEod contains 'N' and selEod does not contain 'Y' ><cfset selEod ='N'>
		<cfelse><cfset selEod =''></cfif>--->
		
		<cfquery name="dta" datasource="#dsn#">
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
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ (sum(#piece_cnt#) +.000000001)   
			AS PER_tot
			FROM  V_BI_AGG_STC_OD_DAY fp
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			areadistname_t ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')-1</cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#) </cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in (#Replace(selCntrLvl,"''","'","All")#)</cfif>  
            <cfif selDir is 'O'><cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif><cfelse>
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif></cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">

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
		
		<!---<cfif selEod contains 'Y' and selEod does not contain 'N' ><cfset selEod ='Y'>
		<cfelseif selEod contains 'N' and selEod does not contain 'Y' ><cfset selEod ='N'>
		<cfelse><cfset selEod =''></cfif>--->
		
		<cfquery name="dta" datasource="#dsn#">
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
			areadistname_t ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')-1</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#) </cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in (#Replace(selCntrLvl,"''","'","All")#)</cfif>  
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif> 
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by to_char(start_the_clock_date,'d'),UPPER(to_char(start_the_clock_date,'day'))
			) gp
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">

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
		
		<!---<cfif selEod contains 'Y' and selEod does not contain 'N' ><cfset selEod ='Y'>
		<cfelseif selEod contains 'N' and selEod does not contain 'Y' ><cfset selEod ='N'>
		<cfelse><cfset selEod =''></cfif>--->
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT gp.*
			FROM (  SELECT
			fp.ml_cl_code as classCode,case when fp.ml_cl_code = 1 then 'First Class' when fp.ml_cl_code = 2 then 'Periodicals' when fp.ml_cl_code = 3 then 'Standard' end as descrip,
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
			areadistname_t ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')-1</cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<!---<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>--->
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#) </cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in (#Replace(selCntrLvl,"''","'","All")#)</cfif>  
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif> 
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by fp.ml_cl_code
			) gp
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">

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
		
		<!---<cfif selEod contains 'Y' and selEod does not contain 'N' ><cfset selEod ='Y'>
		<cfelseif selEod contains 'N' and selEod does not contain 'Y' ><cfset selEod ='N'>
		<cfelse><cfset selEod =''></cfif>--->
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT gp.*
			FROM (  SELECT
			fp.ml_cat_code,case when fp.ml_cat_code = 1 then 'Letters' when fp.ml_cat_code = 2 then 'Flats' when fp.ml_cat_code = 3 then 'Cards' end as descrip,
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
			areadistname_t ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')-1</cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<!---<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>--->
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#) </cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in (#Replace(selCntrLvl,"''","'","All")#)</cfif>  
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif> 
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by fp.ml_cat_code
			) gp
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">

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
			SELECT gp.*
			FROM (  SELECT
			st.orgn_entered,case when st.orgn_entered = 'Y' then 'Origin' when st.orgn_entered = 'N' then 'Destination' end as descrip,
			sum(case when st.orgn_entered='Y' and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then #piece_cnt#
			when st.orgn_entered='N' and fp.epfed_fac_type_code NOT IN (7, 11, 16, 17, 18, 19, 20, 22) then #piece_cnt# else 0 end) as tp_tot,
			sum(case when st.orgn_entered='Y' and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then #fail_piece_cnt#
			when st.orgn_entered='N' and fp.epfed_fac_type_code NOT IN (7, 11, 16, 17, 18, 19, 20, 22) then #fail_piece_cnt# else 0 end) as fp_tot,
			sum(case when st.orgn_entered='Y' and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then #piece_cnt#-#fail_piece_cnt#
			when st.orgn_entered='N' and fp.epfed_fac_type_code NOT IN (7, 11, 16, 17, 18, 19, 20, 22) then #piece_cnt#-#fail_piece_cnt# else 0 end) 
			/ (sum(case when st.orgn_entered='Y' and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then #piece_cnt#
			when st.orgn_entered='N' and fp.epfed_fac_type_code NOT IN (7, 11, 16, 17, 18, 19, 20, 22) then #piece_cnt# else 0 end) +.000000001)   
			AS PER_tot
			FROM  V_BI_AGG_STC_OD_DAY fp
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			areadistname_t ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')-1</cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#) </cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in (#Replace(selCntrLvl,"''","'","All")#)</cfif>  
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif> 
			<!---<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>--->
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by st.orgn_entered
			) gp
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">

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
			SELECT gp.*
			FROM (  SELECT
			'OverAll' as id,'OverAll' as descrip,
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
			areadistname_t ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')-1</cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#) </cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in (#Replace(selCntrLvl,"''","'","All")#)</cfif>  
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif> 
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)<cfelseif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>
			) gp
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
				<cfset ar[count2][6] = #bg_date#>
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">

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
			SELECT gp.*
			FROM (  SELECT
			st.hyb_svc_std,HYB_SVC_STD_DESC as descrip,
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
			areadistname_t ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')-1</cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#) </cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in (#Replace(selCntrLvl,"''","'","All")#)</cfif>  
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif> 
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by st.hyb_svc_std,HYB_SVC_STD_DESC
			) gp
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
	
		
	<cffunction name="getByMlrData" access="remote" returntype="array">
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">

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
			SELECT gp.*
			FROM (  SELECT
			fp.EDOC_SBMTR_CRID_SEQ_ID AS id,
              mailer_name AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ (sum(#piece_cnt#) +.000000001)   
			AS PER_tot
			FROM  V_BI_AGG_STC_OD_DAY fp
			LEFT JOIN bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			INNER JOIN bi_crid_stg cs 
			ON cs.crid_seq_id = fp.EDOC_SBMTR_CRID_SEQ_ID
			INNER JOIN opsvis_crid op 
			ON op.crid = cs.crid   
			inner join 
			(
				SELECT distinct max(plt_fac_key) as plt_fac_key ,plt_fac_zip_3
				FROM BI_PLT_AREA_DISTRICT
				group by plt_fac_zip_3
			)  plt
			on   plt.plt_fac_zip_3 = 
			<cfif seldir is 'O'>  Fp.orgn_fac_zip_3  <cfelse> fp.destn_fac_zip_3 </cfif>   
			inner join
			areadistname_t ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')-1</cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>

			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#) </cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in (#Replace(selCntrLvl,"''","'","All")#)</cfif>  
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif> 
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>
               group by  fp.EDOC_SBMTR_CRID_SEQ_ID,mailer_name
			) gp
			order by fp_tot desc
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selOrgZip3" type="string" required="yes">
        <!---<cfargument name="selRange" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">
        <cfargument name="selOrgFac" type="string" required="yes">--->

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
                  DESTN_FAC_ZIP_3,
                  DESTN_FAC_ZIP_3 || '-' || destfac.plt_fac_name
                   AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
			V_BI_AGG_STC_OD_DAY fp

			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			INNER JOIN bi_plt_area_district destfac
			ON destfac.plt_fac_zip_3 = fp.DESTN_FAC_ZIP_3
 
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from OPSVIS_ADM.POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE 
            fp.START_THE_CLOCK_DATE

			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>
			<cfif selDOW neq ''>and to_char(fp.START_THE_CLOCK_DATE,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
<!---            <cfif selImbZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              --->
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by DESTN_FAC_ZIP_3, DESTN_FAC_ZIP_3 || '-' || destfac.plt_fac_name
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
				<cfset ar[count2][1] = #DESTN_FAC_ZIP_3#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>
	</cffunction>
	
	<cffunction name="getByOrgZip3" access="remote" returntype="array">
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">
        <!---<cfargument name="selRange" type="string" required="yes">
        <cfargument name="selOrgFac" type="string" required="yes">--->

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
                  ORGN_FAC_ZIP_3,
                  ORGN_FAC_ZIP_3 || '-' || destfac.plt_fac_name
                   AS descrip,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
			V_BI_AGG_STC_OD_DAY fp

			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			INNER JOIN bi_plt_area_district destfac
			ON destfac.plt_fac_zip_3 = fp.ORGN_FAC_ZIP_3
 
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from OPSVIS_ADM.POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE 
            fp.START_THE_CLOCK_DATE

			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>
			<cfif selDOW neq ''>and to_char(fp.START_THE_CLOCK_DATE,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selFacility neq ''>and <cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif> in (#Replace(selFacility,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
<!---		<cfif selImbZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>              
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              --->
			<cfif rdCert eq ''>
				and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
			<cfelse>
				and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
			</cfif>                          

			group by ORGN_FAC_ZIP_3, ORGN_FAC_ZIP_3 || '-' || destfac.plt_fac_name
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
				<cfset ar[count2][1] = #ORGN_FAC_ZIP_3#>
				<cfset ar[count2][2] = #descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">       
        <cfargument name="selMailer" type="string" required="yes"> 
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">                              
        
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
			V_BI_AGG_STC_OD_DAY fp
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

			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from OPSVIS_ADM.POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE 
            fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>
			<cfif selDOW neq ''>and to_char(start_the_clock_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif>
			<cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif>
			<cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif>
			<cfif selClass neq ''>and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq ''>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq ''>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>                          
			<!---cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE = '#selCntrLvl#' </cfif>--->  
			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif>                         
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes"> 
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">                                                   

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
			V_BI_AGG_STC_OD_DAY fp

			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from OPSVIS_ADM.POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE 
            fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>
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
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif>                        
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
		<cfargument name="chkPol" type="string" required="yes">
		<cfargument name="selHybStd" type="string" required="yes">
		<cfargument name="sortBy" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfargument name="selFacility" type="string" required="yes">
        <cfargument name="selMailer" type="string" required="yes"> 
        <cfargument name="selOrgZip3" type="string" required="yes">
        <cfargument name="selDestZip3" type="string" required="yes">   

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
			V_BI_AGG_STC_OD_DAY fp

			LEFT JOIN OPSVIS_ADM.bi_facility a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std and st.orgn_entered = case when fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22) then 'Y' else 'N' end and st.ml_cl_code = fp.ml_cl_code
			<cfif chkPol is not ''>
				inner join 
				(
				select job_seq_id from OPSVIS_ADM.POLITICAL_MAILING
				where job_seq_id is not null
				group by job_seq_id
				) pol 
				on pol.job_seq_id = fp.job_seq_id 
			</cfif>
			WHERE 
            fp.START_THE_CLOCK_DATE
			BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
			AND  <cfif ed_date eq ''>TO_DATE('#bg_date#','mm-dd-yyyy')+6<cfelse>TO_DATE('#ed_date#','mm-dd-yyyy')</cfif>
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
			<cfif selMailer neq ''>and fp.EDOC_SBMTR_CRID_SEQ_ID in (#Replace(selMailer,"''","'","All")#)</cfif>
			<cfif selOrgZip3 is not ''>and fp.ORGN_FAC_ZIP_3 in(#Replace( selOrgZip3,"''","'","All")#) </cfif>
            <cfif selDestZip3 is not ''>and fp.DESTN_FAC_ZIP_3 in(#Replace( selDestZip3,"''","'","All")#) </cfif>                      
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
	
	<cffunction name="getDates" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="range" type="string" required="yes">
		
		<cfif range is 'MON'>
			<cfquery name="wk" datasource="#dsn#">
				SELECT dt as beg_mon_date,add_months(dt,1)-1 as end_mon_date,to_char(dt,'mm/dd/yyyy') as strdate 
				FROM
				(select (select min(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY)+rownum as dt
				from V_BI_AGG_STC_OD_DAY
				where rownum <= (select max(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY)-(select min(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY))
				where to_char(dt,'dd')=1
				order by dt desc
			 </cfquery>
		<cfelseif range is 'QTR'>
			<cfquery name="wk" datasource="#dsn#">
				SELECT dt as beg_qtr_date,add_months(dt,3)-1 as end_qtr_date,to_char(dt,'mm/dd/yyyy') as strdate
				FROM
				(select (select min(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY)+rownum as dt
				from V_BI_AGG_STC_OD_DAY
				where rownum <= (select max(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY)-(select min(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY))
				where to_char(dt,'MM') IN('01','04','07','10') AND to_char(dt,'DD')  =1
				order by dt desc
			</cfquery>
		<cfelse>
			<cfquery name="wk" datasource="#dsn#">
				SELECT dt AS beg_wk_date, DT+6 AS end_wk_date,to_char(dt,'MM/DD/YYYY') as strdate
				FROM
				(select (select min(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY)+rownum as dt
				from V_BI_AGG_STC_OD_DAY
				where rownum <= (select max(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY)-(select min(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY))
				where to_char(dt,'d')=7
				order by dt desc
			</cfquery>
		</cfif>
		
		<cfset ar = arraynew(1)>
		<cfloop query="wk">
			<cfset ar[currentrow]= '#strdate#'>      
		</cfloop>        
		<cfreturn ar>

	</cffunction>


</cfcomponent>