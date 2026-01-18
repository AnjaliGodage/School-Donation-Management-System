<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
    <style>
        body {
            font-family: sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: #f0f4f8;
        }
        .login-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            width: 320px;
        }
        input[type=text], input[type=password] {
            width: 100%;
            padding: 10px 40px 10px 12px; /* extra padding for eye icon */
            margin: 8px 0;
            border-radius: 6px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        input[type=submit] {
            width: 100%;
            padding: 10px;
            border: none;
            background: #2b6cb0;
            color: white;
            border-radius: 6px;
            cursor: pointer;
        }
        input[type=submit]:hover { background:#235a98; }
        .error { color:red; margin-bottom:10px; }

        /* Eye toggle styles */
        .pw-toggle {
            position: absolute;
            right: 10px;
            top: 37px;
            width: 24px;
            height: 24px;
            border: none;
            background: transparent;
            cursor: pointer;
            padding: 0;
        }
        .eye-icon { width: 24px; height: 24px; fill: rgba(0,0,0,0.5); }

        .form-row { position: relative; margin-bottom: 12px; }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Admin Login</h2>

    <% String error = (String) request.getAttribute("errorMessage");
       if(error != null){ %>
        <div class="error"><%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/AdminLoginServlet" method="post">
        <div class="form-row">
            <label>Username</label>
            <input type="text" name="username" required>
        </div>

        <div class="form-row">
            <label>Password</label>
            <input type="password" id="password" name="password" required>
            <button type="button" class="pw-toggle" id="pwToggle" aria-label="Show password">
                <svg class="eye-icon" viewBox="0 0 24 24">
                    <path d="M12 5c-7 0-11 7-11 7s4 7 11 7 11-7 11-7-4-7-11-7zm0 12a5 5 0 1 1 0-10 5 5 0 0 1 0 10z"></path>
                    <circle cx="12" cy="12" r="2.5"></circle>
                </svg>
            </button>
        </div>

        <input type="submit" value="Login">
    </form>
</div>

<script>
    (function(){
        var pwInput = document.getElementById('password');
        var toggle = document.getElementById('pwToggle');

        var eyeSvg = '<svg class="eye-icon" viewBox="0 0 24 24"><path d="M12 5c-7 0-11 7-11 7s4 7 11 7 11-7 11-7-4-7-11-7zm0 12a5 5 0 1 1 0-10 5 5 0 0 1 0 10z"></path><circle cx="12" cy="12" r="2.5"></circle></svg>';
        var eyeOffSvg = '<svg class="eye-icon" viewBox="0 0 24 24"><path d="M2 4l20 16M4.8 6.6C2.9 8.2 1.6 10 1 11c1.5 3.2 6 8 11 8 1.8 0 3.5-.4 5-1.1"></path><path d="M9.5 9.5a2.5 2.5 0 0 0 3.5 3.5"></path></svg>';

        toggle.addEventListener('click', function(){
            if(pwInput.type === 'password'){
                pwInput.type = 'text';
                toggle.innerHTML = eyeOffSvg;
            } else {
                pwInput.type = 'password';
                toggle.innerHTML = eyeSvg;
            }
        });
    })();
</script>
</body>
</html>
