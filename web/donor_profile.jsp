<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*, com.example.db.DBConnection" %>

<%
    // Access control
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    Integer donorId = (Integer) session.getAttribute("donorId");

    if (username == null || role == null || !"donor".equals(role)) {
        response.sendRedirect("donor_login.jsp");
        return;
    }

    // Load donor details
    String firstName = "";
    String lastName = "";
    String email = "";
    String phone = "";
    String address = "";
    String dob = "";
    String profileImage = "default.png"; // fallback

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT first_name, last_name, dob, address, phone, email, profile_image FROM donors WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, donorId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            firstName = rs.getString("first_name");
            lastName = rs.getString("last_name");
            email = rs.getString("email");
            phone = rs.getString("phone");
            address = rs.getString("address");
            dob = rs.getString("dob");
            profileImage = rs.getString("profile_image") != null ? rs.getString("profile_image") : "default.png";
        }
    } catch(Exception e){ e.printStackTrace(); }
    finally {
        if(rs!=null) rs.close();
        if(stmt!=null) stmt.close();
        if(conn!=null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Donor Profile</title>
<style>
body{font-family:Arial,sans-serif;background:#f4f6f9;margin:0;}
.container{width:70%;margin:40px auto;background:#fff;padding:25px;border-radius:10px;box-shadow:0 4px 15px rgba(0,0,0,0.1);}
h2{text-align:center;margin-bottom:25px;color:#333;}
.profile-img-box{text-align:center;margin-bottom:30px;}
.profile-img-box img{width:130px;height:130px;border-radius:50%;object-fit:cover;border:3px solid #ddd;}
.form-group{margin-bottom:18px;}
label{display:block;margin-bottom:6px;font-weight:bold;color:#222;}
input[type=text], input[type=email], input[type=date], input[type=file]{width:100%;padding:12px;border:1px solid #bbb;border-radius:6px;font-size:16px;}
button{padding:12px 25px;border:none;background:#007bff;color:white;font-size:16px;border-radius:6px;cursor:pointer;}
button:hover{background:#0056cc;}
</style>
</head>
<body>

<div class="container">
    <h2>My Profile</h2>

    <div class="profile-img-box">
        <img src="uploads/<%= profileImage %>" alt="Profile Image">
    </div>

    <form action="update_donor_profile.jsp" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label>First Name</label>
            <input type="text" name="firstName" value="<%= firstName %>" required>
        </div>
        <div class="form-group">
            <label>Last Name</label>
            <input type="text" name="lastName" value="<%= lastName %>" required>
        </div>
        <div class="form-group">
            <label>Date of Birth</label>
            <input type="date" name="dob" value="<%= dob %>">
        </div>
        <div class="form-group">
            <label>Address</label>
            <input type="text" name="address" value="<%= address %>">
        </div>
        <div class="form-group">
            <label>Phone</label>
            <input type="text" name="phone" value="<%= phone %>">
        </div>
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" value="<%= email %>" required>
        </div>
        <div class="form-group">
            <label>Change Profile Image</label>
            <input type="file" name="profileImage">
        </div>
        <input type="hidden" name="existingImage" value="<%= profileImage %>">
        <button type="submit">Update Profile</button>
    </form>
</div>

</body>
</html>
