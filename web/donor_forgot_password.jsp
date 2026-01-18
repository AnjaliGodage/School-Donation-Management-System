<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Donor Forgot Password</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background: #f4f4f4; 
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container { 
            width: 400px; 
            padding: 30px; 
            background: #fff; 
            border-radius: 8px; 
            box-shadow: 0px 0px 15px rgba(0,0,0,0.1); 
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        input {
            padding: 12px 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
        button {
            padding: 12px;
            margin-top: 15px;
            background: #007BFF;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background: #0056b3;
        }
        .message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
        }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .back-link {
            display: block;
            margin-top: 15px;
            text-align: center;
        }
        .back-link a {
            text-decoration: none;
            color: #007BFF;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Donor Forgot Password</h2>

    <% if(request.getAttribute("success") != null){ %>
        <div class="message success"><%= request.getAttribute("success") %></div>
    <% } %>

    <% if(request.getAttribute("error") != null){ %>
        <div class="message error"><%= request.getAttribute("error") %></div>
    <% } %>

    <form action="DonorForgotPasswordServlet" method="post">
        <input type="text" name="username" placeholder="Enter your username" required>
        <input type="email" name="email" placeholder="Enter your registered email" required>
        <input type="password" name="newPassword" placeholder="Enter new password" required>
        <button type="submit">Reset Password</button>
    </form>

    <div class="back-link">
        <a href="donor_login.jsp">Back to Login</a>
    </div>
</div>
</body>
</html>
