<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*, com.example.db.DBConnection, java.math.BigDecimal" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || role == null || !"donor".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/donor_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Donor Dashboard — School Donation Management</title>

<style>
:root{
  --accent:#2b6cb0;
  --accent-600:#235a98;
  --accent-light:#bee3f8;
  --muted:#6b7280;
  --bg:#f4f8ff;
  --card:#ffffff;
  --glass: rgba(255,255,255,0.95);
  --radius:16px;
  --shadow: 0 10px 30px rgba(11,35,64,0.08);
  --logo-height:64px;
}

*{box-sizing:border-box}
html,body{margin:0;padding:0;font-family:Inter, "Segoe UI", Roboto, Arial, sans-serif;background:var(--bg);color:#0b1724;}
a{text-decoration:none;}

.topbar {
  background: linear-gradient(90deg,var(--accent-600),var(--accent));
  padding:14px 24px;
  color:#fff;
  display:flex;
  align-items:center;
  justify-content:space-between;
  box-shadow: 0 6px 22px rgba(11,35,64,0.08);
}
.topbar .left { display:flex; align-items:center; gap:14px; }
.logo-img { height:var(--logo-height); border-radius:8px; background:rgba(255,255,255,0.10); padding:6px; }
.site-title { font-size:22px; font-weight:800; }

.nav-btn {
  padding:10px 16px;
  border-radius:10px;
  font-weight:700;
  border:2px solid rgba(255,255,255,0.6);
  color:white;
  backdrop-filter: blur(4px);
  transition:0.2s;
}
.nav-btn:hover { background:white; color:var(--accent-600); border-color:white; }

.container { max-width:1200px; margin:30px auto; padding:0 18px 80px; }

.hero { display:flex; align-items:center; margin-bottom:24px; }
.greeting {
  background:var(--glass);
  padding:20px;
  border-radius:var(--radius);
  display:flex; align-items:center;
  box-shadow:var(--shadow);
}
.avatar {
  width:56px; height:56px;
  display:flex; align-items:center; justify-content:center;
  border-radius:12px;
  background:#fff;
  font-size:20px;
  font-weight:800;
  color:var(--accent-600);
}

.grid { display:grid; grid-template-columns: 1fr 360px; gap:20px; }
@media(max-width:980px){ .grid{grid-template-columns:1fr;} }

.card { background:white; border-radius:var(--radius); padding:20px; box-shadow:var(--shadow); }

.controls input, .controls select {
  padding:10px; border-radius:10px; border:1px solid #e6eef7;
  margin-right:8px; width:60%;
}
.controls select{ width:35%; }

.cards { display:grid; gap:20px; }

/* MODERN DONATION CARD */
.request-card {
  display:flex;
  flex-direction: column;
  background: var(--glass);
  border-radius: var(--radius);
  overflow: hidden;
  transition:0.3s;
  box-shadow:0 6px 20px rgba(11,35,64,0.08);
}
.request-card:hover {
  transform: translateY(-5px);
  box-shadow:0 18px 40px rgba(11,35,64,0.15);
}
.req-top { display:flex; gap:16px; padding:16px; }
.req-thumb {
  width:160px; height:120px; border-radius:12px; overflow:hidden;
  display:flex; justify-content:center; align-items:center;
  background:#f7fafc; flex-shrink:0;
  transition:0.3s;
}
.req-thumb img{ width:100%; height:100%; object-fit:cover; }
.req-body { flex:1; display:flex; flex-direction:column; justify-content:space-between; }

.req-title {
  font-size:20px;
  font-weight:700;
  margin-bottom:8px;
  color:var(--accent-600);
}
.req-desc {
  font-size:14px;
  color:var(--muted);
  margin-bottom:12px;
  line-height:1.5;
}

.req-meta {
  display:flex; flex-wrap:wrap; gap:12px; font-size:13px; margin-bottom:12px;
}
.req-meta div {
  background:var(--accent-light);
  padding:6px 10px;
  border-radius:8px;
  font-weight:600;
}

.req-actions {
  display:flex; gap:12px;
  margin-top:12px;
}
.view {
  border:1px solid var(--accent-600);
  padding:10px;
  border-radius:10px;
  color:var(--accent-600);
  font-weight:700;
  flex:1;
  text-align:center;
  transition:0.2s;
}
.view:hover{ background:var(--accent-600); color:white; }

.donate {
  background: linear-gradient(90deg,var(--accent),var(--accent-600));
  color:white;
  padding:10px;
  border-radius:10px;
  border:none;
  font-weight:800;
  cursor:pointer;
  flex:1;
  text-align:center;
  transition:0.2s;
}
.donate:hover{ transform: scale(1.05); }

.empty { padding:32px; background:white; border-radius:10px; text-align:center; color:var(--muted); }

/* PREVIOUS DONATIONS */
.prev-donations { padding:16px; background:#dbe9ff; border-left:6px solid var(--accent); border-radius:12px; }
.prev-don-card { background:white; padding:12px; border-radius:10px; margin-bottom:12px; border-left:4px solid var(--accent-600); }
.total-donated { background:var(--accent-600); color:white; padding:14px; text-align:center; border-radius:10px; margin-top:10px; font-weight:700; }
</style>

<script>
function filterCards() {
  const q = document.getElementById('q').value.toLowerCase();
  const cat = document.getElementById('categoryFilter').value;
  document.querySelectorAll('.request-card').forEach(card => {
    const title = card.dataset.title.toLowerCase();
    const desc = card.dataset.desc.toLowerCase();
    const category = card.dataset.category;
    card.style.display = ((title.includes(q) || desc.includes(q)) && (cat === "" || category === cat)) ? "flex" : "none";
  });
}
</script>

</head>
<body>

<!-- TOPBAR -->
<div class="topbar">
  <div class="left">
    <img class="logo-img" src="${pageContext.request.contextPath}/images/DonorSchool.png"/>
    <div class="site-title">School Donation Management</div>
  </div>
  <div class="right" style="display:flex; gap:14px; align-items:center;">
    <div style="font-weight:700;">Signed in as <%= username %></div>
    <a class="nav-btn" href="<%= request.getContextPath() %>/donor_profile.jsp?username=<%= username %>">Profile</a>
    <a class="nav-btn" href="<%= request.getContextPath() %>/index.jsp">Logout</a>
  </div>
</div>

<div class="container">
  <!-- GREETING -->
  <div class="hero">
    <div class="greeting">
      <div class="avatar"><%= Character.toUpperCase(username.charAt(0)) %></div>
      <div style="margin-left:12px;">
        <h2 style="margin:0;">Welcome, <%= username %></h2>
        <p style="margin:4px 0; color:var(--muted);">Browse open school requests and support education.</p>
      </div>
    </div>
  </div>

  <div class="grid">
    <!-- OPEN REQUESTS -->
    <div class="card">
      <h2 style="margin:0;">Open Requests</h2>
      <p class="muted" style="margin-top:4px;">Currently accepting donations.</p>
      <div class="controls" style="margin:12px 0;">
        <input id="q" type="search" placeholder="Search title or description..." oninput="filterCards()"/>
        <select id="categoryFilter" onchange="filterCards()">
          <option value="">All categories</option>
          <option>Infrastructure</option>
          <option>Supplies</option>
          <option>Education</option>
          <option>Other</option>
        </select>
      </div>

      <div class="cards">
        <%
          ResultSet rs = null;
          try (Connection conn = DBConnection.getConnection();
               PreparedStatement ps = conn.prepareStatement(
                 "SELECT id, title, category, description, amount_needed, deadline, file_path " +
                 "FROM school_requests WHERE status='open' AND amount_needed > 0 ORDER BY created_at DESC")) {
            rs = ps.executeQuery();
            boolean any = false;
            while(rs.next()) {
              any = true;
              int id = rs.getInt("id");
              String title = rs.getString("title");
              String category = rs.getString("category");
              String desc = rs.getString("description");
              BigDecimal amt = rs.getBigDecimal("amount_needed");
              Date ddl = rs.getDate("deadline");
              String filePath = rs.getString("file_path");
              String shortDesc = desc != null && desc.length()>220 ? desc.substring(0,220)+"…" : desc;
              String imgUrl = (filePath != null && !filePath.isEmpty()) ? request.getContextPath() + "/" + filePath : null;
        %>

        <div class="request-card" data-title="<%= title %>" data-desc="<%= desc %>" data-category="<%= category %>">
          <div class="req-top">
            <div class="req-thumb">
              <% if(imgUrl != null){ %>
                <img src="<%= imgUrl %>" />
              <% } else { %>
                <div class="muted">No image</div>
              <% } %>
            </div>
            <div class="req-body">
              <div>
                <div class="req-title"><%= title %></div>
                <div class="req-desc"><%= shortDesc %></div>
                <div class="req-meta">
                  <div>₦ <%= amt %> Needed</div>
                  <% if(ddl != null){ %><div>Deadline: <%= ddl %></div><% } %>
                  <div>Category: <%= category %></div>
                </div>
              </div>
              <div class="req-actions">
                <a class="view" href="<%= request.getContextPath() %>/request_detail.jsp?id=<%= id %>">View</a>
                <form action="<%= request.getContextPath() %>/donate.jsp" method="get" style="margin:0; flex:1;">
                  <input type="hidden" name="requestId" value="<%= id %>"/>
                  <button type="submit" class="donate">Donate</button>
                </form>
              </div>
            </div>
          </div>
        </div>

        <% } if(!any){ %>
          <div class="empty">No open requests available.</div>
        <% } } catch(Exception e){ out.println("<div class='empty'>Error: "+e.getMessage()+"</div>"); if(rs!=null) rs.close(); } %>

      </div>
    </div>

    <!-- PREVIOUS DONATIONS -->
    <aside class="summary">
      <div class="prev-donations">
        <h3>Your Previous Donations</h3>
        <%
          BigDecimal total = new BigDecimal("0");
          ResultSet drs = null;
          try (Connection conn = DBConnection.getConnection();
               PreparedStatement ps2 = conn.prepareStatement(
                 "SELECT d.amount, d.donated_at, r.title FROM donations d " +
                 "JOIN school_requests r ON d.request_id = r.id " +
                 "WHERE d.donor_username=? ORDER BY d.donated_at DESC LIMIT 6")) {
            ps2.setString(1, username);
            drs = ps2.executeQuery();
            boolean has = false;
            while(drs.next()){
              has = true;
              BigDecimal amt = drs.getBigDecimal("amount");
              total = total.add(amt);
        %>
        <div class="prev-don-card">
          <strong><%= drs.getString("title") %></strong><br>
          <span class="muted">Amount: ₦ <%= amt %></span><br>
          <span class="muted">Date: <%= drs.getTimestamp("donated_at") %></span>
        </div>
        <% } if(!has){ %>
          <div class="muted">No previous donations.</div>
        <% } }catch(Exception ex){ out.println("<div class='muted'>Error loading donations.</div>"); } %>

        <div class="total-donated">
          Total Donated: ₦ <%= total %>
        </div>
      </div>
    </aside>

  </div>
</div>
</body>
</html>
