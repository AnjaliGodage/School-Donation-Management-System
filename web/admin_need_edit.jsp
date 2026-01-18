<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%
    ResultSet need = (ResultSet) request.getAttribute("need");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Edit Request — Admin</title>
<style>
body{font-family:Arial,sans-serif;background:#f3f6fb;padding:20px;}
form{max-width:600px;margin:0 auto;background:#fff;padding:20px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.05);}
label{display:block;margin-top:10px;font-weight:600;}
input,textarea,select{width:100%;padding:8px;margin-top:4px;border-radius:6px;border:1px solid #ccc;}
button{margin-top:15px;padding:10px 15px;background:#2b6cb0;color:#fff;border:none;border-radius:6px;cursor:pointer;}
button:hover{background:#235a98;}
</style>
</head>
<body>
<h2>Edit Request — Admin</h2>
<%
if(need != null){
%>
<form action="<%= request.getContextPath() %>/admin/NeedEditServlet" method="post">
<input type="hidden" name="id" value="<%=need.getInt("id")%>">
<label>Title</label>
<input type="text" name="title" value="<%=need.getString("title")%>" required>
<label>Description</label>
<textarea name="description" required><%=need.getString("description")%></textarea>
<label>Quantity</label>
<input type="number" name="quantity" value="<%=need.getInt("quantity")%>" required>
<label>Status</label>
<select name="status">
    <option value="open" <%= "open".equals(need.getString("status"))?"selected":"" %>>Open</option>
    <option value="fulfilled" <%= "fulfilled".equals(need.getString("status"))?"selected":"" %>>Fulfilled</option>
</select>
<button type="submit">Save Changes</button>
</form>
<% } else { %>
<p>Request not found.</p>
<% } %>
</body>
</html>
