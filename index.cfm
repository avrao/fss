<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
<link rel="stylesheet" href="styles/app.css">
<link rel="stylesheet" href="styles/bootstrap.css">
<link rel="stylesheet" href="styles/side-nav.css">
</head>

<body>
<div class="header-nav headerTemplate ng-scope" id="headerTemplate" ng-controller="naviController" ng-class="{'lateral-menu-is-open':showNavMenu}">
	<div class="iv-left pull-left">
		<!-- ngIf: isLoggedin() --><div class="menuTrigger pull-left iv-home-link ng-scope" id="navGuideMenus" ng-if="isLoggedin()" ng-click="toggleNavMenu()">
			<!--<a id="nav-toggle" ng-class="{'active': showNavMenu }" href="#"><span></span></a> -->
			<img title="Menu" class="iv-menu" src="images/menu.png">
		</div><!-- end ngIf: isLoggedin() --> 
		 <div class="iv-home-link" ui-sref="home">
		 	<span><img class="iv-logo pull-left" alt="United States Potal Service" src="images/iv-logo.png"> 
			</span> 
			<span class="pull-left" id="projectBranding" style="font-weight: bold;">
					<div id="projectTitle">Informed Visibility Test</div>

					<div id="projectSlogan">The single source for all your mail
						visibility needs.</div>
			</span>
		</div>
	</div>
	<!-- ngIf: isLoggedin() --><div class="iv-right pull-right ng-scope" id="focusDummy" ng-if="isLoggedin()">
		<div class="logoutTrigger iv-home-link" ng-click="logout()">
		<span><img title="Logout" class="iv-logo pull-right" alt="logout" src="images/logout-icon.png"> 
			
		</span></div>
	</div><!-- end ngIf: isLoggedin() -->
	<!---div class="alert alert-info bubbleGuide ng-hide" style="border-radius: 10px; border: currentColor; border-image: none; width: 175px; height: 60px; color: white; margin-top: 85px; display: none; background-color: rgb(255, 201, 51); -webkit-text-stroke: white .1px;" ng-show="$state.current.name === 'spm' &amp;&amp; toggledHeader !== true">
		
		<a class="close" style="margin: -31px -26px 0px 0px; height: 35px;" aria-label="close" href="" data-dismiss="alert"><img style="top: 0px; height: 35px; right: 0px;" src="assets/img/icons/close_2x.png"></a>
		
		<div class="col-sm-12" style="padding: 0px; margin-top: -5px;">
			<div class="col-sm-3">
				<img style="height: 17px; cursor: pointer;" src="assets/img/icons/Switch_SM_ON.png" ng-click="switchToggle()" ng-src="assets/img/icons/Switch_SM_ON.png">
			</div>
			<div class="col-sm-9">
				<span style="font-size: 13px;">First time here? <br>Turn on tips.</span>
			</div>
		</div>
	</div>
	<div class="row col-sm-12 sysAlertOuterDiv">
		<!-- ngIf: systemAlertError -->
	</div--->
</div>
<div class="main-view ng-scope" ui-view="">
<section class="landing-page-wrapper ng-scope">
	<!---div class="row col-xs-12">
		<div class="pull-left col-xs-12">
			<img src="assets/img/icons/arrow.png"> <span class="arrow-title">Main
				Menu</span>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-12">
			<div class="iv-container">
				<div class="col-xs-12 col-md-4 col-md-offset-4 landing-page-message">
					<p class="title">Welcome</p>

					<p class="message">Informed Visibility (IV) is your solution to
						gaining current, critical insight into end-to-end mail visibility.
						From the main menu in the toolbar, you will be able to access
						dozens of reports to better manage and understand mail operations
						and performance. Currently, you may view the Service Performance
						Measurement (SPM) Sampling metrics reports. Additional reports and
						site enhancements will continue to become available over time.</p>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-12">
			<div class="iv-container">
				<div class="col-xs-4 col-xs-offset-4">
					<center>
						<div class="btn btn-primary" ng-click="goToSPM()">Jump to SPM Sampling</div>
					</center>
				</div>
			</div>
		</div>
	</div--->
</section>
</div>
</body>
</html>