<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    List<Map<String,Object>> donors = (List<Map<String,Object>>) request.getAttribute("donors");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Donor List</title>
<style>
body{font-family:Arial;background:#f4f7fc;margin:20px;}
table{width:100%;border-collapse:collapse;background:#fff;border-radius:8px;overflow:hidden;box-shadow:0 5px 12px rgba(0,0,0,0.1);}
th,td{padding:12px;border-bottom:1px solid #eee;}
th{background:#2b6cb0;color:#fff;}
.btn{padding:6px 10px;background:#2b6cb0;color:#fff;border-radius:5px;text-decoration:none;font-size:13px;}
.btn:hover{background:#1e4f85;}
.btn-delete{background:red;}
.btn-delete:hover{background:#b22222;}
</style>
</head>
<body>

<h2>Donor List</h2>
<% if (error != null) { %>
<p style="color:red;"><%= error %></p>
<% } %>

<table>
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Email</th>
    <th>Phone</th>
    <th>Username</th>
    <th>Actions</th>
</tr>

<%
if (donors == null || donors.isEmpty()) {
%>
<tr><td colspan="6" style="text-align:center;color:red;">No donors found.</td></tr>
<%
} else {
    for (Map<String,Object> d : donors) {
%>
<tr>
    <td><%= d.get("id") %></td>
    <td><%= d.get("first_name") %> <%= d.get("last_name") %></td>
    <td><%= d.get("email") %></td>
    <td><%= d.get("phone") %></td>
    <td><%= d.get("username") %></td>
    <td>
        <a href="<%=request.getContextPath()%>/admin/donor/view?id=<%= d.get("id") %>" class="btn">View</a>
    </td>
</tr>
<%
    }
}
%>
</table>

<br>
<a href="<%= request.getContextPath() %>/admin_dashboard.jsp">Back to Dashboard</a>

</body>
</html>
