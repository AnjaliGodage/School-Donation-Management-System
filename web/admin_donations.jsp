<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*, com.example.db.DBConnection" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || role == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    ResultSet donationsRs = null;
    try {
        Connection conn = DBConnection.getConnection();
        donationsRs = conn.prepareStatement(
            "SELECT id, donor_username, request_id, amount, receipt_file, donated_at FROM donations ORDER BY donated_at DESC"
        ).executeQuery();
    } catch (SQLException e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Donations</title>
<style>
body{font-family:"Segoe UI", Roboto, Arial; margin:0; display:flex; background:#f3f7fb;}
nav.sidebar{width:220px; background:#2b6cb0; color:#fff; height:100vh; padding:20px; box-sizing:border-box;}
nav.sidebar h2{margin:0 0 20px 0; font-size:20px;}
nav.sidebar a{display:block; color:#fff; text-decoration:none; margin:10px 0; font-weight:600;}
nav.sidebar a:hover{color:#cce5ff;}
main.content{flex:1; padding:20px;}
table{width:100%; border-collapse:collapse; background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 4px 15px rgba(0,0,0,0.05);}
table th, table td{padding:12px; text-align:left; border-bottom:1px solid #ddd;}
table th{background:#2b6cb0; color:#fff;}
tr:hover{background:#f1f7ff;}
</style>
</head>
<body>

<nav class="sidebar">
  <h2>Admin Menu</h2>
  <a href="<%=request.getContextPath()%>/admin_dashboard.jsp">Dashboard</a>
  <a href="<%=request.getContextPath()%>/admin_principals.jsp">Principals</a>
  <a href="<%=request.getContextPath()%>/admin/donors">Donors</a>
  <a href="<%=request.getContextPath()%>/school_needs.jsp">School Needs</a>
  <a href="<%=request.getContextPath()%>/admin_donations.jsp">Donations</a>
  <a href="<%=request.getContextPath()%>/LogoutServlet">Logout</a>
</nav>

<main class="content">
  <h1>Donations</h1>
  <table>
    <tr>
      <th>ID</th>
      <th>Donor Username</th>
      <th>Request ID</th>
      <th>Amount</th>
      <th>Receipt</th>
      <th>Donated At</th>
    </tr>
    <%
        try {
            while(donationsRs != null && donationsRs.next()) {
    %>
    <tr>
      <td><%= donationsRs.getInt("id") %></td>
      <td><%= donationsRs.getString("donor_username") %></td>
      <td><%= donationsRs.getInt("request_id") %></td>
      <td>$<%= donationsRs.getBigDecimal("amount") %></td>
      <td>
        <%
            String receipt = donationsRs.getString("receipt_file");
            if(receipt != null && !receipt.isEmpty()) {
        %>
          <a href="uploads/<%= receipt %>" target="_blank">View</a>
        <%
            } else { out.print("N/A"); }
        %>
      </td>
      <td><%= donationsRs.getTimestamp("donated_at") %></td>
    </tr>
    <%
            }
        } catch (SQLException e) { e.printStackTrace(); }
    %>
  </table>
</main>
</body>
</html>
