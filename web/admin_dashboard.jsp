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

    int totalDonors = 0, totalPrincipals = 0, pendingPrincipals = 0, openNeeds = 0, fulfilledNeeds = 0, totalNeeds = 0;
    try (Connection c = DBConnection.getConnection()) {
        try (ResultSet rs = c.prepareStatement("SELECT COUNT(*) FROM donors").executeQuery()){ if(rs.next()) totalDonors = rs.getInt(1); }
        try (ResultSet rs = c.prepareStatement("SELECT COUNT(*) FROM principals").executeQuery()){ if(rs.next()) totalPrincipals = rs.getInt(1); }
        try (ResultSet rs = c.prepareStatement("SELECT COUNT(*) FROM principals WHERE approved=false").executeQuery()){ if(rs.next()) pendingPrincipals = rs.getInt(1); }
        try (ResultSet rs = c.prepareStatement("SELECT COUNT(*) FROM school_requests WHERE status='open'").executeQuery()){ if(rs.next()) openNeeds = rs.getInt(1); }
        try (ResultSet rs = c.prepareStatement("SELECT COUNT(*) FROM school_requests WHERE status='fulfilled'").executeQuery()){ if(rs.next()) fulfilledNeeds = rs.getInt(1); }
        try (ResultSet rs = c.prepareStatement("SELECT COUNT(*) FROM school_requests").executeQuery()){ if(rs.next()) totalNeeds = rs.getInt(1); }
    } catch (SQLException e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Admin Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
body{font-family:"Segoe UI", Roboto, Arial; margin:0; display:flex; background:#f3f7fb;}
nav.sidebar{width:220px; background:#2b6cb0; color:#fff; height:100vh; padding:20px; box-sizing:border-box;}
nav.sidebar h2{margin:0 0 20px 0; font-size:20px;}
nav.sidebar a{display:block; color:#fff; text-decoration:none; margin:10px 0; font-weight:600;}
nav.sidebar a:hover{color:#cce5ff;}
main.content{flex:1; padding:20px;}
.cards-row{display:flex; gap:16px; flex-wrap:wrap; margin-bottom:20px;}
.card{flex:1 1 200px; background:#fff; border-radius:12px; padding:20px; box-shadow:0 4px 15px rgba(0,0,0,0.05);}
.card h3{margin:0; font-size:20px; color:#2b6cb0;}
.card p{margin:8px 0 0 0; color:#555; font-size:14px;}
.card span.value{display:block; font-size:28px; font-weight:700; margin-top:5px; color:#0b1724;}
.chart-container{background:#fff; border-radius:12px; padding:20px; box-shadow:0 4px 15px rgba(0,0,0,0.05); margin-top:20px; max-width:500px;}
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
  <h1>Welcome, <%= username %></h1>
  <div class="cards-row">
    <div class="card">
      <h3>Registered Donors</h3>
      <span class="value"><%= totalDonors %></span>
      <p>Total donors in the system</p>
    </div>
    <div class="card">
      <h3>Total Principals</h3>
      <span class="value"><%= totalPrincipals %> (<%= pendingPrincipals %> pending)</span>
      <p>Principals including pending approvals</p>
    </div>
    <div class="card">
      <h3>School Requests</h3>
      <span class="value"><%= totalNeeds %> (<%= openNeeds %> open)</span>
      <p>Total school needs in the system</p>
    </div>
  </div>

<div class="chart-container" style="max-width:300px; margin-top:20px; margin-left:auto; margin-right:auto;">
    <h3 style="text-align:center;">Need Fulfillment Progress</h3>
    <canvas id="needsChart" width="300" height="300"></canvas>
</div>

<script>
const ctx = document.getElementById('needsChart').getContext('2d');
const needsChart = new Chart(ctx, {
    type: 'pie',
    data: {
        labels: ['Fulfilled Needs', 'Open Needs'],
        datasets: [{
            data: [<%= fulfilledNeeds %>, <%= openNeeds %>],
            backgroundColor: ['#2b6cb0', '#f59e0b'],
            borderColor: ['#fff', '#fff'],
            borderWidth: 2
        }]
    },
    options: {
        responsive: false,
        plugins: {
            legend: { position: 'bottom' },
            tooltip: {
                callbacks: {
                    label: function(context) {
                        let label = context.label || '';
                        let value = context.raw;
                        let total = context.chart._metasets[context.datasetIndex].total;
                        let percentage = ((value/total)*100).toFixed(1);
                        return label + ': ' + value + ' (' + percentage + '%)';
                    }
                }
            }
        }
    }
});
</script>
</main>
</body>
</html>
