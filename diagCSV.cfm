

<cfset fn = gettempfile(ExpandPath('./attachments'),'csvDIAG')>


<!---
        Get the number of records to read at one time. This will
        limit the amount of data that ColdFusion has to pull down
        from the SQL Server and store in it's memory.
--->
<cfset intReadCount = 5000 />

<!--- Get the offset for the read. --->
<cfset intOffset = 0 />
<cfscript>
function nvl(x)
{
  if (x == '')
   return 0;
  else
   return x; 
}


function getraydesc(x) 
{

switch(x)
{
case '143':traydesc ='EXPRESS DROP SHIP'; break;
case '157':traydesc = 'APPS single induction - incoming Std'; break;
case '165':traydesc ='PRIORITY DROP SHIP'; break;
case '205':traydesc ='DEL STD CMM MAN'; break;
case '206':traydesc ='DEL LTR STD CMM MAN'; break;
case '207':traydesc ='DEL FLTS STD CMM MAN'; break;
case '221':traydesc ='FCM FLTS 5D BC/NBC'; break;
case '222':traydesc ='FCM FLTS 3D BC/NBC'; break;
case '231':traydesc ='FCM FLTS ADC BC/NBC'; break;
case '232':traydesc ='FCM FLTS BC/NBC WKG'; break;
case '241':traydesc ='FCM LTR BC 5D SCHEME'; break;
case '242':traydesc ='FCM LTR 5D BC'; break;
case '243':traydesc ='FCM LTR BC SCHEME2'; break;
case '244':traydesc ='FCM LTR 3D BC'; break;
case '245':traydesc ='FCM LTR AADC BC'; break;
case '246':traydesc ='FCM LTR BC WKG'; break;
case '255':traydesc ='FCM LTR 3D MACH'; break;
case '258':traydesc ='FCM LTR AADC MACH'; break;
case '260':traydesc ='FCM LTR MACH WKG'; break;
case '267':traydesc ='FCM LTR 5D MANUAL'; break;
case '268':traydesc ='FCM LTR MANUAL WKG'; break;
case '269':traydesc ='FCM LTR 3D MANUAL'; break;
case '270':traydesc ='FCM LTR ADC MANUAL'; break;
case '272':traydesc ='FCM FLTS 5D BC'; break;
case '273':traydesc ='FCM FLTS 3D BC'; break;
case '274':traydesc ='FCM FLTS ADC BC'; break;
case '275':traydesc ='FCM FLTS BC WKG'; break;
case '278':traydesc ='FCM FLTS 5D NON BC'; break;
case '279':traydesc ='FCM FLTS 3D NON BC'; break;
case '280':traydesc ='FCM FLTS ADC NON BC'; break;
case '282':traydesc ='FCM FLTS NON BC WKG'; break;
case '289':traydesc ='FCM PARCELS 5D'; break;
case '290':traydesc ='FCM PARCELS 3D'; break;
case '291':traydesc ='FCM PARCELS ADC'; break;
case '292':traydesc ='FCM PARCELS WKG'; break;
case '321':traydesc ='PER FLTS 5D BC/NBC'; break;
case '322':traydesc ='PER FLTS 3D BC/NBC'; break;
case '329':traydesc ='PER FLTS SCF BC/NBC'; break;
case '331':traydesc ='PER FLTS ADC BC/NBC'; break;
case '332':traydesc ='PER FLTS BC/NBC WKG'; break;
case '339':traydesc ='PER FLTS CR/5D'; break;
case '340':traydesc ='PER IRREG CR/5D'; break;
case '341':traydesc ='PER LTRS BC 5D SCHEME'; break;
case '342':traydesc ='PER LTRS 5D BC'; break;
case '343':traydesc ='PER LTRS BC SCHEME2'; break;
case '344':traydesc ='PER LTRS 3D BC'; break;
case '345':traydesc ='PER LTRS AADC BC'; break;
case '346':traydesc ='PER LTRS BC WKG'; break;
case '349':traydesc ='PER FLTS CR/5D SCH'; break;
case '350':traydesc ='PER LTRS 5D NON BC'; break;
case '351':traydesc ='PER FLTS 3D CR-RTS'; break;
case '352':traydesc ='PER FLTS CR/5D/3D'; break;
case '353':traydesc ='PER LTRS 3D NON BC'; break;
case '354':traydesc ='PER IRREG CR/5D/3D'; break;
case '355':traydesc ='PER IRREG 3D CR-RTS'; break;
case '356':traydesc ='PER LTRS ADC NON BC'; break;
case '359':traydesc ='PER LTRS NON BC WKG'; break;
case '363':traydesc ='PER IRREG WKG W FCM'; break;
case '365':traydesc ='PER IRREG CR/5D SCH'; break;
case '366':traydesc ='PER LTRS CR1'; break;
case '367':traydesc ='PER LTRS CR-RTS'; break;
case '368':traydesc ='PER LTRS 3D CR-RTS'; break;
case '369':traydesc ='PER LTRS WSS1'; break;
case '370':traydesc ='PER LTRS WSH1'; break;
case '371':traydesc ='PER FLTS CR-RTS SCH'; break;
case '372':traydesc ='PER FLTS 5D BC'; break;
case '373':traydesc ='PER FLTS 3D BC'; break;
case '374':traydesc ='PER FLTS ADC BC'; break;
case '375':traydesc ='PER FLTS BC WKG'; break;
case '377':traydesc ='PER FLTS SCF BC'; break;
case '378':traydesc ='PER FLTS 5D NON BC'; break;
case '379':traydesc ='PER FLTS 3D NON BC'; break;
case '380':traydesc ='PER FLTS ADC NON BC'; break;
case '381':traydesc ='PER FLTS WKG W FCM'; break;
case '382':traydesc ='PER FLTS NON BC WKG'; break;
case '384':traydesc ='PER FLTS SCF NON BC'; break;
case '385':traydesc ='PER FLTS CR1'; break;
case '386':traydesc ='PER FLTS 5D CR-RTS'; break;
case '387':traydesc ='PER FLTS WSS1'; break;
case '388':traydesc ='PER FLTS WSH1'; break;
case '389':traydesc ='PER IRREG 5D'; break;
case '390':traydesc ='PER IRREG 3D'; break;
case '391':traydesc ='PER IRREG ADC'; break;
case '392':traydesc ='PER IRREG WKG'; break;
case '394':traydesc ='PER IRREG SCF'; break;
case '395':traydesc ='PER IRREG CR1'; break;
case '396':traydesc ='PER IRREG 5D CR-RTS'; break;
case '397':traydesc ='PER IRREG WSS1'; break;
case '398':traydesc ='PER IRREG WSH1'; break;
case '399':traydesc ='PER IRREG CR-RTS SCH'; break;
case '421':traydesc ='NEWS FLTS 5D BC/NBC'; break;
case '422':traydesc ='NEWS FLTS 3D BC/NBC'; break;
case '429':traydesc ='NEWS FLTS SCF BC/NBC'; break;
case '431':traydesc ='NEWS FLTS ADC BC/NBC'; break;
case '432':traydesc ='NEWS FLTS BC/NBC WKG'; break;
case '439':traydesc ='NEWS FLTS CR/5D'; break;
case '440':traydesc ='NEWS IRREG CR/5D'; break;
case '441':traydesc ='NEWS LTR BC 5D SCHEME'; break;
case '442':traydesc ='NEWS LTRS 5D BC'; break;
case '443':traydesc ='NEWS LTRS BC SCHEME2'; break;
case '444':traydesc ='NEWS LTRS 3D BC'; break;
case '445':traydesc ='NEWS LTRS AADC BC'; break;
case '446':traydesc ='NEWS LTRS BC WKG'; break;
case '449':traydesc ='NEWS FLTS CR/5D SCH'; break;
case '450':traydesc ='NEWS LTRS 5D NON BC'; break;
case '451':traydesc ='NEWS FLTS 3D CR-RTS'; break;
case '452':traydesc ='NEWS FLTS CR/5D/3D'; break;
case '453':traydesc ='NEWS LTRS 3D NON BC'; break;
case '454':traydesc ='NEWS IRREG CR/5D/3D'; break;
case '455':traydesc ='NEWS IRREG 3D CR-RTS'; break;
case '456':traydesc ='NEWS LTRS ADC NON BC'; break;
case '459':traydesc ='NEWS LTRS NON BC WKG'; break;
case '463':traydesc ='NEWS IRREG WKG W FCM'; break;
case '465':traydesc ='NEWS IRREG CR/5D SCH'; break;
case '466':traydesc ='NEWS LTRS CR1'; break;
case '467':traydesc ='NEWS LTRS CR-RTS'; break;
case '468':traydesc ='NEWS LTRS 3D CR-RTS'; break;
case '469':traydesc ='NEWS LTRS WSS1'; break;
case '470':traydesc ='NEWS LTRS WSH1'; break;
case '471':traydesc ='NEWS FLTS CR-RTS SCH'; break;
case '472':traydesc ='NEWS FLTS 5D BC'; break;
case '473':traydesc ='NEWS FLTS 3D BC'; break;
case '474':traydesc ='NEWS FLTS ADC BC'; break;
case '475':traydesc ='NEWS FLTS BC WKG'; break;
case '477':traydesc ='NEWS FLTS SCF BC'; break;
case '478':traydesc ='NEWS FLTS 5D NON BC'; break;
case '479':traydesc ='NEWS FLTS 3D NON BC'; break;
case '480':traydesc ='NEWS FLTS ADC NON BC'; break;
case '481':traydesc ='NEWS FLTS WKG W FCM'; break;
case '482':traydesc ='NEWS FLTS NON BC WKG'; break;
case '484':traydesc ='NEWS FLTS SCF NON BC'; break;
case '485':traydesc ='NEWS FLTS CR1'; break;
case '486':traydesc ='NEWS FLTS 5D CR-RTS'; break;
case '487':traydesc ='NEWS FLTS WSS1'; break;
case '488':traydesc ='NEWS FLTS WSH1'; break;
case '489':traydesc ='NEWS IRREG 5D'; break;
case '490':traydesc ='NEWS IRREG 3D'; break;
case '491':traydesc ='NEWS IRREG ADC'; break;
case '492':traydesc ='NEWS IRREG WKG'; break;
case '494':traydesc ='NEWS IRREG SCF'; break;
case '495':traydesc ='NEWS IRREG CR1'; break;
case '496':traydesc ='NEWS IRREG 5D CR-RTS'; break;
case '497':traydesc ='NEWS IRREG WSS1'; break;
case '498':traydesc ='NEWS IRREG WSH1'; break;
case '499':traydesc ='NEWS IRREG CR-RTS SCH'; break;
case '500':traydesc ='STD NFM 5D'; break;
case '501':traydesc ='STD/PSVC 3D'; break;
case '502':traydesc ='STD/PSVC ADC'; break;
case '503':traydesc ='STD NFM MACH ASF'; break;
case '505':traydesc ='STD NFM NDC'; break;
case '506':traydesc ='STD/PSVC WKG'; break;
case '507':traydesc ='STD NFM SCF'; break;
case '509':traydesc ='STD NFM ASF'; break;
case '514':traydesc ='STD NFM MACH NDC'; break;
case '518':traydesc ='STD NFM MACH WKG'; break;
case '521':traydesc ='STD FLTS 5D BC/NBC'; break;
case '522':traydesc ='STD FLTS 3D BC/NBC'; break;
case '529':traydesc ='STD FLTS CR-RTS SCH'; break;
case '531':traydesc ='STD FLTS ADC BC/NBC'; break;
case '532':traydesc ='STD FLTS BC/NBC WKG'; break;
case '539':traydesc ='STD FLTS CR/5D'; break;
case '541':traydesc ='STD LTR BC 5D SCHEME'; break;
case '542':traydesc ='STD LTR 5D BC'; break;
case '543':traydesc ='STD LTR BC SCHEME2'; break;
case '544':traydesc ='STD LTR 3D BC'; break;
case '545':traydesc ='STD LTR AADC BC'; break;
case '546':traydesc ='STD LTR BC WKG'; break;
case '549':traydesc ='STD FLTS CR/5D SCH'; break;
case '555':traydesc ='STD LTR 3D MACH'; break;
case '557':traydesc ='STD LTR BC'; break;
case '558':traydesc ='STD LTR AADC MACH'; break;
case '560':traydesc ='STD LTR MACH WKG'; break;
case '564':traydesc ='STD LTR 5D CR-RT BC'; break;
case '565':traydesc ='STD LTR 3D CR-RT BC'; break;
case '567':traydesc ='STD LTR 5D CR-RT MACH'; break;
case '568':traydesc ='STD LTR 3D CR-RT MACH'; break;
case '569':traydesc ='STD LTR MACH'; break;
case '570':traydesc ='STD IRREG NDC'; break;
case '571':traydesc ='STD IRREG ASF'; break;
case '572':traydesc ='STD FLTS 5D BC'; break;
case '573':traydesc ='STD FLTS 3D BC'; break;
case '574':traydesc ='STD FLTS ADC BC'; break;
case '575':traydesc ='STD FLTS BC WKG'; break;
case '578':traydesc ='STD FLTS 5D NON BC'; break;
case '579':traydesc ='STD FLTS 3D NON BC'; break;
case '580':traydesc ='STD FLTS ADC NON BC'; break;
case '582':traydesc ='STD FLTS NON BC WKG'; break;
case '586':traydesc ='STD FLTS CR-RTS'; break;
case '587':traydesc ='STD FLTS ECRWSS1'; break;
case '588':traydesc ='STD FLTS ECRWSH1'; break;
case '589':traydesc ='STD FLTS ECRLOT1'; break;
case '590':traydesc ='STD IRREG 5D'; break;
case '591':traydesc ='STD/PSVC IRREG 3D'; break;
case '592':traydesc ='STD/PSVC IRREG ADC'; break;
case '594':traydesc ='STD IRREG WKG'; break;
case '596':traydesc ='STD IRREG SCF'; break;
case '598':traydesc ='STD IRREG CR-RTS'; break;
case '599':traydesc ='STD IRREG WSS1'; break;
case '600':traydesc ='STD IRREG WSH1'; break;
case '601':traydesc ='STD IRREG LOT1'; break;
case '603':traydesc ='STD MACH-IRREG 5D'; break;
case '604':traydesc ='STD LTR 5D MANUAL'; break;
case '605':traydesc ='STD LTR MANUAL WKG'; break;
case '606':traydesc ='STD LTR 3D MANUAL'; break;
case '607':traydesc ='STD LTR ADC MANUAL'; break;
case '608':traydesc ='STD LTR MAN LOT1'; break;
case '609':traydesc ='STD LTR 5D CR-RT MAN'; break;
case '611':traydesc ='STD LTR 3D CR-RT MAN'; break;
case '635':traydesc ='PSVC FLTS 5D BC'; break;
case '636':traydesc ='PSVC FLTS 3D BC'; break;
case '637':traydesc ='PSVC FLTS SCF BC'; break;
case '638':traydesc ='PSVC FLTS ADC BC'; break;
case '639':traydesc ='PSVC FLTS BC WKG'; break;
case '648':traydesc ='PSVC FLTS 5D BC/NBC'; break;
case '649':traydesc ='PSVC FLTS 5D NON BC'; break;
case '650':traydesc ='PSVC FLTS 3D NON BC'; break;
case '651':traydesc ='PSVC FLTS ADC NON BC'; break;
case '653':traydesc ='PSVC FLTS NON BC WKG'; break;
case '654':traydesc ='PSVC FLTS SCF NON BC'; break;
case '657':traydesc ='PSVC FLTS CR1'; break;
case '658':traydesc ='PSVC FLTS CR-RTS'; break;
case '659':traydesc ='PSVC FLTS CR-RTS SCH'; break;
case '660':traydesc ='STD/PSVC MACH 5D'; break;
case '661':traydesc ='PSVC FLTS 3D BC/NBC'; break;
case '662':traydesc ='STD/PSVC MACH ASF'; break;
case '663':traydesc ='STD/PSVC MACH NDC'; break;
case '664':traydesc ='STD/PSVC MACH WKG'; break;
case '667':traydesc ='PSVC FLTS SCF BC/NBC'; break;
case '668':traydesc ='PSVC FLTS ADC BC/NBC'; break;
case '669':traydesc ='PSVC FLTS BC/NBC WKG'; break;
case '670':traydesc ='STD MACH 5D'; break;
case '672':traydesc ='STD MACH ASF'; break;
case '673':traydesc ='STD MACH NDC'; break;
case '674':traydesc ='STD MACH WKG'; break;
case '680':traydesc ='PSVC MACH 5D'; break;
case '682':traydesc ='PSVC MACH ASF'; break;
case '683':traydesc ='PSVC MACH NDC'; break;
case '684':traydesc ='PSVC MACH WKG'; break;
case '687':traydesc ='PSVC MACH CR1'; break;
case '688':traydesc ='PSVC PARCELS 5D'; break;
case '690':traydesc ='PSVC IRREG 5D'; break;
case '691':traydesc ='PSVC IRREG 3D'; break;
case '692':traydesc ='PSVC IRREG ADC'; break;
case '694':traydesc ='PSVC IRREG WKG'; break;
case '696':traydesc ='PSVC IRREG SCF'; break;
case '697':traydesc ='PSVC IRREG CR1'; break;
case '698':traydesc ='PSVC IRREG CR-RTS'; break;
default:traydesc='-';
}
return traydesc;
}

</cfscript>

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

<cfset selJob = ''><cfset selZip5 = ''>

<!---
        Keep looping while we have records to read. This loop
        will only be broken manually once we have no more records
        getting returned from the database.
--->
<cfloop condition="true">

        <!--- Query for TOP ## records. --->
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
				REPLACE(NVL (op.op_desc, 'Unknown'),',',' -') AS x_op_desc,
				REPLACE(pr.mlr_name,',',' -') AS x_mailer_name,
				fp.edoc_sbmtr_crid_seq_id AS x_edoc_seq,
				fp.job_seq_id AS x_job_seq_id,
				LOGICAL_HU_SEQ_ID as x_log_hu,
				PHYS_HU_SEQ_ID as x_phys_hu,
				LOGICAL_CONTR_SEQ_ID as x_log_cntr,
				PHYS_CONTR_SEQ_ID as x_phys_cntr,
				fp.ml_cl_code as x_ml_cl_code,
				fp.ml_cat_code as x_ml_cat_code,
				HYB_SVC_STD_DESC as x_svc_std,
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
		where rec_no > <cfqueryparam value="#intOffset#" cfsqltype="cf_sql_decimal"> and rec_no <=  <cfqueryparam value="#intOffset+intreadcount#" cfsqltype="cf_sql_decimal">
		</cfquery>
		
		<cfquery name = "dta" dbtype="query">
		select distinct rec_no,origin_fac_zip3,fac_zip_code,op_code,mpe_id,declared_TRAY_CONTENT,
		sort_plan,scan_datetime,imb_code,sort_zip,route_id,id_tag, x_stc,x_imcb_code,
		x_actual_entry_datetime,x_critical_entry_time,x_code_desc,x_plt_facility_name,
		x_op_desc,x_mailer_name,x_edoc_seq,x_job_seq_id,x_log_hu,x_phys_hu,x_log_cntr,x_phys_cntr,
		x_ml_cl_code,x_ml_cat_code,x_svc_std,x_CONTR_LVL_DESC,
		x_FEDEX_AIR_SCAN_IND,
		x_THS_CLEAN_AIR_SCAN_IND,
		x_CAIR_SCAN_IND
		from dta_main
		ORDER BY IMB_CODE,SCAN_DATETIME
		</cfquery> 
 
		<cfset rn = 1>

        <!---
               Check to see if we have a record count. If we do not,
               then we are out of data. Break out of the loop.
        --->
        <cfif dta.RecordCount>

               <!--- We have returned records from the database. --->

               <!--- Loop over the records. --->
			   <cfset ml_cl='Standard'>
			   <cfset ml_cat=''>
               <cfloop query="dta">

                       <!--- Create a string buffer to hold row output. --->
                       <cfset objRowBuffer = CreateObject(
                               "java",
                               "java.lang.StringBuffer"
                              ).Init()
                               />
                       <cfif rn is 1>
					   <cfif x_ml_cl_code eq 1><cfset ml_cl='First Class'></cfif>
					   <cfif x_ml_cl_code eq 2><cfset ml_cl='Periodicals'></cfif>
					   
					   <cfset rn = 2>
                       <cfset objRowBuffer.Append(
                              
						 "REC_NO" & "," & "CLASS" & "," & "CATEGORY" & "," & "SVC_STD" & "," & "ORIGIN_FAC_ZIP3" & "," & "FAC_ZIP_CODE" & "," & "OP_CODE" & "," & "MPE_ID" & "," & "DECLARED_TRAY_CONTENT" & "," & "SORT_PLAN" 
						 & "," & "SCAN_DATETIME" & "," & "IMB_CODE" & "," & "SORT_ZIP" & "," & "ROUTE_ID" & "," & "ID_TAG" & "," & " START_THE_CLOCK_DATE" & "," & "IMCB_CODE" & "," 
						 & "ACTUAL_ENTRY_DATETIME" & "," & "CRITICAL_ENTRY_TIME" & "," & "INDUCTION_METHOD" & "," & "PLT_FACILITY_NAME" & "," & "OP_DESC" & "," 
						 & "MAILER_NAME" & "," & "CRID" & "," & "JOB_SEQ_ID" & "," & "LOG_HU" & "," & "PHYS_HU" & "," & "LOG_CONTAINER" & "," & "PHYS_CONTAINER" 
						        
                               ) />  
                        <cfset objRowBuffer.Append(
                               Chr( 13 ) &
                               Chr( 10 )
                               ) />                               
                        </cfif>
						
					   <cfif x_ml_cat_code eq 1><cfset ml_cat='Letters'></cfif>
					   <cfif x_ml_cat_code eq 2><cfset ml_cat='Flats'></cfif>
					   <cfif x_ml_cat_code eq 3><cfset ml_cat='Cards'></cfif>                                  

                       <!--- Add ID. --->
                       <cfset objRowBuffer.Append(
                            
						REC_NO & "," & ml_cl & "," & ml_cat & "," & X_SVC_STD & "," & ORIGIN_FAC_ZIP3 & "," & FAC_ZIP_CODE & "," 
						& OP_CODE & "," & MPE_ID & "," & getraydesc(DECLARED_TRAY_CONTENT)  
						& "," & SORT_PLAN & "," & SCAN_DATETIME & ",:" & IMB_CODE & ",:" 
						& SORT_ZIP & "," & ROUTE_ID & ",:" & ID_TAG & "," &  X_STC & "," 
						& X_IMCB_CODE & "," & X_ACTUAL_ENTRY_DATETIME & "," & X_CRITICAL_ENTRY_TIME 
						& "," & X_CODE_DESC & "," & X_PLT_FACILITY_NAME & "," & X_OP_DESC 
						& "," & X_MAILER_NAME & "," & X_EDOC_SEQ & "," & X_JOB_SEQ_ID & ",:" 
						& X_LOG_HU & ",:" & X_PHYS_HU & "," & X_LOG_CNTR & "," & X_PHYS_CNTR
                              
                               ) />


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

<cfcookie
name="downloadID"
value="dlDone"
expires="0.0005"
/>

<cfheader name="Content-disposition" value="attachment; filename=output.csv">
<cfcontent type="application/plain"  file="#fn#" deletefile="yes">





