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
		<cfargument name="selDestFac" type="string" required="yes">
		<cfargument name="lvl" type="string" required="yes">
		
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
		
		<cfif ed_date eq ''>
		<cfset ed_date = dateformat(now(), 'mm/dd/yyyy')>
		</cfif>
		<cfquery name="dta" datasource="#dsn#">
			with dta_main as (
				<cfloop from="#bg_date#" to="#ed_date-1#" index="day">
					select fp.destn_fac_seq_id,
					fac_name,
					fp.destn_fac_zip_3,
					<cfif lvl is 1 and selDestFac is not ''>
					IMB_DLVRY_ZIP_3,				  
					</cfif>
					sum(#piece_cnt#) as piece_cnt,
					sum(#fail_piece_cnt#) as fail_piece_cnt,
					to_char(start_the_clock_date,'d') as dow
					from V_BI_AGG_STC_OD_DAY_zip3 fp
					inner JOIN bi_facility a
					ON a.fac_SEQ_ID = fp.destn_fac_seq_id
					inner join BI_MSTR_SVC_STD st
					on st.svc_std = fp.svc_std and st.orgn_entered = '#selEOD#'
					and st.ml_cl_code = fp.ml_cl_code
					<cfif chkPol is not ''>
					inner join 
					(
					select job_seq_id from POLITICAL_MAILING
					where job_seq_id is not null
					group by job_seq_id
					) pol 
					on pol.job_seq_id = fp.job_seq_id 
					</cfif>
					WHERE fp.STArT_THE_CLOCK_DATE = TO_DATE(<cfqueryparam value="#dateformat(day, 'mm/dd/yyyy')#" cfsqltype="cf_sql_varchar">,'mm-dd-yyyy')
					and fp.ml_cl_code = <cfqueryparam value="#selClass#" cfsqltype="cf_sql_varchar"> 
					and fp.ml_cat_code in (<cfqueryparam value="#selCategory#" cfsqltype="cf_sql_varchar" list="yes">)
					and st.hyb_svc_std = <cfqueryparam value="#selHybStd#" cfsqltype="cf_sql_decimal">
					<cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
					<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
					<cfif rdCert neq ''>
					and nvl(fp.certified_mailer_ind,'Y') =  <cfqueryparam value="#rdcert#" cfsqltype="cf_sql_varchar">
					</cfif>                          
					<cfif selFacility is not ''>and fp.ORGN_fac_seq_id = <cfqueryparam value="#selFacility#" cfsqltype="cf_sql_decimal"></cfif>
					<cfif selDestFac is not '' and left(selDestFac,1) neq 'E' and lvl is 1 > and fp.destn_fac_seq_id = <cfqueryparam value="#selDestFac#" cfsqltype="cf_sql_decimal"> </cfif>
					<cfif selDestFac is not '' and left(selDestFac,1) eq 'E' and lvl is 1> and fp.destn_fac_seq_id = -1 </cfif>
					<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') = <cfqueryparam value="#selFSS#" cfsqltype="cf_sql_varchar"> </cfif>
					<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND = '#selAir#' </cfif>
					<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE = <cfqueryparam value="#selCntrLvl#" cfsqltype="cf_sql_varchar"> </cfif>
					and piece_cnt >0
					group by fp.destn_fac_seq_id,
					fac_name,<cfif lvl is 1 and selDestFac is not ''>IMB_DLVRY_ZIP_3,</cfif>
					fp.destn_fac_zip_3, to_char(start_the_clock_date,'d')
					<cfif day neq ed_date-1>UNION ALL</cfif>
				</cfloop>			
			)
		
		
			SELECT gp.*
			FROM (  
				SELECT	destn_fac_seq_id  AS FAC_KEY,
				fac_name,
				destn_fac_zip_3,
				<cfif lvl is 1 and selDestFac is not ''>
				IMB_DLVRY_ZIP_3,				  
				</cfif>
				sum(CASE   WHEN dow = 7 then #piece_cnt# else 0 end) as tp_sat,
				sum(CASE   WHEN dow = 7 then #fail_piece_cnt# else 0 end) as fp_sat,
				sum(CASE   WHEN dow = 1 then #piece_cnt# else 0 end) as tp_sun,
				sum(CASE   WHEN dow = 1 then #fail_piece_cnt# else 0 end) as fp_sun,				   
				sum(CASE   WHEN dow = 2 then #piece_cnt# else 0 end) as tp_mon,
				sum(CASE   WHEN dow = 2 then #fail_piece_cnt# else 0 end) as fp_mon,
				sum(CASE   WHEN dow = 3 then #piece_cnt# else 0 end) as tp_tue,
				sum(CASE   WHEN dow = 3 then #fail_piece_cnt# else 0 end) as fp_tue,
				sum(CASE   WHEN dow = 4 then #piece_cnt# else 0 end) as tp_wed,
				sum(CASE   WHEN dow = 4 then #fail_piece_cnt# else 0 end) as fp_wed,
				sum(CASE   WHEN dow = 5 then #piece_cnt# else 0 end) as tp_thu,
				sum(CASE   WHEN dow = 5 then #fail_piece_cnt# else 0 end) as fp_thu,
				sum(CASE   WHEN dow = 6 then #piece_cnt# else 0 end) as tp_fri,
				sum(CASE   WHEN dow = 6 then #fail_piece_cnt# else 0 end) as fp_fri,
				sum(#piece_cnt#) as tp_tot,
				sum(#fail_piece_cnt#) as fp_tot,
				sum(CASE   WHEN dow = 7 then
				(#piece_cnt#-#fail_piece_cnt#) 
				ELSE  0    END )/ 
				(sum(CASE   WHEN dow =7 then
				(#piece_cnt#) 
				ELSE  0    END )+.000000001)  
				AS PER_sat,
				sum(CASE   WHEN dow = 1 then
				(#piece_cnt#-#fail_piece_cnt#) 
				ELSE  0    END )/ 
				(sum(CASE   WHEN dow = 1 then
				(#piece_cnt#) 
				ELSE  0    END )+.000000001)  
				AS PER_sun,
				sum(CASE   WHEN dow = 2 then
				(#piece_cnt#-#fail_piece_cnt#) 
				ELSE  0    END )/ 
				(sum(CASE   WHEN dow = 2 then
				(#piece_cnt#) 
				ELSE  0    END )+.000000001)  
				AS PER_mon,
				sum(CASE   WHEN dow = 3 then
				(#piece_cnt#-#fail_piece_cnt#) 
				ELSE  0    END )/ 
				(sum(CASE   WHEN dow = 3 then
				(#piece_cnt#) 
				ELSE  0    END )+.000000001)   AS PER_tue,
				sum(CASE   WHEN dow = 4 then
				(#piece_cnt#-#fail_piece_cnt#) 
				ELSE  0    END )/ 
				(sum(CASE   WHEN dow = 4 then
				(#piece_cnt#) 
				ELSE  0    END )+.000000001)   AS PER_WED,
				sum(CASE   WHEN dow = 5 then
				(#piece_cnt#-#fail_piece_cnt#) 
				ELSE  0    END )/ 
				(sum(CASE   WHEN dow = 5 then
				(#piece_cnt#) 
				ELSE  0    END )+.000000001)   AS PER_thu,
				sum(CASE   WHEN dow = 6 then
				(#piece_cnt#-#fail_piece_cnt#) 
				ELSE  0    END )/ 
				(sum(CASE   WHEN dow = 6 then
				(#piece_cnt#) 
				ELSE  0    END )+.000000001)   AS PER_fri,
				sum(#piece_cnt#-#fail_piece_cnt#) / (sum(#piece_cnt#) +.000000001) AS PER_tot
				FROM  dta_main
				group by
				destn_fac_seq_id,fac_name,destn_fac_zip_3
				<cfif selDestFac is not '' and lvl is 1>,IMB_DLVRY_ZIP_3</cfif>
				having sum(#piece_cnt#) > 0
			) gp
			order by 
			<cfif sortBy is '' >
			fp_tot desc
			<cfelse>
			#sortBy#
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

</cfcomponent>