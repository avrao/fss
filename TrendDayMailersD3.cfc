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
		<cfargument name="selFacility" type="string" required="yes">
		<cfargument name="selDOW" type="string" required="yes">
		<cfquery name="dta" datasource="#dsn#">
			SELECT gp.*,
			case when sum(fail_piece_cnt) over (PARTITION BY start_the_clock_date) > 0 then
			sum(fail_piece_cnt) over (partition by mailer_name,start_the_clock_date)/
			sum(fail_piece_cnt) over (partition by start_the_clock_date) 
			else 0 end as imp_per,
			dense_rank()   OVER ( order by  start_the_clock_date )  as rk 
			FROM (  
				SELECT  Mailer_name, fp.EDOC_SBMTR_CRID_SEQ_ID, to_char(FP.START_THE_CLOCK_DATE,'DY-mm/dd/yyyy') as dow,fp.start_the_clock_date,
				to_char(start_the_clock_date,'MM/dd/yyyy') as dt_str,  
				<!--- add air--->                   
				<cfif selAir is 'Y' and selMode eq 'N'>
					SUM (fp.air_piece_cnt) as piece_cnt,
					SUM (fp.air_fail_piece_cnt) as  fail_piece_cnt,
					case when sum(fp.air_piece_cnt) > 0 then
					(sum(fp.air_piece_cnt)-sum(fp.air_fail_piece_cnt))/sum(fp.air_piece_cnt)                         
					else 0
					end
					as per
				<cfelseif  selAir is 'N' and selMode eq 'N'>
					SUM (fp.piece_cnt-fp.air_piece_cnt) as piece_cnt,
					SUM (fp.fail_piece_cnt-fp.air_fail_piece_cnt) as  fail_piece_cnt,
					case when sum(fp.piece_cnt-fp.air_piece_cnt) > 0 then
					(sum(fp.piece_cnt-fp.air_piece_cnt)-sum(fp.fail_piece_cnt-fp.air_fail_piece_cnt))/sum(fp.piece_cnt-fp.air_piece_cnt)                         
					else 0
					end
					as per
				<cfelse>
					SUM (fp.piece_cnt) as piece_cnt,
					SUM (fp.fail_piece_cnt) as  fail_piece_cnt,
					case when sum(fp.piece_cnt) > 0 then
					(sum(fp.piece_cnt)-sum(fp.fail_piece_cnt))/sum(fp.piece_cnt)                         
					else 0
					end
					as per
				</cfif>
				<!--- add air--->                   
				FROM V_BI_AGG_STC_OD_DAY fp
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
				inner join BI_MSTR_SVC_STD st
				on st.svc_std = fp.svc_std and st.orgn_entered = '#selEod#'
				<cfif chkPol is not ''>
					inner join 
					(
						select job_seq_id from POLITICAL_MAILING
						where job_seq_id is not null
						group by job_seq_id
					) pol 
					on pol.job_seq_id = fp.job_seq_id 
				</cfif>

				WHERE STArT_THE_CLOCK_DATE
				BETWEEN TO_DATE('#bg_date#','mm-dd-yyyy')
				AND  TO_DATE('#ed_date#','mm-dd-yyyy')-1
				AND to_char(fp.START_THE_CLOCK_DATE,'d') = '#selDOW#'
				and fp.ml_cl_code = #selClass# 
				and fp.ml_cat_code in (#selCategory#)
				and st.hyb_svc_std = '#selHybStd#'
				<cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
				<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
				<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') = '#selFSS#' </cfif>  
				<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND = '#selAir#' </cfif>
				<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE = '#selCntrLvl#' </cfif>
				<cfif seldir is 'O'>
					<cfif isnumeric(selFacility)>
						and fp.orgn_fac_seq_id = #selFacility#
					<cfelse>
						and plt.plt_fac_key = '#selFacility#'
					</cfif>
				<cfelse> 
					<cfif isnumeric(selFacility)>
						and fp.destn_fac_seq_id = #selFacility#
					<cfelse>
						and plt.plt_fac_key = '#selFacility#'
					</cfif>
				</cfif>
				<cfif rdCert eq ''>
					and nvl(fp.certified_mailer_ind,'Y') in ('Y','N')
				<cfelse>
					and nvl(fp.certified_mailer_ind,'Y') =  '#rdcert#'
				</cfif> 
				group by  
				op.mailer_name,fp.start_the_clock_date,fp.EDOC_SBMTR_CRID_SEQ_ID
			) gp
			ORDER BY 
			<cfif sortBy eq ''>
				dow,imp_per desc
			<cfelseif sortBy is 'imp_per'>
				#sortBy#
			<cfelse>
				#sortBy#,imp_per desc
			</cfif>
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