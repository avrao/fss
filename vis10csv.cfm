<cfset opsvisdata = 'iv_spduser'>
<cfset sdate = parsedatetime(dateformat(dateadd('d',-14,now()),'mm/dd/yyyy'))>
<cfset fn = gettempfile(ExpandPath('./attachments'),'FP')>
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


<cfparam name="dsn" default = ''>
<cfparam name="rlupv" default = ''>
<cfparam name="selDir" default = ''>
<cfparam name="selEOD" default = '' >
<cfparam name="bg_date" default = ''>
<cfparam name="ed_date" default = ''>
<cfparam name="selArea" default = ''>
<cfparam name="selDistrict" default = ''>
<cfparam name="selClass" default = ''>
<cfparam name="selCategory" default = ''>
<cfparam name="selFSS" default = ''>
<cfparam name="selMode" default = ''>
<cfparam name="selAir" default = ''>
<cfparam name="selCntrLvl" default = ''>
<cfparam name="rdCert" default = ''>
<cfparam name="selPol" default = ''>
<cfparam name="selHybStd" default = ''>
<cfparam name="sortBy" default = ''>
<cfparam name="selDOW" default = ''>
<cfparam name="selFacility" default = ''>    
<cfparam name="selRange" default = ''>    
<cfparam name="selMailer" default = ''>    
<cfparam name="selImbZip3" default = ''> 
<cfparam name="selOrgFac" default = ''>  
<cfparam name="selEntType" default = ''>                          
<cfparam name="selInduct" default = ''>                          
<cfparam name="selState" default = ''>                          
<cfparam name="selUR" default = ''>                          
<cfparam name="surbko" default = ''>                          
<cfparam name="surbkd" default = ''>
<cfparam name="selDestnFac" default = ''>



<!---
        Get the number of records to read at one time. This will
        limit the amount of data that ColdFusion has to pull down
        from the SQL Server and store in it's memory.
--->
<cfset intReadCount = 10000 />

<!--- Get the offset for the read. --->
<cfset intOffset = 0 />


<!---
        Set up the buffered output stream. The buffered output
        stream requires a file output stream which requires
        a file object. By using a buffered output stream we
        will limit the amount of data that ColdFusion has to store
        in memory AND we will moderate the number of write commands
        that need to take place.
--->
<cfset objOutput = CreateObject(
        "java",
        "java.io.BufferedOutputStream" ).Init(

        <!--- File Output Stream. --->
        CreateObject(
               "java",
               "java.io.FileOutputStream" ).Init(

               <!--- File object. --->
               CreateObject(
                       "java",
                       "java.io.File" ).Init(

                       <!--- File Path. --->
                       JavaCast(
                               "string",
							   fn
                               <!---ExpandPath( "./output.csv" )--->
                               )
                       )
               )
        ) />



<!---
        Keep looping while we have records to read. This loop
        will only be broken manually once we have no more records
        getting returned from the database.
--->
<cfloop condition="true">

        <!--- Query for TOP ## records. --->


<cfquery name="seq_q" datasource="#dsn#">
select crid_seq_id from bi_crid_stg
<cfif selMailer is ''>
where crid is null
<cfelse>
where crid in (#Replace(selMailer,"''","'","All")#) 
</cfif>

</cfquery>






<CFSET seq_list = valuelist(seq_q.crid_seq_id)>

        <cfquery name="qBlog" datasource="#opsvisdata#" blockfactor="70">
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
      select tgp.*,rownum as rn from
      (   
			 SELECT 
               rec_no,fp.orgn_fac_zip_3 AS origin_fac_zip3,
               SUBSTR(fp.SCAN_FAC_ZIP_9,1,5) AS fac_zip_code,
               ad.plt_fac_name AS plt_facility_name,               
               case when length(fp.op_code) < 3 then LPAD (fp.op_code, 3, 0) else to_char(fp.op_code) end AS op_code,               
               fp.mpe_id,
               cin.code_desc as declared_TRAY_CONTENT, 
               NVL (fp.sort_plan, '-') AS sort_plan,
               to_char(fp.scan_datetime,'MM/DD/YYYY HH24:MI') as scan_datetime,
               '="' ||  fp.imb_code || '"'  as imb_code,
               fp.mpe_dlvry_point AS sort_zip,
               NVL (z4.carrier_route_id, '-') as route_id,
               '="' || LPAD (fp.id_tag, 16, 0) || '"' AS id_tag,
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
     ) tgp
)
where rn > <cfqueryparam value="#intOffset#" cfsqltype="cf_sql_decimal"> and rn <=  <cfqueryparam value="#intOffset+intreadcount#" cfsqltype="cf_sql_decimal">
order by rn,imb_code,scan_datetime 
        
</cfquery>        

 



        <!---
               Check to see if we have a record count. If we do not,
               then we are out of data. Break out of the loop.
        --->
        <cfif qBlog.RecordCount>

               <!--- We have returned records from the database. --->

               <!--- Loop over the records. --->
               <cfloop query="qBlog">

                       <!--- Create a string buffer to hold row output. --->
                       <cfset objRowBuffer = CreateObject(
                               "java",
                               "java.lang.StringBuffer"
                              ).Init()
                               />
                       <cfif rn is 1>
                       <cfset objRowBuffer.Append(
                              
"REC NO" & "," & 	"ORIGIN FAC ZIP3" & "," & 	"FAC ZIP CODE" & "," & 	"PLT FACILITY NAME" & "," & 	"OP CODE" & "," & 	"MPE ID" & "," & 	"DECLARED TRAY CONTENT" & "," & 	"SORT PLAN" & "," & 	"SCAN DATETIME" & "," & 	"IMB CODE" & "," & 	"SORT ZIP" & "," & 	"ROUTE ID" & "," & 	"ID TAG" & "," & 	"START THE CLOCK DATE" & "," & 	"IMCB CODE" & "," & 	"ACTUAL ENTRY DATETIME" & "," & 	"CRITICAL ENTRY TIME" & "," & 	"CLEARANCE TIME" & "," & 	"INDCTN MTHD" & "," & 	"OP CODE DESC" & "," & 	"MAILER NAME" & "," & 	"EDOC CRID" & "," & 	"MAIL CLASS" & "," & 	"MAIL SHAPE" & "," & 	"SVC STD" & ","  & 	"ROOT CAUSE" 
						        
                               ) />  
                        <cfset objRowBuffer.Append(
                               Chr( 13 ) &
                               Chr( 10 )
                               ) />                               
                        </cfif>                                     

                       <!--- Add ID. --->
                       <cfset objRowBuffer.Append(
                              
REC_NO & "," & 	ORIGIN_FAC_ZIP3 & "," & 	FAC_ZIP_CODE & "," & 	PLT_FACILITY_NAME & "," & 	OP_CODE & "," & 	MPE_ID & "," & 	DECLARED_TRAY_CONTENT & "," & 	SORT_PLAN & "," & 	SCAN_DATETIME & "," & 	IMB_CODE & "," & 	SORT_ZIP & "," & 	ROUTE_ID & "," & 	ID_TAG & "," & 	START_THE_CLOCK_DATE & "," & 	IMCB_CODE & "," & 	ACTUAL_ENTRY_DATETIME & "," & 	CRITICAL_ENTRY_TIME & "," & 	CLEARANCE_TIME & "," & 	INDCTN_MTHD & "," & 	OP_CODE_DESC & "," & 	MAILER_NAME & "," & 	EDOC_CRID & "," & 	MAIL_CLASS & "," & 	MAIL_SHAPE & "," & 	SVC_STD & "," & 	ROOT_CAUSE
						 
                              
                               ) />

                       <!--- Add name. --->
<!---
                       <cfset objRowBuffer.Append(
                               qBlog.district_abbr & ","
                             
                               ) />

                       <!--- Add description. --->
                       <cfset objRowBuffer.Append(
                               qBlog.LOCALE_NAME & ","

                               ) />

                       <!--- Add date posted. --->
                       <cfset objRowBuffer.Append(

                                qBlog.SERVICE_AREA_KEY 

                               ) />
--->
                       <!--- Add new line (for next record). --->
                       <cfset objRowBuffer.Append(
                               Chr( 13 ) &
                               Chr( 10 )
                               ) />


                       <!---
                               Convert the string buffer to a string
                               (concatenate all the fields) and then get the
                               character byte array from the resultant string.
                       --->
                       <cfset arrRowBytes = objRowBuffer.ToString().GetBytes() />

                       <!--- Write the byte array to the output stream. --->
                       <cfset objOutput.Write(
                               arrRowBytes,
                               JavaCast( "int", 0 ),
                               JavaCast( "int", ArrayLen( arrRowBytes ) )
                               ) />

               </cfloop>


               <!--- Increment the offset. --->
               <cfset intOffset = (intOffset + intReadCount) />


               <!---
                       Reset the buffer. This should kill the white space
                       that is building up in the ColdFusion memory space.
               --->
               <cfset GetPageContext().GetOut().ClearBuffer() />

        <cfelse>

               <!--- No more records. Stop looping. --->
               <cfbreak />

        </cfif>

</cfloop>


<!---
        Flush the buffered output stream to make sure there
        is no straggling buffer data.
--->
<cfset objOutput.Flush() />
<cfset objOutput.Close() />

<cfset nd = getdirectoryfrompath(gettemplatepath()) & "attachments">
<cfdirectory directory ="#nd#"  name = "output" action="list">
</cfdirectory>
<cfoutput query ="output">
<cfif datediff('d',parsedatetime(left(output.datelastmodified,10)),now()) gt 0 and output.name contains '.tmp'>
 <cffile action="delete" file="#nd#/#output.name#">
</cfif>
</cfoutput>



<cfheader name="Content-disposition" value="attachment; filename=output.csv">
<cfcontent type="application/plain"  file="#fn#" deletefile="yes">





