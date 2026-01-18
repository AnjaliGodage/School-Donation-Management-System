<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.db.DBConnection, java.io.*" %>

<%
String idStr = request.getParameter("id");
if (idStr == null) {
    response.sendRedirect("admin_principals.jsp");
    return;
}

int id = Integer.parseInt(idStr);
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

byte[] documentBytes = null;
String documentName = null;

try {
    conn = DBConnection.getConnection();
    ps = conn.prepareStatement("SELECT * FROM principals WHERE id=?");
    ps.setInt(1, id);
    rs = ps.executeQuery();

    if (!rs.next()) {
        out.println("Principal not found.");
        return;
    }

    // Get principal details
    String schoolName = rs.getString("school_name");
    String principalName = rs.getString("principal_name");
    String email = rs.getString("email");
    String phone = rs.getString("phone_number");
    int servicePeriod = rs.getInt("service_period");
    String empNumber = rs.getString("employee_number");
    String schoolAddress = rs.getString("school_address");
    Timestamp createdAt = rs.getTimestamp("created_at");
    Timestamp approvedAt = rs.getTimestamp("approved_at");

    // Get document
    Blob blob = rs.getBlob("proof_document");
    if (blob != null) {
        documentBytes = blob.getBytes(1, (int) blob.length());
    }

%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Principal Details</title>
<style>
body { font-family: Arial; padding:20px; background:#f2f6fa; }
.container { background:#fff; padding:20px; border-radius:8px; width:700px; margin:auto; box-shadow:0 5px 20px rgba(0,0,0,0.1);}
h2 { color:#2b6cb0; text-align:center; }
label { font-weight:bold; }
.row { margin-bottom:12px; }
a { color:#2b6cb0; text-decoration:none; }
a:hover { text-decoration:underline; }
iframe { border:1px solid #ccc; margin-top:10px; width:100%; height:600px; }
img { max-width:100%; max-height:600px; margin-top:10px; border:1px solid #ccc; }
.back-link { display:block; margin-top:20px; text-align:center; }
</style>
</head>
<body>

<div class="container">
<h2>Principal Full Details</h2>

<div class="row"><label>ID:</label> <%=id%></div>
<div class="row"><label>School Name:</label> <%=schoolName%></div>
<div class="row"><label>Principal Name:</label> <%=principalName%></div>
<div class="row"><label>Email:</label> <%=email%></div>
<div class="row"><label>Phone Number:</label> <%=phone%></div>
<div class="row"><label>Service Period:</label> <%=servicePeriod%> years</div>
<div class="row"><label>Employee Number:</label> <%=empNumber%></div>
<div class="row"><label>School Address:</label> <%=schoolAddress%></div>
<div class="row"><label>Created At:</label> <%=createdAt%></div>
<div class="row"><label>Approved At:</label> <%=approvedAt%></div>

<%
if(documentBytes != null){
%>
<div class="row">
<label>Proof Document:</label><br/>
<%
    // Get file type
    String mimeType = "application/pdf"; // default PDF
%>
<iframe src="DownloadDocument?id=<%=id%>&inline=true"></iframe>
<br/>
<a href="DownloadDocument?id=<%=id%>">Download Document</a>
</div>
<%
} else {
%>
<div class="row"><label>Proof Document:</label> No document uploaded.</div>
<%
}
%>

<a class="back-link" href="admin_principals.jsp">← Back to Principal List</a>

</div>

</body>
</html>

<%
} catch(Exception e) {
    out.println("Error: " + e.getMessage());
} finally {
    if(rs != null) try{ rs.close(); } catch(Exception ex){}
    if(ps != null) try{ ps.close(); } catch(Exception ex){}
    if(conn != null) try{ conn.close(); } catch(Exception ex){}
}
%>
