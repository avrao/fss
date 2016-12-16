<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>IV Login</title>
<link rel="stylesheet" href="styles/app.css">
<link rel="stylesheet" href="styles/bootstrap.css">
</head>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<body onLoad="">
<div class="iv-login-wrapper ng-scope"<!--- ng-controller="loginCtrl"--->>

	<div class="row">
		<div class="col-lg-12 col-md-12  col-sm-12 col-xs-12 login-section">
		<!---<form class="ng-pristine ng-invalid ng-invalid-required ng-valid-maxlength form-signin form-group" ng-class="{'has-error': error, 'form-signin':true, 'form-group':true}" method="post">--->
		<form name="frmLogin" class="form-signin form-group" action="login_a_iv.cfm" target="winLogin" method="post" onSubmit="">
		<img id="imgLogo" src="images/logo-large.png">
		<h2 class="form-signin-heading">Login</h2>
		<!---<input name="aceID" class="form-control ng-pristine ng-invalid ng-invalid-required ng-valid-maxlength ng-touched" autofocus required type="text" maxlength="10" placeholder="ACE ID" ng-class="{'has-error': error}" ng-model="credentials.userId">---> 
		<input name="aceID" class="form-control" autofocus required type="text" maxlength="10" placeholder="ACE ID"> 
		<!---<input name="acePassword" class="form-control ng-pristine ng-untouched ng-invalid ng-invalid-required ng-valid-maxlength" required="" type="password" maxlength="50" placeholder="Password" ng-class="{'has-error': error}" ng-model="credentials.password">--->
		<input name="acePassword" class="form-control" required="" type="password" maxlength="50" placeholder="Password">
		<!---p class="ng-binding ng-hide" ng-show="error">Your session has expired. Please login again
		<p--->
		<button id="btnLogin" class="btn btn-lg btn-primary btn-block" type="submit" <!---ng-click="checkLogin()"--->>Login</button>
		</p>
		</form>
		</div>
	</div>
		
	<!-- <form action="/spm-report-ex.html">
	<input type="text" name="ace-id" placeholder="ACE ID">
	<input type="password" name="password" placeholder="Password">
	<input type="submit" value="Login" class="btn">
	</form> -->
	<div class="row iv-login-disclaimer">
		<div class=" col-lg-12 col-md-12  col-sm-12 col-xs-12">
			<div class="iv-disclaimer-table">
				<div class="iv-disclaimer-header">
				<span>Restricted Information</span>
				</div>
				<div>
				<span class="iv-disclaimer-body">This is a U.S. Government
				computer system and is intended for official and other authorized
				use only. Unauthorized access or use of this system may subject
				violators to administrative action, civil, and/or criminal
				prosecution under the United States Criminal Code (Title 18 U.S C.
				§ 1030). All information on this computer system may be
				monitored, intercepted, recorded, read, copied, or captured and
				disclosed by and to authorized personnel for official purposes,
				including criminal prosecution. You have no expectations of
				privacy using this system. Any authorized or unauthorized use of
				this computer system signifies consent to and compliance with
				postal service policies and these terms.</span>
				</div>
			</div>
			
		</div>
	</div>

</div>
<div id="iv-wheelOverlay" style="display: none;" loading="">
	<div class="iv-load-container">
		<center>
			<div class="iv-outside-container">
				<div class="iv-inside-spinner"></div>
				<div class="iv-outside-spinner"></div>
		</div></center>
		<h1 id="iv-loading-message">Loading</h1>
	</div>
</div>
<iframe name="winLogin" style="display: none;"></iframe>
</body>
</html>