<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !"principal".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/principal_login.jsp");
        return;
    }

    Integer needId = (Integer) request.getAttribute("needId");
    String title = (String) request.getAttribute("title");
    String category = (String) request.getAttribute("category");
    String description = (String) request.getAttribute("description");
    java.math.BigDecimal amount = (java.math.BigDecimal) request.getAttribute("amount");
    java.sql.Date deadline = (java.sql.Date) request.getAttribute("deadline");
    String status = (String) request.getAttribute("status");
    String account = (String) request.getAttribute("account");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Edit Request</title>
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
<h2>Edit Request</h2>
<form action="<%= request.getContextPath() %>/EditNeedServlet" method="post">
    <input type="hidden" name="id" value="<%= needId %>">

    <label>Title</label>
    <input type="text" name="title" value="<%= title %>" required>

    <label>Category</label>
    <select name="category">
        <option <%= "Infrastructure".equals(category)?"selected":"" %>>Infrastructure</option>
        <option <%= "Supplies".equals(category)?"selected":"" %>>Supplies</option>
        <option <%= "Education".equals(category)?"selected":"" %>>Education</option>
        <option <%= "Other".equals(category)?"selected":"" %>>Other</option>
    </select>

    <label>Description</label>
    <textarea name="description" required><%= description %></textarea>

    <label>Amount (optional)</label>
    <input type="number" step="0.01" name="amount_needed" value="<%= amount != null ? amount.toPlainString() : "" %>">

    <label>Deadline (optional)</label>
    <input type="date" name="deadline" value="<%= deadline != null ? deadline.toString() : "" %>">

    <label>Status</label>
    <select name="status">
        <option value="open" <%= "open".equals(status)?"selected":"" %>>Open</option>
        <option value="fulfilled" <%= "fulfilled".equals(status)?"selected":"" %>>Fulfilled</option>
    </select>

    <label>Account Number (optional)</label>
    <input type="text" name="account_number" value="<%= account != null ? account : "" %>">

    <button type="submit">Save Changes</button>
</form>
</body>
</html>
