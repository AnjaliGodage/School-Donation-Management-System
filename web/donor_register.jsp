<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Donor Registration</title>
  <style>
    body{font-family:Arial,Helvetica,sans-serif;background:#f3f6fb;display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0;padding:20px}
    .card{width:520px;background:#fff;padding:26px;border-radius:8px;box-shadow:0 8px 24px rgba(0,0,0,0.08)}
    h2{color:#2b6cb0;margin:0 0 12px;text-align:center}
    .row{display:flex;gap:10px}
    .col{flex:1}
    label{display:block;margin-top:10px;font-weight:600}
    input[type=text],input[type=email],input[type=date],input[type=password]{width:100%;padding:10px;margin-top:6px;border-radius:6px;border:1px solid #ccd;box-sizing:border-box}
    textarea{width:100%;padding:10px;border-radius:6px;border:1px solid #ccd}
    button{margin-top:16px;width:100%;padding:12px;background:#2b6cb0;color:#fff;border:none;border-radius:6px;font-weight:700;cursor:pointer}
    .back-link{display:block;margin-top:12px;text-align:center;color:#666;text-decoration:none}
    .error{color:#d32f2f;margin-top:10px}
  </style>
</head>
<body>
  <div class="card">
    <h2>Create Donor Account</h2>
    <% String err = (String) request.getAttribute("errorMessage"); if (err != null) { %>
      <div class="error"><%= err %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/DonorRegisterServlet" method="post">
      <div class="row">
        <div class="col">
          <label>First Name</label>
          <input type="text" name="firstName" required />
        </div>
        <div class="col">
          <label>Last Name</label>
          <input type="text" name="lastName" required />
        </div>
      </div>

      <label>Date of Birth</label>
      <input type="date" name="dob" required />

      <label>Address</label>
      <input type="text" name="address" required />

      <div class="row">
        <div class="col">
          <label>Phone</label>
          <input type="text" name="phone" required />
        </div>
        <div class="col">
          <label>Email</label>
          <input type="email" name="email" required />
        </div>
      </div>

      <label>Username</label>
      <input type="text" name="username" required />

      <label>Password</label>
      <input type="password" name="password" required />

      <button type="submit">Register</button>
    </form>

    <a class="back-link" href="${pageContext.request.contextPath}/donor_login.jsp">← Back to Login</a>
  </div>
</body>
</html>
