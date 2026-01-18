package requests;

import com.example.db.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/EditNeedServlet")  // <-- Correct mapping
public class EditNeedServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        Integer principalId = (session != null) ? (Integer) session.getAttribute("principalId") : null;

        if (role == null || !"principal".equals(role) || principalId == null) {
            response.sendRedirect(request.getContextPath() + "/principal_login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
            return;
        }

        int id = Integer.parseInt(idStr);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM school_requests WHERE id=? AND principal_id=?")) {

            ps.setInt(1, id);
            ps.setInt(2, principalId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("needId", rs.getInt("id"));
                request.setAttribute("title", rs.getString("title"));
                request.setAttribute("category", rs.getString("category"));
                request.setAttribute("description", rs.getString("description"));
                request.setAttribute("amount", rs.getBigDecimal("amount_needed"));
                request.setAttribute("deadline", rs.getDate("deadline"));
                request.setAttribute("status", rs.getString("status"));
                request.setAttribute("account", rs.getString("account_number"));
                request.setAttribute("filePath", rs.getString("file_path"));

                request.getRequestDispatcher("/need_edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        Integer principalId = (session != null) ? (Integer) session.getAttribute("principalId") : null;

        if (role == null || !"principal".equals(role) || principalId == null) {
            response.sendRedirect(request.getContextPath() + "/principal_login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String account = request.getParameter("account_number");
        String status = request.getParameter("status");
        String amountStr = request.getParameter("amount_needed");
        String deadlineStr = request.getParameter("deadline");

        java.math.BigDecimal amount = null;
        java.sql.Date deadline = null;

        try {
            if (amountStr != null && !amountStr.isEmpty()) {
                amount = new java.math.BigDecimal(amountStr);
            }
            if (deadlineStr != null && !deadlineStr.isEmpty()) {
                deadline = java.sql.Date.valueOf(deadlineStr);
            }

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "UPDATE school_requests SET title=?, category=?, description=?, amount_needed=?, deadline=?, status=?, account_number=? WHERE id=? AND principal_id=?")) {

                ps.setString(1, title);
                ps.setString(2, category);
                ps.setString(3, description);
                if (amount != null) {
                    ps.setBigDecimal(4, amount);
                } else {
                    ps.setNull(4, java.sql.Types.DECIMAL);
                }
                if (deadline != null) {
                    ps.setDate(5, deadline);
                } else {
                    ps.setNull(5, java.sql.Types.DATE);
                }
                ps.setString(6, status);
                ps.setString(7, account);
                ps.setInt(8, id);
                ps.setInt(9, principalId);

                ps.executeUpdate();

                session.setAttribute("success", "Request updated successfully!");
                response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");

            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error updating request: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/principal_dashboard.jsp");
        }
    }
}
