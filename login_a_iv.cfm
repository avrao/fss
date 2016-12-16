<cfparam name="form.aceID" default="">
<cfif form.aceID is "">
	<cfabort>
</cfif>
<cfset strACEid = form.aceID>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Informed Visibility Login</title>
</head>
<body>
<!---cfparam default="true" name="chkUserID"--->


<!---cfldap server="eagandcs.usa.dce.usps.gov"
	  action="QUERY"
	  name="results"
	  start="dc=usa,dc=dce,dc=usps,dc=gov"
	  attributes="sAMAccountName,name"
	  filter="sAMAccountName=#strACEid#"
	  scope="SUBTREE"
	  rebind="Yes"
	  username="USA\ncsce1"
	  password="Outlook2"--->

<!---cfif results.recordcount gt 0--->
<cftry>
<cfldap server="eagandcs.usa.dce.usps.gov"
	action="QUERY"
	name="results"
	start="dc=usa,dc=dce,dc=usps,dc=gov"
	attributes="sAMAccountName,name,telephoneNumber,mail"
	filter="sAMAccountName=#strACEid#"
	scope="SUBTREE"
	rebind="Yes"
	username="USA\#strACEid#"
	password="#form.acePassword#">
	<cfcatch type="any">
		<cfset chkPass="false">
	</cfcatch>
</cftry>
<!---cfelse>
  <cfset chkUserID="false">
</cfif--->
<cfparam name="chkPass" default="TRUE">
<cfif chkPass>
	<cfquery name="qUser" datasource="#opsvisdata#">
	select 'x' from user_t
	where UPPER(ace_id) = UPPER('#strACEid#')
	</cfquery>
	<cfquery name="qContacts" datasource="#opsvisdata#">
	select regexp_replace(first_name || ' ' || middle_name || ' ' || last_name, '( )+', ' ') full_name,
	user_type
	from contacts_t
	where UPPER(ace_id) = UPPER('#strACEid#')
	</cfquery>
	<cfif qContacts.full_name is not "">
		<cfset strFullName = ReReplace(qContacts.full_name, "^( )*$", "Unknown User")>
	<cfelse>
		<cfset strFullName = ReReplace(results.name, "^(.*), *(.*)$", "\2 \1")>
	</cfif>
	<cflock timeout="30" scope="session" type="exclusive">
	<cfset session.username = UCase(strACEid)>
	<!---cfset session.isAdmin = qUser.recordcount GE "1"--->
	<cfset session.fullname = strFullName>
	<!---cfset isAdmin = session.isAdmin--->
	<cfset session.usertype = qContacts.user_type>
	<cfset session.telephone = results.telephoneNumber>
	<cfset session.email = results.mail>
	</cflock>
	<cfif qUser.RecordCount GT 0>
		<!--- set username variable --->
		<cfquery datasource="#opsvisdata#">
		update user_t
		set last_visit_dtm = sysdate
		where UPPER(ace_id) = UPPER('#strACEid#')
		</cfquery>
		<!---session role variables set in svar.cfm
		<cfinclude template="svar.cfm">
		<cfset login_success = "yes">--->
	<cfelse>
		<!---allow access to all ACE IDs--->
	</cfif>
	<script language="javascript">
	var wheel = window.parent.document.getElementById('iv-wheelOverlay');
	wheel.style.display = '';
	var frm = window.parent.frmLogin;
	for (var idx = 0; idx < frm.elements.length; idx ++)
		frm.elements[idx].disabled = true;
	window.parent.location.replace('index.cfm');
	//window.close();
	</script>
<cfelse>
	<script type="text/javascript">
	<!--
	alert('Your ACE Login ID and Password were not recognized. Please try again.');
	// -->
	</script>
</cfif>

</body>
</html>
