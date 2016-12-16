<!---Application.cfm specific to IMb Service Performance Measurement - define datasources & application (adapted from IMAQ version)
--->

<!--- set data source variable --->
<cfset datasource = "spmweb_user">
<cfset opsvisdata = "opsvis_user">
<cfset app_name = "opsvis_user"> <!---for compatifility w/ OpsVis--->
<!---path for login routine--->
<cfset login_path = "https://ime-prod.usps.gov/login_spm.cfm">
<!---current directory for redirection from login routine--->
<cfset current_path = "http://" & cgi.HTTP_HOST & GetDirectoryFromPath(cgi.script_name)>
<cfapplication name="#app_name#"
		sessionmanagement="yes"
		setclientcookies="no"
		setdomaincookies="no"
		sessiontimeout="#CreateTimeSpan(0,0,60,0)#"
		clientmanagement="no">
<!---cferror type="exception" template="error.cfm"--->
<!---insert row into web usage log--->
<cftry>
	<cflock scope="session" type="readonly" timeout="10">
	<cfif isDefined("session.username")>
		<cfset strACEID = session.username>
	</cfif>
	<cfparam name="strACEID" default="">
	</cflock>
	<cfparam name="cookie.CFID" default="null">
	<cfset intCFID = cookie.CFID>
	<cfset strScript = GetFileFromPath(cgi.SCRIPT_NAME)>
	<cfset strAddr = cgi.REMOTE_ADDR>
	<cfset inet = CreateObject("java", "java.net.InetAddress")>
	<cfset inet = inet.getLocalHost()>
	<cfset strHostName = inet.getHostName()>
	<cfquery datasource="#opsvisdata#">
	insert into spmweb_access_log_t (remote_addr, CFID, script_name, host_name, ACE_ID)
	values ('#strAddr#', #intCFID#, '#strScript#', '#strHostName#', '#strACEID#')
	</cfquery>
<cfcatch>
	<!---we can add something here if we want to track errors, for now just continue on--->
</cfcatch>
</cftry>
