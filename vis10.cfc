<cfcomponent>
	<cffunction name="getstctop10" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">        
        <cfargument name="chkpol" type="string" required="yes">
        <cfargument name="selEod" type="string" required="yes">
        <cfargument name="selDir" type="string" required="yes">
        <cfargument name="selClass" type="string" required="yes">
        <cfargument name="selCategory" type="string" required="yes">
        <cfargument name="selArea" type="string" required="yes">
        <cfargument name="selDistrict" type="string" required="yes">
        <cfargument name="top10" type="string" required="yes">
        <cfargument name="selHybStd" type="string" required="yes">
        <cfargument name="selFSS" type="string" required="yes">
        <cfargument name="selCntrLvl" type="string" required="yes">
        <cfargument name="selcert" type="string" required="yes">
        <cfargument name="selAir" type="string" required="yes">
        <cfargument name="selMode" type="string" required="yes">
        <cfargument name="selDate" type="string" required="yes">        
		<cfargument name="selRange" type="string" required="yes">
        <cfargument name="selBMEU" type="string" required="yes">
                                                                                

				<cfif selrange is 'WEEK' and  chkpol is ''>
                <cfset rpt_table = 'V_BI_ADD_OD_RPT_WEEK_zip3'>
            	<cfelseif selRange is not  'WEEK' and  chkpol is ''>
                <cfset rpt_table = 'V_BI_ADD_OD_RPT_MONTH_zip3'>
				<cfelseif selRange is 'WEEK' and  chkpol is not ''>
                <cfset rpt_table = 'PM_ADD_OD_RPT_WEEK'>
            	<cfelseif selRange is not  'WEEK' and  chkpol is not ''>
                <cfset rpt_table = 'PM_ADD_OD_RPT_MONTH'>
                </cfif>   

                <cfset dt = parsedatetime(seldate)>
            	<cfif selrange is  'WEEK'>
                <cfset ed_date = dateformat(dateadd('d',6,dt),'mm/dd/yyyy')>
            	<cfelseif selrange is  'MON'>
                <cfset ed_date = dateformat(dateadd('d',-1,dateadd('m',1,dt)),'mm/dd/yyyy')>
            	<cfelseif selrange is  'QTR'>
                <cfset ed_date = dateformat(dateadd('d',-1,dateadd('q',1,dt)),'mm/dd/yyyy')>
                </cfif>   
				



			<cfif selAir eq 'N' and selMode eq 'N'>
            <cfset minu4='(INCL_SVC_VAR_MINUS4_CNT-INCL_AIR_SVC_VAR_MINUS4_CNT)'>
            <cfset minu3='(INCL_SVC_VAR_MINUS3_CNT-INCL_AIR_SVC_VAR_MINUS3_CNT)'>
            <cfset minu2='(INCL_SVC_VAR_MINUS2_CNT-INCL_AIR_SVC_VAR_MINUS2_CNT)'>
            <cfset minu1='(INCL_SVC_VAR_MINUS1_CNT-INCL_AIR_SVC_VAR_MINUS1_CNT)'>
            <cfset zeroed='(INCL_SVC_VAR_0_CNT-INCL_AIR_SVC_VAR_0_CNT)'>
            <cfset plus1='(INCL_SVC_VAR_PLUS1_CNT-INCL_AIR_SVC_VAR_PLUS1_CNT)'>
            <cfset plus2='(INCL_SVC_VAR_PLUS2_CNT-INCL_AIR_SVC_VAR_PLUS2_CNT)'>
            <cfset plus3='(INCL_SVC_VAR_PLUS3_CNT-INCL_AIR_SVC_VAR_PLUS3_CNT)'>
            <cfset plus4='(INCL_SVC_VAR_PLUS4_CNT-INCL_AIR_SVC_VAR_PLUS4_CNT)'>
            <cfset passedIncl='(TOTAL_INCL_PASSED_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
            <cfset totalIncl='(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
            <cfset passed='(PASSED_PIECES-PASSED_AIR_PIECES)'>
            <cfset total='(TOTAL_PIECES-TOTAL_AIR_PIECES)'>
            
            <cfelseif selAir eq 'Y' and selMode eq 'N'>
            <cfset minu4='INCL_AIR_SVC_VAR_MINUS4_CNT'>
            <cfset minu3='INCL_AIR_SVC_VAR_MINUS3_CNT'>
            <cfset minu2='INCL_AIR_SVC_VAR_MINUS2_CNT'>
            <cfset minu1='INCL_AIR_SVC_VAR_MINUS1_CNT'>
            <cfset zeroed='INCL_AIR_SVC_VAR_0_CNT'>
            <cfset plus1='INCL_AIR_SVC_VAR_PLUS1_CNT'>
            <cfset plus2='INCL_AIR_SVC_VAR_PLUS2_CNT'>
            <cfset plus3='INCL_AIR_SVC_VAR_PLUS3_CNT'>
            <cfset plus4='INCL_AIR_SVC_VAR_PLUS4_CNT'>
            <cfset passedIncl='TOT_INCL_PASSED_AIR_PIECE_CNT'>
            <cfset totalIncl='TOTAL_INCL_AIR_PIECE_CNT'>
            <cfset passed='PASSED_AIR_PIECES'>
            <cfset total='TOTAL_AIR_PIECES'>
            
            <cfelse>
            <cfset minu4='INCL_SVC_VAR_MINUS4_CNT'>
            <cfset minu3='INCL_SVC_VAR_MINUS3_CNT'>
            <cfset minu2='INCL_SVC_VAR_MINUS2_CNT'>
            <cfset minu1='INCL_SVC_VAR_MINUS1_CNT'>
            <cfset zeroed='INCL_SVC_VAR_0_CNT'>
            <cfset plus1='INCL_SVC_VAR_PLUS1_CNT'>
            <cfset plus2='INCL_SVC_VAR_PLUS2_CNT'>
            <cfset plus3='INCL_SVC_VAR_PLUS3_CNT'>
            <cfset plus4='INCL_SVC_VAR_PLUS4_CNT'>
            <cfset passedIncl='TOTAL_INCL_PASSED_PIECE_CNT'>
            <cfset totalIncl='TOTAL_INCL_PIECE_CNT'>
            <cfset passed='PASSED_PIECES'>
            <cfset total='TOTAL_PIECES'>
            </cfif>


        <cfquery name="dta" datasource="#dsn#">
        
          with gtotal as
            (  
            SELECT     SUM (TOTAL_INCL_PIECE_CNT) AS gTOTAL_pieces,
            SUM (TOTAL_INCL_PIECE_CNT) - SUM (TOTAL_INCL_PASSED_PIECE_CNT)
            AS gfailed_pieces
            from #rpt_table# fp
            INNER JOIN bi_facility f ON f.fac_SEQ_ID = fp.orgn_fac_SEQ_ID
            INNER JOIN (SELECT DISTINCT site_name AS area_name,
            area,
            district_name,
            district
            FROM BI_PLT_AREA_DISTRICT) ad
            ON ad.district = fp.orgn_district
            INNER JOIN BI_MSTR_SVC_STD st
            ON     st.svc_std = fp.svc_std
            AND st.orgn_entered = fp.orgn_entered
            AND st.ml_cl_code = fp.ml_cl_code
            WHERE 
            <cfif selrange is 'WEEK'> 
             ACTUAL_DLVRY_WEEK  = TO_DATE('#selDate#','mm-dd-yyyy')
            <cfelseif selrange is 'MON'>  
             ACTUAL_DLVRY_MONTH = TO_DATE('#selDate#','mm-dd-yyyy')
            <cfelseif selrange is 'QTR'>  
            ACTUAL_DLVRY_MONTH in (TO_DATE ('#selDate#', 'mm-dd-yyyy'),ADD_MONTHS (TO_DATE ('#selDate#', 'mm-dd-yyyy'),1),ADD_MONTHS (TO_DATE ('#selDate#', 'mm-dd-yyyy'),2))
            </cfif>
            <cfif selClass is not ''>and fp.ml_cl_code = #selClass# </cfif>
            <cfif selCategory is not ''>and fp.ml_cat_code in (#selCategory#)</cfif>
            <cfif selHybStd is not ''>and st.hyb_svc_std = '#selHybStd#'</cfif>
            <cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') = '#selFSS#' </cfif>  
            <cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE = '#selCntrLvl#' </cfif>  
            <cfif selEod neq ''>and fp.ORGN_ENTERED = '#selEod#'</cfif>
            <cfif selCert is not ''> and nvl(fp.certified_mailer_ind,'Y') = '#selCert#' </cfif> 
            <cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND = '#selAir#' </cfif>
		 <cfif selBMEU is 'P'> and   f.FAC_CAT not in (4,11) and f.FAC_TYPE not in (1,11)  </cfif>
             <cfif selBMEU is 'D'> and   f.FAC_CAT in (4,11) and f.FAC_TYPE  in (1,11)  </cfif>
            )

        
        
         select gp. *,
            ROUND (gp.failed_pieces / (select gtotal_pieces from gtotal)*10000)
               /100
        
            AS per_imp,
            
             gp.failed_pieces / (select gtotal_pieces from gtotal)
                         AS per_imp_ord,
           ROUND (gp.failed_pieces / (select gfailed_pieces+.0000001 from gtotal)*10000)
         / 100
            AS per_failed
        
        
<!---        case when  SUM (TOTAL_pieces) OVER () = 0 then 0 else
        ROUND (gp.failed_pieces / SUM (TOTAL_pieces) OVER () * 10000) / 100
        end   AS per_imp,
        case when  SUM (TOTAL_pieces) OVER () = 0 then 0 else
        gp.failed_pieces / SUM (TOTAL_pieces) OVER () end AS per_imp_ord,
        ROUND (gp.failed_pieces / (SUM (failed_pieces) OVER () + .00000001) * 10000) / 100
        AS per_failed
--->		
        from
            (
            select f.fac_SEQ_ID,fac_name,
            ad.area_name,ad.area,ad.district_name,ad.district,
            sum(nvl(#minu4#,0)) as m4,
            sum(nvl(#minu3#,0)) as m3,
            sum(nvl(#minu2#,0)) as m2,
            sum(nvl(#minu1#,0)) as m1,
            sum(nvl(#zeroed#,0)) as p0,
            sum(nvl(#plus1#,0)) as p1,
            sum(nvl(#plus2#,0)) as p2,
            sum(nvl(#plus3#,0)) as p3,
            sum(nvl(#plus4#,0)) as p4,
            sum(#totalIncl#) as TOTAL_pieces,
            sum(#totalIncl#)-sum(#passedIncl#)  as failed_pieces,
            case when SUM (#totalIncl#) > 0 then
            ROUND (SUM (#passedIncl#) / SUM (#totalIncl#) * 10000)
            / 100 else 0 end AS PER_std
            from #rpt_table# fp
            INNER JOIN
            bi_facility f
            ON f.fac_SEQ_ID = <CFIF selDir is 'O'>fp.orgn_fac_SEQ_ID<cfelse>fp.destn_fac_SEQ_ID</CFIF>   
            inner join 
            (select distinct site_name as area_name,area,district_name,district
            from BI_PLT_AREA_DISTRICT) ad
            on ad.district = <CFIF selDir is 'O'>fp.orgn_district<cfelse>fp.destn_district</CFIF>   
            inner join BI_MSTR_SVC_STD st
            on st.svc_std = fp.svc_std and st.orgn_entered = fp.orgn_entered and st.ml_cl_code = fp.ml_cl_code
            WHERE 
            <cfif selrange is 'WEEK'> 
             ACTUAL_DLVRY_WEEK  = TO_DATE('#selDate#','mm-dd-yyyy')
            <cfelseif selrange is 'MON'>  
             ACTUAL_DLVRY_MONTH = TO_DATE('#selDate#','mm-dd-yyyy')
            <cfelseif selrange is 'QTR'>  
            ACTUAL_DLVRY_MONTH in (TO_DATE ('#selDate#', 'mm-dd-yyyy'),ADD_MONTHS (TO_DATE ('#selDate#', 'mm-dd-yyyy'),1),ADD_MONTHS (TO_DATE ('#selDate#', 'mm-dd-yyyy'),2))
            </cfif>
            <cfif selArea is not '' and selArea is not 'HQ'>and ad.area = '#selArea#' </cfif>            
            <cfif selDistrict is not ''>and ad.district = '#selDistrict#' </cfif>                        
            <cfif selClass is not ''>and fp.ml_cl_code = #selClass# </cfif>
            <cfif selCategory is not ''>and fp.ml_cat_code in (#selCategory#)</cfif>
            <cfif selHybStd is not ''>and st.hyb_svc_std = '#selHybStd#'</cfif>
            <cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') = '#selFSS#' </cfif>  
            <cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE = '#selCntrLvl#' </cfif>  
            <cfif selEod neq ''>and fp.ORGN_ENTERED = '#selEod#'</cfif>
            <cfif selCert is not ''> and nvl(fp.certified_mailer_ind,'Y') = '#selCert#' </cfif> 
            <cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND = '#selAir#' </cfif>
			 <cfif selBMEU is 'P'> and   f.FAC_CAT not in (4,11) and f.FAC_TYPE not in (1,11)  </cfif>
             <cfif selBMEU is 'D'> and   f.FAC_CAT in (4,11) and f.FAC_TYPE  in (1,11)  </cfif>
            group by  f.fac_SEQ_ID,fac_name,
            ad.area_name,ad.area,ad.district_name,ad.district
            having sum(#totalIncl#) > 0
        ) gp
        order by per_imp_ord desc

</cfquery>
<cfset ar =arraynew(3)>
<cfloop query="dta">
<cfset ar[1][currentrow][1] = #fac_name#>
<cfset ar[1][currentrow][2] = #area_name#>
<cfset ar[1][currentrow][3] = #district_name#>
<cfset ar[1][currentrow][4] = #total_pieces#>
<cfset ar[1][currentrow][5] = #failed_pieces#>
<cfset ar[1][currentrow][6] = #per_failed#>
<cfset ar[1][currentrow][7] = #per_std#>
<cfset ar[1][currentrow][8] = #per_imp#>

<cfset ar[2][currentrow][1] = #fac_seq_id#>
<cfset ar[2][currentrow][2] = #area#>
<cfset ar[2][currentrow][3] = #district#>
<cfset ar[2][currentrow][4] = #total_pieces#>
<cfset ar[2][currentrow][5] = #failed_pieces#>
<cfset ar[2][currentrow][6] = #m4#>
<cfset ar[2][currentrow][7] = #m3#>
<cfset ar[2][currentrow][8] = #m2#>
<cfset ar[2][currentrow][9] = #m1#>
<cfset ar[2][currentrow][10] = #p0#>
<cfset ar[2][currentrow][11] = #p1#>
<cfset ar[2][currentrow][12] = #p2#>
<cfset ar[2][currentrow][13] = #p3#>
<cfset ar[2][currentrow][14] = #p4#>


</cfloop>
<cfreturn ar>
	</cffunction>
<!--- zip3 --->

	<cffunction name="getstctop10zip3" access="remote" returntype="query" returnformat="JSON">
		<cfargument name="dsn" type="string" required="yes">        
        <cfargument name="chkpol" type="string" required="yes">
        <cfargument name="selEod" type="string" required="yes">
        <cfargument name="selDir" type="string" required="yes">
        <cfargument name="selClass" type="string" required="yes">
        <cfargument name="selCategory" type="string" required="yes">
        <cfargument name="selArea" type="string" required="yes">
        <cfargument name="selDistrict" type="string" required="yes">
        <cfargument name="top10" type="string" required="yes">
        <cfargument name="selHybStd" type="string" required="yes">
        <cfargument name="selFSS" type="string" required="yes">
        <cfargument name="selCntrLvl" type="string" required="yes">
        <cfargument name="selcert" type="string" required="yes">
        <cfargument name="selAir" type="string" required="yes">
        <cfargument name="selMode" type="string" required="yes">
        <cfargument name="selDate" type="string" required="yes">        
		<cfargument name="selRange" type="string" required="yes">
        <cfargument name="selBMEU" type="string" required="yes">
        <cfargument name="seqList" type="string" required="yes">                                                                                                                                                        

				<cfif selrange is 'WEEK' and  chkpol is ''>
                <cfset rpt_table = 'V_BI_ADD_OD_RPT_WEEK_zip3'>
            	<cfelseif selRange is not  'WEEK' and  chkpol is ''>
                <cfset rpt_table = 'V_BI_ADD_OD_RPT_MONTH_zip3'>
				<cfelseif selRange is 'WEEK' and  chkpol is not ''>
                <cfset rpt_table = 'PM_ADD_OD_RPT_WEEK'>
            	<cfelseif selRange is not  'WEEK' and  chkpol is not ''>
                <cfset rpt_table = 'PM_ADD_OD_RPT_MONTH'>
                </cfif>   

                <cfset dt = parsedatetime(seldate)>
            	<cfif selrange is  'WEEK'>
                <cfset ed_date = dateformat(dateadd('d',6,dt),'mm/dd/yyyy')>
            	<cfelseif selrange is  'MON'>
                <cfset ed_date = dateformat(dateadd('d',-1,dateadd('m',1,dt)),'mm/dd/yyyy')>
            	<cfelseif selrange is  'QTR'>
                <cfset ed_date = dateformat(dateadd('d',-1,dateadd('q',1,dt)),'mm/dd/yyyy')>
                </cfif>   
				
<!--- zip3 --->


			<cfif selAir eq 'N' and selMode eq 'N'>
            <cfset minu4='(INCL_SVC_VAR_MINUS4_CNT-INCL_AIR_SVC_VAR_MINUS4_CNT)'>
            <cfset minu3='(INCL_SVC_VAR_MINUS3_CNT-INCL_AIR_SVC_VAR_MINUS3_CNT)'>
            <cfset minu2='(INCL_SVC_VAR_MINUS2_CNT-INCL_AIR_SVC_VAR_MINUS2_CNT)'>
            <cfset minu1='(INCL_SVC_VAR_MINUS1_CNT-INCL_AIR_SVC_VAR_MINUS1_CNT)'>
            <cfset zeroed='(INCL_SVC_VAR_0_CNT-INCL_AIR_SVC_VAR_0_CNT)'>
            <cfset plus1='(INCL_SVC_VAR_PLUS1_CNT-INCL_AIR_SVC_VAR_PLUS1_CNT)'>
            <cfset plus2='(INCL_SVC_VAR_PLUS2_CNT-INCL_AIR_SVC_VAR_PLUS2_CNT)'>
            <cfset plus3='(INCL_SVC_VAR_PLUS3_CNT-INCL_AIR_SVC_VAR_PLUS3_CNT)'>
            <cfset plus4='(INCL_SVC_VAR_PLUS4_CNT-INCL_AIR_SVC_VAR_PLUS4_CNT)'>
            <cfset passedIncl='(TOTAL_INCL_PASSED_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
            <cfset totalIncl='(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
            <cfset passed='(PASSED_PIECES-PASSED_AIR_PIECES)'>
            <cfset total='(TOTAL_PIECES-TOTAL_AIR_PIECES)'>
            
            <cfelseif selAir eq 'Y' and selMode eq 'N'>
            <cfset minu4='INCL_AIR_SVC_VAR_MINUS4_CNT'>
            <cfset minu3='INCL_AIR_SVC_VAR_MINUS3_CNT'>
            <cfset minu2='INCL_AIR_SVC_VAR_MINUS2_CNT'>
            <cfset minu1='INCL_AIR_SVC_VAR_MINUS1_CNT'>
            <cfset zeroed='INCL_AIR_SVC_VAR_0_CNT'>
            <cfset plus1='INCL_AIR_SVC_VAR_PLUS1_CNT'>
            <cfset plus2='INCL_AIR_SVC_VAR_PLUS2_CNT'>
            <cfset plus3='INCL_AIR_SVC_VAR_PLUS3_CNT'>
            <cfset plus4='INCL_AIR_SVC_VAR_PLUS4_CNT'>
            <cfset passedIncl='TOT_INCL_PASSED_AIR_PIECE_CNT'>
            <cfset totalIncl='TOTAL_INCL_AIR_PIECE_CNT'>
            <cfset passed='PASSED_AIR_PIECES'>
            <cfset total='TOTAL_AIR_PIECES'>
            
            <cfelse>
            <cfset minu4='INCL_SVC_VAR_MINUS4_CNT'>
            <cfset minu3='INCL_SVC_VAR_MINUS3_CNT'>
            <cfset minu2='INCL_SVC_VAR_MINUS2_CNT'>
            <cfset minu1='INCL_SVC_VAR_MINUS1_CNT'>
            <cfset zeroed='INCL_SVC_VAR_0_CNT'>
            <cfset plus1='INCL_SVC_VAR_PLUS1_CNT'>
            <cfset plus2='INCL_SVC_VAR_PLUS2_CNT'>
            <cfset plus3='INCL_SVC_VAR_PLUS3_CNT'>
            <cfset plus4='INCL_SVC_VAR_PLUS4_CNT'>
            <cfset passedIncl='TOTAL_INCL_PASSED_PIECE_CNT'>
            <cfset totalIncl='TOTAL_INCL_PIECE_CNT'>
            <cfset passed='PASSED_PIECES'>
            <cfset total='TOTAL_PIECES'>
            </cfif>

<!--- zip3 --->
        <cfquery name="dta" datasource="#dsn#">
<!--- zip3 --->        
        

            select  fo.fac_name as orgn_fac_name,
            ORGN_FAC_ZIP_3,
            fd.fac_name as destn_fac_name,            
            destn_fac_zip_3,
            
            sum(#totalIncl#) as TOTAL_pieces,
            sum(#totalIncl#)-sum(#passedIncl#)  as failed_pieces,
            <CFIF selDir is 'O'>fp.orgn_fac_SEQ_ID<cfelse>fp.destn_fac_SEQ_ID</CFIF> as fac_seq_id
            from #rpt_table# fp
            INNER JOIN bi_facility fo
            ON fo.fac_SEQ_ID = fp.orgn_fac_SEQ_ID <!--- <CFIF selDir is 'O'>fp.orgn_fac_SEQ_ID<cfelse>fp.destn_fac_SEQ_ID</CFIF>   --->
            INNER JOIN bi_facility fd
            ON fd.fac_SEQ_ID = fp.destn_fac_SEQ_ID
            inner join 
            (select distinct site_name as area_name,area,district_name,district
            from BI_PLT_AREA_DISTRICT) ad
            on ad.district = <CFIF selDir is 'O'>fp.orgn_district<cfelse>fp.destn_district</CFIF>   
            inner join BI_MSTR_SVC_STD st
            on st.svc_std = fp.svc_std and st.orgn_entered = fp.orgn_entered and st.ml_cl_code = fp.ml_cl_code
            WHERE 
            <cfif selrange is 'WEEK'> 
             ACTUAL_DLVRY_WEEK  = TO_DATE(<cfqueryparam value="#selDate#" cfsqltype="cf_sql_varchar">,'mm-dd-yyyy')
            <cfelseif selrange is 'MON'>  
             ACTUAL_DLVRY_MONTH = TO_DATE(<cfqueryparam value="#selDate#" cfsqltype="cf_sql_varchar">,'mm-dd-yyyy')
            <cfelseif selrange is 'QTR'>  
            ACTUAL_DLVRY_MONTH in (TO_DATE (<cfqueryparam value="#selDate#" cfsqltype="cf_sql_varchar">, 'mm-dd-yyyy'),ADD_MONTHS (TO_DATE ('#selDate#', 'mm-dd-yyyy'),1),ADD_MONTHS (TO_DATE ('#selDate#', 'mm-dd-yyyy'),2))
            </cfif>
             and <CFIF selDir is 'O'>fp.orgn_fac_SEQ_ID<cfelse>fp.destn_fac_SEQ_ID</CFIF> in (#seqlist#)
            <cfif selArea is not '' and selArea is not 'HQ'>and ad.area = <cfqueryparam value="#selArea#" cfsqltype="cf_sql_varchar"> </cfif>            
            <cfif selDistrict is not ''>and ad.district = <cfqueryparam value="#selDistrict#" cfsqltype="cf_sql_varchar"> </cfif>                        
            <cfif selClass is not ''>and fp.ml_cl_code = <cfqueryparam value="#selClass#" cfsqltype="cf_sql_numeric"> </cfif>
            <cfif selCategory is not ''>and fp.ml_cat_code in (<cfqueryparam value="#selCategory#" cfsqltype="cf_sql_numeric" list="yes">)</cfif>
            <cfif selHybStd is not ''>and st.hyb_svc_std = <cfqueryparam value="#selHybStd#" cfsqltype="cf_sql_numeric"></cfif>
            <cfif selFSS is not ''>  and nvl(fp.fss_scan_ind,'N') = <cfqueryparam value="#selFSS#" cfsqltype="cf_sql_varchar"> </cfif>  
            <cfif selCntrLvl is not ''>  and fp.CONTR_LVL_CODE = <cfqueryparam value="#selCntrLvl#" cfsqltype="cf_sql_numeric"> </cfif>  
            <cfif selEod neq ''>and fp.ORGN_ENTERED = <cfqueryparam value="#selEod#" cfsqltype="cf_sql_varchar"></cfif>
            <cfif selCert is not ''> and nvl(fp.certified_mailer_ind,'Y') = <cfqueryparam value="#selCert#" cfsqltype="cf_sql_varchar"> </cfif> 
            <cfif selMode eq 'Y' and selAir neq ''>and EXPECTED_AIR_IND = <cfqueryparam value="#selAir#" cfsqltype="cf_sql_varchar"> </cfif>
			 <cfif selBMEU is 'P' and selDir is 'O'> and   fo.FAC_CAT not in (4,11) and fo.FAC_TYPE not in (1,11)  </cfif>
             <cfif selBMEU is 'D' and selDir is 'O'> and   fo.FAC_CAT in (4,11) and fo.FAC_TYPE  in (1,11)  </cfif>
			 <cfif selBMEU is 'P' and selDir is 'D'> and   fd.FAC_CAT not in (4,11) and fd.FAC_TYPE not in (1,11)  </cfif>
             <cfif selBMEU is 'D' and selDir is 'D'> and   fd.FAC_CAT in (4,11) and fd.FAC_TYPE  in (1,11)  </cfif>
             
            group by  fo.fac_SEQ_ID,fo.fac_name,
            fd.fac_SEQ_ID,fd.fac_name,
           ORGN_FAC_ZIP_3,destn_fac_zip_3,
            fp.orgn_fac_SEQ_ID,fp.destn_fac_SEQ_ID
            having sum(#totalIncl#) > 0
<!---        ) gp--->
        order by failed_pieces desc

</cfquery>
<!--- zip3 --->  
<!---
<cfset ar =arraynew(3)>
<cfloop query="dta">
<cfset ar[1][currentrow][1] = #fac_name#>
<cfset ar[1][currentrow][2] = #area_name#>
<cfset ar[1][currentrow][3] = #district_name#>
<cfset ar[1][currentrow][4] = #total_pieces#>
<cfset ar[1][currentrow][5] = #failed_pieces#>
<cfset ar[1][currentrow][6] = #per_std#>
<cfset ar[1][currentrow][7] = #ORGN_FAC_ZIP_3#>
<cfset ar[1][currentrow][8] = #imb_dlvry_zip_3#>

<cfset ar[2][currentrow][1] = #fac_seq_id#>
<cfset ar[2][currentrow][2] = #area#>
<cfset ar[2][currentrow][3] = #district#>
<cfset ar[2][currentrow][4] = #total_pieces#>
<cfset ar[2][currentrow][5] = #failed_pieces#>
<cfset ar[2][currentrow][6] = #m4#>
<cfset ar[2][currentrow][7] = #m3#>
<cfset ar[2][currentrow][8] = #m2#>
<cfset ar[2][currentrow][9] = #m1#>
<cfset ar[2][currentrow][10] = #p0#>
<cfset ar[2][currentrow][11] = #p1#>
<cfset ar[2][currentrow][12] = #p2#>
<cfset ar[2][currentrow][13] = #p3#>
<cfset ar[2][currentrow][14] = #p4#>
<cfset ar[2][currentrow][15] = #ORGN_FAC_ZIP_3#>
<cfset ar[2][currentrow][16] = #imb_dlvry_zip_3#>


</cfloop>--->
<cfreturn dta>
	</cffunction>




	<cffunction name="getFac" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">    
		<cfargument name="bg_date" type="string" required="yes">                
		<cfargument name="selarea" type="string" required="yes">        
		<cfargument name="seldistrict" type="string" required="yes">
		<cfargument name="selRange" type="string" required="yes">                                
		<cfargument name="selBMEU" type="string" required="yes">                                          


<cfset dt = parsedatetime('#bg_date#')>
<cfif month(dt) gt 9><cfset dt = dateadd('y',1,dt)></cfif>
<cfset wid = dateformat(dt,'yyyymmdd')>
<cfset mid = dateformat(dt,'yyyym')>
<cfif quarter(dt) is 4><cfset q = 1><cfelse><cfset q =  quarter(dt)+1> </cfif> 
<cfset qid = dateformat(dt,'yyyy') & q>

<cfquery name="fac_q" datasource="#dsn#">

<cfif selRange is 'MON'>
select f.fac_seq_id, f.fac_name || ',' || f.phys_state  || 
 case when f.FAC_CAT in (4,11) and f.FAC_TYPE in (1,11) then ' BMEU' else '' end as fac_name
from BIDS_CRITERIA_values_monthly m
inner join bi_facility f
on m.ORGN_FAC_SEQ_ID = f.fac_seq_id
where monthly_id = '#MID#' 
 <cfif selArea is not 'HQ'>and area_id ='#selArea#'</cfif> 
 <cfif selDistrict is not ''>and dist_id ='#selDistrict#'</cfif> 
 <cfif selBMEU is not ''>
 <cfif selBMEU is 'P'> and   f.FAC_CAT not in (4,11) and f.FAC_TYPE not in (1,11)  </cfif>
 <cfif selBMEU is 'D'> and   f.FAC_CAT in (4,11) and f.FAC_TYPE  in (1,11)  </cfif>
 </cfif>
 
group by f.fac_seq_id, f.fac_name,f.phys_state,f.FAC_CAT,f.FAC_TYPE
</cfif>

<cfif selRange is 'QTR'>
select f.fac_seq_id, f.fac_name || ',' || f.phys_state  || 
 case when f.FAC_CAT in (4,11) and f.FAC_TYPE in (1,11) then ' BMEU' else '' end as fac_name
from BIDS_CRITERIA_values_qtrly q
inner join bi_facility f
on q.ORGN_FAC_SEQ_ID = f.fac_seq_id
where qtrly_id = '#QID#'
 <cfif selArea is not 'HQ'>and area_id ='#selArea#'</cfif> 
 <cfif selDistrict is not ''>and dist_id ='#selDistrict#'</cfif> 
 <cfif selBMEU is not ''>
 <cfif selBMEU is 'P'> and   f.FAC_CAT not in (4,11) and f.FAC_TYPE not in (1,11)  </cfif>
 <cfif selBMEU is 'D'> and   f.FAC_CAT in (4,11) and f.FAC_TYPE  in (1,11)  </cfif>
 </cfif>
 
group by f.fac_seq_id, f.fac_name,f.phys_state,f.FAC_CAT,f.FAC_TYPE
</cfif>

<cfif selRange is 'WEEK'>
select f.fac_seq_id, f.fac_name || ',' || f.phys_state || 
 case when f.FAC_CAT in (4,11) and f.FAC_TYPE in (1,11) then ' BMEU' else '' end as fac_name
from BIDS_CRITERIA_values_weekly w
inner join bi_facility f
on w.ORGN_FAC_SEQ_ID = f.fac_seq_id
where week_begin_date = '#WID#'
 <cfif selArea is not 'HQ'>and area_id ='#selArea#'</cfif> 
 <cfif selDistrict is not ''>and dist_id ='#selDistrict#'</cfif> 
 <cfif selBMEU is not ''>
 <cfif selBMEU is 'P'> and   f.FAC_CAT not in (4,11) and f.FAC_TYPE not in (1,11)  </cfif>
 <cfif selBMEU is 'D'> and   f.FAC_CAT in (4,11) and f.FAC_TYPE  in (1,11)  </cfif>
 </cfif>
group by f.fac_seq_id, f.fac_name,f.phys_state,f.FAC_CAT,f.FAC_TYPE
</cfif>
order by fac_name
</cfquery>

 	<cfset ar = arraynew(2)>
    <cfloop query="fac_q">
    <cfset ar[currentrow][1] = #fac_seq_id#>
    <cfset ar[currentrow][2] = #fac_name#>    
    </cfloop>
        
		<cfreturn ar>

	</cffunction>
    

	<cffunction name="getdates" access="remote" returntype="array">
		<cfargument name="dsn" type="string" required="yes">    
		<cfargument name="selrange" type="string" required="yes">                                 			
			<cfif selRange is 'QTR'>
                <cfquery name="wk" datasource="#dsn#">
                SELECT dt as beg_qtr_date,add_months(dt,3)-1 as end_qtr_date,to_char(dt,'mm/dd/yyyy') as strdate
                FROM
                (select (select min(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY)+rownum as dt
                from V_BI_AGG_STC_OD_DAY
                where rownum <= (select max(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY)-(select min(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY))
                where to_char(dt,'MM') IN('01','04','07','10') AND to_char(dt,'DD')  =1
                order by dt desc
                </cfquery>
            </cfif>
            <cfif selRange is 'MON'>
                <cfquery name="wk" datasource="#dsn#">
                SELECT dt as beg_mon_date,add_months(dt,1)-1 as end_mon_date,to_char(dt,'mm/dd/yyyy') as strdate 
                FROM
                (select (select min(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY)+rownum as dt
                from V_BI_AGG_STC_OD_DAY
                where rownum <= (select max(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY)-(select min(START_THE_CLOCK_DATE) from V_BI_AGG_STC_OD_DAY))
                where to_char(dt,'dd')=1
                order by dt desc
                </cfquery>
            </cfif>
			<cfif selRange is 'WEEK'>
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
    <cfloop query="WK">
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





	<cffunction name="getsvisdata" access="remote" returntype="query" returnformat="JSON">
		<cfargument name="dsn" type="string" required="yes">    
		<cfargument name="selDate" type="string" required="yes">                                 			

        <cfquery name="vis_q" datasource="#dsn#">
            select  
            fp.ACTUAL_DLVRY_WEEK,
            fp.ML_CL_CODE,
            fp.ORGN_AREA,
            fp.ORGN_DISTRICT,
            fp.ORGN_FAC_ZIP_3,
            fp.ORGN_FAC_SEQ_ID,
            SUM(fp.TOTAL_INCL_PASSED_PIECE_CNT) AS TOTAL_INCL_PASSED_PIECE_CNT,
            SUM(fp.TOTAL_INCL_PIECE_CNT) AS TOTAL_INCL_PIECE_CNT,
            fp.CERTIFIED_MAILER_IND,
            --CRID,
            fp.ML_CAT_CODE,
            SUM(fp.INCL_SVC_VAR_MINUS4_CNT) AS INCL_SVC_VAR_MINUS4_CNT,
            SUM(fp.INCL_SVC_VAR_MINUS3_CNT) AS INCL_SVC_VAR_MINUS3_CNT,
            SUM(fp.INCL_SVC_VAR_MINUS2_CNT) AS INCL_SVC_VAR_MINUS2_CNT,
            SUM(fp.INCL_SVC_VAR_MINUS1_CNT) AS INCL_SVC_VAR_MINUS1_CNT,
            SUM(fp.INCL_SVC_VAR_0_CNT) AS INCL_SVC_VAR_0_CNT,
            SUM(fp.INCL_SVC_VAR_PLUS1_CNT) AS INCL_SVC_VAR_PLUS1_CNT,
            SUM(fp.INCL_SVC_VAR_PLUS2_CNT) AS INCL_SVC_VAR_PLUS2_CNT,
            SUM(fp.INCL_SVC_VAR_PLUS3_CNT) AS INCL_SVC_VAR_PLUS3_CNT,
            SUM(fp.INCL_SVC_VAR_PLUS4_CNT) AS INCL_SVC_VAR_PLUS4_CNT,
            SUM(fp.INCL_SVC_VAR_NULL_CNT) AS INCL_SVC_VAR_NULL_CNT,
            --fp.CONTR_LVL_CODE,
            fp.FSS_SCAN_IND,
            fp.EXPECTED_AIR_IND,
            st.hyb_svc_std,
            case when f.FAC_CAT in (4,11) and f.FAC_TYPE in (1,11) then 0 else 1 end as Facility_type
   from V_BI_ADD_OD_RPT_WEEK_zip3 fp
    inner join bi_facility f
    on fp.orgn_fac_seq_id = f.fac_seq_id   
    INNER JOIN BI_MSTR_SVC_STD st
    ON     st.svc_std = fp.svc_std
    AND st.orgn_entered = fp.orgn_entered
    AND st.ml_cl_code = fp.ml_cl_code
    where ACTUAL_DLVRY_WEEK = '#selDate#'
    and fp.orgn_area > '-1'
    and fp.orgn_district > '-1'
    
    GROUP BY ACTUAL_DLVRY_WEEK,
    fp.ML_CL_CODE,
    fp.ORGN_AREA,
    fp.ORGN_DISTRICT,
    fp.ORGN_FAC_ZIP_3,
    fp.ORGN_FAC_SEQ_ID,
    fp.CERTIFIED_MAILER_IND,
    --CRID,
    fp.ML_CAT_CODE,
    --fp.CONTR_LVL_CODE,
    fp.FSS_SCAN_IND,
    fp.EXPECTED_AIR_IND,
    st.hyb_svc_std,
    case when f.FAC_CAT in (4,11) and f.FAC_TYPE in (1,11) then 0 else 1 end
    having SUM(fp.TOTAL_INCL_PASSED_PIECE_CNT) >0  

   </cfquery>

  <cfreturn vis_q>
	</cffunction>

	<cffunction name="getsvisfac" access="remote" returntype="query" returnformat="JSON">
		<cfargument name="dsn" type="string" required="yes">    
		<cfargument name="selDate" type="string" required="yes">                                 			
    <cfset dt = right(seldate,4) & mid(seldate,4,2) & left(seldate,2)> 
    <cfquery name="vis_q" datasource="#dsn#">
        select f.fac_seq_id,fac_name
        from
        (
        select orgn_fac_seq_id as fac_seq_id from BIDS_CRITERIA_VALUES_QTRLY
        union
        select destn_fac_seq_id as fac_seq_id from BIDS_CRITERIA_VALUES_QTRLY
        ) a
        inner join bi_facility f
        on a.fac_seq_id = f.fac_seq_id     </cfquery>
  <cfreturn vis_q>
	</cffunction>







</cfcomponent>