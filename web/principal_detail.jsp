<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.db.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Principal Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background: #f0f4f8; color: #111827; margin: 0; padding: 0; }
        .container { max-width: 700px; margin: 80px auto; background: #fff; padding: 30px 40px; border-radius: 20px; box-shadow: 0 16px 40px rgba(11,35,64,0.1); }
        h1 { text-align: center; font-size: 28px; margin-bottom: 30px; color: #07203b; }
        .details { display: flex; flex-direction: column; gap: 15px; font-size: 16px; }
        .details div { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #e2e8f0; }
        .label { font-weight: 600; color: #334155; }
        .value { color: #111827; }
        a.back { display: inline-block; margin-top: 20px; text-decoration: none; color: #fff; background: #2b6cb0; padding: 10px 20px; border-radius: 10px; transition: background 0.2s; }
        a.back:hover { background: #235a98; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Principal Details</h1>
        <%
            String idParam = request.getParameter("id");
            if(idParam != null) {
                int principalId = Integer.parseInt(idParam);

                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(
                         "SELECT id, principal_name, email, phone_number, service_period, school_name FROM principals WHERE id = ? AND approved = 1")) {

                    ps.setInt(1, principalId);
                    ResultSet rs = ps.executeQuery();

                    if(rs.next()) {
        %>
        <div class="details">
            <div><span class="label">ID:</span> <span class="value"><%= rs.getInt("id") %></span></div>
            <div><span class="label">Name:</span> <span class="value"><%= rs.getString("principal_name") %></span></div>
            <div><span class="label">Email:</span> <span class="value"><%= rs.getString("email") %></span></div>
            <div><span class="label">Phone:</span> <span class="value"><%= rs.getString("phone_number") %></span></div>
            <div><span class="label">Service Period:</span> <span class="value"><%= rs.getInt("service_period") %></span></div>
            <div><span class="label">School:</span> <span class="value"><%= rs.getString("school_name") %></span></div>
        </div>
        <%      } else { %>
            <p style="text-align:center;color:red;">Principal not found or not approved.</p>
        <%      }
                    rs.close();
                } catch(Exception e) {
        %>
            <p style="text-align:center;color:red;">Error: <%= e.getMessage() %></p>
        <%  }
            } else { %>
            <p style="text-align:center;color:red;">No Principal ID provided.</p>
        <% } %>

        <div style="text-align:center;">
            <a href="<%= request.getContextPath() %>/index.jsp" class="back">Back to Requests</a>
        </div>
    </div>
</body>
</html>
