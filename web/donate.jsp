<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.db.DBConnection, java.math.BigDecimal"%>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || role == null || !"donor".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/donor_login.jsp");
        return;
    }

    String requestIdStr = request.getParameter("requestId");
    if (requestIdStr == null) {
        response.sendRedirect(request.getContextPath() + "/donor_dashboard.jsp");
        return;
    }
    int requestId = Integer.parseInt(requestIdStr);

    String title="", category="", descr="", acct="";
    BigDecimal amountNeeded = BigDecimal.ZERO;
    Date ddl = null;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(
            "SELECT * FROM school_requests WHERE id=? AND status='open'")) {
        ps.setInt(1, requestId);
        ResultSet rs = ps.executeQuery();
        if(rs.next()) {
            title = rs.getString("title");
            category = rs.getString("category");
            descr = rs.getString("description");
            amountNeeded = rs.getBigDecimal("amount_needed");
            ddl = rs.getDate("deadline");
            acct = rs.getString("account_number");
        } else {
            out.println("<h3>Request not found or already fulfilled.</h3>");
            return;
        }
    } catch(Exception e){ out.println(e.getMessage()); }
%>

<!DOCTYPE html>
<html>
<head>
<title>Donate — <%= title %></title>
<style>
body{font-family:sans-serif; background:#f5f7fb; padding:40px;}
.container{max-width:600px; margin:auto; background:white; padding:25px; border-radius:12px; box-shadow:0 5px 18px rgba(0,0,0,0.08);}
h2{text-align:center;}
label{font-weight:bold; margin-top:10px; display:block;}
input[type="number"], input[type="file"]{width:100%; padding:10px; margin-top:8px; border:1px solid #ccc; border-radius:8px;}
button{width:100%; margin-top:20px; background:#2b6cb0; color:white; padding:12px; border:none; border-radius:8px; font-size:16px; cursor:pointer;}
button:hover{background:#245a92;}
</style>
</head>
<body>
<div class="container">
    <h2>Donate to "<%= title %>"</h2>
    <p><strong>Category:</strong> <%= category %></p>
    <% if(ddl!=null){ %><p><strong>Deadline:</strong> <%= ddl %></p><% } %>
    <% if(acct!=null && acct.trim().length()>0){ %><p><strong>Account Number:</strong> <%= acct %></p><% } %>
    <p><strong>Description:</strong><br> <%= descr %></p>
    <p><strong>Remaining Amount Needed:</strong> ₦<span id="remaining"><%= amountNeeded %></span></p>

    <form action="<%= request.getContextPath() %>/DonationServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="requestId" value="<%= requestId %>"/>
        <input type="hidden" name="username" value="<%= username %>"/>
        <label>Amount to Donate (₦):</label>
        <input type="number" id="amount" name="amount" min="1" max="<%= amountNeeded %>" required/>
        <label>Upload Receipt (Optional):</label>
        <input type="file" name="receipt"/>
        <button type="submit">Confirm Donation</button>
    </form>
</div>

<script>
const remaining = parseFloat('<%= amountNeeded %>');
const amountInput = document.getElementById('amount');
amountInput.addEventListener('input', ()=>{
    let val = parseFloat(amountInput.value)||0;
    if(val>remaining){ amountInput.value=remaining; val=remaining; }
    document.getElementById('remaining').innerText=(remaining-val).toFixed(2);
});
</script>
</body>
</html>
