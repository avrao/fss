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
		
		<cfargument name="selvariance" type="string" required="yes">
		<cfargument name="fp_chk" type="string" required="yes">
		<cfargument name="selMailer" type="string" required="yes">
		
		<cfset selArea=''><cfset selDistrict=''>
		<cfset rdRptType = ''><cfif selDir eq 'O'><cfset rdRptType='3'></cfif>
		<cfset selJob = ''>
		
		<cfquery name="dta" datasource="#dsn#">
			SELECT fp.ORGN_FAC_ZIP_3,
			fp.DESTN_FAC_ZIP_3,

			fo.fac_name   as org_fac_name,
			fd.fac_name  as dest_fac_name,
			fp.ORGN_FAC_SEQ_ID,
			fp.DESTN_FAC_SEQ_ID,
			<cfif selAir eq 'Y' and selMode eq 'N'>
				<cfif selVariance eq ''>
					SUM(fp.AIR_FAIL_PIECE_CNT) AS FAILED_PIECES,
				<cfelse>
					sum(INCL_AIR_SVC_VAR_PLUS#selvariance#_CNT) as failed_pieces,
				</cfif>
				SUM (fp.AIR_PIECE_CNT) AS MAILED_PIECES,
				CASE
				WHEN SUM (fp.AIR_PIECE_CNT) > 0
				THEN
				ROUND (
				(SUM (fp.AIR_PIECE_CNT) - SUM (fp.AIR_FAIL_PIECE_CNT))
				/ SUM (fp.AIR_PIECE_CNT)
				* 10000)
				/ 10000
				ELSE
				0
				END
				AS ON_TIME_PER 
			<cfelseif selAir eq 'N' and selMode eq 'N'>
				<cfif selVariance eq ''>
					SUM(fp.fail_piece_cnt)-SUM(fp.AIR_FAIL_PIECE_CNT) AS FAILED_PIECES,
				<cfelse>
					sum(INCL_SVC_VAR_PLUS#selvariance#_CNT)-sum(INCL_AIR_SVC_VAR_PLUS#selvariance#_CNT) as failed_pieces,
				</cfif>
				SUM(fp.piece_cnt)-SUM(fp.AIR_PIECE_CNT) AS MAILED_PIECES,
				CASE
				WHEN SUM(fp.piece_cnt)-SUM(fp.AIR_PIECE_CNT) > 0
				THEN
				ROUND (
				((SUM(fp.piece_cnt)-SUM(fp.AIR_PIECE_CNT)) - (SUM(fp.fail_piece_cnt)-SUM(fp.AIR_FAIL_PIECE_CNT)))
				/ (SUM(fp.piece_cnt)-SUM(fp.AIR_PIECE_CNT))
				* 10000)
				/ 10000
				ELSE
				0
				END
				AS ON_TIME_PER 
			<cfelse>	
				<cfif selVariance eq ''>
					SUM(fp.fail_piece_cnt) AS FAILED_PIECES,
				<cfelse>
					sum(INCL_SVC_VAR_PLUS#selvariance#_CNT) as failed_pieces,
				</cfif>
				SUM (fp.piece_cnt) AS MAILED_PIECES,
				CASE
				WHEN SUM (fp.piece_cnt) > 0
				THEN
				ROUND (
				(SUM (fp.piece_cnt) - SUM (fp.FAIL_PIECE_CNT))
				/ SUM (fp.piece_cnt)
				* 10000)
				/ 10000
				ELSE
				0
				END
				AS ON_TIME_PER 
			</cfif>           
			FROM   V_BI_AGG_STC_OD_DAY fp
			INNER JOIN bi_facility fd
			ON fp.destn_FAC_SEQ_ID = fd.FAC_SEQ_ID
			inner join 
			areadistname_t ad
			on fd.dist_id = ad.district_id
			inner join bi_facility fo
			on fp.ORGN_FAC_SEQ_ID = fo.FAC_SEQ_ID
			inner join 
			areadistname_t ado
			on fo.dist_id = ado.district_id
			<cfif selHybStd is not ''>
				inner join BI_MSTR_SVC_STD st
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

			WHERE fp.start_the_clock_date >= to_date(<cfqueryparam value='#bg_date#'>,'mm/dd/yyyy')
			and fp.start_the_clock_date < TO_DATE (<cfqueryparam value='#ed_date#'>, 'mm/dd/yyyy')
			and to_char(start_the_clock_date,'d') = #selDow#
			<cfif selMailer is not ''>  and fp.EDOC_SBMTR_CRID_SEQ_ID  in  (<cfqueryparam value=#selmailer# list = "true">)</cfif>
			<cfif selClass is not ''>  and fp.ml_cl_code = <cfqueryparam value=#selClass#></cfif>
<!---			<cfif selHybStd is not ''>--->
				and st.hyb_svc_std = '#selHybStd#'
				<cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
				<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
<!---			<cfelse>
				<cfif selSTD is not ''>and fp.svc_std =  <cfqueryparam value='#selStd#'></cfif>
			</cfif>--->

			<cfif rdRptType eq 3>
				<cfif selfacility is not ''> and fp.orgn_fac_seq_id = <cfqueryparam value='#SelFacility#'> </cfif>
				<cfif SelDistrict is not ''> 
					and ado.district_id = '#selDistrict#' 
				</cfif>
				<cfif SelArea is not ''> and ado.area_id = '#selArea#' </cfif>
			<cfelse>
				<cfif selfacility is not ''> and fp.destn_fac_seq_id  = <cfqueryparam value='#SelFacility#'> </cfif>
				<cfif SelDistrict is not ''> 
					and ad.district_id = '#selDistrict#' 
				</cfif>
				<cfif SelArea is not ''> and ad.area_id = '#selArea#' </cfif>
			</cfif> 
			<cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') = '#selFSS#' </cfif>  
			<cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE = '#selCntrLvl#' </cfif>  
			<cfif selair is 'Y' and selMode eq 'N'>and fp.AIR_PIECE_CNT > 0</cfif>
			<cfif selair is 'N' and selMode eq 'N'>and fp.PIECE_CNT -fp.AIR_PIECE_CNT > 0</cfif>
			<cfif selJob is not ''>
				and (
				<cfloop index = #idx# from = "1" to ="#arraylen(selJobArray)#">
					fp.job_seq_id in (#selJobArray[idx]#)
					<cfif idx lt arraylen(selJobArray)>
						or 
					</cfif>
				</cfloop>
				)
			</cfif>
			<cfif selCategory is not ''>  and fp.ml_cat_code in  (<cfqueryparam value=#selcategory# list = "true">)</cfif> 
			<cfif rdCert is not ''>
				<cfif rdCert is 'Y'> and  nvl(fp.certified_mailer_ind,'Y') = <cfqueryparam value='Y'> 
			<cfelse> 
				and fp.certified_mailer_ind = <cfqueryparam value='N'>
			</cfif>
			</cfif>
			<cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND = '#selAir#' </cfif>
			GROUP BY 
			fp.ORGN_FAC_ZIP_3,
			fp.DESTN_FAC_ZIP_3,
			fo.fac_name,
			fd.fac_name, 
			fp.ORGN_FAC_SEQ_ID,
			fp.destn_FAC_SEQ_ID
			<cfif selair is 'Y' and selMode eq 'N'>
				<cfif isdefined('fp_chk')> having SUM (fp.AIR_FAIL_PIECE_CNT)  > 0 </cfif>
			<cfelseif selair is 'N' and selMode eq 'N'>
				<cfif isdefined('fp_chk')> having SUM (fp.FAIL_PIECE_CNT-fp.AIR_FAIL_PIECE_CNT)  > 0 </cfif>
			<cfelse>
				<cfif isdefined('fp_chk')> having SUM (fp.FAIL_PIECE_CNT)  > 0 </cfif>
			</cfif>         
			order by #sortBy#FAILED_PIECES
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