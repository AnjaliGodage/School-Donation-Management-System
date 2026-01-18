<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*, com.example.db.DBConnection, java.math.BigDecimal" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    Integer principalId = (Integer) session.getAttribute("principalId");

    if (username == null || role == null || !"principal".equals(role) || principalId == null) {
        response.sendRedirect(request.getContextPath() + "/principal_login.jsp");
        return;
    }
%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Principal Dashboard — School Donation Management</title>
  <style>
    :root{
      --bg: #f5f8fb; --card:#fff; --muted:#6b7280; --accent:#2b6cb0; --accent-600:#235a98; --glass: rgba(255,255,255,0.85);
    }
    *{box-sizing:border-box}
    body{ margin:0; font-family:Inter, "Segoe UI", Roboto, Arial; background:linear-gradient(180deg,#f8fbff 0%,var(--bg) 100%); color:#0f172a; padding:28px; }
    .container{ max-width:1100px; margin:0 auto; }
    header.top{ display:flex; justify-content:space-between; align-items:center; gap:16px; margin-bottom:18px; }
    .logo{ width:52px;height:52px;border-radius:10px;background:linear-gradient(135deg,var(--accent),var(--accent-600)); color:#fff; display:flex;align-items:center;justify-content:center;font-weight:800; }
    .grid{ display:grid; grid-template-columns: 1fr 360px; gap:18px; }
    .card{ background:var(--card); border-radius:12px; padding:18px; box-shadow:0 10px 30px rgba(11,35,64,0.04); }
    label{ display:block; font-weight:700; margin-bottom:6px; color:#0f172a; }
    input[type=text], input[type=number], input[type=date], select, textarea, input[type=file] { width:100%; padding:10px; border-radius:8px; border:1px solid #e6eef7; background:#fff; }
    textarea{ min-height:110px; resize:vertical; }
    .form-actions{ display:flex; gap:10px; margin-top:12px; }
    .btn{ background:var(--accent); color:#fff; border:none; padding:10px 14px; border-radius:8px; cursor:pointer; font-weight:700; }
    .btn.ghost{ background:transparent; border:1px solid rgba(43,108,176,0.12); color:var(--accent); }
    table.requests{ width:100%; border-collapse:collapse; margin-top:12px; }
    table.requests th, table.requests td{ padding:10px 12px; border-bottom:1px solid #eef2f7; font-size:14px; vertical-align:middle; }
    table.requests th{ background:#fafcff; font-weight:700; }
    .thumb{ width:72px;height:48px; object-fit:cover; border-radius:6px; }
    .muted{ color:var(--muted); font-size:13px; }
    .message{ padding:10px 12px; border-radius:8px; margin-bottom:12px; font-weight:600; }
    .success{ background:#e6ffef; color:#0a7f3a; }
    .error{ background:#ffecec; color:#c72e2e; }
    @media(max-width:980px){ .grid{ grid-template-columns:1fr; } .thumb{width:56px;height:40px} }
  </style>
</head>
<body>
  <div class="container">
    <header class="top">
      <div style="display:flex;align-items:center;gap:12px;">
        <div class="logo">SD</div>
        <div>
          <div style="font-weight:700;font-size:18px">School Donation Management</div>
          <div class="muted">Principal Dashboard</div>
        </div>
      </div>
      <div style="text-align:right">
        <div style="font-weight:700">Signed in as <%= username %></div>
        <div><a href="<%= request.getContextPath() %>/index.jsp">Logout</a></div>
      </div>
    </header>

    <div class="grid">
      <!-- Left: create & list -->
      <div>
        <div class="card">
          <h2 style="margin-top:0">Create a Request</h2>
          <p class="muted">Attach an image or PDF and (optionally) an account number for direct deposits.</p>

          <% String success = (String) session.getAttribute("success");
             String error = (String) session.getAttribute("error");
             if (success != null) { %>
               <div class="message success"><%= success %></div>
          <% session.removeAttribute("success"); }
             if (error != null) { %>
               <div class="message error"><%= error %></div>
          <% session.removeAttribute("error"); } %>

          <form action="<%= request.getContextPath() %>/AddNeedServlet" method="post" enctype="multipart/form-data" novalidate>
            <input type="hidden" name="principalId" value="<%= principalId %>" />
            <div style="margin-bottom:12px;">
              <label for="title">Title</label>
              <input id="title" name="title" type="text" required placeholder="e.g. New classroom desks" />
            </div>

            <div style="margin-bottom:12px;">
              <label for="category">Category</label>
              <select id="category" name="category" required>
                <option>Infrastructure</option><option>Supplies</option><option>Education</option><option>Other</option>
              </select>
            </div>

            <div style="margin-bottom:12px;">
              <label for="description">Description</label>
              <textarea id="description" name="description" required placeholder="Describe the need..."></textarea>
            </div>

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
              <div>
                <label for="amount">Amount (optional)</label>
                <input id="amount" name="amount_needed" type="number" step="0.01" placeholder="e.g. 2500.00" />
              </div>
              <div>
                <label for="deadline">Deadline (optional)</label>
                <input id="deadline" name="deadline" type="date" />
              </div>
            </div>

            <div style="margin-top:12px;">
              <label for="attachment">Attachment (image or PDF)</label>
              <input id="attachment" name="attachment" type="file" accept=".jpg,.jpeg,.png,.gif,.pdf" />
            </div>

            <div style="margin-top:12px;">
              <label for="account_number">Account number (optional)</label>
              <input id="account_number" name="account_number" type="text" placeholder="Account number for deposits (optional)" />
            </div>

            <div class="form-actions">
              <button class="btn" type="submit">Create Request</button>
              <button type="reset" class="btn ghost">Clear</button>
            </div>
          </form>
        </div>

        <div class="card" style="margin-top:16px;">
          <h3 style="margin:0 0 10px 0">Your Requests</h3>

          <%
            ResultSet rs = null;
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                   "SELECT id, title, category, description, amount_needed, deadline, status, created_at, file_path, account_number FROM school_requests WHERE principal_id = ? ORDER BY created_at DESC")) {

              ps.setInt(1, principalId);
              rs = ps.executeQuery();
          %>

          <table class="requests" role="table" aria-label="Your requests">
            <tr>
              <th>Title</th><th>Category</th><th>Amount</th><th>Deadline</th><th>Status</th><th>Attachment</th><th>Account</th><th>Created</th><th>Action</th>
            </tr>

          <%
              boolean any = false;
              while (rs.next()) {
                 any = true;
                 int reqId = rs.getInt("id");
                 String title = rs.getString("title");
                 String category = rs.getString("category");
                 BigDecimal amt = rs.getBigDecimal("amount_needed");
                 java.sql.Date ddl = rs.getDate("deadline");
                 String status = rs.getString("status");
                 Timestamp created = rs.getTimestamp("created_at");
                 String filePath = rs.getString("file_path");
                 String acct = rs.getString("account_number");
          %>
            <tr>
              <td><%= title %></td>
              <td class="muted"><%= category %></td>
              <td class="muted"><%= (amt != null ? amt.toPlainString() : "-") %></td>
              <td class="muted"><%= (ddl != null ? ddl.toString() : "-") %></td>
              <td class="muted"><%= (status != null ? status : "open") %></td>
              <td>
                <%
                  if (filePath != null && !filePath.trim().isEmpty()) {
                    String lc = filePath.toLowerCase();
                    if (lc.endsWith(".jpg")||lc.endsWith(".jpeg")||lc.endsWith(".png")||lc.endsWith(".gif")) {
                %>
                      <a href="<%= request.getContextPath() + "/" + filePath %>" target="_blank">
                        <img class="thumb" src="<%= request.getContextPath() + "/" + filePath %>" alt="attachment" />
                      </a>
                <%
                    } else {
                %>
                      <a href="<%= request.getContextPath() + "/" + filePath %>" target="_blank">View file</a>
                <%
                    }
                  } else { out.print("-"); }
                %>
              </td>
              <td class="muted"><%= (acct != null && !acct.isEmpty() ? acct : "-") %></td>
              <td class="muted"><%= (created != null ? created.toString() : "-") %></td>
              <td>
                <a href="<%= request.getContextPath() %>/EditNeedServlet?id=<%= reqId %>">Edit</a>
                <form method="post" action="<%= request.getContextPath() %>/DeleteNeedServlet" style="display:inline;margin-left:8px;" onsubmit="return confirm('Delete this request?');">
                  <input type="hidden" name="id" value="<%= reqId %>" />
                  <button type="submit" style="background:none;border:none;color:var(--accent);font-weight:600;cursor:pointer">Delete</button>
                </form>
              </td>
            </tr>
          <%
              } // while

              if (!any) {
          %>
            <tr>
              <td colspan="9" style="text-align:center;color:var(--muted);padding:18px">No requests — create one using the form above.</td>
            </tr>
          <%
              }
          %>
          </table>

          <%
            } catch (SQLException e) {
               out.println("<div style='color:red'>Error: " + e.getMessage() + "</div>");
               e.printStackTrace();
            } finally {
               if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            }
          %>
        </div>
      </div>

      <!-- right column -->
      <aside>
        <div class="card">
          <h4 style="margin:0 0 8px 0">Tips</h4>
          <p class="muted">If you plan to accept deposits, include the account number and bank details in the request description or account field so donors have the info they need.</p>
        </div>
      </aside>
    </div>
  </div>
</body>
</html>
