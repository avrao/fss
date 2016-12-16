<cfcomponent>
<!---cfset ivdata = "iv_spduser"--->
<cffunction name="getByAreaPlant" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="selFSS" type="string" required="yes">
	<cfargument name="selSV" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfargument name="rptType" type="string" required="yes">
	
	<cfif rptType is "1">
		<!---non-nested bundles report--->
		<cfset lstCols = "area_id,site_name,plnt_nonnested_fs,plnt_fs_bndl_nested_pct">
		<cfset sortOrder = "plnt_nonnested_fs">
	<cfelseif rptType is "2">
		<!---bundles processed on afsm/fss report--->
		<cfset lstCols = "area_id,site_name,plnt_fs_afsmfs_procss_bndl,plnt_fs_afsmfs_procss_bndl">
		<cfset sortOrder = "plnt_fs_afsmfs_procss_bndl">
	<cfelseif rptType is "3">
		<!---% 99P loaded report--->
		<cfset lstCols = "area_id,site_name,plnt_loaded_99p_contr_pct,plnt_loaded_99p_contr_pct">
		<cfset sortOrder = "plnt_loaded_99p_contr_pct">
	<cfelseif rptType is "4">
		<!---Bundles Not Loaded (on-Hand) report--->
		<cfset lstCols = "area_id,site_name,plnt_nnp_not_loaded,plnt_nnp_not_loaded">
		<cfset sortOrder = "plnt_nnp_not_loaded">
	</cfif>

	<cfquery name="DataSelect" datasource="#dsn#">
	select
	area_id,
	site_name,
	max(plnt_fs_procss_bndl_cnt) - max(plnt_fs_afsmfs_procss_bndl_cnt) plnt_total_fs,
	max(plnt_fs_procss_bndl_cnt) - max(plnt_fs_nested_bndl_cnt) plnt_nonnested_fs,
	max(plnt_webeor_procss_bndl_cnt) plnt_total_bndl,
	max(plnt_fs_procss_bndl_cnt) plnt_fs_bndl_proc,
	max(plnt_fs_nested_bndl_cnt) plnt_fs_bndl_nest,
	max(plnt_fs_afsmfs_procss_bndl_cnt) plnt_fs_afsmfs_procss_bndl,
	case when nvl(max(plnt_fs_procss_bndl_cnt)- max(plnt_fs_afsmfs_procss_bndl_cnt), 0) > 0
		then round((max(plnt_fs_nested_bndl_cnt) - max(plnt_fs_afsmfs_procss_bndl_cnt)) / (max(plnt_fs_procss_bndl_cnt) - max(plnt_fs_afsmfs_procss_bndl_cnt)), 3)
		else 0 end plnt_fs_bndl_nested_pct,
	max(plnt_nested_99p_contr_cnt) plnt_nnp_cont,
	max(plnt_nested_99h_contr_cnt) plnt_nnh_cont,
	max(plnt_nested_99p_loaded_cnt) plnt_nnp_loaded,
	max(plnt_not_loaded_99p_cnt) plnt_nnp_not_loaded,
	case when nvl(max(plnt_nested_99p_contr_cnt),0) > 0
		then round(max(plnt_nested_99p_loaded_cnt)/max(plnt_nested_99p_contr_cnt), 3)
		else 0 end plnt_loaded_99p_contr_pct,
	max(plnt_fs_bndl_nested_99p_onhand) plnt_bndls_not_loaded_onhand
	from
		(
		select
		rept.area_id,
		ad.site_name,
		sum(plnt_webeor_procss_bndl_cnt) plnt_webeor_procss_bndl_cnt,
		sum(plnt_fs_procss_bndl_cnt) plnt_fs_procss_bndl_cnt,
		sum(plnt_fs_nested_bndl_cnt) plnt_fs_nested_bndl_cnt,
		sum(plnt_fs_afsmfs_procss_bndl_cnt) plnt_fs_afsmfs_procss_bndl_cnt,
		sum(plnt_nested_99p_contr_cnt) plnt_nested_99p_contr_cnt,
		sum(plnt_nested_99h_contr_cnt) plnt_nested_99h_contr_cnt,
		sum(plnt_nested_99p_loaded_cnt) plnt_nested_99p_loaded_cnt,
		sum(plnt_not_loaded_99p_cnt) plnt_not_loaded_99p_cnt,
		sum(plnt_fs_bndl_nested_99p_onhand)  plnt_fs_bndl_nested_99p_onhand
		from bun_vis_plant_sumry rept
		join (select distinct area, site_name, district, district_name from area_district) ad
		on  rept.area_id = ad.area
		and rept.dist_id = ad.district
		where rept.reporting_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
		and rept.reporting_date < <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
		<cfif selFSS is not "">
			and fss_zone_destn_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#selFSS#">
		</cfif>
		<cfif selSV is not "">
			and fac_sv_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#selSV#">
		</cfif>
		group by rept.area_id, ad.site_name
		)
	group by area_id, site_name
	<!---order by site_name--->
	order by #sortOrder#
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<!---cfset lstCols = DataSelect.ColumnList>
	<cfset lstCols = "area_id,site_name,plnt_nonnested_fs,plnt_fs_bndl_nested_pct,plnt_total_fs"--->
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>
	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<cffunction name="getByDistrictPlant" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="selFSS" type="string" required="yes">
	<cfargument name="selSV" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfargument name="rptType" type="string" required="yes">
	<cfargument name="selArea" type="string" required="no" default="">

	<cfif rptType is "1">
		<!---non-nested bundles report--->
		<cfset lstCols = "dist_id,district_name,plnt_nonnested_fs,plnt_fs_bndl_nested_pct">
		<cfset sortOrder = "plnt_nonnested_fs">
	<cfelseif rptType is "2">
		<!---bundles processed on afsm/fss report--->
		<cfset lstCols = "dist_id,district_name,plnt_fs_afsmfs_procss_bndl,plnt_fs_afsmfs_procss_bndl">
		<cfset sortOrder = "plnt_fs_afsmfs_procss_bndl">
	<cfelseif rptType is "3">
		<!---% 99P loaded report--->
		<cfset lstCols = "dist_id,district_name,plnt_loaded_99p_contr_pct,plnt_loaded_99p_contr_pct">
		<cfset sortOrder = "plnt_loaded_99p_contr_pct">
	<cfelseif rptType is "4">
		<!---Bundles Not Loaded (on-Hand) report--->
		<cfset lstCols = "dist_id,district_name,plnt_nnp_not_loaded,plnt_nnp_not_loaded">
		<cfset sortOrder = "plnt_nnp_not_loaded">
	</cfif>
	
	<cfset selArea = Replace(selArea, "'", "", "ALL")>

	<cfquery name="DataSelect" datasource="#dsn#">
	select
	dist_id,
	district_name,
	max(plnt_fs_procss_bndl_cnt) - max(plnt_fs_afsmfs_procss_bndl_cnt) plnt_total_fs,
	max(plnt_fs_procss_bndl_cnt) - max(plnt_fs_nested_bndl_cnt) plnt_nonnested_fs,
	max(plnt_webeor_procss_bndl_cnt) plnt_total_bndl,
	max(plnt_fs_procss_bndl_cnt) plnt_fs_bndl_proc,
	max(plnt_fs_nested_bndl_cnt) plnt_fs_bndl_nest,
	max(plnt_fs_afsmfs_procss_bndl_cnt) plnt_fs_afsmfs_procss_bndl,
	case when nvl(max(plnt_fs_procss_bndl_cnt)- max(plnt_fs_afsmfs_procss_bndl_cnt), 0) > 0
		then round((max(plnt_fs_nested_bndl_cnt) - max(plnt_fs_afsmfs_procss_bndl_cnt)) / (max(plnt_fs_procss_bndl_cnt) - max(plnt_fs_afsmfs_procss_bndl_cnt)), 3)
		else 0 end plnt_fs_bndl_nested_pct,
	max(plnt_nested_99p_contr_cnt) plnt_nnp_cont,
	max(plnt_nested_99h_contr_cnt) plnt_nnh_cont,
	max(plnt_nested_99p_loaded_cnt) plnt_nnp_loaded,
	max(plnt_not_loaded_99p_cnt) plnt_nnp_not_loaded,
	case when nvl(max(plnt_nested_99p_contr_cnt),0) > 0
		then round(max(plnt_nested_99p_loaded_cnt)/max(plnt_nested_99p_contr_cnt), 3)
		else 0 end plnt_loaded_99p_contr_pct,
	max(plnt_fs_bndl_nested_99p_onhand) plnt_bndls_not_loaded_onhand
	from
		(
		select
		rept.dist_id,
		ad.district_name,
		sum(plnt_webeor_procss_bndl_cnt) plnt_webeor_procss_bndl_cnt,
		sum(plnt_fs_procss_bndl_cnt) plnt_fs_procss_bndl_cnt,
		sum(plnt_fs_nested_bndl_cnt) plnt_fs_nested_bndl_cnt,
		sum(plnt_fs_afsmfs_procss_bndl_cnt) plnt_fs_afsmfs_procss_bndl_cnt,
		sum(plnt_nested_99p_contr_cnt) plnt_nested_99p_contr_cnt,
		sum(plnt_nested_99h_contr_cnt) plnt_nested_99h_contr_cnt,
		sum(plnt_nested_99p_loaded_cnt) plnt_nested_99p_loaded_cnt,
		sum(plnt_not_loaded_99p_cnt) plnt_not_loaded_99p_cnt,
		sum(plnt_fs_bndl_nested_99p_onhand)  plnt_fs_bndl_nested_99p_onhand
		from bun_vis_plant_sumry rept
		join (select distinct area, site_name, district, district_name from area_district) ad
		on  rept.area_id = ad.area
		and rept.dist_id = ad.district
		where rept.reporting_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
		and rept.reporting_date < <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
		<cfif selFSS is not "">
			and fss_zone_destn_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#selFSS#">
		</cfif>
		<cfif selSV is not "">
			and fac_sv_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#selSV#">
		</cfif>
		<cfif selArea is not "">
			and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
		</cfif>
		group by rept.dist_id, ad.district_name
		)
	group by dist_id, district_name
	order by #sortOrder#
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<!---cfset lstCols = DataSelect.ColumnList>
	<cfset lstCols = "dist_id,district_name,plnt_nonnested_fs,plnt_fs_bndl_nested_pct,plnt_total_fs"--->
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>
	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<cffunction name="getByFacilityPlant" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="selFSS" type="string" required="yes">
	<cfargument name="selSV" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfargument name="rptType" type="string" required="yes">
	<cfargument name="selArea" type="string" required="no" default="">
	<cfargument name="selDistrict" type="string" required="no" default="">
	
	<cfif rptType is "1">
		<!---non-nested bundles report--->
		<cfset lstCols = "fac_seq_id,fac_name,plnt_nonnested_fs,plnt_fs_bndl_nested_pct">
		<cfset sortOrder = "plnt_nonnested_fs">
	<cfelseif rptType is "2">
		<!---bundles processed on afsm/fss report--->
		<cfset lstCols = "fac_seq_id,fac_name,plnt_fs_afsmfs_procss_bndl,plnt_fs_afsmfs_procss_bndl">
		<cfset sortOrder = "plnt_fs_afsmfs_procss_bndl">
	<cfelseif rptType is "3">
		<!---% 99P loaded report--->
		<cfset lstCols = "fac_seq_id,fac_name,plnt_loaded_99p_contr_pct,plnt_loaded_99p_contr_pct">
		<cfset sortOrder = "plnt_loaded_99p_contr_pct">
	<cfelseif rptType is "4">
		<!---Bundles Not Loaded (on-Hand) report--->
		<cfset lstCols = "fac_seq_id,fac_name,plnt_nnp_not_loaded,plnt_nnp_not_loaded">
		<cfset sortOrder = "plnt_nnp_not_loaded">
	</cfif>

	<cfset selArea = Replace(selArea, "'", "", "ALL")>
	<cfset selDistrict = Replace(selDistrict, "'", "", "ALL")>

	<cfquery name="DataSelect" datasource="#dsn#">
	select
	fac_seq_id,
	fac_name,
	max(plnt_fs_procss_bndl_cnt) - max(plnt_fs_afsmfs_procss_bndl_cnt) plnt_total_fs,
	max(plnt_fs_procss_bndl_cnt) - max(plnt_fs_nested_bndl_cnt) plnt_nonnested_fs,
	max(plnt_webeor_procss_bndl_cnt) plnt_total_bndl,
	max(plnt_fs_procss_bndl_cnt) plnt_fs_bndl_proc,
	max(plnt_fs_nested_bndl_cnt) plnt_fs_bndl_nest,
	max(plnt_fs_afsmfs_procss_bndl_cnt) plnt_fs_afsmfs_procss_bndl,
	case when nvl(max(plnt_fs_procss_bndl_cnt)- max(plnt_fs_afsmfs_procss_bndl_cnt), 0) > 0
		then round((max(plnt_fs_nested_bndl_cnt) - max(plnt_fs_afsmfs_procss_bndl_cnt)) / (max(plnt_fs_procss_bndl_cnt) - max(plnt_fs_afsmfs_procss_bndl_cnt)), 3)
		else 0 end plnt_fs_bndl_nested_pct,
	max(plnt_nested_99p_contr_cnt) plnt_nnp_cont,
	max(plnt_nested_99h_contr_cnt) plnt_nnh_cont,
	max(plnt_nested_99p_loaded_cnt) plnt_nnp_loaded,
	max(plnt_not_loaded_99p_cnt) plnt_nnp_not_loaded,
	case when nvl(max(plnt_nested_99p_contr_cnt),0) > 0
		then round(max(plnt_nested_99p_loaded_cnt)/max(plnt_nested_99p_contr_cnt), 3)
		else 0 end plnt_loaded_99p_contr_pct,
	max(plnt_fs_bndl_nested_99p_onhand) plnt_bndls_not_loaded_onhand
	from
		(
		select
		rept.fac_seq_id, f.fac_name,
		sum(plnt_webeor_procss_bndl_cnt) plnt_webeor_procss_bndl_cnt,
		sum(plnt_fs_procss_bndl_cnt) plnt_fs_procss_bndl_cnt,
		sum(plnt_fs_nested_bndl_cnt) plnt_fs_nested_bndl_cnt,
		sum(plnt_fs_afsmfs_procss_bndl_cnt) plnt_fs_afsmfs_procss_bndl_cnt,
		sum(plnt_nested_99p_contr_cnt) plnt_nested_99p_contr_cnt,
		sum(plnt_nested_99h_contr_cnt) plnt_nested_99h_contr_cnt,
		sum(plnt_nested_99p_loaded_cnt) plnt_nested_99p_loaded_cnt,
		sum(plnt_not_loaded_99p_cnt) plnt_not_loaded_99p_cnt,
		sum(plnt_fs_bndl_nested_99p_onhand)  plnt_fs_bndl_nested_99p_onhand
		from bun_vis_plant_sumry rept
		join facility f
		on f.fac_seq_id = rept.fac_seq_id
		where rept.reporting_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
		and rept.reporting_date < <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
		<cfif selFSS is not "">
			and fss_zone_destn_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#selFSS#">
		</cfif>
		<cfif selSV is not "">
			and fac_sv_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#selSV#">
		</cfif>
		<cfif selArea is not "">
			and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
		</cfif>
		<cfif selDistrict is not "">
			and rept.dist_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selDistrict#">)
		</cfif>
		group by rept.fac_seq_id, f.fac_name
		)
	group by fac_seq_id, fac_name
	<!---order by site_name--->
	order by #sortOrder#
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<!---cfset lstCols = DataSelect.ColumnList>
	<cfset lstCols = "fac_seq_id,fac_name,plnt_nonnested_fs,plnt_fs_bndl_nested_pct,plnt_total_fs"--->
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>
	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<cffunction name="getOverallPlant" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="selFSS" type="string" required="yes">
	<cfargument name="selSV" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfargument name="selArea" type="string" required="no" default="">
	<cfargument name="selDistrict" type="string" required="no" default="">
	<cfargument name="selFacility" type="string" required="no" default="">

	<cfset selArea = Replace(selArea, "'", "", "ALL")>
	<cfset selDistrict = Replace(selDistrict, "'", "", "ALL")>
	<cfset selFacility = Replace(selFacility, "'", "", "ALL")>

	<cfquery name="DataSelect" datasource="#dsn#">
	select
	plnt_webeor_procss_bndl_cnt total_bndl,
	plnt_fs_procss_bndl_cnt fs_bndl_proc,
	plnt_fs_nested_bndl_cnt fs_bndl_nest,
	plnt_fs_afsmfs_procss_bndl_cnt fs_afsmfs_procss_bndl,
	case when nvl(plnt_fs_procss_bndl_cnt- plnt_fs_afsmfs_procss_bndl_cnt, 0) > 0
		then round((plnt_fs_nested_bndl_cnt - plnt_fs_afsmfs_procss_bndl_cnt) / (plnt_fs_procss_bndl_cnt - plnt_fs_afsmfs_procss_bndl_cnt), 3)
		else 0 end fs_bndl_nested_pct,
	plnt_nested_99p_contr_cnt nnp_cont,
	plnt_nested_99h_contr_cnt nnh_cont,
	plnt_nested_99p_loaded_cnt nnp_loaded,
	plnt_not_loaded_99p_cnt nnp_not_loaded,
	case when nvl(plnt_nested_99p_contr_cnt, 0) > 0
		then round(plnt_nested_99p_loaded_cnt / plnt_nested_99p_contr_cnt, 3)
		else 0 end loaded_99p_contr_pct,
	plnt_fs_bndl_nested_99p_onhand bndls_not_loaded_onhand
	from
		(
		select
		sum(plnt_webeor_procss_bndl_cnt) plnt_webeor_procss_bndl_cnt,
		sum(plnt_fs_procss_bndl_cnt) plnt_fs_procss_bndl_cnt,
		sum(plnt_fs_nested_bndl_cnt) plnt_fs_nested_bndl_cnt,
		sum(plnt_fs_afsmfs_procss_bndl_cnt) plnt_fs_afsmfs_procss_bndl_cnt,
		sum(plnt_nested_99p_contr_cnt) plnt_nested_99p_contr_cnt,
		sum(plnt_nested_99h_contr_cnt) plnt_nested_99h_contr_cnt,
		sum(plnt_nested_99p_loaded_cnt) plnt_nested_99p_loaded_cnt,
		sum(plnt_not_loaded_99p_cnt) plnt_not_loaded_99p_cnt,
		sum(plnt_fs_bndl_nested_99p_onhand) plnt_fs_bndl_nested_99p_onhand
		from bun_vis_plant_sumry rept
		where rept.reporting_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
		and rept.reporting_date <= <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
		<cfif selFSS is not "">
			and fss_zone_destn_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#selFSS#">
		</cfif>
		<cfif selSV is not "">
			and fac_sv_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#selSV#">
		</cfif>
		<cfif selArea is not "">
			and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
		</cfif>
		<cfif selDistrict is not "">
			and rept.dist_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selDistrict#">)
		</cfif>
		<cfif selFacility is not "">
			and rept.fac_seq_id in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selFacility#">
		</cfif>
		)
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<cfset lstCols = DataSelect.ColumnList>
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>
	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<cffunction name="getDates" access="remote" returntype="array">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="range" type="string" required="yes">
	
	<cfquery name="DateSelect" datasource="#dsn#" blockfactor="100">
	<cfif range is 'MON'>
		select dt as beg_mon_date,
		add_months(dt,1)-1 as end_mon_date,
		to_char(dt,'mm/dd/yyyy') as strdate,
		to_char(add_months(dt,1)-1,'mm/dd/yyyy') as strend 
		from
			(
			select
				(
				select min(reporting_date) from bun_vis_plant_sumry
				) + rownum as dt
				from bun_vis_plant_sumry
				where rownum <=
				(
				select max(reporting_date) from bun_vis_plant_sumry
				)
				-
				(
				select min(reporting_date) from bun_vis_plant_sumry
				)
			)
		where to_char(dt, 'dd')=1
		order by dt desc
	<cfelseif range is 'QTR'>
		select dt as beg_qtr_date,
		add_months(dt, 3) - 1 as end_qtr_date,
		to_char(dt, 'mm/dd/yyyy') as strdate,
		to_char(add_months(dt, 3) - 1, 'mm/dd/yyyy') as strend 
		from
			(
			select
				(
				select min(reporting_date)
				from bun_vis_plant_sumry
				) + rownum - 1 as dt
			from bun_vis_plant_sumry
			where rownum <=
				(
				select max(reporting_date) from bun_vis_plant_sumry
				)
				-
				(
				select min(reporting_date) from bun_vis_plant_sumry
				)
			)
		where to_char(dt,'MM') IN('01', '04', '07', '10') AND to_char(dt, 'DD') = 1
		order by dt desc
	<cfelse>
		select
		dt beg_wk_date,
		dt + 6 end_wk_date,
		to_char (dt, 'mm/dd/yyyy') strdate,
		to_char(dt + 6,'mm/dd/yyyy') strend
		from
		(
		select
			(
			select min(reporting_date)
			from bun_vis_plant_sumry
			)
			+ rownum dt
			from bun_vis_plant_sumry
			where rownum <=
				(
				select max(reporting_date)
				from bun_vis_plant_sumry
				)
				-
				(
				select min(reporting_date)
				from bun_vis_plant_sumry
				)
		)
		where to_char (dt, 'd') = 7
		order by dt desc
 	</cfif>
	</cfquery>
	
	<cfset ar = ArrayNew(2)>
	<cfloop query="DateSelect">
		<cfset ar[currentrow][1]= strDate>      
		<cfset ar[currentrow][2]= strEnd>                  
	</cfloop>        
	<cfreturn ar>
</cffunction>

<cffunction name="getPlantTrend" access="remote" returntype="array">
<cfargument name="ReqId" type="string" required="yes">
<cfargument name="dsn" type="string" required="yes">
<cfargument name="dtFrom" type="string" required="yes">
<cfargument name="dtTo" type="string" required="yes">
<cfargument name="selRange" type="string" required="yes">        
<cfargument name="selArea" type="string" required="no" default="">
<cfargument name="selDistrict" type="string" required="no" default="">
<cfargument name="selFacility" type="string" required="no" default="">
<cfargument name="selFSS" type="string" required="no" default="">
<cfargument name="selSV" type="string" required="no" default="">

<cfset selArea = Replace(selArea, "'", "", "ALL")>
<cfset selDistrict = Replace(selDistrict, "'", "", "ALL")>
<cfset selFacility = Replace(selFacility, "'", "", "ALL")>
<cfset dtFrom = DateFormat(dtFrom, "MM/DD/YYYY")>
<cfset dtTo = selRange is "MON" ? DateAdd("M", 1, dtFrom) - 1 : dtTo>
<cfset dtSort = DateFormat(dtFrom, 'YYYYMMDD')>

<cfquery name="DataSelect" datasource="#dsn#" blockfactor="100">
select '#dtFrom#' strDate,
'#dtSort#' sortDate,
intNonNested,
case when nvl(intTotal, 0) > 0 then
	1 - intNonNested / intTotal
end pctNested
from
	(
	select
	sum(plnt_fs_procss_bndl_cnt) - sum(plnt_fs_afsmfs_procss_bndl_cnt) intTotal,
	sum(plnt_fs_procss_bndl_cnt) - sum(plnt_fs_nested_bndl_cnt) intNonNested
	from bun_vis_plant_sumry rept
	where rept.reporting_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
	and rept.reporting_date <= <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
	<cfif selFSS is not "">
		and fss_zone_destn_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#selFSS#">
	</cfif>
	<cfif selSV is not "">
		and fac_sv_ind = <cfqueryparam cfsqltype="cf_sql_char" value="#selSV#">
	</cfif>
	<cfif selArea is not "">
		and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
	</cfif>
	<cfif selDistrict is not "">
		and rept.dist_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selDistrict#">)
	</cfif>
	<cfif selFacility is not "">
		and rept.fac_seq_id in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selFacility#">
	</cfif>
	)
</cfquery>
<cfset aryData = ArrayNew(2)>
<cfset lstCols = DataSelect.columnList>
<cfset aryData[1] = ListToArray(DataSelect.columnList)>
<cfoutput query="DataSelect">
	<cfset idx = "0">
	<cfloop list="#lstCols#" index="col">
		<cfset aryData[2][++idx] = Evaluate(col)>
	</cfloop>
</cfoutput>
<cfset aryData[3][1] = ReqId>
<cfreturn aryData>
</cffunction>

</cfcomponent>