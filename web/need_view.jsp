<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%
    Map<String,Object> need = (Map<String,Object>) request.getAttribute("need");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>View School Need</title>
<style>
body{font-family:Arial,sans-serif;background:#f3f6fb;padding:20px;}
.card{background:#fff;padding:24px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.05);max-width:800px;margin:0 auto;}
h2{margin-bottom:16px;color:#2b6cb0;}
p{margin:8px 0;}
</style>
</head>
<body>
<div class="card">
<h2>School Need Details</h2>

<p><strong>ID:</strong> <%= need.get("id") %></p>
<p><strong>School Name:</strong> <%= need.get("school_name") %></p>
<p><strong>Title:</strong> <%= need.get("title") %></p>
<p><strong>Description:</strong> <%= need.get("description") %></p>
<p><strong>Quantity:</strong> <%= need.get("quantity") %></p>
<p><strong>Status:</strong> <%= need.get("status") %></p>
<p><strong>Created At:</strong> <%= need.get("created_at") %></p>

<p><a href="<%= request.getContextPath() %>/school_needs.jsp">← Back to Needs List</a></p>
</div>
</body>
</html>
