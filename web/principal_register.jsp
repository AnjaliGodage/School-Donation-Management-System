<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Principal Registration</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: #f3f6fb;
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100vh;
      margin: 0;
      padding: 20px;
    }
    .card {
      width: 520px;
      background: #fff;
      padding: 26px;
      border-radius: 8px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.08);
    }
    h2 {
      color: #2b6cb0;
      margin: 0 0 12px;
      text-align: center;
    }
    label {
      display: block;
      margin-top: 10px;
      font-weight: 600;
    }
    input[type=text],
    input[type=email],
    input[type=number],
    input[type=tel],
    input[type=file] {
      width: 100%;
      padding: 10px;
      margin-top: 6px;
      border-radius: 6px;
      border: 1px solid #ccd;
      box-sizing: border-box;
    }
    button {
      margin-top: 16px;
      width: 100%;
      padding: 12px;
      background: #2b6cb0;
      color: #fff;
      border: none;
      border-radius: 6px;
      font-weight: 700;
      cursor: pointer;
    }
    .back-link {
      display: block;
      margin-top: 12px;
      text-align: center;
      color: #666;
      text-decoration: none;
    }
    .error {
      color: #d32f2f;
      margin-top: 10px;
      font-weight: bold;
      text-align: center;
    }
    .message {
      color: green;
      margin-top: 10px;
      font-weight: bold;
      text-align: center;
    }
  </style>
</head>
<body>
  <div class="card">
    <h2>Register as Principal</h2>

    <% 
       String success = (String) request.getAttribute("success");
       String error = (String) request.getAttribute("error");
       if(success != null){ %>
         <div class="message"><%= success %></div>
    <% } 
       if(error != null){ %>
         <div class="error"><%= error %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/PrincipalRegisterServlet" method="post" enctype="multipart/form-data">
      <label>School Name</label>
      <input type="text" name="school_name" required />

      <label>Principal Name</label>
      <input type="text" name="principal_name" required />

      <label>Email</label>
      <input type="email" name="email" required />

      <label>Phone Number</label>
      <input type="tel" name="phone_number" required pattern="[0-9]{10}" title="Enter 10-digit phone number" />

      <label>Service Period (Years)</label>
      <input type="number" name="service_period" required min="0" />

      <label>Employee Number</label>
      <input type="text" name="employee_number" required />

      <label>School Address</label>
      <input type="text" name="school_address" required />

      <label>Proof Document (PDF/Image)</label>
      <input type="file" name="proof_document" accept=".pdf,.jpg,.png" required />

      <button type="submit">Register</button>
    </form>

    <a class="back-link" href="<%= request.getContextPath() %>/principal_login.jsp">← Back to Login</a>
  </div>
</body>
</html>
