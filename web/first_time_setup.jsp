<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>First Time Login</title>
<style>
body{font-family:Arial;background:#f3f6fb;display:flex;align-items:center;justify-content:center;height:100vh;margin:0;}
.card{width:440px;background:#fff;padding:26px;border-radius:10px;box-shadow:0 8px 24px rgba(0,0,0,0.1);}
h2{text-align:center;color:#2b6cb0;margin-bottom:12px;}
input{width:100%;padding:10px;margin-top:6px;border-radius:6px;border:1px solid #ccd;}
button{margin-top:16px;width:100%;padding:12px;background:#2b6cb0;color:#fff;border:none;border-radius:6px;font-weight:bold;cursor:pointer;}
.error{color:red;text-align:center;margin-top:10px;}
.success{color:green;text-align:center;margin-top:10px;}
.link{text-align:center;margin-top:10px;display:block;color:#2b6cb0;text-decoration:none;}
</style>
</head>
<body>
<div class="card">
<h2>First Time Login</h2>

<div class="error"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></div>
<div class="success"><%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %></div>

<form action="<%= request.getContextPath() %>/FirstTimeLoginServlet" method="post">
    Employee Number:
    <input type="text" name="employee_number" value="<%= request.getAttribute("employee_number") != null ? request.getAttribute("employee_number") : "" %>" required>

    New Password:
    <input type="password" name="new_password" required>

    Confirm Password:
    <input type="password" name="confirm_password" required>

    <button type="submit">Set Password</button>
</form>

<a class="link" href="principal_login.jsp">← Back to Login</a>
</div>
</body>
</html>
