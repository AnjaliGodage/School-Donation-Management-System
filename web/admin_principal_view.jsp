<%@ page import="java.sql.*, com.example.db.DBConnection" %>
<%
String id = request.getParameter("id");
if (id == null) { out.print("Invalid principal ID"); return; }

String name="", email="", phone="", school="", createdAt="", rejectionReason="";
boolean approved=false;

try (Connection conn = DBConnection.getConnection();
     PreparedStatement ps = conn.prepareStatement(
        "SELECT * FROM principals WHERE id = ?")) {
    ps.setInt(1, Integer.parseInt(id));
    try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            name = rs.getString("principal_name");
            email = rs.getString("email");
            phone = rs.getString("phone");
            school = rs.getString("school");
            createdAt = rs.getString("created_at");
            approved = rs.getBoolean("approved");
            rejectionReason = rs.getString("rejection_reason");
        }
    }
}
%>

<h2>Principal Details</h2>
<p><strong>Name:</strong> <%= name %></p>
<p><strong>Email:</strong> <%= email %></p>
<p><strong>Phone:</strong> <%= phone %></p>
<p><strong>School:</strong> <%= school %></p>
<p><strong>Created:</strong> <%= createdAt %></p>
<p><strong>Status:</strong> <%= approved ? "Approved" : "Pending/Rejected" %></p>

<% if (rejectionReason != null) { %>
<p><strong>Rejection Reason:</strong> <%= rejectionReason %></p>
<% } %>

<form method="post" action="PrincipalApproveServlet">
    <input type="hidden" name="id" value="<%= id %>">
    <button type="submit">Approve</button>
</form>

<form method="post" action="PrincipalRejectServlet">
    <input type="hidden" name="id" value="<%= id %>">
    Rejection reason:<br>
    <textarea name="reason" rows="3"></textarea><br>
    <button type="submit">Reject</button>
</form>

<form method="post" action="PrincipalDeleteServlet" onsubmit="return confirm('Delete this principal?');">
    <input type="hidden" name="id" value="<%= id %>">
    <button type="submit" style="color:red;">Delete</button>
</form>
