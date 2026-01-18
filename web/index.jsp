<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.example.db.DBConnection, java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>School Donation Management</title>

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

  <style>
    :root {
      --accent: #2b6cb0;
      --accent-dark: #235a98;
      --muted: #cbd5e1;
      --card-bg: rgba(255,255,255,0.85);
      --glass-radius: 20px;
      --shadow: 0 16px 40px rgba(11,35,64,0.1);
      --dark-blue: #1e3a8a;
    }

    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Inter', sans-serif; }
    body, html { height: 100%; scroll-behavior: smooth; background: #f0f4f8; color: #111827; }

    /* Topbar */
    .topbar { position: fixed; top: 0; left: 0; width: 100%; background: var(--dark-blue); color: #fff; display: flex; justify-content: space-between; align-items: center; padding: 12px 28px; z-index: 100; box-shadow: 0 4px 20px rgba(0,0,0,0.2); }
    .topbar-left { display: flex; align-items: center; gap: 12px; }
    .logo-img { height: 50px; border-radius: 6px; }
    .site-name { font-size: 20px; font-weight: 700; color: #fff; }
    .topbar .actions a { background: linear-gradient(90deg,var(--accent),var(--accent-dark)); color: #fff; padding: 10px 18px; border-radius: 12px; font-weight: 600; text-decoration: none; transition: transform 0.2s, box-shadow 0.2s; margin-left: 8px; }
    .topbar .actions a:hover { transform: translateY(-3px); box-shadow: 0 16px 32px rgba(0,0,0,0.2); }

    /* Hero Section */
    .hero { display: flex; flex-direction: column-reverse; align-items: center; justify-content: center; margin-top: 80px; position: relative; min-height: 90vh; }
    @media(min-width: 992px){ .hero { flex-direction: row; } }
    .hero-left { flex: 1; position: relative; overflow: hidden; min-height: 300px; border-radius: var(--glass-radius); }
    .hero-left img { width: 100%; height: 100%; object-fit: cover; filter: brightness(0.5); transition: transform 0.5s; }
    .hero-left:hover img { transform: scale(1.05); }
    .hero-right { flex: 1; background: var(--card-bg); padding: 40px; margin: 20px; border-radius: var(--glass-radius); box-shadow: var(--shadow); backdrop-filter: blur(10px); display: flex; flex-direction: column; justify-content: center; gap: 20px; }
    .hero-right h1 { font-size: 36px; color: #07203b; }
    .hero-right p { font-size: 16px; color: #334155; line-height: 1.5; }
    .hero-right a.btn { width: fit-content; display: inline-block; padding: 12px 22px; font-weight: 700; color: #fff; background: linear-gradient(90deg,var(--accent),var(--accent-dark)); border-radius: 12px; text-decoration: none; transition: transform 0.2s, box-shadow 0.2s; }
    .hero-right a.btn:hover { transform: translateY(-3px); box-shadow: 0 16px 32px rgba(0,0,0,0.2); }

    /* Requests Section */
    .requests { max-width: 1200px; margin: 60px auto; padding: 0 20px; }
    .requests h2 { text-align: center; font-size: 28px; margin-bottom: 40px; color: #07203b; }
    .grid { display: grid; grid-template-columns: 1fr; gap: 24px; }
    @media(min-width: 720px){ .grid { grid-template-columns: repeat(2,1fr); } }
    @media(min-width: 1100px){ .grid { grid-template-columns: repeat(3,1fr); } }

    .card { background: var(--card-bg); border-radius: var(--glass-radius); overflow: hidden; box-shadow: var(--shadow); display: flex; flex-direction: column; transition: transform 0.3s, box-shadow 0.3s; cursor: pointer; position: relative; min-height: 360px; }
    .card:hover { transform: translateY(-10px); box-shadow: 0 24px 48px rgba(11,35,64,0.15); }
    .thumb-wrap { height: 180px; width: 100%; overflow: hidden; background: #000; display: flex; justify-content: center; align-items: center; }
    .thumb-wrap img { width: 100%; height: 100%; object-fit: cover; }
    .card-content { padding: 20px; display: flex; flex-direction: column; gap: 12px; flex: 1; }
    .meta { display: flex; justify-content: space-between; align-items: center; gap: 10px; flex-wrap: wrap; }
    .title { font-weight: 700; font-size: 18px; color: #07203b; }
    .category { font-size: 13px; color: var(--muted); background: rgba(43,108,176,0.08); padding: 4px 10px; border-radius: 999px; font-weight: 600; }
    .desc { font-size: 14px; color: #334155; flex: 1; min-height: 60px; }
    .details { display: flex; gap: 10px; font-size: 13px; color: #334155; flex-wrap: wrap; }
    .amount { font-weight: 700; color: var(--accent-dark); }
    .deadline { font-style: italic; }
    .card-footer { display: flex; justify-content: flex-start; align-items: center; margin-top: 10px; gap: 10px; }
    .card-footer a { text-decoration: none; font-weight: 700; padding: 8px 12px; border-radius: 10px; }
    .donate { background: linear-gradient(90deg,var(--accent),var(--accent-dark)); color: #fff; }
    .view { border: 1px solid rgba(43,108,176,0.2); color: var(--accent-dark); }
    .view-principal { background: #fbbf24; color: #111827; border: none; cursor: pointer; transition: transform 0.2s; }
    .view-principal:hover { transform: translateY(-2px); }

    /* Principal Table Section */
    .principal-section { max-width: 1200px; margin: 60px auto 80px auto; padding: 0 20px; }
    .principal-section h2 { text-align: center; font-size: 28px; margin-bottom: 30px; color: #07203b; }
    table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow); }
    th { background: var(--dark-blue); color: #fff; padding: 14px; font-size: 15px; text-align: left; }
    td { padding: 14px; border-bottom: 1px solid #e2e8f0; font-size: 14px; }
    tr:hover td { background: #f1f5f9; }

    footer { text-align: center; padding: 36px 12px; color: #64748b; margin-top: 60px; font-size: 14px; }
  </style>
</head>
<body>

  <!-- TOPBAR -->
  <div class="topbar">
    <div class="topbar-left">
      <img class="logo-img" src="${pageContext.request.contextPath}/images/DonorSchool.png" alt="Logo" />
      <div class="site-name">School Donation Management</div>
    </div>
    <div class="actions">
      <a href="${pageContext.request.contextPath}/donor_login.jsp">Help A School</a>
      <a href="${pageContext.request.contextPath}/principal_login.jsp">Post A Need</a>
    </div>
  </div>

  <!-- HERO -->
  <section class="hero">
    <div class="hero-left">
      <img src="${pageContext.request.contextPath}/images/black.jpg" alt="School Background">
    </div>
    <div class="hero-right">
      <h1>Empower Schools, Empower Futures</h1>
      <p>Browse verified school requests, view their details, and make a direct impact. Donations are securely processed and reach the schools in need.</p>
      <a href="#requests" class="btn">View Requests</a>
    </div>
  </section>

  <!-- REQUESTS -->
  <section id="requests" class="requests">
    <h2>Available School Requests</h2>
    <div class="grid">
      <%
        ResultSet rs = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT sr.id, sr.title, sr.category, sr.description, sr.amount_needed, sr.deadline, sr.file_path, sr.account_number, sr.principal_id, p.principal_name, p.phone_number, p.approved " +
                 "FROM school_requests sr " +
                 "LEFT JOIN principals p ON sr.principal_id = p.id " +
                 "WHERE sr.status = ? ORDER BY sr.created_at DESC")) {

          ps.setString(1, "open");
          rs = ps.executeQuery();
          boolean any = false;

          while(rs.next()) {
            boolean principalApproved = rs.getBoolean("approved");
            int principalId = rs.getInt("principal_id");

            if(!principalApproved || principalId == 0) continue; // Skip unapproved or missing principals

            any = true;
            int id = rs.getInt("id");
            String title = rs.getString("title");
            String category = rs.getString("category");
            String descr = rs.getString("description");
            BigDecimal amt = rs.getBigDecimal("amount_needed");
            Date ddl = rs.getDate("deadline");
            String filePath = rs.getString("file_path");
            String acct = rs.getString("account_number");
            String principal = rs.getString("principal_name");
            String phone = rs.getString("phone_number");

            String shortDesc = descr == null ? "" : (descr.length() > 140 ? descr.substring(0,140) + "…" : descr);
            String imgUrl = (filePath != null && !filePath.trim().isEmpty()) ? request.getContextPath() + "/" + filePath : null;
      %>
      <article class="card">
        <div class="thumb-wrap">
          <% if(imgUrl != null){ %>
            <img src="<%= imgUrl %>" alt="Attachment for <%= title.replace("\"","'") %>"/>
          <% } else { %>
            <div style="color:#fff;font-weight:700;">No Image</div>
          <% } %>
        </div>
        <div class="card-content">
          <div class="meta">
            <div class="title"><%= title %></div>
            <div class="category"><%= category != null ? category : "Other" %></div>
          </div>
          <div class="desc"><%= shortDesc %></div>
          <div class="details">
            <div class="amount"><%= (amt != null ? "₦" + amt.toPlainString() : "—") %></div>
            <div class="deadline"><%= (ddl != null ? "By " + ddl.toString() : "") %></div>
            <div>Principal: <strong><%= principal %></strong></div>
            <% if(acct != null && !acct.trim().isEmpty()) { %>
              <div>Acct: <strong><%= acct %></strong></div>
            <% } %>
            <% if(phone != null && !phone.trim().isEmpty()) { %>
              <div>Phone: <strong><%= phone %></strong></div>
            <% } %>
          </div>
        </div>
        <div class="card-footer">
          <a class="donate" href="<%= request.getContextPath() %>/donor_login.jsp?requestId=<%= id %>">Donate</a>
          <a class="view-principal" href="<%= request.getContextPath() %>/principal_detail.jsp?id=<%= principalId %>">View Principal</a>
        </div>
      </article>
      <% } // end while

         if(!any){ %>
           <div class="empty" style="grid-column:1/-1;">No open requests at the moment. Check back soon.</div>
      <% }

        } catch(SQLException e) {
            out.println("<div style='color:red;padding:12px;border-radius:10px;background:#fff;margin-top:12px'>Error loading requests: " + e.getMessage() + "</div>");
            e.printStackTrace();
        } finally {
            if(rs != null) try{ rs.close(); } catch(SQLException ignore) {}
        }
      %>
    </div>
  </section>

  <!-- PRINCIPAL TABLE -->
  <section class="principal-section">
    <h2>Registered School Principals</h2>
    <table>
      <tr>
        <th>School Name</th>
        <th>Principal Name</th>
        <th>Phone</th>
        <th>Email</th>
        <th>Employee No</th>
        <th>Service Period</th>
        <th>Status</th>
      </tr>
      <%
        ResultSet rs2 = null;
        try (Connection conn2 = DBConnection.getConnection();
             PreparedStatement ps2 = conn2.prepareStatement(
               "SELECT school_name, principal_name, phone_number, email, employee_number, service_period, approved FROM principals WHERE approved = 1 ORDER BY created_at DESC"
             )) {

          rs2 = ps2.executeQuery();
          boolean any2 = false;

          while (rs2.next()) {
            any2 = true;
            String school = rs2.getString("school_name");
            String pname  = rs2.getString("principal_name");
            String phone  = rs2.getString("phone_number");
            String email  = rs2.getString("email");
            String empNo  = rs2.getString("employee_number");
            String service= rs2.getString("service_period");
      %>
      <tr>
        <td><%= school %></td>
        <td><%= pname %></td>
        <td><%= phone %></td>
        <td><%= email %></td>
        <td><%= empNo %></td>
        <td><%= service %></td>
        <td style="font-weight:600; color:#16a34a;">Approved</td>
      </tr>
      <% } // end while

        if (!any2) { %>
          <tr><td colspan='7' style='text-align:center; padding:20px;'>No approved principals registered yet.</td></tr>
      <% }

        } catch(Exception e) {
          out.println("<tr><td colspan='7' style='color:red;padding:20px;'>Error loading principals: "+ e.getMessage() +"</td></tr>");
        } finally {
          if (rs2 != null) try { rs2.close(); } catch(Exception ignore) {}
        }
      %>
    </table>
  </section>

  <footer>
    © <%= java.time.LocalDate.now().getYear() %> School Donation Management
  </footer>
</body>
</html>
