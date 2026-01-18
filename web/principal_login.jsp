<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Principal Login</title>

  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">

  <style>
    body {
      margin: 0;
      padding: 0;
      height: 100vh;
      background: #eef3f9;
      display: flex;
      justify-content: center;
      align-items: center;
      font-family: 'Inter', sans-serif;
    }

    .login-wrapper {
      width: 880px;
      height: 540px;
      background: #fff;
      border-radius: 16px;
      overflow: hidden;
      display: flex;
      box-shadow: 0 10px 32px rgba(0,0,0,0.15);
    }

    /* Left Image Panel */
    .left-panel {
      width: 50%;
      background: url('images/girl.jpg') center/cover no-repeat;
    }

    /* Right Form Panel */
    .right-panel {
      width: 50%;
      padding: 50px 40px;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
      align-items: center;
    }

    /* Larger Logo */
    .logo {
      width: 180px;
      height: 180px;
      object-fit: contain;
      margin-bottom: 14px;
      display: block;
    }

    h2 {
      text-align: center;
      color: #2b6cb0;
      margin-bottom: 22px;
      font-size: 26px;
      font-weight: 600;
    }

    /* Controls width of inputs + button */
    .form-container {
      width: 100%;
      max-width: 320px;
      margin-top: 10px;
    }

    .form-group {
      width: 100%;
      margin-bottom: 20px;
      position: relative;
    }

    .input-field {
      width: 100%;
      padding: 14px 12px;
      padding-right: 48px;
      font-size: 16px;
      border: 1px solid #cbd5e0;
      border-radius: 10px;
      transition: 0.3s;
    }

    .input-field:focus {
      border-color: #2b6cb0;
      box-shadow: 0 0 8px rgba(43,108,176,0.25);
      outline: none;
    }

    .pw-toggle {
      position: absolute;
      top: 50%;
      right: 12px;
      transform: translateY(-50%);
      cursor: pointer;
      background: none;
      border: none;
      font-size: 18px;
    }

    input[type="submit"] {
      width: 100%;
      padding: 16px;
      background: #2b6cb0;
      color: #fff;
      border: none;
      border-radius: 10px;
      font-size: 18px;
      cursor: pointer;
      font-weight: 600;
      transition: background 0.3s;
      margin-top: 5px;
    }

    input[type="submit"]:hover {
      background: #1f4f88;
    }

    .links {
      text-align: center;
      margin-top: 20px;
      width: 100%;
    }

    .links a {
      color: #2b6cb0;
      font-size: 14px;
      display: block;
      margin: 5px 0;
      text-decoration: none;
    }

    .links a:hover {
      text-decoration: underline;
    }

    .error {
      color: #d32f2f;
      text-align: center;
      margin-top: -5px;
      margin-bottom: 15px;
      font-size: 14px;
    }

  </style>
</head>

<body>

<div class="login-wrapper">

  <!-- LEFT IMAGE -->
  <div class="left-panel"></div>

  <!-- RIGHT PANEL -->
  <div class="right-panel">

    <img src="images/DonorSchool.png" class="logo" alt="System Logo">

    <h2>Principal Login</h2>

    <% String err = (String) request.getAttribute("error");
       if (err != null) { %>
        <div class="error"><%= err %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/PrincipalLoginServlet" method="post" class="form-container">

      <div class="form-group">
        <input type="text" name="employee_number" class="input-field" placeholder="Employee Number" required>
      </div>

      <div class="form-group">
        <input type="password" name="password" id="password" class="input-field" placeholder="Password" required>
        <button type="button" class="pw-toggle" id="pwToggle">👁️</button>
      </div>

      <input type="submit" value="Login">
    </form>

    <div class="links">
      <a href="principal_register.jsp">Create Account</a>
      <a href="forgot_password.jsp">Forgot Password?</a>
      <a href="first_time_setup.jsp">First Time Login</a>
    </div>

  </div>
</div>

<script>
  const pwInput = document.getElementById('password');
  const toggle = document.getElementById('pwToggle');

  toggle.addEventListener('click', () => {
    pwInput.type = pwInput.type === "password" ? "text" : "password";
  });
</script>

</body>
</html>
