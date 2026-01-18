<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.example.db.DBConnection" %>

<%
    // Admin guard
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || role == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String,Object>> needs = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM school_requests ORDER BY id DESC");
         ResultSet rs = ps.executeQuery()) {

        while(rs.next()){
            Map<String,Object> n = new HashMap<>();
            n.put("id", rs.getInt("id"));
            n.put("principal_id", rs.getInt("principal_id"));
            n.put("title", rs.getString("title"));
            n.put("category", rs.getString("category"));
            n.put("description", rs.getString("description"));
            n.put("amount_needed", rs.getBigDecimal("amount_needed"));
            n.put("deadline", rs.getDate("deadline"));
            n.put("status", rs.getString("status"));
            n.put("created_at", rs.getTimestamp("created_at"));
            n.put("file_path", rs.getString("file_path"));
            n.put("account_number", rs.getString("account_number"));
            needs.add(n);
        }

    } catch(SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>School Needs — Admin</title>
<style>
body{font-family:Arial,sans-serif; background:#f3f6fb; padding:20px;}
table{width:100%; border-collapse:collapse; background:#fff; border-radius:8px; overflow:hidden; box-shadow:0 4px 12px rgba(0,0,0,0.05);}
th, td{padding:12px; border-bottom:1px solid #eee; text-align:left;}
th{background:#2b6cb0; color:#fff;}
tr:hover{background:#f0f4fb;}
a.btn{padding:6px 10px; background:#dc2626; color:#fff; border-radius:6px; text-decoration:none; font-size:13px;}
a.btn:hover{background:#b91c1c;}
.status-open{color:orange; font-weight:600;}
.status-fulfilled{color:green; font-weight:600;}
</style>
</head>
<body>

<h2>School Needs</h2>
<table>
<tr>
    <th>ID</th>
    <th>Principal ID</th>
    <th>Title</th>
    <th>Category</th>
    <th>Description</th>
    <th>Amount Needed</th>
    <th>Deadline</th>
    <th>Status</th>
    <th>Created At</th>
    <th>File</th>
    <th>Account Number</th>
    <th>Action</th>
</tr>

<%
for(Map<String,Object> n : needs){
    int id = (int)n.get("id");
    int principalId = (int)n.get("principal_id");
    String title = (String)n.get("title");
    String category = (String)n.get("category");
    String desc = (String)n.get("description");
    java.math.BigDecimal amount = (java.math.BigDecimal)n.get("amount_needed");
    java.sql.Date deadline = (java.sql.Date)n.get("deadline");
    String status = (String)n.get("status");
    Timestamp created = (Timestamp)n.get("created_at");
    String file = (String)n.get("file_path");
    String account = (String)n.get("account_number");
%>
<tr>
    <td><%=id%></td>
    <td><%=principalId%></td>
    <td><%=title%></td>
    <td><%=category%></td>
    <td><%=desc%></td>
    <td><%=amount%></td>
    <td><%=deadline != null ? deadline.toString() : "-" %></td>
    <td class="status-<%=status.equals("open") ? "open" : "fulfilled"%>"><%=status%></td>
    <td><%=created%></td>
    <td>
        <% if(file != null && !file.isEmpty()){ %>
            <a href="<%=request.getContextPath()%>/uploads/<%=file%>" target="_blank">View</a>
        <% } else { %>
            -
        <% } %>
    </td>
    <td><%=account != null ? account : "-" %></td>
    <td>
        <a class="btn" href="<%=request.getContextPath()%>/SchoolNeedDeleteServlet?id=<%=id%>"
           onclick="return confirm('Are you sure you want to delete this record?')">
           Delete
        </a>
    </td>
</tr>
<% } %>
</table>

</body>
</html>
