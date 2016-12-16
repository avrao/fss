<cfcomponent>



<cfset day_table = 'V_BI_ADD_OD_RPT_day_ZIP3'>
<cfset week_table = 'V_BI_ADD_OD_RPT_WEEK_ZIP3'>
<cfset month_table = 'V_BI_ADD_OD_RPT_MONTH_ZIP3'>
<cfset quarter_table = 'V_BI_ADD_OD_RPT_QTR_ZIP3'>


<!---
<cfset day_table = 'V_BI_ADD_OD_RPT_day_job'>
<cfset week_table = 'V_BI_ADD_OD_RPT_WEEK_job'>
<cfset month_table = 'V_BI_ADD_OD_RPT_MONTH_job'>
<cfset quarter_table = 'V_BI_ADD_OD_RPT_QTR_job'>
--->


	<cffunction name="getByDOW" access="remote" returntype="array">
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
        <cfargument name="selMlrFlg" type="string" required="yes">                                                                       
        <cfargument name="selIndvDay" type="string" required="yes">                                                                               

       <cfif sortby is "1">
        <cfset sval = 'ad.AREA_id'> <cfset sdesc = 'ad.AREA_name'>  <cfset gval = 'ad.AREA_id'> <cfset gdesc = 'ad.AREA_name'>               
       <cfelseif sortby is "2">
        <cfset sval = 'ad.district_id'> <cfset sdesc = 'ad.district_name'><cfset gval = 'ad.district_id'> <cfset gdesc = 'ad.district_name'>
       <cfelseif sortby is "3">
		<cfset sval = 'a.fac_seq_id'><cfset sdesc = 'a.fac_name'><cfset gval = 'a.fac_seq_id'><cfset gdesc = 'a.fac_name'>        
       <cfelseif sortby is "4">
		<cfset sval = 's.state_abbr'><cfset sdesc = 's.state_name'><cfset gval = 's.state_abbr'><cfset gdesc = 's.state_name'>         
       <cfelseif sortby is "5">
		<cfset sval = 'b.crid'><cfset sdesc = 'b.mlr_name'><cfset gval = 'b.crid'><cfset gdesc = 'b.mlr_name'>     
       <cfelseif sortby is "6">
		<cfset sval = 'fp.orgn_entered'><cfset sdesc = "decode(fp.orgn_entered,'Y','ORIGIN','N','DESTINATION')"><cfset gval = 'fp.orgn_entered'><cfset gdesc = 'fp.orgn_entered'>
       <cfelseif sortby is "7">
		<cfset sval = 'bc.code_val'> <cfset sdesc = "upper(bc.code_desc_long)">		<cfset gval = 'bc.code_val'> <cfset gdesc = "bc.code_desc_long">                
       <cfelseif sortby is "8">
		<cfset sval = 'fp.ml_cl_code'> <cfset sdesc = "decode(fp.ml_cl_code,1,'FIRST CLASS',2,'PERIODICALS',3,'STANDARD','OTHER')">	<cfset gval = 'fp.ml_cl_code'> <cfset gdesc = "fp.ml_cl_code">                
       <cfelseif sortby is "9">
		<cfset sval = 'fp.ml_cat_code'> <cfset sdesc = "decode(fp.ml_cat_code,1,'LETTERS',2,'FLATS',3,'CARDS','OTHER')">	<cfset gval = 'fp.ml_cat_code'> <cfset gdesc = "fp.ml_cat_code">                
       <cfelseif sortby is "10">
		<cfset sval = 'st.hyb_svc_std'> <cfset sdesc = "upper(st.HYB_SVC_STD_DESC)">	<cfset gval = 'st.hyb_svc_std'> <cfset gdesc = "st.HYB_SVC_STD_DESC">                
       <cfelseif sortby is "11">
		<cfset sval = "nvl(fp.expected_air_ind,'N')"> <cfset sdesc = "decode(nvl(fp.expected_air_ind,'N'),'N','SURFACE','Y','AIR')">	<cfset gval = "nvl(fp.expected_air_ind,'N')"> <cfset gdesc = "nvl(fp.expected_air_ind,'N')">
       <cfelseif sortby is "12">
		<cfset sval = "nvl(fp.fss_scan_ind,'N')"> <cfset sdesc = "decode(nvl(fp.fss_scan_ind,'N'),'N','NON_FSS','Y','FSS')">	<cfset gval = "nvl(fp.fss_scan_ind,'N')"> <cfset gdesc = "nvl(fp.fss_scan_ind,'N')">
       <cfelseif sortby is "13">
		<cfset sval = "IMB_DLVRY_ZIP_3"> <cfset sdesc = "IMB_DLVRY_ZIP_3 || '-' || destfac.plt_fac_name">	<cfset gval = "IMB_DLVRY_ZIP_3"> <cfset gdesc = "IMB_DLVRY_ZIP_3 || '-' || destfac.plt_fac_name">
       <cfelseif sortby is "14">
		<cfset sval = "fp.political_mail_ind"> <cfset sdesc = "decode(fp.political_mail_ind,'Y','POLITICAL','N','NON-POLITICAL')">	<cfset gval = "fp.political_mail_ind"> <cfset gdesc = "fp.political_mail_ind">
       <cfelseif sortby is "15">
		<cfset sval = "fp.EPFED_FAC_TYPE_CONSLN_CODE"> <cfset sdesc = "con.epfed_consln_short_desc">	<cfset gval = "fp.EPFED_FAC_TYPE_CONSLN_CODE"> <cfset gdesc = "con.epfed_consln_short_desc">
       <cfelseif sortby is "16">
		<cfset sval = "fp.INDCTN_MTHD"> <cfset sdesc = "nvl(cv.code_desc,fp.INDCTN_MTHD)">	<cfset gval = "fp.INDCTN_MTHD"> <cfset gdesc = "nvl(cv.code_desc,fp.INDCTN_MTHD)">
       <cfelseif sortby is "17">
		<cfset sval = "to_char(fp.actual_dlvry_date,'d')"> <cfset sdesc = "to_char(fp.actual_dlvry_date,'DAY')">	<cfset gval = "fp.actual_dlvry_date"> <cfset gdesc = "fp.actual_dlvry_date">
       <cfelseif sortby is "18">
		<cfset sval = "to_char(fp.actual_dlvry_date,'dd-mon-yyyy')"> <cfset sdesc = "to_char(fp.actual_dlvry_date,'DY mm/dd/yyyy')">	<cfset gval = "fp.actual_dlvry_date"> <cfset gdesc = "fp.actual_dlvry_date">
       <cfelseif sortby is "19">
		<cfset sval = "'OverAll'"> <cfset sdesc = "'OverAll'">	<cfset gval = ""> <cfset gdesc = "">

       </cfif>        





		<cfif selAir is 'Y' and selMode eq 'N'>
		 <cfset piece_cnt = 'TOTAL_INCL_AIR_PIECE_CNT'>
		 <cfset fail_piece_cnt = '(TOTAL_INCL_AIR_PIECE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelseif selAir is 'N' and selMode eq 'N'>
		  <cfset piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_AIR_PIECE_CNT)'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)-(TOTAL_INCL_AIR_PIE1CE_CNT-TOT_INCL_PASSED_AIR_PIECE_CNT)'>
		<cfelse>
		  <cfset piece_cnt = 'TOTAL_INCL_PIECE_CNT'>
		  <cfset fail_piece_cnt = '(TOTAL_INCL_PIECE_CNT-TOTAL_INCL_PASSED_PIECE_CNT)'>
		</cfif>


		
		<cfquery name="dta#sortby#" datasource="#dsn#" blockfactor="100">
        <cfif sortby is 100>x</cfif>
         with AREADISTNAME as (
             select /*+ result_cache */ area_id as area_id,area_name,district_id as district_id,district_name 
             from  areadistname_t
             where area_id not in ('4M','4N')
			)  
        ,dtable as
        (select to_date('#bg_date#','mm/dd/yyyy') + level -1 as dt, to_char(to_date('#bg_date#','mm/dd/yyyy') + level -1, 'd') as dtc
        from dual
        connect by to_date('#bg_date#','mm/dd/yyyy') + level -1 < 
		<cfif selRange is 'WEEK'>to_date('#bg_date#','mm/dd/yyyy')+7
        <cfelseif selRange is 'Mon'>
        add_months(to_date('#bg_date#','mm/dd/yyyy'),1)
        <cfelseif selRange is 'Qtr'>
        add_months(to_date('#bg_date#','mm/dd/yyyy'),3)
        <cfelse>
           to_date('#bg_date#','mm/dd/yyyy')+1
        </cfif> 
        )
        ,ddays as
        (select /*+ result_cache */ to_date('#bg_date#','mm/dd/yyyy') + level -1 as dt, to_char(to_date('#bg_date#','mm/dd/yyyy') + level -1, 'd') as dtc
        from dual
		<cfif sortby neq '18' and selIndvDay neq ''>where to_date('#bg_date#','mm/dd/yyyy') + level -1 in (#Replace(selIndvDay,"''","'","All")#)</cfif>                    
        connect by to_date('#bg_date#','mm/dd/yyyy') + level -1 < 
		<cfif selRange is 'WEEK'>to_date('#bg_date#','mm/dd/yyyy')+7
        <cfelseif selRange is 'Mon'>
        add_months(to_date('#bg_date#','mm/dd/yyyy'),1)
        <cfelseif selRange is 'Qtr'>
        add_months(to_date('#bg_date#','mm/dd/yyyy'),3)
        <cfelse>
           to_date('#bg_date#','mm/dd/yyyy')+1
        </cfif> 
        )

	,bi_fac as 
        ( select /*+ result_cache */ fac_seq_id,fac_name,dist_id,phys_state
          from bi_facility
         )     
        
        
        
             
<!---  /*+ PQ_CONCURRENT_UNION */ ---->
<!---  /*+ parallel(7)  */---->

select /*+ parallel 7  */
                   LOOKUP_VALUE,
                  substr(LOOKUP_DESCRIP,1,38) as LOOKUP_DESCRIP,
                   SUM (tp_tot) AS tp_tot,
                   SUM (fp_tot)
                      AS fp_tot,
                   DECODE (
                      SUM (tp_tot),
                      0, 0,
                      (SUM (tp_tot)-SUM (fp_tot))
                      / SUM (tp_tot))
                      AS PER_tot
 from
(

<!---top--->
			SELECT gp.*
			FROM (  SELECT
			#preservesinglequotes(sval)# as LOOKUP_VALUE,#preservesinglequotes(sdesc)# as LOOKUP_DESCRIP,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            #day_table# fp            
			LEFT JOIN bi_fac a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered =fp.orgn_entered and st.ml_cl_code = fp.ml_cl_code
           <cfif sortby is "4">
               inner join 
                <!---state_t---> 
                (
                select distinct state_name,abbr_state_name as state_abbr
                 from IV_APP.ZIP3_STATE_MAP
                ) s
               on <cfif selDir is 'O'>a.phys_state<cfelse>fp.mailg_state </cfif> = s.state_abbr 
          </cfif>
		<cfif sortby is "5">
            inner join 
            bi_opsvis_crid b
            ON fp.CRID = b.CRID
        </cfif>
		<cfif sortby is "7">        
            inner join iv_app.bi_code_value bc
            on bc.CODE_TYPE_NAME ='CONTR_LVL_CODE'
            and fp.CONTR_LVL_CODE = bc.code_val 
        </cfif>
		<cfif sortby is "13">        
                  INNER JOIN bi_plt_area_district destfac
                  ON destfac.plt_fac_zip_3 = fp.IMB_DLVRY_ZIP_3
                  and destfac.district =  fp.destn_district
        </cfif>
		<cfif sortby is "15">        
              left join iv_app.V_MSTR_LU_EPFED_CONSLN con
              on fp.EPFED_FAC_TYPE_CONSLN_CODE = con.EPFED_FAC_TYPE_CONSLN_CODE          
        </cfif>
		<cfif sortby is "16">        
            left JOIN  iv_app.bi_code_value cv
                  ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
        </cfif>
        
			WHERE 
            (exists             ( select dt 
               from dtable  
               where dtable.dt = fp.actual_dlvry_DATE
              and dtc=1
            ))                  

            <cfif selState neq '' and sortby neq '4'><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
            <cfif selInduct neq '' and sortby neq '16'>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq '' and sortby neq '15'>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq ''  and sortby neq '14'>and fp.political_mail_ind in (#Replace(selPol,"''","'","All")#) </cfif>
			<cfif sortby neq '17'><cfif selDOW neq ''>and to_char(actual_dlvry_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif></cfif>
<!---			<cfif sortby neq '18' and selIndvDay neq ''>and actual_dlvry_date in (#Replace(selIndvDay,"''","'","All")#)</cfif> --->           
			<cfif sortby neq '18' and selIndvDay neq ''>and actual_dlvry_date in (select dt from ddays)</cfif>                        
            <cfif sortby gt 1><cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif> </cfif>
            <cfif sortby gt 2><cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif> </cfif>            
            <cfif sortby gt 3><cfif selFacility neq ''>and a.fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif> </cfif>                        
			<cfif selClass neq '' and sortby neq '8' >and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq '' and sortby neq '9'>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq '' and sortby neq '10'>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not '' and sortby neq '12'>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq '' and sortby neq '11'>and fp.EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''  and sortby neq '7'>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
            <cfif selEod is not '' and sortby neq '6'>  and fp.orgn_entered in(#Replace(selEOD,"''","'","All")#) </cfif>  
<!---			<cfif selEod neq ''><cfif selEod eq 'Y'>and fp.epfed_fac_type_code IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif>
			<cfif selEod eq 'N'>and fp.epfed_fac_type_code not IN (7, 11, 16, 17, 18, 19, 20, 22)</cfif></cfif>--->
			<cfif sortby neq '5' or selMlrFlg is 'Y'><cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif></cfif>
            <cfif selImbZip3 is not '' and sortby neq '13'>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
            <cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              
			<cfif sortby neq '19'>group by #preservesinglequotes(gval)#,#preservesinglequotes(gdesc)#</cfif>
			) gp
<!---bottom--->            

<!---top--->
union all
			SELECT gp.*
			FROM (  SELECT
			#preservesinglequotes(sval)# as LOOKUP_VALUE,#preservesinglequotes(sdesc)# as LOOKUP_DESCRIP,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            #day_table# fp            
			LEFT JOIN bi_fac a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id             
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered =fp.orgn_entered and st.ml_cl_code = fp.ml_cl_code
           <cfif sortby is "4">
               inner join 
                <!---state_t---> 
                (
                select distinct state_name,abbr_state_name as state_abbr
                 from IV_APP.ZIP3_STATE_MAP
                ) s
               on <cfif selDir is 'O'>a.phys_state<cfelse>fp.mailg_state </cfif> = s.state_abbr 
          </cfif>

		<cfif sortby is "5">
            inner join 
            bi_opsvis_crid b
            ON fp.CRID = b.CRID
        </cfif>
		<cfif sortby is "7">        
            inner join iv_app.bi_code_value bc
            on bc.CODE_TYPE_NAME ='CONTR_LVL_CODE'
            and fp.CONTR_LVL_CODE = bc.code_val 
        </cfif>
		<cfif sortby is "13">        
                  INNER JOIN bi_plt_area_district destfac
                  ON destfac.plt_fac_zip_3 = fp.IMB_DLVRY_ZIP_3
                  and destfac.district =  fp.destn_district
        </cfif>
		<cfif sortby is "15">        
              left join iv_app.V_MSTR_LU_EPFED_CONSLN con
              on fp.EPFED_FAC_TYPE_CONSLN_CODE = con.EPFED_FAC_TYPE_CONSLN_CODE          
        </cfif>
		<cfif sortby is "16">        
            left JOIN  iv_app.bi_code_value cv
                  ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
        </cfif>
                  
          
			WHERE 
            (exists             ( select dt 
               from dtable  
               where dtable.dt = fp.actual_dlvry_DATE
               and dtc=2 
            ))                  

            <cfif selState neq '' and sortby neq '4'><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
            <cfif selInduct neq '' and sortby neq '16'>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq '' and sortby neq '15'>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq ''  and sortby neq '14'>and fp.political_mail_ind in (#Replace(selPol,"''","'","All")#) </cfif>
			<cfif sortby neq '17'><cfif selDOW neq ''>and to_char(actual_dlvry_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif></cfif>
			<cfif sortby neq '18' and selIndvDay neq ''>and actual_dlvry_date in (select dt from ddays)</cfif>                        
            <cfif sortby gt 1><cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif> </cfif>
            <cfif sortby gt 2><cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif> </cfif>            
            <cfif sortby gt 3><cfif selFacility neq ''>and a.fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif> </cfif>                        
			<cfif selClass neq '' and sortby neq '8' >and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq '' and sortby neq '9'>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq '' and sortby neq '10'>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not '' and sortby neq '12'>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq '' and sortby neq '11'>and fp.EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''  and sortby neq '7'>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
            <cfif selEod is not '' and sortby neq '6'>  and fp.orgn_entered in(#Replace(selEOD,"''","'","All")#) </cfif>  			
			<cfif sortby neq '5' or selMlrFlg is 'Y'><cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif></cfif>
            <cfif selImbZip3 is not '' and sortby neq '13'>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
            <cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              

			<cfif sortby neq '19'>group by #preservesinglequotes(gval)#,#preservesinglequotes(gdesc)#</cfif>
			) gp
<!---bottom--->
<!---top--->
union all
			SELECT gp.*
			FROM (  SELECT
			#preservesinglequotes(sval)# as LOOKUP_VALUE,#preservesinglequotes(sdesc)# as LOOKUP_DESCRIP,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            #day_table# fp            
			LEFT JOIN bi_fac a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered =fp.orgn_entered and st.ml_cl_code = fp.ml_cl_code
           <cfif sortby is "4">
               inner join 
                <!---state_t---> 
                (
                select distinct state_name,abbr_state_name as state_abbr
                 from IV_APP.ZIP3_STATE_MAP
                ) s
               on <cfif selDir is 'O'>a.phys_state<cfelse>fp.mailg_state </cfif> = s.state_abbr 
          </cfif>

		<cfif sortby is "5">
            inner join 
            bi_opsvis_crid b
            ON fp.CRID = b.CRID
        </cfif>
		<cfif sortby is "7">        
            inner join iv_app.bi_code_value bc
            on bc.CODE_TYPE_NAME ='CONTR_LVL_CODE'
            and fp.CONTR_LVL_CODE = bc.code_val 
        </cfif>
		<cfif sortby is "13">        
                  INNER JOIN bi_plt_area_district destfac
                  ON destfac.plt_fac_zip_3 = fp.IMB_DLVRY_ZIP_3
                  and destfac.district =  fp.destn_district
        </cfif>
		<cfif sortby is "15">        
              left join iv_app.V_MSTR_LU_EPFED_CONSLN con
              on fp.EPFED_FAC_TYPE_CONSLN_CODE = con.EPFED_FAC_TYPE_CONSLN_CODE          
        </cfif>
		<cfif sortby is "16">        
            left JOIN  iv_app.bi_code_value cv
                  ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
        </cfif>
                  
          
			WHERE 
            (exists             ( select dt 
               from dtable  
               where dtable.dt = fp.actual_dlvry_DATE
               and dtc=3 
            ))                  

            <cfif selState neq '' and sortby neq '4'><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
            <cfif selInduct neq '' and sortby neq '16'>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq '' and sortby neq '15'>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq ''  and sortby neq '14'>and fp.political_mail_ind in (#Replace(selPol,"''","'","All")#) </cfif>
			<cfif sortby neq '17'><cfif selDOW neq ''>and to_char(actual_dlvry_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif></cfif>
			<cfif sortby neq '18' and selIndvDay neq ''>and actual_dlvry_date in (select dt from ddays)</cfif>                        
            <cfif sortby gt 1><cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif> </cfif>
            <cfif sortby gt 2><cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif> </cfif>            
            <cfif sortby gt 3><cfif selFacility neq ''>and a.fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif> </cfif>                        
			<cfif selClass neq '' and sortby neq '8' >and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq '' and sortby neq '9'>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq '' and sortby neq '10'>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not '' and sortby neq '12'>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq '' and sortby neq '11'>and fp.EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''  and sortby neq '7'>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
            <cfif selEod is not '' and sortby neq '6'>  and fp.orgn_entered in(#Replace(selEOD,"''","'","All")#) </cfif>  			
			<cfif sortby neq '5' or selMlrFlg is 'Y'><cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif></cfif>
            <cfif selImbZip3 is not '' and sortby neq '13'>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
            <cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              

			<cfif sortby neq '19'>group by #preservesinglequotes(gval)#,#preservesinglequotes(gdesc)#</cfif>
			) gp
<!---bottom--->            
<!---top--->
union all
			SELECT gp.*
			FROM (  SELECT
			#preservesinglequotes(sval)# as LOOKUP_VALUE,#preservesinglequotes(sdesc)# as LOOKUP_DESCRIP,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            #day_table# fp            
			LEFT JOIN bi_fac a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered =fp.orgn_entered and st.ml_cl_code = fp.ml_cl_code
           <cfif sortby is "4">
               inner join 
                <!---state_t---> 
                (
                select distinct state_name,abbr_state_name as state_abbr
                 from IV_APP.ZIP3_STATE_MAP
                ) s
               on <cfif selDir is 'O'>a.phys_state<cfelse>fp.mailg_state </cfif> = s.state_abbr 
          </cfif>

		<cfif sortby is "5">
            inner join 
            bi_opsvis_crid b
            ON fp.CRID = b.CRID
        </cfif>
		<cfif sortby is "7">        
            inner join iv_app.bi_code_value bc
            on bc.CODE_TYPE_NAME ='CONTR_LVL_CODE'
            and fp.CONTR_LVL_CODE = bc.code_val 
        </cfif>
		<cfif sortby is "13">        
                  INNER JOIN bi_plt_area_district destfac
                  ON destfac.plt_fac_zip_3 = fp.IMB_DLVRY_ZIP_3
                  and destfac.district =  fp.destn_district
        </cfif>
		<cfif sortby is "15">        
              left join iv_app.V_MSTR_LU_EPFED_CONSLN con
              on fp.EPFED_FAC_TYPE_CONSLN_CODE = con.EPFED_FAC_TYPE_CONSLN_CODE          
        </cfif>
		<cfif sortby is "16">        
            left JOIN  iv_app.bi_code_value cv
                  ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
        </cfif>
                  
          
			WHERE 
            (exists             ( select dt 
               from dtable  
               where dtable.dt = fp.actual_dlvry_DATE
               and dtc=4
            ))                  

            <cfif selState neq '' and sortby neq '4'><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
            <cfif selInduct neq '' and sortby neq '16'>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq '' and sortby neq '15'>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq ''  and sortby neq '14'>and fp.political_mail_ind in (#Replace(selPol,"''","'","All")#) </cfif>
			<cfif sortby neq '17'><cfif selDOW neq ''>and to_char(actual_dlvry_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif></cfif>
			<cfif sortby neq '18' and selIndvDay neq ''>and actual_dlvry_date in (select dt from ddays)</cfif>                        
            <cfif sortby gt 1><cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif> </cfif>
            <cfif sortby gt 2><cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif> </cfif>            
            <cfif sortby gt 3><cfif selFacility neq ''>and a.fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif> </cfif>                        
			<cfif selClass neq '' and sortby neq '8' >and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq '' and sortby neq '9'>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq '' and sortby neq '10'>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not '' and sortby neq '12'>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq '' and sortby neq '11'>and fp.EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''  and sortby neq '7'>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
            <cfif selEod is not '' and sortby neq '6'>  and fp.orgn_entered in(#Replace(selEOD,"''","'","All")#) </cfif>  			
			<cfif sortby neq '5' or selMlrFlg is 'Y'><cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif></cfif>
            <cfif selImbZip3 is not '' and sortby neq '13'>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
            <cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              

			<cfif sortby neq '19'>group by #preservesinglequotes(gval)#,#preservesinglequotes(gdesc)#</cfif>
			) gp
<!---bottom--->            
<!---top--->
union all
			SELECT gp.*
			FROM (  SELECT
			#preservesinglequotes(sval)# as LOOKUP_VALUE,#preservesinglequotes(sdesc)# as LOOKUP_DESCRIP,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            #day_table# fp            
			LEFT JOIN bi_fac a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered =fp.orgn_entered and st.ml_cl_code = fp.ml_cl_code
           <cfif sortby is "4">
               inner join 
                <!---state_t---> 
                (
                select distinct state_name,abbr_state_name as state_abbr
                 from IV_APP.ZIP3_STATE_MAP
                ) s
               on <cfif selDir is 'O'>a.phys_state<cfelse>fp.mailg_state </cfif> = s.state_abbr 
          </cfif>

		<cfif sortby is "5">
            inner join 
            bi_opsvis_crid b
            ON fp.CRID = b.CRID
        </cfif>
		<cfif sortby is "7">        
            inner join iv_app.bi_code_value bc
            on bc.CODE_TYPE_NAME ='CONTR_LVL_CODE'
            and fp.CONTR_LVL_CODE = bc.code_val 
        </cfif>
		<cfif sortby is "13">        
                  INNER JOIN bi_plt_area_district destfac
                  ON destfac.plt_fac_zip_3 = fp.IMB_DLVRY_ZIP_3
                  and destfac.district =  fp.destn_district
        </cfif>
		<cfif sortby is "15">        
              left join iv_app.V_MSTR_LU_EPFED_CONSLN con
              on fp.EPFED_FAC_TYPE_CONSLN_CODE = con.EPFED_FAC_TYPE_CONSLN_CODE          
        </cfif>
		<cfif sortby is "16">        
            left JOIN  iv_app.bi_code_value cv
                  ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
        </cfif>
                  
          
			WHERE 
            (exists             ( select dt 
               from dtable  
               where dtable.dt = fp.actual_dlvry_DATE
               and dtc=5 
            ))                  

            <cfif selState neq '' and sortby neq '4'><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
            <cfif selInduct neq '' and sortby neq '16'>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq '' and sortby neq '15'>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq ''  and sortby neq '14'>and fp.political_mail_ind in (#Replace(selPol,"''","'","All")#) </cfif>
			<cfif sortby neq '17'><cfif selDOW neq ''>and to_char(actual_dlvry_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif></cfif>
			<cfif sortby neq '18' and selIndvDay neq ''>and actual_dlvry_date in (select dt from ddays)</cfif>                        
            <cfif sortby gt 1><cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif> </cfif>
            <cfif sortby gt 2><cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif> </cfif>            
            <cfif sortby gt 3><cfif selFacility neq ''>and a.fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif> </cfif>                        
			<cfif selClass neq '' and sortby neq '8' >and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq '' and sortby neq '9'>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq '' and sortby neq '10'>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not '' and sortby neq '12'>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq '' and sortby neq '11'>and fp.EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''  and sortby neq '7'>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
            <cfif selEod is not '' and sortby neq '6'>  and fp.orgn_entered in(#Replace(selEOD,"''","'","All")#) </cfif>  			
			<cfif sortby neq '5' or selMlrFlg is 'Y'><cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif></cfif>
            <cfif selImbZip3 is not '' and sortby neq '13'>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
            <cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              

			<cfif sortby neq '19'>group by #preservesinglequotes(gval)#,#preservesinglequotes(gdesc)#</cfif>
			) gp
<!---bottom--->            
<!---top--->
union all
			SELECT gp.*
			FROM (  SELECT
			#preservesinglequotes(sval)# as LOOKUP_VALUE,#preservesinglequotes(sdesc)# as LOOKUP_DESCRIP,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            #day_table# fp            
			LEFT JOIN bi_fac a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered =fp.orgn_entered and st.ml_cl_code = fp.ml_cl_code
           <cfif sortby is "4">
               inner join 
                <!---state_t---> 
                (
                select distinct state_name,abbr_state_name as state_abbr
                 from IV_APP.ZIP3_STATE_MAP
                ) s
               on <cfif selDir is 'O'>a.phys_state<cfelse>fp.mailg_state </cfif> = s.state_abbr 
          </cfif>

		<cfif sortby is "5">
            inner join 
            bi_opsvis_crid b
            ON fp.CRID = b.CRID
        </cfif>
		<cfif sortby is "7">        
            inner join iv_app.bi_code_value bc
            on bc.CODE_TYPE_NAME ='CONTR_LVL_CODE'
            and fp.CONTR_LVL_CODE = bc.code_val 
        </cfif>
		<cfif sortby is "13">        
                  INNER JOIN bi_plt_area_district destfac
                  ON destfac.plt_fac_zip_3 = fp.IMB_DLVRY_ZIP_3
                  and destfac.district =  fp.destn_district
        </cfif>
		<cfif sortby is "15">        
              left join iv_app.V_MSTR_LU_EPFED_CONSLN con
              on fp.EPFED_FAC_TYPE_CONSLN_CODE = con.EPFED_FAC_TYPE_CONSLN_CODE          
        </cfif>
		<cfif sortby is "16">        
            left JOIN  iv_app.bi_code_value cv
                  ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
        </cfif>
                  
          
			WHERE 
            (exists             ( select dt 
               from dtable  
               where dtable.dt = fp.actual_dlvry_DATE
               and dtc=6 
            ))                  

            <cfif selState neq '' and sortby neq '4'><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
            <cfif selInduct neq '' and sortby neq '16'>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq '' and sortby neq '15'>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq ''  and sortby neq '14'>and fp.political_mail_ind in (#Replace(selPol,"''","'","All")#) </cfif>
			<cfif sortby neq '17'><cfif selDOW neq ''>and to_char(actual_dlvry_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif></cfif>
			<cfif sortby neq '18' and selIndvDay neq ''>and actual_dlvry_date in (select dt from ddays)</cfif>                        
            <cfif sortby gt 1><cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif> </cfif>
            <cfif sortby gt 2><cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif> </cfif>            
            <cfif sortby gt 3><cfif selFacility neq ''>and a.fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif> </cfif>                        
			<cfif selClass neq '' and sortby neq '8' >and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq '' and sortby neq '9'>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq '' and sortby neq '10'>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not '' and sortby neq '12'>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq '' and sortby neq '11'>and fp.EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''  and sortby neq '7'>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
            <cfif selEod is not '' and sortby neq '6'>  and fp.orgn_entered in(#Replace(selEOD,"''","'","All")#) </cfif>  			
			<cfif sortby neq '5' or selMlrFlg is 'Y'><cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif></cfif>
            <cfif selImbZip3 is not '' and sortby neq '13'>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
            <cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              

			<cfif sortby neq '19'>group by #preservesinglequotes(gval)#,#preservesinglequotes(gdesc)#</cfif>
			) gp
<!---bottom--->            
<!---top--->
union all
			SELECT gp.*
			FROM (  SELECT
			#preservesinglequotes(sval)# as LOOKUP_VALUE,#preservesinglequotes(sdesc)# as LOOKUP_DESCRIP,
			sum(#piece_cnt#) as tp_tot,
			sum(#fail_piece_cnt#) as fp_tot,
            decode(sum(#piece_cnt#),0,0, 
			sum(#piece_cnt#-#fail_piece_cnt#) 
			/ sum(#piece_cnt#))   
			AS PER_tot
			FROM  
            #day_table# fp            
			LEFT JOIN bi_fac a
			ON a.fac_SEQ_ID = 
			<cfif selDir is 'O'>  fp.orgn_fac_seq_id <cfelse> fp.destn_fac_seq_id </cfif>
			inner join
			AREADISTNAME ad
			on a.dist_id = ad.district_id 
			inner join BI_MSTR_SVC_STD st
			on st.svc_std = fp.svc_std  and st.orgn_entered =fp.orgn_entered and st.ml_cl_code = fp.ml_cl_code
           <cfif sortby is "4">
               inner join 
                <!---state_t---> 
                (
                select distinct state_name,abbr_state_name as state_abbr
                 from IV_APP.ZIP3_STATE_MAP
                ) s
               on <cfif selDir is 'O'>a.phys_state<cfelse>fp.mailg_state </cfif> = s.state_abbr 
          </cfif>
		<cfif sortby is "5">
            inner join 
            bi_opsvis_crid b
            ON fp.CRID = b.CRID
        </cfif>
		<cfif sortby is "7">        
            inner join iv_app.bi_code_value bc
            on bc.CODE_TYPE_NAME ='CONTR_LVL_CODE'
            and fp.CONTR_LVL_CODE = bc.code_val 
        </cfif>
		<cfif sortby is "13">        
                  INNER JOIN bi_plt_area_district destfac
                  ON destfac.plt_fac_zip_3 = fp.IMB_DLVRY_ZIP_3
                  and destfac.district =  fp.destn_district
        </cfif>
		<cfif sortby is "15">        
              left join iv_app.V_MSTR_LU_EPFED_CONSLN con
              on fp.EPFED_FAC_TYPE_CONSLN_CODE = con.EPFED_FAC_TYPE_CONSLN_CODE          
        </cfif>
		<cfif sortby is "16">        
            left JOIN  iv_app.bi_code_value cv
                  ON cv.code_type_name = 'INDCTN_MTHD'   AND cv.code_val = fp.INDCTN_MTHD
        </cfif>
                  
          
			WHERE 
            (exists 
            ( select dt 
               from dtable  
               where dtable.dt = fp.actual_dlvry_DATE
               and dtc=7
            ))                  

            <cfif selState neq '' and sortby neq '4'><cfif selDir is 'O'> and a.phys_state in (#Replace(SelState,"''","'","All")#) <cfelse> and fp.mailg_state in (#Replace(SelState,"''","'","All")#)</cfif></cfif>
            <cfif selInduct neq '' and sortby neq '16'>and fp.INDCTN_MTHD in (#Replace(SelInduct,"''","'","All")#)</cfif>
            <cfif selEntType neq '' and sortby neq '15'>and fp.EPFED_FAC_TYPE_CONSLN_CODE in (#Replace(selEntType,"''","'","All")#)</cfif>
            <cfif selPol neq ''  and sortby neq '14'>and fp.political_mail_ind in (#Replace(selPol,"''","'","All")#) </cfif>
  		    <cfif sortby neq '17'><cfif selDOW neq ''>and to_char(actual_dlvry_date,'d') in (#Replace(selDOW,"''","'","All")#)</cfif></cfif>
   			<cfif sortby neq '18' and selIndvDay neq ''>and actual_dlvry_date in (select dt from ddays)</cfif>                        
            <cfif sortby gt 1><cfif selArea neq ''>and ad.area_id in (#Replace(selArea,"''","'","All")#)</cfif> </cfif>
            <cfif sortby gt 2><cfif selDistrict neq ''>and ad.district_id in (#Replace(selDistrict,"''","'","All")#)</cfif> </cfif>            
            <cfif sortby gt 3><cfif selFacility neq ''>and a.fac_seq_id in (#Replace(selFacility,"''","'","All")#)</cfif> </cfif>                        
			<cfif selClass neq '' and sortby neq '8' >and fp.ml_cl_code in (#Replace(selClass,"''","'","All")#)</cfif>
			<cfif selCategory neq '' and sortby neq '9'>and fp.ml_cat_code in (#Replace(selCategory,"''","'","All")#)</cfif>
			<cfif selHybStd neq '' and sortby neq '10'>and st.hyb_svc_std in (#Replace(selHybStd,"''","'","All")#)</cfif>
			<cfif selFSS is not '' and sortby neq '12'>  and nvl(fp.fss_scan_ind,'N') in (#Replace(selFSS,"''","'","All")#) </cfif>  
			<cfif selMode eq 'Y' and selAir neq '' and sortby neq '11'>and fp.EXPECTED_AIR_IND in (#Replace(selAir,"''","'","All")#)</cfif>
			<cfif selCntrLvl is not ''  and sortby neq '7'>  and fp.CONTR_LVL_CODE in(#Replace(selCntrLvl,"''","'","All")#) </cfif>  
            <cfif selEod is not '' and sortby neq '6'>  and fp.orgn_entered in(#Replace(selEOD,"''","'","All")#) </cfif>  			
			<cfif sortby neq '5' or selMlrFlg is 'Y'><cfif selMailer is not ''>  and fp.crid in(#Replace(selMailer,"''","'","All")#) </cfif></cfif>
            <cfif selImbZip3 is not '' and sortby neq '13'>and fp.IMB_DLVRY_ZIP_3 in(#Replace( selImbZip3,"''","'","All")#) </cfif>  
            <cfif selOrgFac is not ''>and fp.orgn_fac_seq_id in(#Replace(selOrgFac,"''","'","All")#) </cfif>              
            <cfif selCert is not ''>and fp.certified_mailer_ind  in(#Replace(selCert,"''","'","All")#) </cfif>              

			<cfif sortby neq '19'>group by #preservesinglequotes(gval)#,#preservesinglequotes(gdesc)#</cfif>
			) gp
<!---bottom--->            


  )
          GROUP BY  LOOKUP_VALUE,
                   LOOKUP_DESCRIP   
  ORDER BY fp_tot desc


		</cfquery>        


		<cfset ar = arraynew(2)>
		<cfset clist = evaluate("dta#sortby#").columnList>
		<cfset count2=1>
		<cfset ar[count2] =ListToArray(evaluate("dta#sortby#").columnList)>
		<cfset count2+=1>
		<cfloop query="dta#sortby#">
			<cfset count=1>
				<cfset ar[count2][1] = #lookup_value#>
				<cfset ar[count2][2] = #lookup_descrip#>
				<cfset ar[count2][3] = #fp_tot#>
				<cfset ar[count2][4] = #PER_tot#>
				<cfset ar[count2][5] = #tp_tot#>
				<cfset count2+=1>
		</cfloop>
		<cfset ar[count2][1] = #ReqId#>
		<cfreturn ar>


	</cffunction>


</cfcomponent>