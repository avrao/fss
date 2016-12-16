<cfcomponent>

	<cffunction name="getMainData" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">
		<cfargument name="selDir" type="string" required="yes">
		<cfargument name="selEOD" type="string" required="yes" default="Y">
		<cfargument name="bg_date" type="string" required="yes">
		<cfargument name="ed_date" type="string" required="yes">
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
			<cfargument name="selOrgFac" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		
		<cfargument name="selvariance" type="string" required="yes">
		<cfargument name="fp_chk" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
		
		<cfargument name="selOrg3" type="string" required="yes">
		<cfargument name="selDest3" type="string" required="yes">
		<cfargument name="selPhysCntr" type="string" required="yes">
		<cfargument name="selDestFac" type="string" required="yes">
		<cfargument name="selImbZip3" type="string" required="yes">
		
		<cfset selJob = ''><cfset selZip5 = ''>
		
		<cfquery name="dta_main" datasource="#dsn#" result="dtatest">
		select *  from
		(
			SELECT    gp.* ,DENSE_RANK () OVER (ORDER BY imb_code) AS rec_no
			,sum(ap) over() as isap,
			count (distinct imb_code) OVER () AS tot_cnt
			FROM (
				SELECT /*+DRIVING_SITE(FP)*/  
				SUM (CASE WHEN mpe_id like 'APP%' then 1 else 0 end) over (partition  by imb_code) as ap,
				fp.orgn_fac_zip_3 AS origin_fac_zip3,
				fp.scan_fac_zip_9 AS fac_zip_code,
				case when length(fp.op_code) < 3 then LPAD (fp.op_code, 3, 0) else to_char(fp.op_code) end AS op_code,
				fp.mpe_id,
				fp.HU_LBL_CIN_CODE as declared_TRAY_CONTENT, 
				NVL (fp.sort_plan, '-') AS sort_plan,
				fp.scan_datetime,
				fp.imb_code,
				nvl(fp.mpe_dlvry_point,'-') AS sort_zip,
				NVL (z4.carrier_route_id, '-') as route_id,
				LPAD (fp.id_tag, 16, 0) AS id_tag,
				to_char(fp.start_the_clock_date,'mm/dd/yyyy')  AS x_stc,
				NVL (fp.imcb_code, 'Logical Container') AS x_imcb_code,
				fp.actual_entry_datetime AS x_actual_entry_datetime,
				fp.critical_entry_time AS x_critical_entry_time,
				NVL (cv.code_desc, 'Unknown') AS x_code_desc,
				ad.plt_fac_name AS x_plt_facility_name,
				NVL (op.op_desc, 'Unknown') AS x_op_desc,
				pr.mlr_name AS x_mailer_name,
				fp.edoc_sbmtr_crid_seq_id AS x_edoc_seq,
				fp.job_seq_id AS x_job_seq_id,
				LOGICAL_HU_SEQ_ID as x_log_hu,
				PHYS_HU_SEQ_ID as x_phys_hu,
				LOGICAL_CONTR_SEQ_ID as x_log_cntr,
				PHYS_CONTR_SEQ_ID as x_phys_cntr,
				fp.ml_cl_code as x_ml_cl_code,
				fp.ml_cat_code as x_ml_cat_code,
				fp.svc_std as x_svc_std,
				ccv.code_desc_long as x_CONTR_LVL_DESC,
				FEDEX_AIR_SCAN_IND as x_FEDEX_AIR_SCAN_IND,
				THS_CLEAN_AIR_SCAN_IND as x_THS_CLEAN_AIR_SCAN_IND,
				CAIR_SCAN_IND as x_CAIR_SCAN_IND
				FROM 
				bi_app.BI_stc_FAILED_PIECE@p2sasp_usr fp
				INNER JOIN bi_plt_area_district@p2sasp_usr ad
				ON substr(fp.scan_fac_zip_9,1,3) = ad.plt_fac_zip_3
				INNER JOIN BI_CODE_VALUE@p2sasp_usr cv
				ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
				left JOIN BI_CODE_VALUE@p2sasp_usr ccv
				ON ccv.code_type_name = 'CONTR_LVL_CODE'   AND ccv.code_val = fp.CONTR_LVL_CODE
				left JOIN bi_OP_CODE@p2sasp_usr op
				ON op.op_code = fp.op_code
				LEFT JOIN BI_ZIP4@p2sasp_usr z4
				ON z4.ZIP_9 = SUBSTR (fp.mpe_DLVRY_POINT, 1, 9)
				INNER JOIN bi_opsvis_crid@p2sasp_usr pr
				ON pr.CRID = fp.edoc_sbmtr_CRID 
				<cfif selHybStd neq ''>
					inner join BI_MSTR_SVC_STD@p2sasp_usr st
					on st.svc_std = fp.svc_std and st.orgn_entered = '#selEod#'
				</cfif>   
				<cfif chkPol is not ''>
					inner join 
					(
						select job_seq_id from POLITICAL_MAILING
						where job_seq_id is not null
						group by job_seq_id
					) pol 
					on pol.job_seq_id = fp.job_seq_id 
				</cfif>
				WHERE fp.start_the_clock_date >= to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value ='#bg_date#'>,'mm/dd/yyyy')
				and fp.start_the_clock_date < TO_DATE (<cfqueryparam value='#ed_date#'>, 'mm/dd/yyyy')
				and to_char(fp.start_the_clock_date,'d') = #selDow#
				<cfif selOrg3 is not ''>and fp.ORGN_FAC_ZIP_3 = <cfqueryparam cfsqltype="cf_sql_varchar" value ='#selOrg3#'></cfif>
				<cfif selPhysCntr is not ''>
					and fp.DESTN_FAC_ZIP_3 in  (<cfqueryparam value=#zipslist#  cfsqltype="cf_sql_varchar" list = "true">)
				<cfelse>
					<cfif seldest3 is not ''>and fp.DESTN_FAC_ZIP_3 = <cfqueryparam cfsqltype="cf_sql_varchar" value ='#selDest3#'></cfif>
				</cfif>
				<cfif selmailer is not ''>  and fp.EDOC_SBMTR_CRID_SEQ_ID  in  (<cfqueryparam value=#selmailer# list = "true">)</cfif>
				<cfif selPhysCntr is not ''>  and fp.PHYS_CONTR_SEQ_ID  in  (<cfqueryparam value=#selPhysCntr# list = "true">)</cfif>
				<cfif selOrgFac is not ''>and NVL (fp.rpt_orgn_fac_seq_id, fp.orgn_fac_seq_id)  = <cfqueryparam cfsqltype="cf_sql_decimal" value ='#selOrgFac#'></cfif>
				<cfif selDestFac is not '' and selDestFac neq -1 and left(selDestFac,1) neq 'E'>
					<cfif parsedatetime('#bg_date#') lt parsedatetime('04/01/2014')>
						and COALESCE (fp.mhts_fac_seq_id, -1)  =  <cfqueryparam cfsqltype="cf_sql_decimal" value ='#seldestFac#'>
					<cfelse>
						and fp.destn_fac_seq_id =  <cfqueryparam cfsqltype="cf_sql_decimal" value ='#seldestFac#'>
					</cfif> 
				</cfif>
				<cfif selDestFac is not '' and selDestFac neq -1 and left(selDestFac,1) eq 'E'>
					and  ad.plt_fac_key = <cfqueryparam  value ='#seldestFac#'>
				</cfif>
				<cfif selHybStd is not ''>
					and st.hyb_svc_std = <cfqueryparam  cfsqltype="cf_sql_decimal" value = #selHybStd#>
					<cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
					<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
				<cfelse>
					<cfif selSTD is not ''>and fp.svc_std =  <cfqueryparam  cfsqltype="cf_sql_decimal" value = #selStd#></cfif>
				</cfif>
				<cfif selVariance is not ''>
					and  svc_variance 
					<cfif selvariance is 4> > 3 <cfelse> = #selVariance#
					</cfif>
				</cfif>
				<cfif selFSS is not ''> and fp.fss_scan_ind =  <cfqueryparam cfsqltype="cf_sql_varchar" value ='#selFSS#'></cfif>
				<cfif selClass is not ''>  and fp.ml_cl_code = <cfqueryparam cfsqltype="cf_sql_decimal" value=#selClass#></cfif>
				<!---<cfif selJob is not ''>
					and (
					<cfloop index = #idx# from = "1" to ="#arraylen(selJobArray)#">
						fp.job_seq_id in (<cfqueryparam value=#selJobArray[idx]# list = "true">) 
						<cfif idx lt arraylen(selJobArray)>
							or 
						</cfif>
					</cfloop>
					)
				</cfif>--->
				<cfif selCategory is not ''>  and fp.ml_cat_code in  (<cfqueryparam cfsqltype="cf_sql_decimal" value=#selcategory# list = "true">)</cfif>
				<cfif selImbZip3 is not ''>  AND fp.IMB_DLVRY_ZIP_3 =  <cfqueryparam value='#selImbZip3#'></cfif> 
				<cfif selZip5 is not ''>  AND fp.IMB_DLVRY_ZIP_5 =  <cfqueryparam value='#selZip5#'></cfif> 
				<!---<cfif selmlronly is not ''>  and fp.EDOC_SBMTR_CRID_SEQ_ID  =  <cfqueryparam value="#selmlronly#"></cfif> --->
				<cfif selAir is 'Y' and selMode eq 'N'>  AND (FEDEX_AIR_SCAN_IND ='Y' or THS_CLEAN_AIR_SCAN_IND = 'Y' or CAIR_SCAN_IND = 'Y')</cfif> 
				<cfif selAir is 'N' and selMode eq 'N'>  AND FEDEX_AIR_SCAN_IND is null and THS_CLEAN_AIR_SCAN_IND is null and CAIR_SCAN_IND is null</cfif> 
				<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND = '#selAir#' </cfif>
				<cfif rdCert is not ''>
					<cfif rdCert is 'Y'>
						and nvl(fp.certified_mailer_ind,'Y') = <cfqueryparam  cfsqltype="cf_sql_varchar"value='Y'> 
					<cfelse> 
						and fp.certified_mailer_ind = <cfqueryparam cfsqltype="cf_sql_varchar" value='N'>
					</cfif>
				</cfif>
				<cfif selCntrLvl is not ''> and fp.CONTR_LVL_CODE = <cfqueryparam cfsqltype="cf_sql_decimal" value=#selCntrLvl#> </cfif>
				and fp.excl_sts_code IS NULL AND NVL (stop_scan_ind, 'Y') = 'Y' 
			) gp
			<!---<cfif appsck is 'ON'>where ap > 0</cfif>--->
		)
		where rec_no >= 1 and rec_no <= 3000
		ORDER BY IMB_CODE,SCAN_DATETIME

		</cfquery>
		
		<cfquery name = "dta" dbtype="query">
		select distinct rec_no,origin_fac_zip3,fac_zip_code,op_code,mpe_id,declared_TRAY_CONTENT,
		sort_plan,scan_datetime,' '||imb_code as imb_code,sort_zip,route_id,id_tag, x_stc,x_imcb_code,
		x_actual_entry_datetime,x_critical_entry_time,x_code_desc,x_plt_facility_name,
		x_op_desc,x_mailer_name,x_edoc_seq,x_job_seq_id,x_log_hu,x_phys_hu,x_log_cntr,x_phys_cntr,
		x_ml_cl_code,x_ml_cat_code,x_svc_std,x_CONTR_LVL_DESC,
		x_FEDEX_AIR_SCAN_IND,
		x_THS_CLEAN_AIR_SCAN_IND,
		x_CAIR_SCAN_IND
		from dta_main
		<!---where rec_no >= 1 and rec_no <= 1+499--->
		ORDER BY IMB_CODE,SCAN_DATETIME
		</cfquery> 
		<cfset ar = arraynew(2)>
		<cfset clist = '#dta.columnList#'>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(dta.columnList)>
		<cfset count2+=1>
		<cfloop query="dta">
			<cfset count=1>
			<cfloop index="idx"  list='#clist#'>
				<cfset ar[count2][count] = dta['#idx#'][count2-1]>
				<cfset count+=1>
			</cfloop>
				<cfset count2+=1>
		</cfloop>
		<cfreturn ar>

	</cffunction>



	<cffunction name="getAreaDistData" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">    

		<cfquery name="areaDist_q" datasource="#dsn#">
			select distinct site_name area_name, area,district_name, district
			from BI_PLT_AREA_DISTRICT
			where area not in ('4M','4N')
			order by area_name,district_name
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
        order by  hyb_svc_std
   </cfquery>
 	<cfset ar = arraynew(2)>
   <cfloop query="STD_Q">
      <cfset ar[currentrow][1]= '#HYB_SVC_STD#'>
      <cfset ar[currentrow][2]= '#HYB_SVC_STD_DESC#'>      
    </cfloop>
		<cfreturn ar>
	</cffunction>

</cfcomponent>