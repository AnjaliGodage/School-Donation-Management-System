<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.sql.*, com.example.db.DBConnection" %>

<%
    // Admin session check
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if(username == null || role == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Show alert message if any
    String msg = (String) session.getAttribute("msg");
    if(msg != null) {
%>
<script>alert("<%= msg %>");</script>
<%
        session.removeAttribute("msg");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Principals – Admin</title>
<style>
body { font-family: Arial; background:#f7f9fc; padding:20px; }
h2 { color:#2b6cb0; }
table { width:100%; border-collapse:collapse; background:#fff; box-shadow:0 5px 18px rgba(0,0,0,0.06); }
th, td { padding:12px; border-bottom:1px solid #e8eef5; font-size:14px; }
th { background:#2b6cb0; color:#fff; }
tr:hover { background:#f0f4fb; }
.btn { padding:6px 10px; border:none; border-radius:6px; cursor:pointer; text-decoration:none; color:white; }
.view-btn { background:#555; }
.approve-btn { background:#2b6cb0; }
.reject-btn { background:#c23; }
.approve-btn:hover { background:#235a98; }
.reject-btn:hover { background:#a00; }
.status-approved { color:green; font-weight:bold; }
.status-pending { color:orange; font-weight:bold; }
.status-rejected { color:red; font-weight:bold; }
input[name="reason"] { padding:4px; margin-right:4px; border-radius:4px; border:1px solid #ccc; }
</style>
</head>
<body>

<h2>Principal Accounts</h2>

<table>
<tr>
  <th>ID</th>
  <th>School</th>
  <th>Principal Name</th>
  <th>Email</th>
  <th>Service Period</th>
  <th>Employee Number</th>
  <th>School Address</th>
  <th>Status</th>
  <th>Created At</th>
  <th>Approved At</th>
  <th>Actions</th>
</tr>

<%
try (Connection conn = DBConnection.getConnection();
     PreparedStatement ps = conn.prepareStatement(
        "SELECT id, school_name, principal_name, email, service_period, employee_number, " +
        "school_address, approved, rejected, created_at, approved_at FROM principals ORDER BY id DESC"
     )) {

    ResultSet rs = ps.executeQuery();

    while(rs.next()) {
        int id = rs.getInt("id");
        String school = rs.getString("school_name");
        String name = rs.getString("principal_name");
        String email = rs.getString("email");
        int servicePeriod = rs.getInt("service_period");
        String empNum = rs.getString("employee_number");
        String address = rs.getString("school_address");

        boolean approved = rs.getBoolean("approved");
        boolean rejected = rs.getBoolean("rejected");

        Timestamp createdAt = rs.getTimestamp("created_at");
        Timestamp approvedAt = rs.getTimestamp("approved_at");

        // -----------------------------
        // Corrected Status Logic
        // -----------------------------
        String status;
        String statusClass;

        if (approved) {
            status = "Approved";
            statusClass = "status-approved";

        } else if (rejected) {
            status = "Rejected";
            statusClass = "status-rejected";

        } else {
            status = "Pending";
            statusClass = "status-pending";
        }
%>

<tr>
<td><%= id %></td>
<td><%= school %></td>
<td><%= name %></td>
<td><%= email %></td>
<td><%= servicePeriod %></td>
<td><%= empNum %></td>
<td><%= address %></td>
<td class="<%= statusClass %>"><%= status %></td>
<td><%= createdAt != null ? createdAt.toString() : "-" %></td>
<td><%= approvedAt != null ? approvedAt.toString() : "-" %></td>

<td>
    <a class="btn view-btn" href="principal_view.jsp?id=<%= id %>">View</a>

    <% if(!approved && !rejected){ %>
        <!-- Approve Form -->
        <form action="PrincipalApproveServlet" method="post" style="display:inline;">
            <input type="hidden" name="id" value="<%= id %>">
            <button class="btn approve-btn" type="submit">Approve</button>
        </form>

        <!-- Reject Form -->
        <form action="PrincipalRejectServlet" method="post" style="display:inline;">
            <input type="hidden" name="id" value="<%= id %>">
            <input type="text" name="reason" placeholder="Reason for rejection" required>
            <button class="btn reject-btn" type="submit">Reject</button>
        </form>
    <% } %>

</td>
</tr>

<%
    }
} catch(Exception e) {
    out.print("Error: " + e.getMessage());
}
%>

</table>

</body>
</html>
