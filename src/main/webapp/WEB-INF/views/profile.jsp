<%@page import="org.springframework.ui.ModelMap"%>
<%@page import="org.springframework.ui.Model"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="edu.neu.cs5500.Jerks.apiCall.*, edu.neu.cs5500.Jerks.definitions.*,java.io.*,java.util.*,java.text.*, edu.neu.cs5500.Jerks.dbProviders.*, edu.neu.cs5500.Jerks.business.*, com.google.gson.Gson ,java.util.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
	<spring:url value="/resources/js/GeoLocation.js" var="GeoLocator" />
	<spring:url value="/resources/js/GoogleMaps.js" var="GoogleMaps" />
	<spring:url value="/resources/css/main.css" var="MainCSS" />
	<spring:url value="/resources/js/bootstrap.min.js" var="BootStrap" />
	<spring:url value="/resources/img/favicon.GIF" var="favIcon" />
	<spring:url value="/resources/js/Login.js" var="Login" />
	<spring:url value="/resources/img/brandImage.JPG" var="brandIcon" />
<%	
	UserProvider userDao = new UserProvider();
	String username = "";
	User user = null;
	String firstName = "";
	String lastName = "";
	String password = "";
	Address address = null;
	String addressLine1 = "";
	String addressLine2 = "";
	String city = "";
	String state = "";
	String zipCode = "";
	String latitude = String.valueOf(session.getAttribute("latitude"));
	System.out.println("Profile update: "+latitude);
	String longitude = String.valueOf(session.getAttribute("longitude"));
	System.out.println("Profile update: "+longitude);
	List<String> areaOfInterest = null;
	List<String> dislikes = null;
	String gender = "";
	String phoneNumber = "";
	Date dob = null;
	String date="";
	try
	{
		username = String.valueOf(session.getAttribute("username"));
		System.out.println("Yo from profile page: "+username);
		user = userDao.findByEmail(username);
		firstName = user.getFirstName();
		lastName = user.getLastName();
		password = user.getPassword();
		address = user.getAddress();
		addressLine1 = address.getAddressLine1();
		addressLine2 = address.getAddressLine2();
		city = address.getCity();
		state = address.getState();
		zipCode = address.getZipCode();
		areaOfInterest = user.getAreaOfInterest();
		dislikes = user.getDislikes();
		phoneNumber = user.getPhoneNumber();
		dob = user.getDOB();
		Calendar myCal = new GregorianCalendar();
		myCal.setTime(dob);
		
		date = String.valueOf(myCal.get(Calendar.YEAR)) + "-" + String.valueOf(myCal.get(Calendar.MONTH) + 1) + "-" + String.valueOf(myCal.get(Calendar.DAY_OF_MONTH));
	}
	catch(Exception e)
	{
		System.out.println("Updating the user");
	}
	
%>
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" />
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/font-awesome/4.0.0/css/font-awesome.css" />
<link rel="stylesheet" type="text/css" href="${MainCSS}">
<link rel="icon" type="image/gif" href="${favIcon}" />
<script src="${GeoLocator}"></script>
<script src="http://maps.googleapis.com/maps/api/js?key="></script>
<script src="${GoogleMaps}"></script>
<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="${BootStrap}"></script>
<script src="${Login}"></script>
<title>WHAM - Home</title>
<script>
		$(function() {
			$( "#datepicker" ).datepicker({ dateFormat: 'yy-mm-dd' }).val();
		});
</script>
</head>
<body>
	<div class="container-fluid">
		<!-- Header Start -->
		<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
			<div class="navbar-header">
				<a class="navbar-brand" rel="home" href="/jerks"><img
					src="${brandIcon}" alt="WHAM"
					style="width: 42px; height: 42px; border: 0;"></a>
				<ul class="nav navbar-nav">
					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown"><label><%=firstName %>
							</label><span
							class="glyphicon glyphicon-user icon-large brown pull-left">&nbsp;</span></a>
						<ul class="dropdown-menu">
							<li><a href="/jerks/createEvents">Create Event<span
									class="glyphicon glyphicon-bullhorn icon-large brown pull-right"></span></a></li>
							<li class="divider"></li>
							<li><a href="/jerks/profile">Profile<span
									class="glyphicon glyphicon-cog icon-large brown pull-right"></span></a></li>
							<li class="divider"></li>
							<li><a href="/jerks/history">My Events<span
									class="glyphicon glyphicon-time icon-large brown pull-right"></span></a></li>
							<li class="divider"></li>
							<li><a href="/jerks/logout">Logout<span
									class="glyphicon glyphicon-off icon-large brown pull-right"></span></a></li>
						</ul></li>
				</ul>
				
 				</div> 				
 					<div class="form-group">
					<form action="/jerks/login" method="post">
						<input type = "hidden" name="username" value=<%=username %>>
						<input type = "hidden" name="password" value=<%=password %>>
						<input type ="hidden"  name="latitude" value = "${latitude}"> 
						<input type ="hidden"  name="longitude" value ="${longitude}"> 
						<button type="submit" class="btn btn-success navbar-btn">New Search</button>
					</form>
				</div>
				</div>
		</div>
	<!-- Header End -->
	<div>
		<div id="profileDetails" class="eventDetails">
		<div class="wrapper" style = "width: 40%; margin:0 auto;">
				<H3 id="name">Update your Details</H3>
				<form action="/jerks/update" method="post">
					<div class="form-group">
					<label>First Name</label>
					 <input type="text" name="firstName" value="<%=firstName %>" class="form-control">
					</div>
					<div class="form-group">
					<label>Last Name</label>
					 <input type="text" name="lastName" value="<%=lastName %>" class="form-control">
					</div>
					<div class="form-group">
					<label>Email</label>
					 <input type="text" name="username" value="<%=username %>" class="form-control" readonly>
					</div>
					<div class="form-group">
					<label>Password</label>
					 <input type="password" name="password" value="<%=password %>"  pattern=".{8,20}" class="form-control" title="Enter a valid Password. (Minimum length is 8. Password requires Uppercase, lowercase and a Number )">
					</div>
					<div class="form-group">
					<label>Address Line 1</label>
					 <input type="text" name="addrLine1" value="<%=addressLine1 %>" class="form-control">
					</div>
					<div class="form-group">
					<label>Address Line 2</label>
					 <input type="text" name="addrLine2" value="<%=addressLine2 %>" class="form-control">
					</div>
					<div class="form-group">
					<label>City</label>
					 <input type="text" name="city" value="<%=city %>" class="form-control">
					</div>
					<div class="form-group">
					<label>State</label>
					 <input type="text" name="state" value="<%=state %>" class="form-control">
					</div>
					
		<div class="form-group">
            <label>Zip Code</label>
            <input type="text" name="zipCode" value="<%=zipCode %>" pattern=".{5,}" class="form-control" title="Enter valid Zip Code">
        </div> 
		 
		<div class="form-group" >
            <label>Date</label>
            <input type="text" name="datepicker" id="datepicker" value="<%=date %>" class="form-control">
        </div> 
				
		<div class="form-group">
            <label>Phone Number</label>
            <input type="phoneNumber" name="phoneNumber" value="<%=phoneNumber %>" pattern=".{10,}"  title="Enter a valid 10 digit Phone number (Numbers only)." class="form-control" > 
        </div>
       
        <input type ="hidden"  name="latitude" value = "<%=latitude%>"> 
		<input type ="hidden"  name="longitude" value ="<%=longitude %>">  
		<input type ="hidden"  name="optradio" value ="<%=gender %>">  
		<button type="submit" class="btn btn-success navbar-btn">Update</button>
				</form>
				</div>
			</div>
	</div>
	<div class="footer">		
		<p style="float:center">&copy; JeRKS (CS5500)</p>
		<p style="float:right">CCIS - Northeastern University</p>
	</div>

</body>
</html>