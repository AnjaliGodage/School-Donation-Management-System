<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Forgot Password - Principal</title>
  <style>
    body{font-family:Arial,Helvetica,sans-serif;background:#f3f6fb;display:flex;align-items:center;justify-content:center;height:100vh;margin:0;padding:20px}
    .card{width:460px;background:#fff;padding:26px;border-radius:8px;box-shadow:0 8px 24px rgba(0,0,0,0.08)}
    h2{color:#2b6cb0;margin:0 0 12px;text-align:center}
    label{display:block;margin-top:10px;font-weight:600}
    input[type=text], input[type=password]{width:100%;padding:10px;margin-top:6px;border-radius:6px;border:1px solid #ccd;box-sizing:border-box}
    .actions{margin-top:18px}
    input[type=submit]{width:100%;padding:12px;background:#2b6cb0;color:#fff;border:none;border-radius:6px;font-weight:700;cursor:pointer}
    .links{display:flex;justify-content:flex-end;margin-top:12px}
    .links a{color:#2b6cb0;text-decoration:none}
    .msg {margin-top:10px;padding:8px;border-radius:6px;}
    .error{background:#ffecec;color:#c72e2e}
    .success{background:#e6ffef;color:#0a7f3a}
  </style>
</head>
<body>
  <div class="card">
    <h2>Reset Password</h2>

    <% 
       String error = (String) request.getAttribute("error");
       String success = (String) request.getAttribute("success");
       if (error != null) { %>
         <div class="msg error"><%= error %></div>
    <% } else if (success != null) { %>
         <div class="msg success"><%= success %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/ForgotPasswordServlet" method="post">
      <label>Employee Number</label>
      <input type="text" name="employee_number" required />

      <label>New Password</label>
      <input type="password" name="new_password" required />

      <label>Confirm New Password</label>
      <input type="password" name="confirm_password" required />

      <div class="actions">
        <input type="submit" value="Reset Password" />
      </div>
    </form>

    <div class="links">
      <a href="<%= request.getContextPath() %>/principal_login.jsp">Back to Login</a>
    </div>
  </div>
</body>
</html>
