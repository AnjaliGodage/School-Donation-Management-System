<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    Map<String,Object> donor = (Map<String,Object>) request.getAttribute("donor");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Donor</title>
<style>
body{font-family:Arial;background:#f4f7fc;margin:20px;}
table{width:50%;border-collapse:collapse;background:#fff;border-radius:8px;overflow:hidden;box-shadow:0 5px 12px rgba(0,0,0,0.1);}
th,td{padding:12px;text-align:left;border-bottom:1px solid #eee;}
th{background:#2b6cb0;color:#fff;width:150px;}
</style>
</head>
<body>

<h2>Donor Details</h2>

<% if (donor == null) { %>
<p style="color:red;">Donor not found.</p>
<% } else { %>
<table>
<tr><th>ID</th><td><%= donor.get("id") %></td></tr>
<tr><th>First Name</th><td><%= donor.get("first_name") %></td></tr>
<tr><th>Last Name</th><td><%= donor.get("last_name") %></td></tr>
<tr><th>DOB</th><td><%= donor.get("dob") %></td></tr>
<tr><th>Address</th><td><%= donor.get("address") %></td></tr>
<tr><th>Phone</th><td><%= donor.get("phone") %></td></tr>
<tr><th>Email</th><td><%= donor.get("email") %></td></tr>
<tr><th>Username</th><td><%= donor.get("username") %></td></tr>
<tr><th>Created At</th><td><%= donor.get("created_at") %></td></tr>
</table>
<% } %>

<br>
<a href="<%= request.getContextPath() %>/admin/donors">Back to Donor List</a>

</body>
</html>
